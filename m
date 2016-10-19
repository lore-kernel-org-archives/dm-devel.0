From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/3] access vecs memory outside of locking
	range in check_path()
Date: Wed, 19 Oct 2016 08:00:23 +0200
Message-ID: <CABr-Gnck-z7xJE4gB6-6o9KgRFvS_DtCQ4ah0YrvL0FKSnM-Ng@mail.gmail.com>
References: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
	<1476759069-9832-2-git-send-email-tang.junhui@zte.com.cn>
	<20161018162216.GL1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8944883967548387406=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161018162216.GL1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============8944883967548387406==
Content-Type: multipart/alternative; boundary=94eb2c0db23a5ee3d2053f3186c0

--94eb2c0db23a5ee3d2053f3186c0
Content-Type: text/plain; charset=UTF-8

Merged.

On Tue, Oct 18, 2016 at 6:22 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Oct 18, 2016 at 10:51:08AM +0800, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> >
> > there are vecs->mpvec memory accesses outside of locking range in
> > check_path(), the judgments is not necessary since the they has
> > existed in vector_foreach_slot(), so delete them.
>
> ACK
>
> -Ben
>
>
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> > ---
> >  multipathd/main.c | 45 ++++++++++++++++++++++-----------------------
> >  1 file changed, 22 insertions(+), 23 deletions(-)
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index b6eb696..e369a79 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1804,30 +1804,29 @@ checkerloop (void *ap)
> >                       condlog(4, "timeout waiting for DAEMON_IDLE");
> >                       continue;
> >               }
> > -             if (vecs->pathvec) {
> > -                     pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > -                     lock(&vecs->lock);
> > -                     pthread_testcancel();
> > -                     vector_foreach_slot (vecs->pathvec, pp, i) {
> > -                             rc = check_path(vecs, pp, ticks);
> > -                             if (rc < 0) {
> > -                                     vector_del_slot(vecs->pathvec, i);
> > -                                     free_path(pp);
> > -                                     i--;
> > -                             } else
> > -                                     num_paths += rc;
> > -                     }
> > -                     lock_cleanup_pop(vecs->lock);
> > -             }
> > -             if (vecs->mpvec) {
> > -                     pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > -                     lock(&vecs->lock);
> > -                     pthread_testcancel();
> > -                     defered_failback_tick(vecs->mpvec);
> > -                     retry_count_tick(vecs->mpvec);
> > -                     missing_uev_wait_tick(vecs);
> > -                     lock_cleanup_pop(vecs->lock);
> > +
> > +             pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > +             lock(&vecs->lock);
> > +             pthread_testcancel();
> > +             vector_foreach_slot (vecs->pathvec, pp, i) {
> > +                     rc = check_path(vecs, pp, ticks);
> > +                     if (rc < 0) {
> > +                             vector_del_slot(vecs->pathvec, i);
> > +                             free_path(pp);
> > +                             i--;
> > +                     } else
> > +                             num_paths += rc;
> >               }
> > +             lock_cleanup_pop(vecs->lock);
> > +
> > +             pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > +             lock(&vecs->lock);
> > +             pthread_testcancel();
> > +             defered_failback_tick(vecs->mpvec);
> > +             retry_count_tick(vecs->mpvec);
> > +             missing_uev_wait_tick(vecs);
> > +             lock_cleanup_pop(vecs->lock);
> > +
> >               if (count)
> >                       count--;
> >               else {
> > --
> > 2.8.1.windows.1
>

--94eb2c0db23a5ee3d2053f3186c0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+
PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFR1ZSwgT2N0IDE4LCAyMDE2IGF0IDY6MjIgUE0s
IEJlbmphbWluIE1hcnppbnNraSA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzpi
bWFyemluc0ByZWRoYXQuY29tIiB0YXJnZXQ9Il9ibGFuayI+Ym1hcnppbnNAcmVkaGF0LmNvbTwv
YT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBz
dHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGlu
Zy1sZWZ0OjFleCI+PHNwYW4gY2xhc3M9IiI+T24gVHVlLCBPY3QgMTgsIDIwMTYgYXQgMTA6NTE6
MDhBTSArMDgwMCwgPGEgaHJlZj0ibWFpbHRvOnRhbmcuanVuaHVpQHp0ZS5jb20uY24iPnRhbmcu
anVuaHVpQHp0ZS5jb20uY248L2E+IHdyb3RlOjxicj4NCiZndDsgRnJvbTogJnF1b3Q7dGFuZy5q
dW5odWkmcXVvdDsgJmx0OzxhIGhyZWY9Im1haWx0bzp0YW5nLmp1bmh1aUB6dGUuY29tLmNuIj50
YW5nLmp1bmh1aUB6dGUuY29tLmNuPC9hPiZndDs8YnI+DQomZ3Q7PGJyPg0KJmd0OyB0aGVyZSBh
cmUgdmVjcy0mZ3Q7bXB2ZWMgbWVtb3J5IGFjY2Vzc2VzIG91dHNpZGUgb2YgbG9ja2luZyByYW5n
ZSBpbjxicj4NCiZndDsgY2hlY2tfcGF0aCgpLCB0aGUganVkZ21lbnRzIGlzIG5vdCBuZWNlc3Nh
cnkgc2luY2UgdGhlIHRoZXkgaGFzPGJyPg0KJmd0OyBleGlzdGVkIGluIHZlY3Rvcl9mb3JlYWNo
X3Nsb3QoKSwgc28gZGVsZXRlIHRoZW0uPGJyPg0KPGJyPg0KPC9zcGFuPkFDSzxicj4NCjxicj4N
Ci1CZW48YnI+DQo8ZGl2IGNsYXNzPSJIT0VuWmIiPjxkaXYgY2xhc3M9Img1Ij48YnI+DQo8YnI+
DQomZ3Q7IFNpZ25lZC1vZmYtYnk6IHRhbmcuanVuaHVpICZsdDs8YSBocmVmPSJtYWlsdG86dGFu
Zy5qdW5odWlAenRlLmNvbS5jbiI+dGFuZy5qdW5odWlAenRlLmNvbS5jbjwvYT4mZ3Q7PGJyPg0K
Jmd0OyAtLS08YnI+DQomZ3Q7wqAgbXVsdGlwYXRoZC9tYWluLmMgfCA0NSArKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tLS08d2JyPi0tLS0tLS0tLS0tLS0tLTxicj4NCiZndDvCoCAxIGZpbGUg
Y2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pPGJyPg0KJmd0Ozxicj4N
CiZndDsgZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvbWFpbi5jIGIvbXVsdGlwYXRoZC9tYWluLmM8
YnI+DQomZ3Q7IGluZGV4IGI2ZWI2OTYuLmUzNjlhNzkgMTAwNjQ0PGJyPg0KJmd0OyAtLS0gYS9t
dWx0aXBhdGhkL21haW4uYzxicj4NCiZndDsgKysrIGIvbXVsdGlwYXRoZC9tYWluLmM8YnI+DQom
Z3Q7IEBAIC0xODA0LDMwICsxODA0LDI5IEBAIGNoZWNrZXJsb29wICh2b2lkICphcCk8YnI+DQom
Z3Q7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDQsICZxdW90O3Rp
bWVvdXQgd2FpdGluZyBmb3IgREFFTU9OX0lETEUmcXVvdDspOzxicj4NCiZndDvCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbnRpbnVlOzxicj4NCiZndDvCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoH08YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoGlmICh2ZWNzLSZndDtw
YXRodmVjKSB7PGJyPg0KJmd0OyAtwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwdGhy
ZWFkX2NsZWFudXBfcHVzaChjbGVhbnVwXzx3YnI+bG9jaywgJmFtcDt2ZWNzLSZndDtsb2NrKTs8
YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGxvY2soJmFtcDt2ZWNz
LSZndDtsb2NrKTs8YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHB0
aHJlYWRfdGVzdGNhbmNlbCgpOzxicj4NCiZndDsgLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgdmVjdG9yX2ZvcmVhY2hfc2xvdCAodmVjcy0mZ3Q7cGF0aHZlYywgcHAsIGkpIHs8YnI+
DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJjID0g
Y2hlY2tfcGF0aCh2ZWNzLCBwcCwgdGlja3MpOzxicj4NCiZndDsgLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHJjICZsdDsgMCkgezxicj4NCiZndDsgLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgdmVj
dG9yX2RlbF9zbG90KHZlY3MtJmd0O3BhdGh2ZWMsIGkpOzxicj4NCiZndDsgLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZnJlZV9wYXRoKHBw
KTs8YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGktLTs8YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoH0gZWxzZTxicj4NCiZndDsgLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbnVtX3BhdGhzICs9IHJjOzxicj4NCiZn
dDsgLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfTxicj4NCiZndDsgLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbG9ja19jbGVhbnVwX3BvcCh2ZWNzLSZndDtsb2NrKTs8
YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoH08YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDC
oCDCoCDCoGlmICh2ZWNzLSZndDttcHZlYykgezxicj4NCiZndDsgLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgcHRocmVhZF9jbGVhbnVwX3B1c2goY2xlYW51cF88d2JyPmxvY2ssICZh
bXA7dmVjcy0mZ3Q7bG9jayk7PGJyPg0KJmd0OyAtwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBsb2NrKCZhbXA7dmVjcy0mZ3Q7bG9jayk7PGJyPg0KJmd0OyAtwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBwdGhyZWFkX3Rlc3RjYW5jZWwoKTs8YnI+DQomZ3Q7IC3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGRlZmVyZWRfZmFpbGJhY2tfdGljayh2ZWNzLSZndDs8
d2JyPm1wdmVjKTs8YnI+DQomZ3Q7IC3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJl
dHJ5X2NvdW50X3RpY2sodmVjcy0mZ3Q7bXB2ZWMpOzxicj4NCiZndDsgLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgbWlzc2luZ191ZXZfd2FpdF90aWNrKHZlY3MpOzxicj4NCiZndDsg
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbG9ja19jbGVhbnVwX3BvcCh2ZWNzLSZn
dDtsb2NrKTs8YnI+DQomZ3Q7ICs8YnI+DQomZ3Q7ICvCoCDCoCDCoCDCoCDCoCDCoCDCoHB0aHJl
YWRfY2xlYW51cF9wdXNoKGNsZWFudXBfPHdicj5sb2NrLCAmYW1wO3ZlY3MtJmd0O2xvY2spOzxi
cj4NCiZndDsgK8KgIMKgIMKgIMKgIMKgIMKgIMKgbG9jaygmYW1wO3ZlY3MtJmd0O2xvY2spOzxi
cj4NCiZndDsgK8KgIMKgIMKgIMKgIMKgIMKgIMKgcHRocmVhZF90ZXN0Y2FuY2VsKCk7PGJyPg0K
Jmd0OyArwqAgwqAgwqAgwqAgwqAgwqAgwqB2ZWN0b3JfZm9yZWFjaF9zbG90ICh2ZWNzLSZndDtw
YXRodmVjLCBwcCwgaSkgezxicj4NCiZndDsgK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgcmMgPSBjaGVja19wYXRoKHZlY3MsIHBwLCB0aWNrcyk7PGJyPg0KJmd0OyArwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAocmMgJmx0OyAwKSB7PGJyPg0KJmd0OyArwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB2ZWN0b3JfZGVsX3Nsb3QodmVj
cy0mZ3Q7cGF0aHZlYywgaSk7PGJyPg0KJmd0OyArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBmcmVlX3BhdGgocHApOzxicj4NCiZndDsgK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaS0tOzxicj4NCiZndDsgK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgfSBlbHNlPGJyPg0KJmd0OyArwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBudW1fcGF0aHMgKz0gcmM7PGJyPg0KJmd0O8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgfTxicj4NCiZndDsgK8KgIMKgIMKgIMKgIMKgIMKgIMKgbG9ja19j
bGVhbnVwX3BvcCh2ZWNzLSZndDtsb2NrKTs8YnI+DQomZ3Q7ICs8YnI+DQomZ3Q7ICvCoCDCoCDC
oCDCoCDCoCDCoCDCoHB0aHJlYWRfY2xlYW51cF9wdXNoKGNsZWFudXBfPHdicj5sb2NrLCAmYW1w
O3ZlY3MtJmd0O2xvY2spOzxicj4NCiZndDsgK8KgIMKgIMKgIMKgIMKgIMKgIMKgbG9jaygmYW1w
O3ZlY3MtJmd0O2xvY2spOzxicj4NCiZndDsgK8KgIMKgIMKgIMKgIMKgIMKgIMKgcHRocmVhZF90
ZXN0Y2FuY2VsKCk7PGJyPg0KJmd0OyArwqAgwqAgwqAgwqAgwqAgwqAgwqBkZWZlcmVkX2ZhaWxi
YWNrX3RpY2sodmVjcy0mZ3Q7PHdicj5tcHZlYyk7PGJyPg0KJmd0OyArwqAgwqAgwqAgwqAgwqAg
wqAgwqByZXRyeV9jb3VudF90aWNrKHZlY3MtJmd0O21wdmVjKTs8YnI+DQomZ3Q7ICvCoCDCoCDC
oCDCoCDCoCDCoCDCoG1pc3NpbmdfdWV2X3dhaXRfdGljayh2ZWNzKTs8YnI+DQomZ3Q7ICvCoCDC
oCDCoCDCoCDCoCDCoCDCoGxvY2tfY2xlYW51cF9wb3AodmVjcy0mZ3Q7bG9jayk7PGJyPg0KJmd0
OyArPGJyPg0KJmd0O8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKGNvdW50KTxicj4NCiZndDvC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvdW50LS07PGJyPg0KJmd0O8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgZWxzZSB7PGJyPg0KJmd0OyAtLTxicj4NCiZndDsgMi44LjEud2lu
ZG93cy4xPGJyPg0KPC9kaXY+PC9kaXY+PC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg==
--94eb2c0db23a5ee3d2053f3186c0--


--===============8944883967548387406==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8944883967548387406==--
