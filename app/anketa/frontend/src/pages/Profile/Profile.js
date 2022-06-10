import React, {useState, useEffect} from 'react'
import RightMenuStats from '../../Components/menu/RightMenuStats'
import Box from '@mui/material/Box'
import { v4 } from 'uuid'
import { Redirect } from "react-router-dom"
import {
  Alert,
  Button,
  Snackbar,
  TextField,
  CircularProgress
} from '@mui/material'
import { 
  Grid,
  Card,
  Container 
} from "@material-ui/core"
import {
  getUserByUsername,
  isExistsUser,
  editUser,
  editPassword
} from '../../api/client'

const Profile = (props) => {
  let data = (props.location && props.location.state) || {}
  const [open, setOpen] = useState(false)
  const [useCount] = useState(0)
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [isLoading, setLoading] = useState(true)
  const [user, setUser] = useState()
  const [openNotifyS, setOpenNotifyS] = useState(false)
  const [alert, setAlert] = useState({
    severity: '',
    message: ''
  })
  const [password, setPassword] = useState({
    new: '',
    confirm: ''
  })

  const handleCloseS = () => {
    setOpenNotifyS(false)
  }

  const handleOpenS = (sevevity, message) => {
    setOpenNotifyS(true)
    setAlert({severity: sevevity, message: message})
  }

  const [state, setState] = useState({
    isFirstName: false,
    isLastName: false,
    isUsername: false,
    isPhone: false,
    isAlert: false,
    phoneComment: ""
  })
  const [isNewPass, setIsNewPass] = useState(false)
  const [isConfirmPass, setIsConfirmPass] = useState(false)

  useEffect(() => {
    const request = {
      username: data.username,
      token: data.token
    }
    getUserByUsername(request)
      .then(res => res.json())
      .then(res => {
          setUser(res)
          setIsAuthorized(true)
          setLoading(false)
      }).catch(err => {
          setIsAuthorized(false)
          setLoading(false) 
          return err
      })
  }, [useCount])

  const setFisrtName = (value) => {
    let newState = user
    newState.first_name = value.target.value
    setUser(newState)
  }
  const setLastName = (value) => {
    let newState = user
    newState.last_name = value.target.value
    setUser(newState)
  }
  const setUsername = (value) => {
    let newState = user
    newState.username = value.target.value
    setUser(newState)
  }
  const setPhone = (value) => {
    let newState = user
    newState.phone = value.target.value
    setUser(newState)
  }
  const setNewPass = (value) => {
    let newState = password
    newState.new = value.target.value
    setPassword(newState)
  }
  const setConfirmPass = (value) => {
    let newState = password
    newState.confirm = value.target.value
    setPassword(newState)
  }

  const handleDrawerOpen = () => {
    setOpen(true)
  }
  
  const handleDrawerClose = () => {
    setOpen(false)
  }
  const handleInputChange = (name, value) => {
    setState((prevState) => ({
      ...prevState,
      [name]: value
    }))
  }

  const checkFields = (user) => {
    if(user.isPhone) {
      if (user.isPhone.length < 13 || user.isPhone.length > 13 || user.isPhone.substring(1,13).match(/^[0-9]+$/) === null) {
        setState({phoneComment: "Неправильний номер", isPhone: true})
      } else {
        setState({phoneComment: "", isPhone: false})
      }
    }
    for (const val in user) {
      if (val !== 'isPhone') {
        if (!user[val]) {
          handleInputChange(val, true)
          return false
        } else {
          handleInputChange(val, false)
        }
      }
    }
    return true
  }

  const handleSubmitPass = (event) => {
    event.preventDefault()

    if (!password.new) {
      setIsNewPass(true)
    } else {
      setIsNewPass(false)
    }

    if (!password.confirm) {
      setIsConfirmPass(true)
    } else {
      setIsConfirmPass(false)
    }

    const request = {
      password: password.new,
      parents_id: user.parents_id,
      token: user.token
    }
        
    if (password.new !== password.confirm) {
      handleOpenS('error', 'Пароль не співпадає')
      setIsConfirmPass(true)
    } else {
      setIsConfirmPass(false)
      editPassword(request)
      handleOpenS('success', 'Пароль оновлено успішно')
    }
  }

  const handleSubmit = (event) => {
    event.preventDefault()

    const request = {
      parents_id: user.parents_id,
      username: user.username,
      token: data.token
    }
    const checkUser = {
      isFirstName : user.first_name,
      isLastName  : user.last_name,
      isUsername  : user.username,
      isPhone     : user.phone
    }
    const updateUser = {
      user: user,
      token: data.token
    }

    if (checkFields(checkUser)) {
      isExistsUser(request)
          .then(res => res.json())
          .then(res => {
            let newState = state
            if (!res.exist) {
              editUser(updateUser)
              handleOpenS('success', 'Дані успішно оновлено')
              newState.isUsername = false
            } else {
              handleOpenS('error', `Користував з логіном '${user.username}' вже зареєстрований`)
              newState.isUsername = true
            }
            setState(newState)
          })
    }
  }

  if (isLoading) {
    return (
      <Grid
        container
        justifyContent="center"
        alignItems="center"
        direction="column"
        style={{ minHeight: "100vh" }}
      >
        <CircularProgress />
      </Grid>
    )
  }
  if (!isAuthorized) {
    return <Redirect to="/signin"></Redirect>
  } else { 
    return (
      <div>
        <Snackbar
          anchorOrigin={{
            vertical: 'top',
            horizontal: 'right'}}
          open={openNotifyS}
          onClose={handleCloseS}
          autoHideDuration={6000}
          key={v4()}
        > 
          <Alert onClose={handleCloseS} severity={alert.severity} sx={{ width: '100%' }}>
            {alert.message}
          </Alert>
        </Snackbar>
        <RightMenuStats
          open={open}
          handleDrawerOpen={handleDrawerOpen}
          handleDrawerClose={handleDrawerClose}
          parents={data}
          isShowButton={true}
        />
        <Box component="form" onSubmit={handleSubmit} id="profile" noValidate> 
          <Container> 
            <Card> 
              <Grid container spacing={3} key={v4()} direction="row" alignItems="center"> 
                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={4} lg={4}> 
                  <TextField
                    margin="normal"
                    required
                    fullWidth
                    id="first_name"
                    label="Ім'я"
                    name="first_name"
                    autoComplete="off"
                    defaultValue={user.first_name}
                    onChange={setFisrtName}
                    error={state.isFirstName}
                  />
                </Grid>
                <Grid item key={v4()} md={4} lg={4}> 
                  <TextField
                    margin="normal"
                    required
                    fullWidth
                    id="last_name"
                    label="Прізвище"
                    name="last_name"
                    autoComplete="off"
                    defaultValue={user.last_name}
                    onChange={setLastName}
                    error={state.isLastName}
                  />
                </Grid>
                <Grid item key={v4()} md={2} lg={2}/>

                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={8} lg={8}> 
                  <TextField
                    margin="normal"
                    required
                    fullWidth
                    id="username"
                    label="Логін"
                    name="username"
                    autoComplete="off"
                    defaultValue={user.username}
                    onChange={setUsername}
                    error={state.isUsername}
                  />
                </Grid>
                <Grid item key={v4()} md={2} lg={2}/>

                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={8} lg={8}> 
                  <TextField
                    margin="normal"
                    required
                    fullWidth
                    id="phone"
                    label="Мобільний номер"
                    name="phone"
                    autoComplete="off"
                    defaultValue={user.phone}
                    onChange={setPhone}
                    error={state.isPhone}
                    helperText={state.phoneComment}
                  />
                </Grid>
                <Grid item key={v4()} md={2} lg={2}/>

                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={8} lg={8}> 
                  <Button
                    fullWidth
                    size='large'
                    type="submit"
                    color='primary'
                    style={{
                      backgroundColor: '#1976d2', 
                      color: '#ffffff',
                      marginBottom: '20px'
                    }}
                  >
                    Зберегти
                  </Button>
                </Grid>
              </Grid>
            </Card>
          </Container>
        </Box>

        <Box component="form" onSubmit={handleSubmitPass} id="password" noValidate style={{marginTop: '20px'}}> 
          <Container> 
            <Card> 
              <Grid container spacing={3} key={v4()} direction="row" alignItems="center"> 
                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={8} lg={8}> 
                  <TextField
                    margin="normal"
                    required
                    fullWidth
                    id="newPass"
                    label="Новий пароль"
                    name="newPass"
                    type="password"
                    autoComplete="off"
                    defaultValue={password.new}
                    onChange={setNewPass}
                    error={isNewPass}
                  />
                </Grid>
                <Grid item key={v4()} md={2} lg={2}/>

                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={8} lg={8}> 
                  <TextField
                    margin="normal"
                    required
                    fullWidth
                    id="confirmPass"
                    label="Підтвердіть пароль"
                    name="confirmPass"
                    type="password"
                    autoComplete="off"
                    defaultValue={password.confirm}
                    onChange={setConfirmPass}
                    error={isConfirmPass}
                  />
                </Grid>
                <Grid item key={v4()} md={2} lg={2}/>

                <Grid item key={v4()} md={2} lg={2}/>
                <Grid item key={v4()} md={8} lg={8}> 
                  <Button
                    fullWidth
                    size='large'
                    type="submit"
                    color='primary'
                    style={{
                        backgroundColor: '#1976d2', 
                        color: '#ffffff',
                        marginBottom: '20px'
                    }}
                  >
                    Зберегти
                  </Button>
                </Grid>
              </Grid>
            </Card>
          </Container>
        </Box>
      </div>
    )
  }
}

export default Profile