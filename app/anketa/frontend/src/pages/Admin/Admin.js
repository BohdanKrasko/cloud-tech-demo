import React, {useState, useEffect} from 'react'
import RightMenuStats from '../../Components/menu/RightMenuStats'
import AdminTable from '../../Components/table/Admin'
import {
  getAdmins,
  addAdmin,
  editAdmin,
  deleteAdmin
} from '../../api/client'
import { Redirect } from "react-router-dom"
import {
  CircularProgress
} from '@mui/material'
import { 
  Grid,
} from "@material-ui/core"


const columns = [
  {title: "id", field: "id", hidden: true},
  {title: "Прізвище", field: "last_name"},
  {title: "Ім'я", field: "first_name"},
  {title: "Логін", field: "username"},
  {title: "passowrd", field: 'password', hidden: true},
  {title: "Пароль", field: 'pass_star'}
]

const Admin = (props) => {
  let data = (props.location && props.location.state) || {}
  const [open, setOpen] = useState(false)
  const [useCount] = useState(0)
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [isLoading, setLoading] = useState(true)
  const [admins, setAdmins] = useState([])
  const [iserror, setIserror] = useState(false)
  const [errorMessages, setErrorMessages] = useState([])

  const handleDrawerOpen = () => {
    setOpen(true)
  }
  
  const handleDrawerClose = () => {
    setOpen(false)
  }

  useEffect(() => {
    const request = {
        token: data.token
    }
    getAdmins(request)
      .then(res => res.json())
      .then(res => {
        setAdmins(res)
        setIsAuthorized(true)
        setLoading(false)
      }).catch(err => {
        setIsAuthorized(false)
        setLoading(false) 
        return err
      })
  }, [useCount])

  const handleRowDelete = async (oldData) => {
    const request = {
      token: data.token,
      admin_id: oldData.id
    }
    deleteAdmin(request)
      .then(res => {
        let newAdmins = admins.filter(admin => admin.id !== oldData.id )
        setAdmins(newAdmins)
        setErrorMessages([])
        setIserror()
      })
      .catch(err => {
        setErrorMessages(["Помилка на сервері буль ласка зачекайте"])
        setIserror(true)
      })
  }

  const handleRowAdd = async (newData) => {
    newData.password = newData.pass_star
    //validation
    let errorList = validate(newData)
    if (errorList.length > 0) {
      setErrorMessages(errorList)
      setIserror(true)
      throw Error
    } else { //no error
      const request = {
        token: data.token,
        admin: {
          first_name: newData.first_name,
          last_name: newData.last_name,
          username: newData.username,
          password: newData.password
        }
      }
      addAdmin(request)
        .then(res => res.json())
        .then(res => {
          newData.id = res[0].insertId
          let dataToAdd = [...admins]
          dataToAdd.push(newData)
          setAdmins(dataToAdd)
          setErrorMessages([])
          setIserror(false)
        })
      .catch(() => {
        setErrorMessages(["Помилка на сервері буль ласка зачекайте"])
        setIserror(true)
      })
    }
  }

  const handleRowUpdate = async (newData, oldData) => {
    //validation
    let errorList = validate(newData)
  
    if (errorList.length > 0) {
      setErrorMessages(errorList)
      setIserror(true)
      throw Error
    } else { //no error
      const password = newData.pass_star === '' ? '*****' : newData.pass_star
      const request = {
        token: data.token,
        admin: {
          admin_id: newData.id,
          first_name: newData.first_name,
          last_name: newData.last_name,
          username: newData.username,
          password: password
        }
      }

      editAdmin(request)
        .then(() => {
          let updatedAdmins = [...admins]
          const index = updatedAdmins.findIndex(obj => obj.id === oldData.id)
          newData.pass_star = '*****'
          updatedAdmins[index] = newData
          setAdmins(updatedAdmins)
          setIserror(false)
          setErrorMessages([])
        })
        .catch(err => {
          setErrorMessages(["Update failed! Server error"])
          setIserror(true)
        })
    } 
  }

  const validate = (data) => {
    let errorList = []
    if(data.first_name === undefined || data.first_name === ''){
      errorList.push("Будь ласка ведіть ім'я")
    }
    if(data.last_name === undefined || data.last_name === ''){
      errorList.push("Будь ласка ведіть прізвище")
    }
    if(data.username === undefined || data.username === ''){
      errorList.push("Будь ласка ведіть логін")
    }
    if(data.password === undefined || data.password === ''){
      errorList.push("Будь ласка ведіть пароль")
    }
    return errorList
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
        <RightMenuStats
          open={open}
          handleDrawerOpen={handleDrawerOpen}
          handleDrawerClose={handleDrawerClose}
          parents={data}
          isShowButton={true}
        />
        <AdminTable 
          columns={columns} 
          data={admins} 
          handleRowDelete={handleRowDelete} 
          handleRowAdd={handleRowAdd}
          handleRowUpdate={handleRowUpdate}
          iserror={iserror} 
          errorMessages={errorMessages}
        />
      </div>
    )
  }
}

export default Admin