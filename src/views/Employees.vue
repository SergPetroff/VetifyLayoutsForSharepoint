<template>
  <v-container fluid>
    <div id="categories">
      <v-toolbar-title>Сотрудники</v-toolbar-title>
      <!--  <p>
        <dropdownlist
          :data-items="categories"
          :data-item-key="'CategoryID'"
          :text-field="'CategoryName'"
          :default-item="defaultItems"
          @change="handleDropDownChange"
        >
        </dropdownlist>
        &nbsp; Selected category ID:
        <strong>{{ this.dropdownlistCategory }}</strong>
      </p> -->

      <grid
        :data-items="dataResult"
        :pageable="pageable"
        :sortable="sortable"
        :sort="sort"
        :skip="skip"
        :take="take"
        :columns="columns"
        @datastatechange="dataStateChange"
      >
        <template v-slot:isActiveTemplate="{ props }">
          <td colspan="1">
            <input
              type="checkbox"
              :checked="props.dataItem.IsActive"
              disabled="disabled"
            />
          </td>
        </template>
        <template v-slot:organisationTemplate="{ props }">
          <td colspan="1">
            <span>{{ props.dataItem.Organisation.Title }}</span>
          </td>
        </template>
      </grid>
      <v-alert :value="alert" color="red" type="error"
        >Возникла ошибка, перезагрузите страницу или обратитесь в
        поддержку.</v-alert
      >
    </div>
  </v-container>
</template>

<script>
//import { DropDownList } from '@progress/kendo-vue-dropdowns';
//import categories from '../appdata/categories.json';
//import products from '../appdata/products.json';
import { process } from '@progress/kendo-data-query';
import { Grid } from '@progress/kendo-vue-grid';
import '@progress/kendo-theme-material/dist/all.css';
import { sp } from '@pnp/sp/presets/all';

export default {
  name: 'Employyes',
  components: {
    //dropdownlist: DropDownList,
    grid: Grid,
  },
  data: function () {
    return {
      //categories: categories,
      //defaultItems: { CategoryID: null, CategoryName: 'Product categories' },
      //dropdownlistCategory: null,
      // products: products,
      alert: false,
      arrangementsdata: [],
      dataResult: [],
      columns: [
        { field: 'Title', title: 'ФИО рус.' },
        { field: 'FIOEng', title: 'ФИО англ.' },
        { field: 'JobPost', title: 'Должность' },
        {
          field: 'Organisaton',
          title: 'Организация',
          cell: 'organisationTemplate',
        },
        { field: 'IsActive', cell: 'isActiveTemplate', title: 'Действут' },
      ],
      pageable: true,
      sortable: true,
      //filterable: true,
      skip: 0,
      take: 10,
      sort: [{ field: 'Title', dir: 'asc' }],
      //filter: null,
    };
  },
  //created() {
  /* const dataState = {
      skip: this.skip,
      take: this.take,
      sort: this.sort,
    }; */
  //this.dataResult = process(products, dataState);
  //},

  async created() {
    const dataState = {
      skip: this.skip,
      take: this.take,
      sort: this.sort,
    };
    this.arrangementsdata = await this.getDataEmployees();

    this.dataResult = process(this.arrangementsdata, dataState);
  },

  methods: {
    /*  handleDropDownChange(e) {
      this.dropdownlistCategory = e.target.value.CategoryID;

      if (e.target.value.CategoryID !== null) {
        this.filter = {
          logic: 'and',
          filters: [
            {
              field: 'CategoryID',
              operator: 'eq',
              value: e.target.value.CategoryID,
            },
          ],
        };
        this.skip = 0;
      } else {
        this.filter = [];
        this.skip = 0;
      }
      let event = {
        data: {
          skip: this.skip,
          take: this.take,
          sort: this.sort,
          filter: this.filter,
        },
      };
      this.dataStateChange(event);
    }, */
    createAppState: function (dataState) {
      this.take = dataState.take;
      this.skip = dataState.skip;
      this.sort = dataState.sort;
    },
    dataStateChange(event) {
      this.createAppState(event.data);
      this.dataResult = process(this.arrangementsdata, {
        skip: this.skip,
        take: this.take,
        sort: this.sort,
        filter: this.filter,
      });
    },
    async getDataEmployees() {
      try {
        let items = await sp.web.lists
          .getByTitle('Employees')
          .items.select(
            'Title',
            'FIOEng',
            'JobPost',
            'Organisation/Title',
            'IsActive',
            'Note'
          )
          .expand('Organisation')
          .get();

        console.log(items);
        return items;
      } catch (err) {
        this.alert = true;
        console.error(err);
      }
    },
  },
};
</script>
