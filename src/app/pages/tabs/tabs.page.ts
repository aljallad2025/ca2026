import { Component } from '@angular/core';
import { IonTabs, IonTabBar, IonTabButton, IonIcon, IonLabel, IonRouterOutlet } from '@ionic/angular/standalone';
import { TranslatePipe } from '../../pipes/translate.pipe';
import { addIcons } from 'ionicons';
import { home, homeOutline, carSport, carSportOutline, listCircle, listCircleOutline, personCircle, personCircleOutline } from 'ionicons/icons';

@Component({
  selector: 'app-tabs',
  template: `
    <ion-tabs>
      <ion-router-outlet></ion-router-outlet>
      <ion-tab-bar slot="bottom">
        <ion-tab-button tab="home" href="/tabs/home">
          <ion-icon name="home-outline"></ion-icon>
          <ion-label>{{ 'tabs.home' | t }}</ion-label>
        </ion-tab-button>
        <ion-tab-button tab="cars/rental" href="/tabs/cars/rental">
          <ion-icon name="car-sport-outline"></ion-icon>
          <ion-label>{{ 'tabs.rent' | t }}</ion-label>
        </ion-tab-button>
        <ion-tab-button tab="my-bookings" href="/tabs/my-bookings">
          <ion-icon name="list-circle-outline"></ion-icon>
          <ion-label>{{ 'tabs.bookings' | t }}</ion-label>
        </ion-tab-button>
        <ion-tab-button tab="profile" href="/tabs/profile">
          <ion-icon name="person-circle-outline"></ion-icon>
          <ion-label>{{ 'tabs.profile' | t }}</ion-label>
        </ion-tab-button>
      </ion-tab-bar>
    </ion-tabs>
  `,
  styles: [`
    ion-tab-bar {
      height: 64px;
      padding-top: 4px;
    }
    ion-tab-button {
      font-size: 11px;
    }
    ion-tab-button ion-icon {
      font-size: 22px;
    }
  `],
  standalone: true,
  imports: [IonTabs, IonTabBar, IonTabButton, IonIcon, IonLabel, IonRouterOutlet, TranslatePipe],
})
export class TabsPage {
  constructor() {
    addIcons({ home, homeOutline, carSport, carSportOutline, listCircle, listCircleOutline, personCircle, personCircleOutline });
  }
}
