import uvicorn

if __name__ == "__main__":
    uvicorn.run("ceda:app", reload=True, port=9000)
