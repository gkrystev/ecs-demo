FROM python:3.8   
ENV APP_HOME=/opt/webapp  

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

RUN pip install --upgrade pip  

COPY src $APP_HOME  

ADD https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem /etc/ssl/certs/aws-global-bundle.pem
RUN chmod a+r /etc/ssl/certs/aws-global-bundle.pem

RUN pip install -r requirements.txt  
CMD python manage.py runserver 0.0.0.0:80

