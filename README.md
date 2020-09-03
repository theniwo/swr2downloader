# SWR2Downloader

A Docker image for the SWR2Downloader made by [u/DerGumbi](https://www.reddit.com/user/DerGumbi/) found on (German) Subreddit [EinfachPosten](https://www.reddit.com/r/einfach_posten/comments/gqsmwu/unmengen_an_kostenloser_klassischer_musik/)

## Tools / Software installed
* SWR2Downloader by [u/derGumbi](https://www.reddit.com/user/DerGumbi/)
* Other software based on [theniwo/gobuntu](https://hub.docker.com/r/theniwo/gobuntu)

## Usage
```
docker run -d \
        --name SWR2Downloader \
        --hostname SWR2Downloader \
        --restart unless-stopped \
        --memory "1G" \
        -e TZ=Europe/Berlin \
        -p 2222:22 \
        -v swr2downloader_data:/user \
        -v $HOME/Downloads:/home/user/Downloads \
        theniwo/swr2downloader:latest
```

## Connect

### Per ssh
`ssh user@localhost -p 2222`\
or \
`ssh user@$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' SWR2Downloader)`


#### Password
`userpw`

### With docker directly

`docker exec -it SWR2Downloader bash`

## Usage
just type `SWR2Downloader` at any location. You can choose to download there then.

## Bugs / Changelog
### 0.5
* downloading too many files at once leads to an OOM Exception due to memory leakage

### 1.0
* OOM Exception solved
* Graphical issues.
 * Progress bars are not drawn completely to 100 %
 * Filenames may not be visible.
* Possible Exception when writing to an nfs share or general shared folder binding. Needs further inspection.
* No quit or exit commands at the moment

### 1.1
* Now based on my other image [theniwo/gobuntu](https://hub.docker.com/r/theniwo/gobuntu)
* Opted out of Microsoft .NET Telemetry
* Multi language support
