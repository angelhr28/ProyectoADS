
function registerUser(body) {
    return new Promise((resolve) => {
        console.log("registerUser -> URL_BASE", URL_BASE)
        fetch(`${URL_BASE}registrarUsuario`, {
            "method": "POST",
            "headers": {
                "cookie": "PHPSESSID=csko4h9e7olag8kr7mgr4tsv55",
                "content-type": "application/json"
            },
            "body": JSON.stringify({
                ...body
            })
        })
        .then(response => {
            return response.json();
        })
        .then(data => {
            console.log('data', data)

            if(data.status == '0') {
                return resolve({
                    status: 'ok',
                    data: null
                })
            } else {
                return resolve({
                    status: 'error',
                    data: null,
                    err: {
                        ...data
                    }
                })
            }
            // localStorage.setItem('usuario', JSON.stringify(this.dataUser))
        })
        .catch(err => {
            console.error(err);
            return resolve({
                status: 'error',
                data: null,
                err
            })
        });
    })

}



function loginUser(obj) {
    return new Promise((resolve) => {
        fetch(`${URL_BASE}getLogin?user=${obj.user}&password=${obj.password}`, {
            "method": "GET",
            "headers": {
                "cookie": "PHPSESSID=csko4h9e7olag8kr7mgr4tsv55"
            }
        })
        .then((response) => {
            return response.json();
        })
        .then((data) => {
            return resolve({
                status: 'ok',
                data
            })
        })
        .catch(err => {
            console.error(err);
            return resolve({
                status: 'error',
                err
            })
        });
    })

}


function getListCategorias() {
    return new Promise((resolve) => {
        fetch(`${URL_BASE}getListCategoria`, {
            "method": "GET",
            "headers": {
                "cookie": "PHPSESSID=csko4h9e7olag8kr7mgr4tsv55"
            }
        })
        .then((response) => {
            return response.json();
        })
        .then((data) => {
            return resolve({
                status: 'ok',
                data
            })
        })
        .catch(err => {
            console.error(err);
            return resolve({
                status: 'error',
                err
            })
        });
    })

}


