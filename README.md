# GymLog — mākoņsinhronizēta treniņu aplikācija

GymLog ir responsīva tīmekļa lietotne ar e-pasta/paroles kontu, Supabase datubāzi un RLS drošības politikām. Pēc publicēšanas to var atvērt telefonā un datorā; ieteicams pievienot sākuma ekrānam.

## Izmantotais risinājums

- **Supabase** — autentifikācija un PostgreSQL mākoņdatubāze.
- **Vercel** — statiskās lietotnes hostings (alternatīva: Netlify).
- **PWA pamati** — manifest un service worker.
- **Izmaksas** — var sākt ar bezmaksas līmeņiem; pakalpojumu cenas un limiti var mainīties, pārbaudi to oficiālajās lapās.

## 1. Izveido Supabase projektu

1. Atver https://supabase.com/ un izveido projektu.
2. Saglabā datubāzes paroli drošā vietā.
3. Supabase projektā atver **SQL Editor → New query**.
4. Ielīmē visu `supabase-schema.sql` saturu un nospied **Run**.
5. Atver **Project Settings → API** (vai Connect/API Keys, atkarībā no paneļa versijas) un nokopē:
   - Project URL
   - anon/public key (jaunajā saskarnē tā var būt `Publishable key`, kas sākas ar `sb_publishable_...`)
6. **Nekad neizmanto `service_role` vai secret key pārlūkprogrammas lietotnē.** Šī lietotne izmanto anon/public atslēgu un RLS politikas.

## 2. Publicē lietotni Vercel

1. Atver https://vercel.com/ un pieslēdzies.
2. Izveido GitHub repozitoriju, piemēram, `gymlog`, un augšupielādē šīs mapes failus.
3. Vercel izvēlies **Add New → Project**, importē repozitoriju.
4. Framework Preset: **Other**; Build Command un Output Directory atstāj tukšu vai norādi `.` kā statisku failu projektu.
5. Nospied **Deploy**. Vercel izveidos HTTPS adresi.
6. Atver publicēto adresi. Pirmajā reizē ievadi Supabase Project URL un anon/public key. Tie tiek saglabāti šīs pārlūkprogrammas lokālajos iestatījumos.

Alternatīva bez GitHub: augšupielādē mapi statiskās vietnes hostinga servisā, kas atbalsta HTTPS. Vercel parasti ir ērtāks atjauninājumiem.

## 3. Pārbaudi Supabase autentifikāciju

Supabase Dashboard → **Authentication → URL Configuration**:
- Site URL: ieliec savu Vercel publicēto URL, piemēram, `https://tavs-projekts.vercel.app`.
- Redirect URLs: pievieno to pašu URL.

Authentication → Providers → Email:
- Atstāj e-pasta autentifikāciju ieslēgtu.
- Ja e-pasta apstiprināšana ir ieslēgta, pēc reģistrācijas atver apstiprinājuma e-pastu un tad pieslēdzies.

## 4. Pirmā palaišana

1. Atver Vercel adresi.
2. Ievadi Supabase Project URL un anon/public key.
3. Izveido kontu un pieslēdzies.
4. Saglabā testa treniņu.
5. Atver to pašu URL citā ierīcē un pieslēdzies ar to pašu kontu. Treniņam jāparādās vēsturē.

## 5. Pievieno sākuma ekrānam

- **iPhone:** atver vietni Safari → Share → Add to Home Screen.
- **Android:** atver Chrome → izvēlne → Install app / Add to Home screen.

## Datu drošība

- RLS (Row Level Security) politikās lietotājs drīkst lasīt, ievietot, mainīt un dzēst tikai ierakstus, kuru `user_id` sakrīt ar autentificētā lietotāja ID.
- Klienta pusē drīkst atrasties tikai Supabase Project URL un anon/public key.
- Nekad nepublicē `service_role`/secret key, datubāzes paroli vai citus noslēpumus.
- Pirms ikdienas lietošanas testē ar diviem kontiem, lai pārliecinātos, ka viens konts neredz otra treniņus.
- Šī ir sākuma versija. Nav iekļauta paroles atiestatīšanas UI, sociālā pieteikšanās vai automātiska bezsaistes datu rindu sinhronizācija.

## Faili

- `index.html` — pati lietotne.
- `supabase-schema.sql` — datubāzes tabula un piekļuves politikas.
- `manifest.webmanifest`, `sw.js`, `icon.svg` — PWA pamati.
- `vercel.json` — hostinga galvenes un SPA fallback.

## Biežākās kļūdas

- **Invalid API key:** pārbaudi Project URL un anon/public key.
- **relation workout_sessions does not exist:** SQL shēma nav palaista.
- **Row Level Security policy violation:** pārliecinies, ka esi pieslēdzies un SQL politikas izveidotas.
- **Reģistrācija saka “pārbaudi e-pastu”:** apstiprini e-pastu, ja Supabase pieprasa apstiprinājumu.
