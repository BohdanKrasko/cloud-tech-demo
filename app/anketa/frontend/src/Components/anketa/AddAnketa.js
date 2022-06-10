import React from 'react'
import Card from '@material-ui/core/Card'
import CardMedia from '@mui/material/CardMedia'
import { CardActionArea } from '@mui/material'
import plus from '../../img/plus.png'
import { useHistory } from "react-router-dom"

export default function AddAncketa({parents}) {
  const history = useHistory()
  return (
    <div>
      <Card sx={3}>
      <CardActionArea onClick={() => {
          history.push({ 
          pathname: '/anketa/add',
          state: parents
          })
        }} className='card-action-area'>
          <CardMedia
            component="img"
            style={{
              width: "auto",
              maxHeight: "250px",
              margin: "auto",
              marginTop: "44px",
              marginBottom: "44px"
            }}
            image={plus}
            alt="Anketa logo"
          />
        </CardActionArea>
      </Card>
    </div>
  )
}