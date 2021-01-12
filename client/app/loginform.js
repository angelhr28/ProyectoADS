

Vue.component('loginform', {
    template:
    `
        <div>
            <div id="formulario1" style="display: block">
                <form  action="index.html" class="needs-validation" novalidate>

                    <div class="form-group">
                        <label for="exampleInputEmail1">Usuario</label>
                        <input
                            name="user"
                            class="form-control"
                            id="exampleInputEmail1"
                            aria-describedby="emailHelp"
                            placeholder="Ejemplo: amorales357"
                            style="font-size: 14px"
                            v-model="userInput"
                        >
                    </div>
                    
                    <div class="form-group">
                        <label for="exampleInputPassword1">Contraseña</label>
                        <input
                            name="password"
                            type="password"
                            class="form-control"
                            id="exampleInputPassword1"
                            style="font-size: 14px"
                            placeholder="*****"
                            v-model="passwordInput"
                        >
                    </div>
                    <button
                        type="button"
                        class="btn btn-primary"
                        v-on:click="handleLogin"
                    >Iniciar Sesión</button>

                </form>

                <br>
                <div  v-if="displayError" class="alert alert-danger" role="alert">
                    <li v-for='error in errors'>
                    {{error}}
                    </li>
                </div>
            </div>
        </div>
    `,
    data() {
        return {
            displayError: false,
            userInput: '',
            passwordInput: '',
            dataUser: null
        }
    },
    methods: {
        handleLogin: function() {
            const obj = {
                user: this.userInput,
                password: this.passwordInput
            }

            loginUser(obj)
            .then(({data}) => {
                
                const info = (data.status == '1') ? '' : data;
                localStorage.setItem(
                    'usuario', 
                    JSON.stringify(info)
                )
                const actual = window.location.href;
                const indice = actual.lastIndexOf('/');
                const nuevo = actual.substr(0, indice);
                const despues = `${nuevo}/index.html`
                window.location.replace(despues);
            })
        }
    }
})