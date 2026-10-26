
import SwiftUI
import UniformTypeIdentifiers

@main
struct AuroraDistributionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @State private var title = ""
    @State private var artist = ""
    @State private var releaseDate = Date()
    @State private var genre = "Alternative Rap"
    @State private var audioName = ""
    @State private var artworkName = ""
    @State private var explicit = false
    @State private var status = "Draft"
    @State private var selectingAudio = false
    @State private var selectingArtwork = false

    private let genres = [
        "Alternative Rap", "Hip-Hop", "Pop",
        "Alternative", "Electronic", "Other"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AURORA")
                            .font(.caption.weight(.bold))
                            .tracking(4)
                            .foregroundStyle(.purple)

                        Text("Your music.\nYour next chapter.")
                            .font(.largeTitle.bold())

                        Text("Independent music distribution")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                    .listRowBackground(Color.clear)
                }

                Section("Release details") {
                    TextField("Release title", text: $title)
                    TextField("Artist name", text: $artist)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { item in
                            Text(item)
                        }
                    }

                    DatePicker(
                        "Release date",
                        selection: $releaseDate,
                        in: Date()...,
                        displayedComponents: .date
                    )

                    Toggle("Explicit content", isOn: $explicit)
                }

                Section("Release files") {
                    Button {
                        selectingAudio = true
                    } label: {
                        Label(
                            audioName.isEmpty
                                ? "Choose audio file"
                                : audioName,
                            systemImage: "waveform"
                        )
                    }

                    Button {
                        selectingArtwork = true
                    } label: {
                        Label(
                            artworkName.isEmpty
                                ? "Choose cover artwork"
                                : artworkName,
                            systemImage: "photo"
                        )
                    }

                    Text("Audio: WAV or MP3")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Artwork: square JPG or PNG")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Submission") {
                    LabeledContent("Status", value: status)

                    Button("Validate release") {
                        if title.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty || artist.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty {
                            status = "Missing release details"
                        } else if audioName.isEmpty ||
                                    artworkName.isEmpty {
                            status = "Missing audio or artwork"
                        } else {
                            status = "Ready for backend upload"
                        }
                    }
                    .disabled(status == "Uploading")

                    Text("Validation does not deliver music to streaming platforms.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Aurora Distribution")
            .fileImporter(
                isPresented: $selectingAudio,
                allowedContentTypes: [.audio],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    audioName = urls.first?.lastPathComponent ?? ""
                case .failure:
                    status = "Audio selection failed"
                }
            }
            .fileImporter(
                isPresented: $selectingArtwork,
                allowedContentTypes: [.jpeg, .png, .webP],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    artworkName = urls.first?.lastPathComponent ?? ""
                case .failure:
                    status = "Artwork selection failed"
                }
            }
        }
        .tint(.purple)
    }
}
