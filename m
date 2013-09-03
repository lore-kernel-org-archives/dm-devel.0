From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] dm: Deal with merge_bvec_fn in component
 devices better
Date: Tue, 03 Sep 2013 02:45:10 +0100
Message-ID: <1378172710.23151.29.camel@deadeye.wl.decadent.org.uk>
References: <1378051306.25743.18.camel@deadeye.wl.decadent.org.uk>
	<alpine.LRH.2.02.1309021029020.16272@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5121881043833630920=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309021029020.16272@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: 604457@bugs.debian.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--===============5121881043833630920==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-srOhKt32ITRLXAAi31YM"


--=-srOhKt32ITRLXAAi31YM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-09-02 at 10:32 -0400, Mikulas Patocka wrote:
> Hi
>=20
> This was already fixed in 2.6.31 with commit=20
> 8cbeb67ad50f7d68e5e83be2cb2284de8f9c03b5.
>=20
> See this piece of code in dm.c:
>=20
> /*
>  * If the target doesn't support merge method and some of the devices
>  * provided their merge_bvec method (we know this by looking at
>  * queue_max_hw_sectors), then we can't allow bios with multiple vector
>  * entries.  So always set max_size to 0, and the code below allows
>  * just one page.
>  */
> else if (queue_max_hw_sectors(q) <=3D PAGE_SIZE >> 9)
>         max_size =3D 0;

Thanks, I suspected it might have been fixed somehow.

Ben.

> Mikulas
>=20
>=20
> On Sun, 1 Sep 2013, Ben Hutchings wrote:
>=20
> > This is analogous to commit 627a2d3c29427637f4c5d31ccc7fcbd8d312cd71
> > ('md: deal with merge_bvec_fn in component devices better.'),
> > which does the same for md-devices at the top of the stack.  The
> > following explanation is taken from that commit.  Thanks to Neil Brown
> > <neilb@suse.de> for the advice.
> >=20
> > If a component device has a merge_bvec_fn then as we never call it
> > we must ensure we never need to.  Currently this is done by setting
> > max_sector to 1 PAGE, however this does not stop a bio being created
> > with several sub-page iovecs that would violate the merge_bvec_fn.
> >=20
> > So instead set max_segments to 1 and set the segment boundary to the
> > same as a page boundary to ensure there is only ever one single-page
> > segment of IO requested at a time.
> >=20
> > This can particularly be an issue when 'xen' is used as it is
> > known to submit multiple small buffers in a single bio.
> >=20
> > References: http://bugs.debian.org/604457
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > We've been carrying this in Debian for about 3 years and it's about tim=
e
> > it got reviewed...  It's basically Neil's work so should probably have
> > his sign-off as well.
> >=20
> > Ben.
> >=20
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -536,13 +536,15 @@ int dm_set_device_limits(struct dm_target *ti, st=
ruct dm_dev *dev,
> >  		       (unsigned long long) start << SECTOR_SHIFT);
> > =20
> >  	/*
> > -	 * Check if merge fn is supported.
> > -	 * If not we'll force DM to use PAGE_SIZE or
> > -	 * smaller I/O, just to be safe.
> > +	 * If we don't call merge_bvec_fn, we must never risk
> > +	 * violating it, so limit max_phys_segments to 1 lying within
> > +	 * a single page.
> >  	 */
> > -	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
> > -		blk_limits_max_hw_sectors(limits,
> > -					  (unsigned int) (PAGE_SIZE >> 9));
> > +	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge) {
> > +		limits->max_segments =3D 1;
> > +		limits->seg_boundary_mask =3D PAGE_CACHE_SIZE - 1;
> > +	}
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(dm_set_device_limits);
> >=20
> > --=20
> > Ben Hutchings
> > The most exhausting thing in life is being insincere. - Anne Morrow Lin=
dberg
> >=20

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-srOhKt32ITRLXAAi31YM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiU/Jue/yOyVhhEJAQqKdg//R2fqZV3y7+XtXwl7k73dnK/GvtFPfl1/
2gFjFedCuegg4wIoEhN28RxGWOiTk/m2kL9boM3OQrb0muMG2uGMFHp4p44H2Jz5
jTEf+PAwxnis0fHCxMtGqDxL65z66+E7HmWbuz0jQ9AGy22ml0f3y4UDrr5P+jBc
2VurMoEOFoyRl3xOd6etN9jBCC9GEC0NMziMJnsNZ4daNMFK3i1LWGrtrgnZYpPM
uJw1y4loqCeec1bL6DYQs6u7FCm5p5mbl+cXEOqWqA9fWfIuqlFtyI21LcEdiSGA
NDK2naMQdjkznYkWkQglU046swT++gUuq7J581GgN591hWx65TTM8Gg2hLG4o1o6
27wEPDaW8mJpE4ByPdFhPfs1jPzOg7vMt5rRIYtq0HcsUvQnw8U0/KCLztKyFywM
0utANlvz78eMVlfxjXLTAE1fwJx34tBGiwumt8vFBUsuty6GtAPz6nQLrGi0zn82
QCQOynbmhJJh73iuD14hUNQ9fw5njFmFowvq2coUn0xChHYlgwoRT89LiNp05PrN
ncCvb8PbDpDF8prBzttzsqLSX7N6ddTvxp/75JpOLN2/J8hJV5f4815IRCRDDPDL
aNdMxYHvmD2FtGgMZgjPMnByDQVYF//N5WxeU0tgJYE3lxQ9qYfw2kdxvay3mZmC
9e07h3Gv14c=
=iSx8
-----END PGP SIGNATURE-----

--=-srOhKt32ITRLXAAi31YM--


--===============5121881043833630920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5121881043833630920==--
