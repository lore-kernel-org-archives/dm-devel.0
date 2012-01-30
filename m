From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Fix memory corruption caused by repeated calls
 to bitmap_load
Date: Tue, 31 Jan 2012 10:10:31 +1100
Message-ID: <20120131101031.2a15eb96@notabene.brown>
References: <1327676033.9152.7.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BDGZpC0E1xwzBhZjpUDHY40"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327676033.9152.7.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/BDGZpC0E1xwzBhZjpUDHY40
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jan 2012 08:53:53 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I came across this bug when testing snapshots of RAID volumes.  The
> snapshot code performs multiple suspend/resume cycles on the underlying
> LV, which is what caused me to notice that 'bitmap_load' was being
> called multiple times and causing memory corruption.  As I explain in
> the patch header, I'm pretty sure that avoiding the repeat call to
> 'bitmap_load' and kicking the MD thread instead is all that is needed.
> (It certainly works in all my tests.)  However, please let me know if
> there is anything I'm not aware of.
>=20
> Thanks,
>  brassow

Thanks.  I've applied it and pushed it to my for-next branch, with
a small change to the patch description:

>=20
> Prevent DM RAID from loading bitmap twice.
>=20
> The life cycle of a device-mapper target is:
> 1) create
> 2) resume
> 3) suspend
> *) possibly repeat from 2
> 4) destroy
>=20
> The dm-raid target is unconditionally calling MD's bitmap_load function u=
pon
> every resume.  If steps 2 & 3 above are repeated, bitmap_load is called
> multiple times.  It is only written to be called once; otherwise, it allo=
cates
> new memory for the bitmap (without freeing the old) and incrementing the =
number
> of pages it thinks it has without zeroing first.  This ultimately leads to
> access beyond allocated memory and lost memory.
>=20
> Simply avoiding the bitmap_load call upon resume is not sufficient.  If t=
he
> target was suspended while the initial recovery was only partially comple=
te,
> it needs to be restarted when the target is resumed.  This is why
> 'md_wakeup_thread' is called on the before issuing the 'mddev_resume'.
                               ^^^^^^

I removed "on the "

Thanks,
NeilBrown



>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -56,7 +56,8 @@ struct raid_dev {
>  struct raid_set {
>  	struct dm_target *ti;
> =20
> -	uint64_t print_flags;
> +	uint32_t bitmap_loaded;
> +	uint32_t print_flags;
> =20
>  	struct mddev md;
>  	struct raid_type *raid_type;
> @@ -1135,7 +1136,7 @@ static int raid_status(struct dm_target=20
>  				raid_param_cnt +=3D 2;
>  		}
> =20
> -		raid_param_cnt +=3D (hweight64(rs->print_flags & ~DMPF_REBUILD) * 2);
> +		raid_param_cnt +=3D (hweight32(rs->print_flags & ~DMPF_REBUILD) * 2);
>  		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
>  			raid_param_cnt--;
> =20
> @@ -1247,7 +1248,12 @@ static void raid_resume(struct dm_target
>  {
>  	struct raid_set *rs =3D ti->private;
> =20
> -	bitmap_load(&rs->md);
> +	if (!rs->bitmap_loaded) {
> +		bitmap_load(&rs->md);
> +		rs->bitmap_loaded =3D 1;
> +	} else
> +		md_wakeup_thread(rs->md.thread);
> +
>  	mddev_resume(&rs->md);
>  }
> =20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/BDGZpC0E1xwzBhZjpUDHY40
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTycjZznsnt1WYoG5AQLZ1g//cV7s5qg9Nr3UbhQaDCM+3fxdYFU6SNe4
T8QuSL4FSrn5dPRydKrKwW5WNFvLC/I+UhkJKJ92NclAyskS45FV3mBZuYR/d2kV
0o80Z6l9rR4fzKGBFJXAUwldHZH0IOZ8XedgHtlWq+sLft6zWNzv+OyTmRELNk0G
U28U+mXDfnq3R2RNPEQ5pB6paMLNcv5hUdGlToNvUdGJx8qusnGOLWMtrZkIILzw
nhvJ9u7iplZ69+LTB4whq6POYTb+3iY0frmJ38Zhkt7eBcj+O69ymChHXmpZvnf5
vCx7jFkgdz4EV2F0I418KGuKgyY8TdawVcMALcUU+RXN5WcuW2aelAU4mXuWjFpB
Q4Ltfnf2UmjwFSGouQaRGOpiIBHojHxiSH0f0UaL7O4ASGMcHc330Ogd7bTJjKo9
AcscHwLPbyRSEXp6JAlFTN2HFAe1SBhtzGY2Wc2kG7nX6xbLkA8F55rCoUcRRF1d
F3zrYcfGmzZS6VHupsKL+8ZCJOFFuxGbGZesi9LafWoQVSW1mL3EvSIpGfwCGaOs
9Y2DUn6fR3A/Y6vSkwr9r5OpEHOUA7OJLb4IFse5c19W67530/eRma47uGeUW9kW
u7wd6y+ZygPCtfo8a3p77AG9RRuhax0v53Oc9/tdvNPkQ877ONdhHQ9NlvuWfV3h
1ftorbg5Z3Y=
=0G0d
-----END PGP SIGNATURE-----

--Sig_/BDGZpC0E1xwzBhZjpUDHY40--
