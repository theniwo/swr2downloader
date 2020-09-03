# Use the official image as a parent image.
FROM theniwo/gobuntu:latest

# Set the working directory.
WORKDIR /root

# Run the command inside your image filesystem.

# Install packets
RUN apt-get update --fix-missing
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN TZ=Europe/Berlin && DEBIAN_FRONTEND=noninteractive apt-get install -y \
software-properties-common

# Set up timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Set up users and passwords
#RUN useradd --user-group --create-home --skel /etc/skel --shell /bin/bash user
#RUN echo 'root:toor' | chpasswd
#RUN echo 'user:userpw' | chpasswd

# Set up ssh process
# RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Set Variables
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "DOTNET_CLI_TELEMETRY_OPTOUT=1" >> /etc/profile

# Set the locale
#RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
#ENV LANG de_DE.UTF-8
ENV LANGUAGE fr:it:es:pt:sv:de:en
#ENV LC_ALL de_DE.UTF-8
#RUN locale-gen de_DE.UTF-8

# The .NET Core tools collect usage data in order to help us improve your experience.
# The data is anonymous and doesn't include command-line arguments.
# The data is collected by Microsoft and shared with the community.
# You can opt-out of telemetry by setting the DOTNET_CLI_TELEMETRY_OPTOUT environment variable to '1' or 'true' using your favorite shell.
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Copy the file from your host to your current location. (This has to be done as the last step before running CMD or ENTRYPOINT)
COPY ./content /

# Run .NET install
RUN dpkg -i /usr/src/packages-microsoft-prod.deb
RUN add-apt-repository universe
RUN apt-get update
RUN TZ=Europe/Berlin && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
RUN apt-get update
RUN TZ=Europe/Berlin && DEBIAN_FRONTEND=noninteractive apt-get install -y dotnet-sdk-3.1


# Link the binary to the $PATH
RUN ln -s /opt/SWR2Downloader/SWR2Downloader /usr/local/bin/SWR2Downloader
RUN chmod +x /opt/SWR2Downloader/SWR2Downloader
RUN chmod +x /usr/local/bin/SWR2Downloader

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 22

# Run on startup
ENTRYPOINT \
  /usr/sbin/service ntp restart && \
  /usr/sbin/service dbus restart && \
  /usr/sbin/sshd -D

# Run the specified command within the container.
CMD ["/usr/sbin/sshd", "-D"]
