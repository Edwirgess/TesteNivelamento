import requests
import re
import os
import zipfile
from bs4 import BeautifulSoup, SoupStrainer


url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
response = requests.get(url)

#Fazendo download dos anexos
def download (url, nome):
  pdf_response = requests.get(url, stream= True)
  if pdf_response.status_code == 200:
    with open(nome, "wb") as pdf:
      for chuck in pdf_response.iter_content(chunk_size=8192):
        if chuck:
          pdf.write(chuck)

#Funçao de zippar o arquivo
def zip (nome, arquivos):
  with zipfile.ZipFile(nome, "w") as zip:
    for item in arquivos:
      zip.write(item, os.path.basename(item))

#Verificaçao de existencia do arquivo
if not os.path.exists("Download"):
  os.makedirs("Download")

#Lista de arquivo
arquivos = []


if response.status_code == 200:
  #Filtrar os links de acordo com os nomes que possuem Anexo e sejam do tipo pdf
  filter = SoupStrainer("a", href = re.compile(r"Anexo.*\.pdf$"))
  links_pdf = BeautifulSoup(response.text, "html.parser", parse_only= filter)
  print(links_pdf)
  for link in links_pdf :
    url = link.get("href")
    nome = os.path.join("Download", os.path.basename(url))
    download(url, nome)
    arquivos.append(nome)
  zip("Anexos.zip", arquivos)