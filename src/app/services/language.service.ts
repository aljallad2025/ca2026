import { Injectable, signal, effect } from '@angular/core';
import { HttpClient } from '@angular/common/http';

export type AppLang = 'en' | 'ar';

@Injectable({ providedIn: 'root' })
export class LanguageService {
  lang = signal<AppLang>('en');
  private translations: Record<string, any> = {};
  private loaded = signal(false);

  constructor(private http: HttpClient) {
    const saved = (localStorage.getItem('app_lang') as AppLang) || 'en';
    this.lang.set(saved);
    this.loadTranslations(saved);

    effect(() => {
      const current = this.lang();
      document.documentElement.setAttribute('dir', current === 'ar' ? 'rtl' : 'ltr');
      document.documentElement.setAttribute('lang', current);
    });
  }

  private async loadTranslations(lang: AppLang) {
    this.loaded.set(false);
    try {
      const data = await this.http.get<any>(`assets/i18n/${lang}.json`).toPromise();
      this.translations = data || {};
    } catch {
      this.translations = {};
    }
    this.loaded.set(true);
  }

  async setLang(lang: AppLang) {
    localStorage.setItem('app_lang', lang);
    this.lang.set(lang);
    await this.loadTranslations(lang);
  }

  toggle() {
    this.setLang(this.lang() === 'en' ? 'ar' : 'en');
  }

  // Looks up a dot-notation key, e.g. t('home.greeting'). Falls back to the
  // key itself if missing, so a forgotten translation is visible (not blank).
  t(key: string): string {
    const parts = key.split('.');
    let node: any = this.translations;
    for (const p of parts) {
      if (node == null) return key;
      node = node[p];
    }
    return typeof node === 'string' ? node : key;
  }

  get isRTL(): boolean {
    return this.lang() === 'ar';
  }
}
