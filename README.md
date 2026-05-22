# go-template

<!-- TODO(@memes): Update references here and in other files
1. Use as a template when creating a new GitHub repo, or copy the contents into
   a bare-repo directory.
2. Search and replace placeholder names APP and go-template; s/APP/name_of_app/g, s/memes\/go-template/owner\/name_of_app/g
2. Update `.pre-commit-config.yml` to add/remove plugins as necessary.
3. Modify README.md and CONTRIBUTING.md, change LICENSE as needed.
4. Review GitHub PR and issue templates.
5. If pushing container(s) to Docker Hub, make these changes to repo settings:
   1. _Settings_ > _Secrets and Variables_ > _Actions_, and add `DOCKERHUB_USERNAME`
      and `DOCKERHUB_TOKEN` as _Repository Secret_.
6. If using `release-please` action, make these changes:
   1. In GitHub Settings:
      * _Settings_ > _Actions_ > _General_  > _Allow GitHub Actions to create and approve pull requests_ is checked
      * _Settings_ > _Secrets and Variables_ > _Actions_, and add `RELEASE_PLEASE_TOKEN` with PAT as a _Repository Secret_
   2. Modify [release-please](.github/workflows/release-please.yml) action to have the correct package and enable
7. Review and enable [lint](.github/workflows/lint.yml) and [release](.github/workflows/release.yml) actions
8. Remove all [CHANGELOG](CHANGELOG.md) entries.
9. Commit changes.
-->
[![Go Reference](https://pkg.go.dev/badge/github.com/memes/go-template.svg)](https://pkg.go.dev/github.com/memes/go-template)
[![Go Report Card](https://goreportcard.com/badge/github.com/memes/go-template)](https://goreportcard.com/report/github.com/memes/go-template)
![GitHub release](https://img.shields.io/github/v/release/memes/go-template?sort=semver)
![GitHub last commit](https://img.shields.io/github/last-commit/memes/go-template)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](CODE_OF_CONDUCT.md)

This repository contains common settings and actions that I tend to use in my Go projects.

## Verifying releases

For each tagged release, a tarball of the source and a [syft] SBOM is created, along with SHA256 checksums for all
files. [Cosign] is used to automatically generate a signing certificate for download and verification of container images.

### Verify release files

1. Download the checksum, signature, and signing certificate file from GitHub

   Set the environment variable `APP_VERSION` to the semantic version to fetch and verify.

   ```shell
   export APP_VERSION="0.1.0"
   ```

   Retrieve the checksums and sigstore files for the release.

   ```shell
   curl -sLO https://github.com/memes/APP/releases/download/v${APP_VERSION}/checksums.txt
   curl -sLO https://github.com/memes/APP/releases/download/v${APP_VERSION}/checksums.txt.sigstore.json
   ```

2. Verify the checksums file using the GitHub cert associated with the release action.

   ```shell
   cosign verify-blob \
        --certificate-identity "https://github.com/memes/APP/.github/workflows/release.yml@refs/tags/v${APP_VERSION}" \
        --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
        --bundle "checksums.txt.sigstore.json" \
        ./checksums.txt
   ```

   ```text
   Verified OK
   ```

3. Download and verify files

   Now that the checksums file has been verified, any other file can be verified using `sha256sum`.

   For example

   ```shell
   curl -sLO https://github.com/memes/APP/releases/download/v${APP_VERSION}/APP_${APP_VERSION}_linux_amd64
   sha256sum --ignore-missing -c checksums.txt
   ```

   ```text
   APP_0.1.0_linux_amd64: OK
   ```

### Verify container image

[Cosign] can verify the OCI container signature.

```shell
cosign verify \
    --certificate-identity "https://github.com/memes/APP/.github/workflows/release.yml@refs/tags/v${APP_VERSION}" \
    --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
    "ghcr.io/memes/APP:v${APP_VERSION}"
```

[cosign]: https://github.com/SigStore/cosign
[syft]: https://github.com/anchore/syft
