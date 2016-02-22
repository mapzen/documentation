FROM python:3
RUN apt-get update -qq && apt-get install -y build-essential nginx
WORKDIR /documentation
ADD . ./
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs
RUN pip3 install virtualenv
RUN make env
RUN make get
RUN make all
RUN mkdir -p /var/www/html/common/
RUN ln -s /documentation/dist /var/www/html/documentation
CMD nginx -g 'daemon off;'
