from flask import Flask, request
from flask_cors import CORS
import pandas as pd

app = Flask(__name__)
CORS (app)
data_frame = pd.read_csv ("Relatorio_cadop.csv", delimiter= ';', encoding= "latin1")
print(data_frame.columns[2])
@app.route("/Pesquisar", methods=["GET"])
def pesquisar():
    query = request.args.get("operadora")
    resultado = data_frame[data_frame['Razão Social'].str.contains(query,case=False)]
    resultado = resultado.where(pd.notna(resultado), None)
    resultado_json = resultado.to_dict(orient="records")
    resultado_json = resultado.to_json(orient="records",date_format="utf-8", default_handler=str)
    return resultado_json


if __name__ == '__main__' :
    app.run()