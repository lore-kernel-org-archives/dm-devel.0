From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Re: Autoload of DM kernel targets?
Date: Mon, 24 Apr 2017 20:32:21 +0300
Message-ID: <f157f07e-7001-245d-ea15-dc729efd6e32@gmail.com>
References: <3474bd1a-7a81-29ba-3562-aaaaeca47cc7@gmail.com>
	<87zif6phzt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9208276522008330819=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87zif6phzt.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============9208276522008330819==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="gWUFeHNRVHApfX5kQ7UPVCpjjuBVU91Mo"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gWUFeHNRVHApfX5kQ7UPVCpjjuBVU91Mo
Content-Type: multipart/mixed; boundary="7nJtduOJmqIPR6UTQgTTFGkXJjmehsk2m"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: NeilBrown <neilb@suse.com>, dm-devel@redhat.com
Message-ID: <f157f07e-7001-245d-ea15-dc729efd6e32@gmail.com>
Subject: Re: [dm-devel] Autoload of DM kernel targets?
References: <3474bd1a-7a81-29ba-3562-aaaaeca47cc7@gmail.com>
	<87zif6phzt.fsf@notabene.neil.brown.name>
In-Reply-To: <87zif6phzt.fsf@notabene.neil.brown.name>

--7nJtduOJmqIPR6UTQgTTFGkXJjmehsk2m
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: quoted-printable

24.04.2017 07:05, NeilBrown =EF=E8=F8=E5=F2:
> On Fri, Apr 21 2017, Andrei Borzenkov wrote:
>=20
>> See as example https://bugzilla.opensuse.org/show_bug.cgi?id=3D983221
>>
>> "non-standard" DM targets do not appear to be autoloaded (the problem
>> was hit with thin-pool, but it seems to apply to other targets as well=
).
>> "Common" targets (like linear) are provided by dm-mod which seems to b=
e
>> autoloaded by virtue of /dev/mapper/control.
>>
>> Is it expected and intentional? Or are users required to manually load=

>> necessary modules on boot?
>>
>> TIA
>>
>> -andrei
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> Does this patch fix it for you?
>=20

I did not test it, because the problem (at least, this specific problem)
turned out a packaging problem - lvm checks for available targets before
it even tries to call into kernel, so this should not change anything.
But it needs path to modprobe that is detected during build. mkdprobe
was not present in build environment so lvm did not try to autoload
anything and immediately failed. Making sure to BuildRequire (package,
that provides) it fixed the problem.

> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 8f811dc8b3cc..d2c6a9a12d75 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -4400,3 +4400,4 @@ MODULE_PARM_DESC(no_space_timeout, "Out of data s=
pace queue IO timeout in second
>  MODULE_DESCRIPTION(DM_NAME " thin provisioning target");
>  MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("dm-thin-pool");
>=20
> NeilBrown
>=20



--7nJtduOJmqIPR6UTQgTTFGkXJjmehsk2m--

--gWUFeHNRVHApfX5kQ7UPVCpjjuBVU91Mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlj+NqUACgkQR6LMutpd94zLZgCgpyGC51Y1NGjT44Q48yGlwZil
XpAAniR+Di1y6iw6pbqr02ziLuinquoc
=wI5Q
-----END PGP SIGNATURE-----

--gWUFeHNRVHApfX5kQ7UPVCpjjuBVU91Mo--


--===============9208276522008330819==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9208276522008330819==--
