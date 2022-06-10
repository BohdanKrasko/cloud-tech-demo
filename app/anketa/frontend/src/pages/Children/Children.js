import React, {useState, useEffect} from 'react'
import ChildrenTable from '../../Components/table/Children'
import RightMenuStats from '../../Components/menu/RightMenuStats'
import { 
  getChildren,
  deleteChildren, 
  addChildren, 
  editChildren
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
    {title: "Прізвище", field: "surname"},
    {title: "Ім'я", field: "name"},
    {title: "Дата народження", field: "birthday", type: "date", format: "YYYY-dd-mm"},
    {title: "Вага", field: "weight", type: "numeric"},
    {title: "Зріст", field: "height", type: "numeric"}
]

const Children = (props) => {
  let data = (props.location && props.location.state) || {}
  const [iserror, setIserror] = useState(false)
  const [errorMessages, setErrorMessages] = useState([])
  const [children, setChildren] = useState([])
  const [useCount] = useState(0)
  const [open, setOpen] = useState(false)
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [isLoading, setLoading] = useState(true)

  const handleDrawerOpen = () => {
    setOpen(true)
  }
  
  const handleDrawerClose = () => {
    setOpen(false)
  }

  useEffect(() => {
    getChildren(data.parents_id, data.token)
      .then(data => data.json())
      .then((data) => {
        let preperadData = []
        data.forEach((key, val) => {
          var parts = key.birthday.split('/')
          var dateString = parts[2] + '-' + parts[1] + '-' + parts[0] 
          key.birthday = new Date(dateString) 
          preperadData.push(key)
        })
        setChildren(preperadData)
        setIsAuthorized(true)   
        setLoading(false) 
      }).catch(err => {
        setIsAuthorized(false)
        setLoading(false) 
        return err
    })
  }, [useCount])

  const validate = (data) => {
    let errorList = []
    if(data.surname === undefined || data.surname === ''){
      errorList.push("Будь ласка ведіть ім'я")
    }
    if(data.name === undefined || data.name === ''){
      errorList.push("Будь ласка ведіть прізвище")
    }
    if(data.birthday === undefined || data.birthday === ''){
      errorList.push("Будь ласка ведіть дату народження")
    }
    if(data.weight === undefined || data.weight === ''){
      errorList.push("Будь ласка ведіть вагу")
    }
    if(data.height === undefined || data.height === ''){
      errorList.push("Будь ласка ведіть зріст")
    }
    return errorList
  }

  const handleRowDelete = async (oldData) => {
    deleteChildren(oldData.id, data.token)
      .then(res => {
        let newChildren = children.filter(children => children.id !== oldData.id )
        setChildren(newChildren)
        setErrorMessages([])
        setIserror()
      })
      .catch(err => {
        setErrorMessages(["Помилка на сервері буль ласка зачекайте"])
        setIserror(true)
      })
  }

  const handleRowAdd = async (newData) => {
    //validation
    let errorList = validate(newData)
    if (errorList.length > 0) {
      setErrorMessages(errorList)
      setIserror(true)
      throw Error
    } else { //no error
      addChildren(newData, data.token, data.parents_id)
      .then(res => res.json())
      .then(res => {
        newData.id = res[0].insertId
        let dataToAdd = [...children]
        dataToAdd.push(newData)
        setChildren(dataToAdd)
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
    if (typeof(newData.birthday) === 'string' ) {
      newData.birthday = new Date(newData.birthday) 
    }

    let errorList = validate(newData)
  
    if (errorList.length > 0) {
      setErrorMessages(errorList)
      setIserror(true)
      throw Error
    } else { //no error
      editChildren(newData, data.token)
      .then(() => {
        let updatedChildrend = [...children]
        const index = updatedChildrend.findIndex(obj => obj.id === oldData.id)
        updatedChildrend[index] = newData
        setChildren(updatedChildrend)
        setIserror(false)
        setErrorMessages([])
      })
      .catch(err => {
        setErrorMessages(["Update failed! Server error"])
        setIserror(true)
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
        <RightMenuStats
          open={open}
          handleDrawerOpen={handleDrawerOpen}
          handleDrawerClose={handleDrawerClose}
          parents={data}
          isShowButton={true}
        />
        <ChildrenTable 
          columns={columns} 
          parents={data}
          data={children} 
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

export default Children