import React from 'react'
import { grey } from '@mui/material/colors'
import { styled } from '@mui/material/styles'
import Table from './Table'
import {
  Box,
  Typography,
  SwipeableDrawer,
} from '@mui/material'

const drawerBleeding = 30

const StyledBox = styled(Box)(({ theme }) => ({
    backgroundColor: theme.palette.mode === 'light' ? '#fff' : grey[800],
  }))
    
const Puller = styled(Box)(({ theme }) => ({
  width: 30,
  height: 6,
  backgroundColor: theme.palette.mode === 'light' ? grey[300] : grey[900],
  borderRadius: 3,
  position: 'absolute',
  top: 8,
  left: 'calc(50% - 15px)',
}))

const SwipedTable = ({
  container, 
  openChildrend, 
  toggleDrawer, 
  selectedAnketa,
  columns, 
  parents,
  children, 
  handleRowDelete, 
  handleRowAdd, 
  handleRowUpdate, 
  iserror, 
  errorMessages}) => {

  return (
    <SwipeableDrawer
      container={container}
      anchor="bottom"
      open={openChildrend}
      onClose={toggleDrawer(false)}
      onOpen={toggleDrawer(true)}
      swipeAreaWidth={drawerBleeding}
      disableSwipeToOpen={false}
      ModalProps={{
        keepMounted: true,
      }}
    >
      <StyledBox
        sx={{
          position: 'absolute',
          top: -drawerBleeding,
          borderTopLeftRadius: 8,
          borderTopRightRadius: 8,
          visibility: 'visible',
          right: 0,
          left: 0,
        }}
      >
        <Puller />
        <Typography sx={{ p: 2, color: 'text.secondary' }}></Typography>
      </StyledBox>
        <Table 
          columns={columns} 
          parents={parents}
          data={children} 
          handleRowDelete={handleRowDelete} 
          handleRowAdd={handleRowAdd}
          handleRowUpdate={handleRowUpdate}
          selectedAnketa={selectedAnketa}
          iserror={iserror} 
          errorMessages={errorMessages}/>
    </SwipeableDrawer>
  )
}

export default SwipedTable