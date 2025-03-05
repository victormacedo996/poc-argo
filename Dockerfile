FROM python

RUN apt update && apt upgrade -y

RUN poetry alguma coisa > requirements.txt > pip install requirements.txt