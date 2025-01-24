import PyPDF2 
import pandas as pd

pdf_path = "Anexo_I_Rol_2021RN_465.2021_RN624_RN625.2024.pdf"

with open(pdf_path, "rb") as file:
    reader_pdf = PyPDF2.PdfReader(file)
    text = ""
    for page in reader_pdf.pages:
        text += page.extract_text()

print("conteudo")
print(text)

