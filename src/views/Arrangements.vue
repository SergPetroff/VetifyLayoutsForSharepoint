<template>
  <v-container fluid>
    <div id="categories">
      <v-toolbar-title>Мероприятия</v-toolbar-title>
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
              :checked="props.dataItem.IsCanceled"
              disabled="disabled"
            />
          </td>
        </template>

        <template v-slot:placeTemplate="{ props }">
          <td colspan="1">
            <span>{{ props.dataItem.Place.Title }}</span>
          </td>
        </template>
        <template v-slot:stateTemplate="{ props }">
          <td colspan="1">
            <span>{{ props.dataItem.State.Title }}</span>
          </td>
        </template>
        <template v-slot:ExpertsTemplate="{ props }">
          <td colspan="1">
            <ul>
              <li
                v-for="expert in props.dataItem.Experts.results"
                v-bind:key="expert.Title"
              >
                {{ expert.Title }}
              </li>
            </ul>
          </td>
        </template>
        <template v-slot:ActionTemplate="{ props }">
          <td colspan="1">
            <span
              ><v-btn icon @click="openCard(props.dataItem)"
                ><v-icon>mdi-card-bulleted-outline</v-icon></v-btn
              >
            </span>
          </td>
        </template>
      </grid>
      <v-dialog v-model="dialog" persistent max-width="900px">
        <v-card>
          <v-toolbar flat color="blue lighten-5">
            <v-icon>mdi-calendar-account-outline</v-icon>
            <v-toolbar-title class="font-weight-light">
              Мероприятие
            </v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn
              color="blue accent-1"
              fab
              small
              @click="isEditing = !isEditing"
            >
              <v-icon v-if="isEditing"> mdi-close </v-icon>
              <v-icon v-else> mdi-pencil </v-icon>
            </v-btn>
          </v-toolbar>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6" md="6">
                  <v-text-field
                    v-model="props_form.Title"
                    label="Наименование рус.*"
                    required
                    :disabled="!isEditing"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6" md="6">
                  <v-text-field
                    v-model="props_form.NameEng"
                    label="Наименование англ."
                    hint="тут можно подсказку написать"
                    :disabled="!isEditing"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="4">
                  <v-menu
                    :disabled="!isEditing"
                    ref="menu_startdate"
                    v-model="menu_startdate"
                    :close-on-content-click="false"
                    transition="scale-transition"
                    offset-y
                    max-width="290px"
                    min-width="auto"
                  >
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field
                        :disabled="!isEditing"
                        v-model="startdateFormatted"
                        label="Дата начала"
                        persistent-hint
                        prepend-icon="mdi-calendar"
                        v-bind="attrs"
                        v-on="on"
                        readonly
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="startdate"
                      no-title
                      @input="menu_startdate = false"
                    ></v-date-picker>
                  </v-menu>
                </v-col>
                <v-col cols="12" md="4">
                  <v-menu
                    :disabled="!isEditing"
                    ref="menu_enddate"
                    v-model="menu_enddate"
                    :close-on-content-click="false"
                    transition="scale-transition"
                    offset-y
                    max-width="290px"
                    min-width="auto"
                  >
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field
                        :disabled="!isEditing"
                        readonly
                        v-model="enddateFormatted"
                        label="Дата окончания"
                        persistent-hint
                        prepend-icon="mdi-calendar"
                        v-bind="attrs"
                        v-on="on"
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="enddate"
                      no-title
                      @input="menu_enddate = false"
                    ></v-date-picker>
                  </v-menu>
                </v-col>
                <v-col cols="12" md="4">
                  <v-checkbox
                    :disabled="!isEditing"
                    label="Мероприятие отменено"
                    value
                    v-model="props_form.IsCanceled"
                  ></v-checkbox>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-select
                    :disabled="!isEditing"
                    v-model="selected_place"
                    :items="places"
                    item-text="Title"
                    item-value="Id"
                    hide-details
                    prepend-icon="mdi-map-marker-radius"
                    single-line
                    label="Место проведения"
                    required
                  ></v-select>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-select
                    :disabled="!isEditing"
                    v-model="selected_states"
                    :items="states"
                    item-text="Title"
                    item-value="Id"
                    hide-details
                    prepend-icon="mdi-alpha-s"
                    single-line
                    label="Статус"
                    required
                  ></v-select>
                </v-col>
                <v-col cols="12" md="12">
                  <v-autocomplete
                    :disabled="!isEditing"
                    v-model="select_experts"
                    item-text="Title"
                    item-value="Id"
                    :items="experts"
                    prepend-icon="mdi-account-tie-outline"
                    label="Эксперты"
                    multiple
                  ></v-autocomplete>
                </v-col>

                <v-col cols="12" md="12">
                  <v-autocomplete
                    :disabled="!isEditing"
                    v-model="select_experts"
                    :items="experts"
                    label="Эксперты"
                    item-text="Title"
                    item-value="Id"
                    prepend-icon="mdi-account-tie-outline"
                    multiple
                    chips
                    clearable
                    deletable-chips
                  ></v-autocomplete>
                </v-col>
                <v-col cols="12" md="12">
                  <v-textarea
                    :disabled="!isEditing"
                    class="mx-2"
                    label="Примечание"
                    rows="1"
                    prepend-icon="mdi-comment"
                  ></v-textarea>
                </v-col>
              </v-row>
            </v-container>
            <small>*indicates required field</small>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="dialog = false">
              Закрыть
            </v-btn>

            <v-btn
              color="blue darken-1"
              text
              @click="saveform"
              v-if="isEditing"
            >
              Сохранить
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
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
import moment from 'moment';

moment.locale('ru');
export default {
  name: 'Organisations',
  components: {
    //dropdownlist: DropDownList,
    grid: Grid,
  },
  data: function () {
    return {
      isEditing: null,
      startdate: null,
      startdateFormatted: null,
      enddate: '',
      enddateFormatted: '',
      menu_startdate: false,
      menu_enddate: false,
      dialog: false,
      props_form: {
        Title: null,
        NameEng: null,
      },
      places: [],
      selected_place: null,
      experts: [],
      select_experts: [],
      states: [],
      selected_states: null,
      spitemsdata: [],
      dataResult: [],
      columns: [
        { title: 'Действия', cell: 'ActionTemplate', width: '100' },
        { field: 'Title', title: 'Наименовение рус.' },
        { field: 'NameEng', title: 'Наименование англ.' },
        {
          field: 'StartDate',
          title: 'Дата начала',
          format: '{0:dd.MM.yyyy}',
          type: 'date',
        },
        {
          field: 'EndDate',
          title: 'Дата окончания',
          format: '{0:dd.MM.yyyy}',
          type: 'date',
        },
        {
          field: 'State',
          title: 'Статус',
          cell: 'stateTemplate',
        },
        {
          field: 'Place',
          title: 'Место проведения',
          cell: 'placeTemplate',
        },
        {
          title: 'Эксперты',
          cell: 'ExpertsTemplate',
        },
        { field: 'IsCanceled', cell: 'isActiveTemplate', title: 'Отменено' },
      ],
      pageable: true,
      sortable: true,

      skip: 0,
      take: 10,
      sort: [{ field: 'Title', dir: 'asc' }],
    };
  },

  async created() {
    this.initDataGrid();
  },
  watch: {
    startdate(val) {
      this.startdateFormatted = this.formatDate(val);
    },
    enddate(val) {
      this.enddateFormatted = this.formatDate(val);
    },
    async dialog(val) {
      if (val) {
        console.log(val);
        this.experts = await this.getExperts();
        this.places = await this.getPlaces();

        this.states = await this.getStates();
      }
    },
  },

  methods: {
    async initDataGrid() {
      const dataState = {
        skip: this.skip,
        take: this.take,
        sort: this.sort,
      };
      this.spitemsdata = await this.getDataArrganements();

      this.dataResult = process(this.spitemsdata, dataState);
    },

    openCard(ev) {
      console.log(ev);
      this.props_form = ev;
      this.startdate = ev.StartDate;
      this.enddate = ev.EndDate;
      this.select_experts = ev.Experts.results;
      this.selected_place = ev.Place.Id;
      this.selected_states = ev.State.Id;
      this.dialog = true;
    },
    formatDate(date) {
      if (!date) return null;

      return moment(date).format('L');
    },
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
    async getDataArrganements() {
      let items = await sp.web.lists
        .getByTitle('Arrangements')
        .items.select(
          'Id',
          'Title',
          'NameEng',
          'StartDate',
          'EndDate',
          'Experts/Title',
          'Experts/Id',
          'Place/Title',
          'Place/Id',
          'State/Title',
          'State/Id',
          'IsCanceled',
          'Note'
        )
        .expand('Experts', 'Place', 'State')
        .get();

      //console.log(items);
      return items;
    },
    fillFormData() {},
    async getPlaces() {
      let items = await sp.web.lists
        .getByTitle('Countrys')
        .items.select('Id', 'Title')
        .get();
      return items;
    },
    async getExperts() {
      let items = await sp.web.lists
        .getByTitle('Employees')
        .items.select('Id', 'Title', 'Organisation/Title')
        .expand('Organisation')
        .get();
      return items;
    },
    async getStates() {
      let items = await sp.web.lists
        .getByTitle('States')
        .items.select('Id', 'Title', 'IsActive')
        .get();
      return items;
    },
    async saveform() {
      console.log(this.props_form);
      let update = await this.updateItem(this.props_form);
      if (update) {
        this.initDataGrid();
      }

      console.log(update);
      this.dialog = false;
    },
    async updateItem(dataitem) {
      try {
        console.log(this.select_experts);
        let item = await sp.web.lists
          .getByTitle('Arrangements')
          .items.getById(dataitem.Id)
          .update({
            Title: dataitem.Title,
            NameEng: dataitem.NameEng,
            StartDate: this.startdate,
            EndDate: this.enddate,
            IsCanceled: dataitem.IsCanceled,
            PlaceId: this.selected_place ? parseInt(this.selected_place) : null,
            StateId: this.selected_states
              ? parseInt(this.selected_states)
              : null,
            ExpertsId: { results: [...this.select_experts] },
          });

        return item;
      } catch (e) {
        console.error(e);
      }
    },
    async addItem() {
      let additem = await sp.web.lists.getByTitle('Arrangements').items.add({
        Title: 'Title',
      });

      return additem;
    },
  },
};
</script>
