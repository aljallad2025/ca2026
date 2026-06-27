import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { IonContent, IonButton, IonIcon } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { TranslatePipe } from '../../pipes/translate.pipe';
import { addIcons } from 'ionicons';
import { flash } from 'ionicons/icons';

interface OnboardingSlide {
  titleKey: string;
  subtitleKey: string;
  image: string;
}

@Component({
  selector: 'app-onboarding',
  templateUrl: './onboarding.page.html',
  styleUrls: ['./onboarding.page.scss'],
  standalone: true,
  imports: [IonContent, IonButton, IonIcon, CommonModule, TranslatePipe],
})
export class OnboardingPage {
  currentSlide = 0;

  // Fixed, original illustrations bundled with the app (no copyright risk,
  // no dependency on what happens to be in the live fleet at the moment).
  slides: OnboardingSlide[] = [
    { titleKey: 'onboarding.slide1Title', subtitleKey: 'onboarding.slide1Subtitle', image: 'assets/images/hero-car.svg' },
    { titleKey: 'onboarding.slide2Title', subtitleKey: 'onboarding.slide2Subtitle', image: 'assets/images/hero-car.svg' },
    { titleKey: 'onboarding.slide3Title', subtitleKey: 'onboarding.slide3Subtitle', image: 'assets/images/hero-car.svg' },
  ];

  constructor(private router: Router) {
    addIcons({ flash });
  }

  next() {
    if (this.currentSlide < this.slides.length - 1) {
      this.currentSlide++;
    } else {
      this.skip();
    }
  }

  skip() {
    localStorage.setItem('onboarding_done', 'true');
    this.router.navigate(['/auth/login']);
  }
}
