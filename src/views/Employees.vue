<template>
  <v-container fluid>
    <div id="categories">
      <h2>Категории</h2>
      <p>
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
      </p>

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
        <template v-slot:discontinuedTemplate="{ props }">
          <td colspan="1">
            <input
              type="checkbox"
              :checked="props.dataItem.Discontinued"
              disabled="disabled"
            />
          </td>
        </template>
      </grid>
    </div>
  </v-container>
</template>

<script>
import { DropDownList } from '@progress/kendo-vue-dropdowns';
import categories from '../appdata/categories.json';
import products from '../appdata/products.json';
import { process } from '@progress/kendo-data-query';
import { Grid } from '@progress/kendo-vue-grid';
import '@progress/kendo-theme-default/dist/all.css';

export default {
  name: 'Categories',
  components: {
    dropdownlist: DropDownList,
    grid: Grid,
  },
  data: function () {
    return {
      categories: categories,
      defaultItems: { CategoryID: null, CategoryName: 'Product categories' },
      dropdownlistCategory: null,
      products: products,
      columns: [
        { field: 'ProductName', title: 'Product Name' },
        { field: 'UnitPrice', title: 'Price' },
        { field: 'UnitsInStock', title: 'Units in Stock' },
        { field: 'Discontinued', cell: 'discontinuedTemplate' },
      ],
      pageable: true,
      sortable: true,
      skip: 0,
      take: 10,
      sort: [{ field: 'ProductName', dir: 'asc' }],
      filter: null,
    };
  },
  created() {
    const dataState = {
      skip: this.skip,
      take: this.take,
      sort: this.sort,
    };

    this.dataResult = process(products, dataState);
  },

  methods: {
    handleDropDownChange(e) {
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
    },
    createAppState: function (dataState) {
      this.take = dataState.take;
      this.skip = dataState.skip;
      this.sort = dataState.sort;
    },
    dataStateChange(event) {
      this.createAppState(event.data);
      this.dataResult = process(products, {
        skip: this.skip,
        take: this.take,
        sort: this.sort,
        filter: this.filter,
      });
    },
  },
};
</script>
