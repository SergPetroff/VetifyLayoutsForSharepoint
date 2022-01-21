<template>
  <v-app id="inspire">
    <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item class="px-2">
          <v-list-item-avatar>
            <v-img
              :src="require('@/assets/O14_person_placeHolder_192.png')"
            ></v-img>
          </v-list-item-avatar>
        </v-list-item>

        <v-list-item link>
          <v-list-item-content>
            <v-list-item-title class="text-h6">
              {{ currentUserLogin }}
            </v-list-item-title>
            <v-list-item-subtitle>{{ currentUserEmail }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list>
      <v-divider></v-divider>
      <v-list dense>
        <v-list-item
          v-for="item in items"
          :key="item.title"
          :to="item.link"
          link
        >
          <v-list-item-icon>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar app color="blue lighten-3" denset>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Название проекта</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-menu bottom left>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-cog-outline</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item link @click="toSiteSettings">
            <v-list-item-icon>
              <v-icon>mdi-tune</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Параметры сайта</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item link @click="toSiteContent">
            <v-list-item-icon>
              <v-icon>mdi-folder-multiple-outline</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Контент сайта</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item link @click="toLogout">
            <v-list-item-icon>
              <v-icon>mdi-logout-variant</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Выйти</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
import { sp } from '@pnp/sp/presets/all';

sp.setup({
  sp: {
    baseUrl: ' http://localhost:8081/',
    headers: {
      Accept: 'application/json;odata=verbose;charset=utf-8',
      'Content-Type': 'application/json;odata=verbose',
    },
  },
});
export default {
  name: 'App',
  data: () => ({
    drawer: null,
    currentUserLogin: 'Пользователь',
    currentUserEmail: 'test@test.com',
    items: [
      { title: 'Home', icon: 'mdi-home-city', link: '/' },
      { title: 'Сотрудники', icon: 'mdi-account-group', link: '/employees' },
      {
        title: 'Мероприятия',
        icon: 'mdi-calendar-multiple-check',
        link: '/arrangements',
      },
      {
        title: 'Организации',
        icon: 'mdi-office-building',
        link: '/organisations',
      },
      {
        title: 'Места проведения',
        icon: 'mdi-map-marker-radius',
        link: '/places',
      },
    ],
    menuSettings: [
      { title: 'Настройки сайта' },
      { title: 'Контент сайта' },
      { title: 'Выйти' },
    ],
  }),
  methods: {
    toSiteSettings() {
      window.location.href = '/sites/ui/_layouts/15/settings.aspx';
    },
    toLogout() {
      window.location.href =
        '/sites/ui/_layouts/closeConnection.aspx?loginasanotheruser=true';
    },
    toSiteContent() {
      window.location.href = '/sites/ui/_layouts/15/viewlsts.aspx';
    },
    async getCurrentUser() {
      try {
        //Текущий пользователь
        await sp.web.currentUser
          .select('LoginName', 'Id', 'Email', 'Title')
          .get()
          .then(user => {
            this.currentUserLogin = user.Title;
            if (user.Email.length) {
              this.currentUserEmail = user.Email;
            }
          })
          .catch(err => console.log(err));
      } catch (e) {
        console.error(e);
      }
    },

    async getArrangements() {
      let items = await sp.web.lists
        .getByTitle('Arrangements')
        .items.select(
          'Title',
          'Experts/Title',
          'Place/Title',
          'StartDate',
          'EndDate'
        )
        .expand('Experts', 'Place')
        .get();
      console.log(items);
    },
  },
  mounted() {
    this.getCurrentUser();
    //this.getArrangements();
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
