From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 4/5] libmultipath: Print line number for
	which parsing failed
Date: Fri, 25 Jul 2014 11:15:44 +0200
Message-ID: <CABr-GndRdRLRXxREVFMrZ6yfgsBc_AK-Tfojk+QDHJJ7M8ppZg@mail.gmail.com>
References: <53C91871.9070402@acm.org> <53C918F5.2050703@acm.org>
	<20140724164404.000073d6@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2702182168305432995=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140724164404.000073d6@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

--===============2702182168305432995==
Content-Type: multipart/alternative; boundary=001a11c1e27e9c22d604ff0104d9

--001a11c1e27e9c22d604ff0104d9
Content-Type: text/plain; charset=UTF-8

Done,
Thanks.


On Thu, Jul 24, 2014 at 4:44 PM, Sebastian Herbszt <herbszt@gmx.de> wrote:

> Bart Van Assche wrote:
> > Make it easier to figure out which line contains a syntax error
> > by printing the line number and the offending line itself.
> >
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  libmultipath/parser.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> > index b7bdfcc..d8673bc 100644
> > --- a/libmultipath/parser.c
> > +++ b/libmultipath/parser.c
> > @@ -460,7 +460,7 @@ int
> >  process_stream(vector keywords)
> >  {
> >       int i;
> > -     int r = 0;
> > +     int r = 0, t;
> >       struct keyword *keyword;
> >       char *str;
> >       char *buf;
> > @@ -501,8 +501,13 @@ process_stream(vector keywords)
> >                                               free_strvec(strvec);
> >                                               goto out;
> >                               }
> > -                             if (keyword->handler)
> > -                                     r += (*keyword->handler) (strvec);
> > +                             if (keyword->handler) {
> > +                                     t = (*keyword->handler) (strvec);
> > +                                     r += t;
> > +                                     if (t)
> > +                                             condlog(1, "multipath.conf
> +%d parsing failed: %s",
> > +                                                     line_nr, buf);
> > +                             }
> >
> >                               if (keyword->sub) {
> >                                       kw_level++;
>
> Further below
> condlog(1, "multipath.conf +%d, invalid keyword: %s", line_nr, str);
> is used, so maybe also add a comma after the line number too.
>
> Sebastian
>

--001a11c1e27e9c22d604ff0104d9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+RG9uZSw8ZGl2PlRoYW5rcy48L2Rpdj48L2Rpdj48ZGl2IGNsYXNzPSJn
bWFpbF9leHRyYSI+PGJyPjxicj48ZGl2IGNsYXNzPSJnbWFpbF9xdW90ZSI+T24gVGh1LCBKdWwg
MjQsIDIwMTQgYXQgNDo0NCBQTSwgU2ViYXN0aWFuIEhlcmJzenQgPHNwYW4gZGlyPSJsdHIiPiZs
dDs8YSBocmVmPSJtYWlsdG86aGVyYnN6dEBnbXguZGUiIHRhcmdldD0iX2JsYW5rIj5oZXJic3p0
QGdteC5kZTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+DQo8YmxvY2txdW90ZSBjbGFzcz0iZ21h
aWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXItbGVmdDoxcHggI2NjYyBz
b2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij48ZGl2IGNsYXNzPSJIT0VuWmIiPjxkaXYgY2xhc3M9Img1
Ij5CYXJ0IFZhbiBBc3NjaGUgd3JvdGU6PGJyPg0KJmd0OyBNYWtlIGl0IGVhc2llciB0byBmaWd1
cmUgb3V0IHdoaWNoIGxpbmUgY29udGFpbnMgYSBzeW50YXggZXJyb3I8YnI+DQomZ3Q7IGJ5IHBy
aW50aW5nIHRoZSBsaW5lIG51bWJlciBhbmQgdGhlIG9mZmVuZGluZyBsaW5lIGl0c2VsZi48YnI+
DQomZ3Q7PGJyPg0KJmd0OyBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgJmx0OzxhIGhy
ZWY9Im1haWx0bzpidmFuYXNzY2hlQGFjbS5vcmciPmJ2YW5hc3NjaGVAYWNtLm9yZzwvYT4mZ3Q7
PGJyPg0KJmd0OyAtLS08YnI+DQomZ3Q7IMKgbGlibXVsdGlwYXRoL3BhcnNlci5jIHwgMTEgKysr
KysrKystLS08YnI+DQomZ3Q7IMKgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMyBk
ZWxldGlvbnMoLSk8YnI+DQomZ3Q7PGJyPg0KJmd0OyBkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRo
L3BhcnNlci5jIGIvbGlibXVsdGlwYXRoL3BhcnNlci5jPGJyPg0KJmd0OyBpbmRleCBiN2JkZmNj
Li5kODY3M2JjIDEwMDY0NDxicj4NCiZndDsgLS0tIGEvbGlibXVsdGlwYXRoL3BhcnNlci5jPGJy
Pg0KJmd0OyArKysgYi9saWJtdWx0aXBhdGgvcGFyc2VyLmM8YnI+DQomZ3Q7IEBAIC00NjAsNyAr
NDYwLDcgQEAgaW50PGJyPg0KJmd0OyDCoHByb2Nlc3Nfc3RyZWFtKHZlY3RvciBrZXl3b3Jkcyk8
YnI+DQomZ3Q7IMKgezxicj4NCiZndDsgwqAgwqAgwqAgaW50IGk7PGJyPg0KJmd0OyAtIMKgIMKg
IGludCByID0gMDs8YnI+DQomZ3Q7ICsgwqAgwqAgaW50IHIgPSAwLCB0Ozxicj4NCiZndDsgwqAg
wqAgwqAgc3RydWN0IGtleXdvcmQgKmtleXdvcmQ7PGJyPg0KJmd0OyDCoCDCoCDCoCBjaGFyICpz
dHI7PGJyPg0KJmd0OyDCoCDCoCDCoCBjaGFyICpidWY7PGJyPg0KJmd0OyBAQCAtNTAxLDggKzUw
MSwxMyBAQCBwcm9jZXNzX3N0cmVhbSh2ZWN0b3Iga2V5d29yZHMpPGJyPg0KJmd0OyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBmcmVlX3N0cnZlYyhzdHJ2ZWMpOzxicj4NCiZndDsgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBvdXQ7
PGJyPg0KJmd0OyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9
PGJyPg0KJmd0OyAtIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlm
IChrZXl3b3JkLSZndDtoYW5kbGVyKTxicj4NCiZndDsgLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByICs9ICgqa2V5d29yZC0mZ3Q7aGFuZGxl
cikgKHN0cnZlYyk7PGJyPg0KJmd0OyArIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGlmIChrZXl3b3JkLSZndDtoYW5kbGVyKSB7PGJyPg0KJmd0OyArIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHQgPSAoKmtleXdv
cmQtJmd0O2hhbmRsZXIpIChzdHJ2ZWMpOzxicj4NCiZndDsgKyDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByICs9IHQ7PGJyPg0KJmd0OyArIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmICh0
KTxicj4NCiZndDsgKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25kbG9nKDEsICZxdW90O211bHRpcGF0aC5jb25mICsl
ZCBwYXJzaW5nIGZhaWxlZDogJXMmcXVvdDssPGJyPg0KJmd0OyArIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGxpbmVfbnIsIGJ1Zik7PGJyPg0KJmd0OyArIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIH08YnI+DQomZ3Q7PGJyPg0KJmd0OyDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoa2V5d29yZC0mZ3Q7c3ViKSB7PGJyPg0KJmd0
OyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBrd19sZXZlbCsrOzxicj4NCjxicj4NCjwvZGl2PjwvZGl2PkZ1cnRoZXIgYmVsb3c8YnI+DQpj
b25kbG9nKDEsICZxdW90O211bHRpcGF0aC5jb25mICslZCwgaW52YWxpZCBrZXl3b3JkOiAlcyZx
dW90OywgbGluZV9uciwgc3RyKTs8YnI+DQppcyB1c2VkLCBzbyBtYXliZSBhbHNvIGFkZCBhIGNv
bW1hIGFmdGVyIHRoZSBsaW5lIG51bWJlciB0b28uPGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+
PGZvbnQgY29sb3I9IiM4ODg4ODgiPjxicj4NClNlYmFzdGlhbjxicj4NCjwvZm9udD48L3NwYW4+
PC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg==
--001a11c1e27e9c22d604ff0104d9--


--===============2702182168305432995==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2702182168305432995==--
