<template>
  <v-container fluid>
    <div id="categories">
      <v-toolbar-title>Организации</v-toolbar-title>
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
        <template v-slot:isRosatomTemplate="{ props }">
          <td colspan="1">
            <input
              type="checkbox"
              :checked="props.dataItem.IsRosatom"
              disabled="disabled"
            />
          </td>
        </template>
      </grid>
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
  name: 'Organisations',
  components: {
    //dropdownlist: DropDownList,
    grid: Grid,
  },
  data: function () {
    return {
      spitemsdata: [],
      dataResult: [],
      columns: [
        { field: 'Title', title: 'Наименовение рус.' },
        { field: 'NameEng', title: 'Наименование англ.' },
        {
          field: 'IsARosatom',
          cell: 'isRosatomTemplate',
          title: 'Организация госкорпорации',
        },
        { field: 'IsActive', cell: 'isActiveTemplate', title: 'Действут' },
      ],
      pageable: true,
      sortable: true,

      skip: 0,
      take: 10,
      sort: [{ field: 'Title', dir: 'asc' }],
    };
  },

  async created() {
    const dataState = {
      skip: this.skip,
      take: this.take,
      sort: this.sort,
    };
    this.spitemsdata = await this.getDataOrgs();

    this.dataResult = process(this.spitemsdata, dataState);
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
    async getDataOrgs() {
      let items = await sp.web.lists
        .getByTitle('Organisations')
        .items.select(
          'Title',
          'NameEng',

          'IsRosatom',
          'IsActive'
        )
        .get();

      console.log(items);
      return items;
    },
  },
};
</script>
