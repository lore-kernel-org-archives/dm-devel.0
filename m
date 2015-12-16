From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: fix bug due to nested suspend
Date: Wed, 16 Dec 2015 14:57:01 +1100
Message-ID: <87vb7z9hbm.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1511251216100.17579@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3420515540298556547=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1511251216100.17579@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Marian Csontos <mcsontos@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3420515540298556547==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26 2015, Mikulas Patocka wrote:

> The patch c7bfced9a6716ff66c9d61f934bb60af08d4688c committed to 4.4-rc=20
> causes crash in LVM test shell/lvchange-raid.sh. The kernel crashes with=
=20
> this BUG, the reason is that we attempt to suspend a device that is=20
> already suspended. See also=20
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1283491
>
> This patch fixes the bug by introducing functions mddev_nested_suspend and
> mddev_nested_resume that can be called when the device is already
> suspended. The number of calls to mddev_nested_suspend is kept in the
> variable mddev->suspended.

Hi,
 thanks for the report and patch.

I think I would rather just make mddev_suspend() always nest.
It is always called under ->reconfig_mutex or some similar guarentee of
being single-threaded in dm-raid, so we don't need an atomic_t.

Just
  mddev_suspend()
	if (mddev->suspended++)
        	return;
        ...do the suspend.

and
  mddev_resume()
       if (--mddev->suspended)
       		return;
       ... to the resume

Does that seem reasonable to you?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcOENAAoJEDnsnt1WYoG5z8UP/Rt9s7l8ueCmhWoTY/z7Pyjp
ambOpxGET6u403UaL35d7r4Kayhhf/qhvmX6Cwaol+EGLDzZEO1A5G8mWawXIILB
cVHsmmZ/RxicvSPLqc9hMABAcSpBfgssDLt+mjv1LgCo46jJ2nalln5atQh2cZEv
MjwFiGojnD7KsvFXlWnkx/i0lPMLTCbg54wN9rxFPZZFobsu2sRpsrUMVEytyca3
1fYSX1gQSYNdL0bVjDsMKwNRUoDgyZRZbCW2HEchnxEI7TsOk9KllLJNVpM78gQE
KwXMo7CeupyWmLrsCvtYcAM0YuP5hN11j8Umt4P38j+2jnkqPvJJQec6EsXU3NIj
N0zYr3ABUqYysYrheebQ2XuFDvbrnMfKudTp5pZw3OBD4Y+SpevHMK0YyVDtJS8P
A+9iyDxeRQGnRdCPMUH8L5C0PFtX0XqRkq3zup8KkR64OCWKniGG8CaE0zq+TWlK
Y8dxJtiYIQmHNHVBD6foCaxUCKyQBRPa5WjkuB0WZj3CLqrYntwUcz8ZUkoE7Hsp
a0vK6YUXYwpyZRHYJzSmIlaAVPNFQsaVEJHo+tsm+g3PIw0b4+PALTgyf5vFa0xa
/13Pt3nfJfRg1VfmPODtUSmz0hTeq+e5VFW0JaPKcLuDXxvW4h0jvLnwl8HYXonB
UvLSoS3MWUiwklHMmAhH
=vWVV
-----END PGP SIGNATURE-----
--=-=-=--


--===============3420515540298556547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3420515540298556547==--
