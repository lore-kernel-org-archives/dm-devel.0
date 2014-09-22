From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix mirror device creation with lvcreate
 failed
Date: Mon, 22 Sep 2014 11:20:37 +1000
Message-ID: <20140922112037.36361262@notabene.brown>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
	<20140916232104.GC2407@agk-dp.fab.redhat.com>
	<54198887020000A00000CFC2@soto.provo.novell.com>
	<20140917114151.GF2407@agk-dp.fab.redhat.com>
	<541AF2A1020000A00000D113@victor.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1830406623869168379=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <541AF2A1020000A00000D113@victor.provo.novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Liuhua Wang <lwang@suse.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============1830406623869168379==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/qqvdV8=rL/mQtydhSbArL1t";
	protocol="application/pgp-signature"

--Sig_/qqvdV8=rL/mQtydhSbArL1t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Sep 2014 00:56:33 -0600 "Liuhua Wang" <lwang@suse.com> wrote:

> Hi, Alasdair
> Hi, Neil
>=20
> >>> On 9/17/2014 at 07:41 PM, in message
> <20140917114151.GF2407@agk-dp.fab.redhat.com>, Alasdair G Kergon
> <agk@redhat.com> wrote:=20
> > On Tue, Sep 16, 2014 at 11:11:35PM -0600, Liuhua Wang wrote:
> > > There are error messages:
> > > ---------------------
> > > [22798.077877] end_request: I/O error, dev dasdd, sector 2240
> > > [22798.077902] device-mapper: raid: Failed to read superblock of devi=
ce at=20
> > position 1
> > > [23087.875420] type=3D1006 audit(1404313201.346:28): pid=3D1596 uid=
=3D0 old=20
> > auid=3D4294967295 new auid=3D0 old ses=3D4294967295 new ses=3D27 res=3D1
> > > [23127.707296] dasd-eckd.d2bf98: 0.0.141d: ERP 0000000036ab1e40 has r=
un out=20
> > of retries and failed
> > > ----------------------
> > =20
> > OK, so it sounds like Neil's patch will be enough to fix this.
> > Can you test that and confirm it solves the problem?
> >=20
>=20
> I tested Neil's patch, lvcreate succeed, the lv created can display,
> be written successfully, but only there still are error messages:
> --------------------------------
> 2014-09-18T06:39:52.653239+02:00 s390vsl158 kernel: device-mapper: raid: =
Superblocks created for new array
> 2014-09-18T06:39:52.663361+02:00 s390vsl158 kernel: md/raid1:mdX: not cle=
an -- starting background reconstruction
> 2014-09-18T06:39:52.663366+02:00 s390vsl158 kernel: md/raid1:mdX: active =
with 2 out of 2 mirrors
> 2014-09-18T06:39:52.663366+02:00 s390vsl158 kernel: Choosing daemon_sleep=
 default (5 sec)
> 2014-09-18T06:39:52.663367+02:00 s390vsl158 kernel: created bitmap (1 pag=
es) for device mdX
> 2014-09-18T06:39:52.663368+02:00 s390vsl158 kernel: end_request: I/O erro=
r, dev dasdb, sector 19202144
> 2014-09-18T06:39:52.663369+02:00 s390vsl158 kernel: md: super_written get=
s error=3D-5, uptodate=3D0
> 2014-09-18T06:39:52.663369+02:00 s390vsl158 kernel: md/raid1:mdX: Disk fa=
ilure on dm-3, disabling device.
> -------------------------
>=20
> So I add also roundup to md_super_write() as following,
> then the above error messages disappears.
> --------------------------
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1294238..18cd2e7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -754,6 +754,8 @@ void md_super_write(struct mddev *mddev, struct md_rd=
ev *rdev,
>  	struct bio *bio =3D bio_alloc_mddev(GFP_NOIO, 1, mddev);
> =20
>  	bio->bi_bdev =3D rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
> +        size =3D roundup(size, bdev_logical_block_size(bio->bi_bdev));
> +=09
>  	bio->bi_iter.bi_sector =3D sector;
>  	bio_add_page(bio, page, size, 0);
>  	bio->bi_private =3D rdev;

I'm not really comfortable with this change.

It is always safe to read more than requested.  Writing more than requested
is quite different.

I think I would rather that rdev->sb_size were rounded up by the code that
sets it.  That would make it clear to anyone reading the code that a full
block was always written.

Jon: how does lvm allocate space for the dm-raid metadata?  Does it always
allocate some minimum?  Is the allocation aware of underlying block size?
Is it reasonable to round up rdev->sb_size in load_super() ??


Thanks,
NeilBrown


> @@ -784,6 +786,10 @@ int sync_page_io(struct md_rdev *rdev, sector_t sect=
or, int size,
> =20
>  	bio->bi_bdev =3D (metadata_op && rdev->meta_bdev) ?
>  		rdev->meta_bdev : rdev->bdev;
> +        size =3D roundup(size, bdev_logical_block_size(bio->bi_bdev));
> +        if (size > PAGE_SIZE)
> +                return -EINVAL;
> +
>  	if (metadata_op)
>  		bio->bi_iter.bi_sector =3D sector + rdev->sb_start;
>  	else if (rdev->mddev->reshape_position !=3D MaxSector &&


--Sig_/qqvdV8=rL/mQtydhSbArL1t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVB95ZTnsnt1WYoG5AQK60RAAvUv3wRJ36utXyfHDhRo8EXSn8tWUg9ka
2wp5qm87pzHCTNutqeJmfP1BPXaCltR/RIaf4s0eaDut6ackJzZVOXTvzdLzZssw
fPDkcUjFtyLT9bRrYjYtQAbc47L8TlTUmA9N2gTd5kMLjyUHqRLyBpc6faOCyz3u
xZ50hKWWeSwPExkf9E+Az88+II2egFhU09/fFqqi8FbeyUoF+NQXPF/0PTJfDfUS
20JLmfoiHubg91vhYbK/BJO4WQzWLYK1kPZbT8OrwCbOrOCH5Z03MkhFibMRAkZM
lltlF9xb+lbc84MR30pZ9axQgv7zNURuKwBU1qS7OGaxKouaZ6A+kSjM1EGRHFhG
pakP67rGiMdRERbxFNj4B6G3zXvsipgV6Gj85BzyCrMwQZkXIx18eYeNneH5kq+S
FO2FXrTVsdlNM3fJKhm4McyTdeKonPrx/4W33SS74LPUe0465I6pCMThzwXNa3CQ
FYpmgdLFq44pzXEY5IuoULijJumUlX+rOyIynsoilpz3rthc6weS0HHKWsekL+Bt
jf9Sl0lup1FtawlwBzwAO1xQvg+KIjYF2JY3Y6iqWx+OK0G8OqfepARmuyH5GgN/
9CCbLtSBmgIZJ6AY3ID+h4MqDytejZOKB6be92OuhS4F4P/vfrqbAJwFrOmUD08Y
jm5MdWwSGYs=
=MmX4
-----END PGP SIGNATURE-----

--Sig_/qqvdV8=rL/mQtydhSbArL1t--


--===============1830406623869168379==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1830406623869168379==--
