From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipathd segfault
Date: Fri, 27 Mar 2009 08:50:30 +0100
Message-ID: <49CC8546.9080500@suse.de>
References: <448b15030903261725x1fc4c02dx594c6df7b8daa11e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050406000007040200050302"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <448b15030903261725x1fc4c02dx594c6df7b8daa11e@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050406000007040200050302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

David Strand wrote:
> I am getting a multipathd segfault when I have more than 26 devices,
> and the device names become 4 characters. (i.e. /dev/sdz is consumed
> and the next device is /dev/sdaa).
>=20
> I was trying to hook gdb to a core dump, but it keeps complaining that
> it needs device-mapper-libs-debuginfo, which I can not find. Can
> anyone point me to this?
>=20
> I built multipathd with -g turned on and did not strip it. Here is the
> last few lines of output when I run it as multipathd -v9 -d:
>=20
> Jul 04 05:01:26 | alpa-0x000080: discover
> Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm table
> alpa-0x000080  NF   [16384]
> Jul 04 05:01:26 | *word =3D 0, len =3D 1
> Jul 04 05:01:26 | *word =3D 0, len =3D 1
> Jul 04 05:01:26 | *word =3D 1, len =3D 1
> Jul 04 05:01:26 | *word =3D 1, len =3D 1
> Jul 04 05:01:26 | *word =3D 1, len =3D 1
> Jul 04 05:01:26 | *word =3D 1, len =3D 1
> Jul 04 05:01:26 | *word =3D 65:160, len =3D 6
> Jul 04 05:01:26 | *word =3D 1000, len =3D 4
> Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm status
> alpa-0x000080  NF   [16384]
> Jul 04 05:01:26 | *word =3D 2, len =3D 1
> Jul 04 05:01:26 | *word =3D 0, len =3D 1
> Jul 04 05:01:26 | *word =3D 0, len =3D 1
> Jul 04 05:01:26 | *word =3D 1, len =3D 1
> Jul 04 05:01:26 | *word =3D E, len =3D 1
> Jul 04 05:01:26 | *word =3D 1, len =3D 1
> Jul 04 05:01:26 | *word =3D 0, len =3D 1
> Jul 04 05:01:26 | *word =3D A, len =3D 1
> Jul 04 05:01:26 | *word =3D 0, len =3D 1
> Jul 04 05:01:26 | alpa-0x000080: rr_weight =3D 1 (internal default)
> Jul 04 05:01:26 | alpa-0x000080: pgfailback =3D -2 (config file default=
)
> Jul 04 05:01:26 | alpa-0x000080: no_path_retry =3D 3 (config file defau=
lt)
> Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm message
> alpa-0x000080  NF  queue_if_no_path
>  [16384]
> Jul 04 05:01:26 | pg_timeout =3D NONE (internal default)
> Jul 04 05:01:26 | alpa-0x000080: event checker started
> Jul 04 05:01:26 | sdaa path added to devmap alpa-0x000080
> Jul 04 05:01:26 | discard event on /block/sdaa/sdaa1
> Segmentation fault
>=20
Oh, that one.

Fixed by the attached path.

Christophe, care to apply?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)

--------------050406000007040200050302
Content-Type: text/plain;
 name="multipath-tools-uev-discard-segfault"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="multipath-tools-uev-discard-segfault"

Y29tbWl0IDIyMzg4NWI2NjMxMWJiYjQ3ZTQzOTU1N2VjZWQwNjZiMzMyNGFkOGUKQXV0aG9y
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KRGF0ZTogICBUdWUgTWFyIDEwIDA4
OjU3OjE4IDIwMDkgKzAxMDAKCiAgICBTdGFjayBvdmVyZmxvdyBpbiB1ZXZfdHJpZ2dlcigp
CiAgICAKICAgIHVldl9kaXNjYXJkIHVzZXMgc3NjYW5mIHRvIHdyaXRlIGEgMTAgYnl0ZSBz
dHJpbmcgaW50byBhbiBhcnJheSwKICAgIGJ1dCBJIGZvcmdvdCB0byB0YWtlIHRoZSB0cmFp
bGluZyBOVUxMIGJ5dGUgaW50byBhY2NvdW50LgogICAgCiAgICBSZWZlcmVuY2VzOiBibmMj
NDc2NTQwCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBz
dXNlLmRlPgoKZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvbWFpbi5jIGIvbXVsdGlwYXRoZC9t
YWluLmMKaW5kZXggN2M5OTViNi4uMWQ4ZmY1YSAxMDA2NDQKLS0tIGEvbXVsdGlwYXRoZC9t
YWluLmMKKysrIGIvbXVsdGlwYXRoZC9tYWluLmMKQEAgLTY1Miw3ICs2NTIsNyBAQCB1eHNv
Y2tfdHJpZ2dlciAoY2hhciAqIHN0ciwgY2hhciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lk
ICogdHJpZ2dlcl9kYXRhKQogc3RhdGljIGludAogdWV2X2Rpc2NhcmQoY2hhciAqIGRldnBh
dGgpCiB7Ci0JY2hhciBhWzEwXSwgYlsxMF0sICpjOworCWNoYXIgYVsxMV0sIGJbMTFdLCAq
YzsKIAogCS8qCiAJICoga2VlcCBvbmx5IGJsb2NrIGRldmljZXMsIGRpc2NhcmQgcGFydGl0
aW9ucwo=
--------------050406000007040200050302
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050406000007040200050302--
