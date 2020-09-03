#!/usr/bin/env bash
cd /root/Settings/Linux/scripts/docker/SWR2Downloader

	echo "Committing to docker hub"
	docker commit $(docker inspect --format='{{.ID}}' SWR2Downloader) theniwo/swr2downloader:latest && docker push theniwo/swr2downloader:latest
	if [ $? -eq 0 ] ; then
		echo "SWR2Downloader has commited and automatically pushed to docker hub"
		logger -i -t SWR2Downloader "SWR2Downloader has commited and automatically pushed to docker hub"
	else
		echo "SWR2Downloader has failed to commit and automatically push to docker hub"
		logger -i -t SWR2Downloader "SWR2Downloader has failed to commit and automatically push to docker hub"
	fi

