package buf

import (
	"dagger.io/dagger"
	"universe.dagger.io/alpine"
	"universe.dagger.io/bash"
)

dagger.#Plan & {
	client: {
		filesystem: {
			".": read: {
				contents: dagger.#FS
				exclude: [
					"README.md",
					".github",
					"buf.cue",
				]
			}
		}
		network: "unix:///var/run/docker.sock": connect: dagger.#Socket
        env: {
            BUF_TOKEN: dagger.#Secret
        }
	}
	actions: push: {
		_source:     client.filesystem.".".read.contents
		_BuildImage: alpine.#Build & {
			packages: {
				jq: {}
				curl: {}
				git: {}
				bash: {}
			}
		}
        setup: bash.#Run & {
            input:   _BuildImage.output
            script: contents: #"""
                BIN="/usr/local/bin" && \
                VERSION='1.3.1' && \
                    curl -sSL \
                    https://github.com/bufbuild/buf/releases/download/v1.0.0-rc8/buf-Linux-x86_64 \
                    -o ${BIN}/buf && \
                    chmod +x ${BIN}/buf \
                """#
        }
        buf: bash.#Run & {
            input:   setup.output
            script: contents: #"""
                _scripts/buf.sh download
                _scripts/buf.sh publish
                """#
                
            mounts: {
                download: {
                    dest:     "/src"
                    contents: _source
                }
            }
            env: {
                BUF_TOKEN: client.env.BUF_TOKEN
                BUF_USER: "evalsocket"
            }
            workdir: "/src"
        }
	}
}
