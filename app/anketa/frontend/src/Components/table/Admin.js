import React from 'react'
import { forwardRef } from 'react'
import MaterialTable from "@material-table/core"
import AddBox from '@material-ui/icons/AddBox'
import ArrowDownward from '@material-ui/icons/ArrowDownward'
import Check from '@material-ui/icons/Check'
import ChevronLeft from '@material-ui/icons/ChevronLeft'
import ChevronRight from '@material-ui/icons/ChevronRight'
import Clear from '@material-ui/icons/Clear'
import DeleteOutline from '@material-ui/icons/DeleteOutline'
import Edit from '@material-ui/icons/Edit'
import FilterList from '@material-ui/icons/FilterList'
import FirstPage from '@material-ui/icons/FirstPage'
import LastPage from '@material-ui/icons/LastPage'
import Remove from '@material-ui/icons/Remove'
import SaveAlt from '@material-ui/icons/SaveAlt'
import Search from '@material-ui/icons/Search'
import ViewColumn from '@material-ui/icons/ViewColumn'
import Alert from '@mui/material/Alert'

 
const tableIcons = {
  Add: forwardRef((props, ref) => <AddBox {...props} ref={ref} />),
  Check: forwardRef((props, ref) => <Check {...props} ref={ref} />),
  Clear: forwardRef((props, ref) => <Clear {...props} ref={ref} />),
  Delete: forwardRef((props, ref) => <DeleteOutline {...props} ref={ref} />),
  DetailPanel: forwardRef((props, ref) => <ChevronRight {...props} ref={ref} />),
  Edit: forwardRef((props, ref) => <Edit {...props} ref={ref} />),
  Export: forwardRef((props, ref) => <SaveAlt {...props} ref={ref} />),
  Filter: forwardRef((props, ref) => <FilterList {...props} ref={ref} />),
  FirstPage: forwardRef((props, ref) => <FirstPage {...props} ref={ref} />),
  LastPage: forwardRef((props, ref) => <LastPage {...props} ref={ref} />),
  NextPage: forwardRef((props, ref) => <ChevronRight {...props} ref={ref} />),
  PreviousPage: forwardRef((props, ref) => <ChevronLeft {...props} ref={ref} />),
  ResetSearch: forwardRef((props, ref) => <Clear {...props} ref={ref} />),
  Search: forwardRef((props, ref) => <Search {...props} ref={ref} />),
  SortArrow: forwardRef((props, ref) => <ArrowDownward {...props} ref={ref} />),
  ThirdStateCheck: forwardRef((props, ref) => <Remove {...props} ref={ref} />),
  ViewColumn: forwardRef((props, ref) => <ViewColumn {...props} ref={ref} />)
}
 
const AdminTable = ({
  columns, 
  data, 
  handleRowDelete, 
  handleRowAdd, 
  handleRowUpdate, 
  iserror, 
  errorMessages
}) => {
 
  return (
    <div>
      {iserror && 
        <Alert severity="error">
            {errorMessages.map((msg, i) => {
                return <div key={i}>{msg}</div>
            })}
        </Alert>
      }       
      <MaterialTable mt={90}
        title="Адміни"
        columns={columns}
        data={data}
        icons={tableIcons}
        options={{
          search: false,
          pageSize:6,       // make initial page size
          emptyRowsWhenPaging: true,   //to make page size fix in case of less data rows
          pageSizeOptions:[6,12],    // rows selection options
          actionsColumnIndex: -1
          }}
        
        editable={{
          onRowUpdate: async (newData, oldData) => {
            await handleRowUpdate(newData, oldData)
          },
          onRowAdd: async (newData) => {
            await handleRowAdd(newData)
          },
          onRowDelete: async (oldData) => {
            await handleRowDelete(oldData)
          }
        }}
        localization={{
          header: {
              actions: ''
          },
          body: {
              emptyDataSourceMessage: 'Додайте адміна',
              editRow: {
                deleteText: 'Ви дійсно бажаєте видалити дані?'
              }
          }
      }}
      />
    </div>
  )
}
 
export default AdminTable