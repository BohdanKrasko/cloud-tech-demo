import React, {useState} from 'react'
import Avatar from '@mui/material/Avatar'
import Button from '@mui/material/Button' 
import Alert from '@mui/material/Alert'
import Collapse from '@mui/material/Collapse'
import CssBaseline from '@mui/material/CssBaseline'
import TextField from '@mui/material/TextField'
import Link from '@mui/material/Link'
import Grid from '@mui/material/Grid'
import Box from '@mui/material/Box'
import Typography from '@mui/material/Typography'
import Container from '@mui/material/Container'
import { createTheme, ThemeProvider } from '@mui/material/styles'
import { register } from '../../api/client'

function Copyright(props) {
  return (
    <Typography variant="body2" color="text.secondary" align="center" {...props}>
      {'Copyright © '}
      <Link color="inherit" href="http://irc.dubredu.rv.ua/">
        Дубровийьки ІРЦ
      </Link>{' '}
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  )
}

const theme = createTheme()

const SignUp = (props) => {
  const [state, setState] = useState({
    isFirstName: false,
    isLastName: false,
    isUsername: false,
    isPhone: false,
    isPassword: false,
    isSuccess: false,
    isAlert: false,
    phoneComment: ""
  })

  const handleInputChange = (name, value) => {
    setState((prevState) => ({
      ...prevState,
      [name]: value
    }))
  }

  const checkFields = (user) => {
    if (user.isPhone.length < 13 || user.isPhone.length > 13 || user.isPhone.substring(1,13).match(/^[0-9]+$/) === null) {
      setState({phoneComment: "Неправильний номер", isPhone: true})
    } else {
      setState({phoneComment: "", isPhone: false})
    }
    for (const val in user) {
      if (!user[val]) {
        handleInputChange(val, true)
        return false
      } else {
        handleInputChange(val, false)
      }
    }
    return true
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    const data = new FormData(event.currentTarget)
    const user = {
      firstName : data.get('first_name'),
      lastName  : data.get('last_name'),
      username  : data.get('username'),
      password  : data.get('password'),
      phone     : data.get('phone')
    }

    const checkUser = {
      isFirstName : user.firstName,
      isLastName  : user.lastName,
      isUsername  : user.username,
      isPassword  : user.password,
      isPhone     : user.phone
    }
    
    if (checkFields(checkUser)) {
      register(user)
      .then(response => response.json())
      .then((data) => {
        if (data.status_code === 200) {
          setState({isSuccess: true, isAlert: false})
        } else {
          setState({isSuccess: false, isAlert: true})
        }
      }).catch(err => {
        console.log("err" + err.message)
      })
    }
  }

  return (
    <ThemeProvider theme={theme}>
      <Container component="main" maxWidth="xs">
        <CssBaseline />
        <Box
          sx={{
            marginTop: 8,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}
        >
          <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
          </Avatar>
          <Typography component="h1" variant="h5">
            Реєстрація користувача
          </Typography>
          <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="first_name"
              label="Ім'я"
              name="first_name"
              autoComplete="off"
              error={state.isFirstName}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              id="last_name"
              label="Прізвище"
              name="last_name"
              autoComplete="off"
              error={state.isLastName}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              id="username"
              label="Логін"
              name="username"
              autoComplete="off"
              error={state.isUsername}
            />    
            <TextField
              margin="normal"
              required
              fullWidth
              name="phone"
              label="Телефон"
              id="phone"
              helperText={state.phoneComment}
              autoComplete="off"
              defaultValue="+380"
              error={state.isPhone}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Пароль"
              type="password"
              id="password"
              autoComplete="current-password"
              error={state.isPassword}
            />
            <Collapse in={state.isSuccess}>
              <Alert severity="success" action={
                <Link href="/signin" variant="body2" underline="none" color="black">
                  <Button color="inherit" size="small">
                    Увійти
                  </Button>
                </Link>
              }>Ви успішно зареєстровані!</Alert>
            </Collapse>
            <Collapse in={state.isAlert}>
              <Alert severity="error">Користувач з таким логіном вже зареєстрований!</Alert>
            </Collapse>
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Зареєструвати
            </Button>
            <Grid container direction="row-reverse">
              <Grid item>
                <Link href="/signin" variant="body2" underline="none" color="primary">
                  {"Вже маєте акаунт? Увійти"}
                </Link>
              </Grid>
            </Grid>
          </Box>
        </Box>
        <Copyright sx={{ mt: 8, mb: 4 }} />
      </Container>
    </ThemeProvider>
  )
}

export default SignUp