import React, {useState} from 'react'
import Avatar from '@mui/material/Avatar'
import Button from '@mui/material/Button'
import CssBaseline from '@mui/material/CssBaseline'
import TextField from '@mui/material/TextField'
import Link from '@mui/material/Link'
import Grid from '@mui/material/Grid'
import Box from '@mui/material/Box'
import Alert from '@mui/material/Alert'
import Collapse from '@mui/material/Collapse'
import Typography from '@mui/material/Typography'
import Container from '@mui/material/Container'
import { createTheme, ThemeProvider } from '@mui/material/styles'
import { login } from '../../api/client'
import { useHistory } from "react-router-dom"

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

const SignIn = (props) => {
  const history = useHistory()
  const [state, setState] = useState({
    username: false,
    password: false,
    onFailure: false
  })

  const handleInputChange = (name, value) => {
    setState((prevState) => ({
      ...prevState,
      [name]: value
    }))
  }

  const checkFields = (user) => {
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
      username: data.get('username'),
      password: data.get('password'),
    }
    if (checkFields(user)) {
      login(user)
        .then(response => response.json())
        .then((data) => {
          if (!data.parents_id) {
            throw Error("User not found")
          }
          history.push({ 
            pathname: '/ankety',
            state: data
           })
      }).catch(() => {
        setState({onFailure: true})
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
          <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="username"
              label="Ваш логін"
              name="username"
              autoComplete="off"
              autoFocus
              error={state.username}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Ваш пароль"
              type="password"
              id="password"
              autoComplete="current-password"
              error={state.password}
            />
            <Collapse in={state.onFailure}>
              <Alert severity="error">Невірний логін або пароль</Alert>
            </Collapse>
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Увійти
            </Button>
            <Grid container direction="row-reverse">
              <Grid item> 
                <Link href="/signup" variant="body2">
                  {"Не маєте акаунта? Зареєструватися"}
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

export default SignIn