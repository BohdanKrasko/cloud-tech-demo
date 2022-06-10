import React, {useState, useEffect} from 'react'
import { verify } from  'jsonwebtoken'
import { useHistory } from "react-router-dom"
import { getAnaketa } from '../../api/client'
import { Redirect } from "react-router-dom"
import {
  Grid,
  Alert,
  Typography,
  CircularProgress,
} from '@mui/material'
import Form from '../../Components/anketa/Form'
import Dialog from '@mui/material/Dialog'
import DialogContent from '@mui/material/DialogContent'
import DialogContentText from '@mui/material/DialogContentText'
import DialogTitle from '@mui/material/DialogTitle'


const Anketa = (props) => {
  const data = (props.location && props.location.state) || {}
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [anketa, setAnketa] = useState([])
  const [useCount] = useState(0)
  const [isLoading, setLoading] = useState(true)
  const [error, setError] = useState()
  const [scroll] = useState('paper')
  const descriptionElementRef = React.useRef(null)
  const history = useHistory()

  useEffect(() => {
    try {
      verify(data.token, 'TOKEN_KEY')
      setIsAuthorized(true)
      getAnaketa(data)
        .then(res => res.json())
        .then(data => {
          setAnketa(data)
          setLoading(false)
        })
    } catch (err) {
      setError('Вибачте але ваш токен не валідний щоб авторизуватись')
    }
  }, [useCount])

  if (error) {
    return (
      <Alert severity="error">{error}</Alert>
    )
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
        <div style={{
            display: 'block',
            textAlign: 'center',
            paddingTop: '5%',
            backgroundColor: '#1976d2'
        }}
        >
        </div>
        <div>
        <Dialog
          open={true}
          onClose={true}
          scroll={scroll}
          fullWidth={true}
          maxWidth='md'
          aria-labelledby="scroll-dialog-title"
          aria-describedby="scroll-dialog-description"
        >
          <DialogTitle id="scroll-dialog-title">
            <Typography variant="h5" gutterBottom component="div" style={{
              display: 'block', 
              textAlign: 'center',
              fontWeight: 'bold'
            }}
            >
              {data.name_of_anketa}
            </Typography>
          </DialogTitle>
          <DialogContent dividers={scroll === 'paper'}>
          <DialogContentText
            id="scroll-dialog-description"
            ref={descriptionElementRef}
            tabIndex={-1}
          >
            <Form
              data={data}
              history={history}
              anketa={anketa}
            />
          </DialogContentText>
          </DialogContent>
        </Dialog>
        </div>
      </div>
    )
  }
}

export default Anketa