# cliente

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).




## Como enviar peticion post

```js
            
            fetch("http://127.0.0.1:8000/api/registrarUsuario", {
                "method": "POST",
                "headers": {
                  "content-type": "application/json"
                },
                "body": JSON.stringify({
                  "user": "cr123123213221",
                  "password": "12341232156",
                  "nom_user": "cristian2",
                  "ape_user": "soto33"
                })
              })
              .then(response => {
                console.log(response);
                return response.json()
              })
              .then(data => {
                  console.log('data', data)
              })
              .catch(err => {
                console.error(err);
              });
```





