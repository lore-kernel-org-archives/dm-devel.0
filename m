From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Tue, 10 Mar 2009 08:17:18 +0100
Message-ID: <49B613FE.3060501@suse.de>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>
	<49B60444.2090008@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060004040507090501040304"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B60444.2090008@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060004040507090501040304
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> Hi Hannes,
>=20
> On 2009/01/30 17:05 +0900, Kiyoshi Ueda wrote:
>>>>   o kernel panic occurs by frequent table swapping during heavy I/Os=
.
>>>> =20
>>> That's probably fixed by this patch:
>>>
>>> --- linux-2.6.27/drivers/md/dm.c.orig   2009-01-23 15:59:22.741461315=
 +0100
>>> +++ linux-2.6.27/drivers/md/dm.c        2009-01-26 09:03:02.787605723=
 +0100
>>> @@ -714,13 +714,14 @@ static void free_bio_clone(struct reques
>>>         struct dm_rq_target_io *tio =3D clone->end_io_data;
>>>         struct mapped_device *md =3D tio->md;
>>>         struct bio *bio;
>>> -       struct dm_clone_bio_info *info;
>>> =20
>>>         while ((bio =3D clone->bio) !=3D NULL) {
>>>                 clone->bio =3D bio->bi_next;
>>> =20
>>> -               info =3D bio->bi_private;
>>> -               free_bio_info(md, info);
>>> +               if (bio->bi_private) {
>>> +                       struct dm_clone_bio_info *info =3D bio->bi_pr=
ivate;
>>> +                       free_bio_info(md, info);
>>> +               }
>>> =20
>>>                 bio->bi_private =3D md->bs;
>>>                 bio_put(bio);
>>>
>>> The info field is not necessarily filled here, so we have to check fo=
r it
>>> explicitly.
>>>
>>> With these two patches request-based multipathing have survived all s=
tress-tests
>>> so far. Except on mainframe (zfcp), but that's more a driver-related =
thing.
>=20
> My problem was different from that one, and I have fixed my problem.
>=20
What was this? Was is something specific to your setup or some within the
request-based multipathing code?
If the latter, I'd be _very_ much interested in seeing the patch. Natural=
ly.

> Do you hit some problem without the patch above?
> If so, that should be a programming bug and we need to fix it.  Otherwi=
se,
> we should be leaking a memory (since all cloned bio should always have
> the dm_clone_bio_info structure in ->bi_private).
>=20
Yes, I've found that one later on.
The real problem was in clone_setup_bios(), which might end up calling an
invalid end_io_data pointer. Patch is attached.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)

--------------060004040507090501040304
Content-Type: text/plain;
 name="dm-use-md-for-free_bio_clone"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dm-use-md-for-free_bio_clone"

RnJvbTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+ClN1YmplY3Q6IEtlcm5lbCBv
b3BzIGluIGZyZWVfYmlvX2Nsb25lKCkKUmVmZXJlbmNlczogYm5jIzQ3MjM2MAoKQnVnIGlz
IGhlcmU6CgpzdGF0aWMgaW50IHNldHVwX2Nsb25lKHN0cnVjdCByZXF1ZXN0ICpjbG9uZSwg
c3RydWN0IHJlcXVlc3QgKnJxLAogICAgICAgICAgICAgICBzdHJ1Y3QgZG1fcnFfdGFyZ2V0
X2lvICp0aW8pCnsKICAgIGludCByOwoKICAgIGJsa19ycV9pbml0KE5VTEwsIGNsb25lKTsK
CiAgICByID0gY2xvbmVfcmVxdWVzdF9iaW9zKGNsb25lLCBycSwgdGlvLT5tZCk7CiAgICBp
ZiAocikKICAgICAgICByZXR1cm4gcjsKCiAgICBjb3B5X3JlcXVlc3RfaW5mbyhjbG9uZSwg
cnEpOwogICAgY2xvbmUtPnN0YXJ0X3RpbWUgPSBqaWZmaWVzOwogICAgY2xvbmUtPmVuZF9p
byA9IGVuZF9jbG9uZV9yZXF1ZXN0OwogICAgY2xvbmUtPmVuZF9pb19kYXRhID0gdGlvOwoK
ICAgIHJldHVybiAwOwp9CgpjbG9uZV9yZXF1ZXN0X2Jpb3MoKSBtaWdodCBlbmQgdXAgY2Fs
bGluZyBmcmVlX2Jpb19jbG9uZSgpLCB3aGljaCByZWZlcmVuY2VzOgoKc3RhdGljIHZvaWQg
ZnJlZV9iaW9fY2xvbmUoc3RydWN0IHJlcXVlc3QgKmNsb25lKQp7CiAgICBzdHJ1Y3QgZG1f
cnFfdGFyZ2V0X2lvICp0aW8gPSBjbG9uZS0+ZW5kX2lvX2RhdGE7CiAgICBzdHJ1Y3QgbWFw
cGVkX2RldmljZSAqbWQgPSB0aW8tPm1kOwouLi4KCmJ1dCBlbmRfaW9fZGF0YSB3aWxsIGJl
IHNldCBvbmx5IF9hZnRlcl8gdGhlIGNhbGwgdG8gY2xvbmVfcmVxdWVzdF9iaW9zKCkuClNv
IHdlIHNob3VsZCBiZSBwYXNzaW5nIHRoZSAnbWQnIGFyZ3VtZW50IGRpcmVjdGx5IGhlcmUg
dG8gYXZvaWQgdGhpcwpidWcgYW5kIHNldmVyYWwgcG9pbnRsZXNzIGRlcmVmZW5jaW5ncy4K
ClNpZ25lZC1vZmYtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKLS0tIGxp
bnV4LTIuNi4yNy1TTEUxMV9CUkFOQ0gvZHJpdmVycy9tZC9kbS5jLm9yaWcJMjAwOS0wMi0w
NCAxMDozMzoyMi42NTY2Mjc2NTAgKzAxMDAKKysrIGxpbnV4LTIuNi4yNy1TTEUxMV9CUkFO
Q0gvZHJpdmVycy9tZC9kbS5jCTIwMDktMDItMDUgMTE6MDM6MzUuODQzMjUxNzczICswMTAw
CkBAIC03MDksMTAgKzcwOSw4IEBAIHN0YXRpYyB2b2lkIGVuZF9jbG9uZV9iaW8oc3RydWN0
IGJpbyAqY2wKIAlibGtfdXBkYXRlX3JlcXVlc3QodGlvLT5vcmlnLCAwLCBucl9ieXRlcyk7
CiB9CiAKLXN0YXRpYyB2b2lkIGZyZWVfYmlvX2Nsb25lKHN0cnVjdCByZXF1ZXN0ICpjbG9u
ZSkKK3N0YXRpYyB2b2lkIGZyZWVfYmlvX2Nsb25lKHN0cnVjdCByZXF1ZXN0ICpjbG9uZSwg
c3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kKQogewotCXN0cnVjdCBkbV9ycV90YXJnZXRfaW8g
KnRpbyA9IGNsb25lLT5lbmRfaW9fZGF0YTsKLQlzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQg
PSB0aW8tPm1kOwogCXN0cnVjdCBiaW8gKmJpbzsKIAogCXdoaWxlICgoYmlvID0gY2xvbmUt
PmJpbykgIT0gTlVMTCkgewpAQCAtNzQzLDcgKzc0MSw3IEBAIHN0YXRpYyB2b2lkIGRtX3Vu
cHJlcF9yZXF1ZXN0KHN0cnVjdCByZXEKIAlycS0+c3BlY2lhbCA9IE5VTEw7CiAJcnEtPmNt
ZF9mbGFncyAmPSB+UkVRX0RPTlRQUkVQOwogCi0JZnJlZV9iaW9fY2xvbmUoY2xvbmUpOwor
CWZyZWVfYmlvX2Nsb25lKGNsb25lLCB0aW8tPm1kKTsKIAlkZWNfcnFfcGVuZGluZyh0aW8p
OwogCWZyZWVfcnFfdGlvKHRpby0+bWQsIHRpbyk7CiB9CkBAIC04MjAsNyArODE4LDcgQEAg
c3RhdGljIHZvaWQgZG1fZW5kX3JlcXVlc3Qoc3RydWN0IHJlcXVlcwogCQkJcnEtPnNlbnNl
X2xlbiA9IGNsb25lLT5zZW5zZV9sZW47CiAJfQogCi0JZnJlZV9iaW9fY2xvbmUoY2xvbmUp
OworCWZyZWVfYmlvX2Nsb25lKGNsb25lLCB0aW8tPm1kKTsKIAlkZWNfcnFfcGVuZGluZyh0
aW8pOwogCWZyZWVfcnFfdGlvKHRpby0+bWQsIHRpbyk7CiAKQEAgLTE0MDYsNyArMTQwNCw3
IEBAIHN0YXRpYyBpbnQgY2xvbmVfcmVxdWVzdF9iaW9zKHN0cnVjdCByZXEKIAlyZXR1cm4g
MDsKIAogZnJlZV9hbmRfb3V0OgotCWZyZWVfYmlvX2Nsb25lKGNsb25lKTsKKwlmcmVlX2Jp
b19jbG9uZShjbG9uZSwgbWQpOwogCiAJcmV0dXJuIC1FTk9NRU07CiB9Cg==
--------------060004040507090501040304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060004040507090501040304--
