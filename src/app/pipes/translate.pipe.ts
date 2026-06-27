import { Pipe, PipeTransform, inject } from '@angular/core';
import { LanguageService } from '../services/language.service';

@Pipe({
  name: 't',
  standalone: true,
  pure: false, // re-evaluates when the language signal changes
})
export class TranslatePipe implements PipeTransform {
  private lang = inject(LanguageService);

  transform(key: string): string {
    // Touch the signal so Angular's change detection re-runs this pipe
    // whenever the language switches.
    this.lang.lang();
    return this.lang.t(key);
  }
}
