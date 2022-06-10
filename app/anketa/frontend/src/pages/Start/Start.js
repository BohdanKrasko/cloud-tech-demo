import React, {useState} from 'react'
import logo from '../../img/logo.png'
import { makeStyles } from '@material-ui/core/styles'
import {
  Card,
  CardMedia,
  Alert,
  Button
} from '@mui/material'
import { Grid, Typography } from "@material-ui/core"
import { useHistory } from "react-router-dom"

const App = (props) => {
  const history = useHistory()
  const useStyles = makeStyles({
    root: {
      transition: "transform 0.15s ease-in-out"
    },
    cardHovered: {
      transform: "scale3d(1.05, 1.05, 1)"
    }
  })
  const data = (props.location && props.location.state) || {}
  const classes = useStyles()
  const [state, setState] = useState({
    raised:false,
    shadow:1,
  })
  const handleSubmit = (event) => {
    event.preventDefault()
    history.push({ 
      pathname: '/ankety',
      state: data
     })
  }
  
  return (
    <Grid
      container
      justifyContent="center"
      alignItems="center"
      direction="column"
      style={{ minHeight: "100vh" }}
      >
      <Grid>
        <Card sx={{ maxWidth: "40%",  margin: "auto"}} 
          className={classes.root} 
          classes={{root: state.raised ? classes.cardHovered : ""}}
          onMouseOver={()=>setState({ raised: true, shadow:3})} 
          onMouseOut={()=>setState({ raised:false, shadow:1 })} 
          raised={state.raised} zdepth={state.shadow} 
          >
            <Button onClick={handleSubmit}>
              <CardMedia
                component="img"
                image={logo}/>
            </Button>
            <Alert icon={false} severity="success" sx={{textAlign: "center", display: "block"}}>
              <Typography>Пройти анкетування</Typography>
            </Alert>
        </Card>
      </Grid>
    </Grid>
  )
}

export default App
