From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix mirror device creation with lvcreate
 failed
Date: Wed, 17 Sep 2014 11:15:55 +1000
Message-ID: <20140917111555.0e8df37f@notabene.brown>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
	<20140916232104.GC2407@agk-dp.fab.redhat.com>
	<20140916233529.GD2407@agk-dp.fab.redhat.com>
	<20140916234008.GE2407@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2406522666398332686=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140916234008.GE2407@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Liuhua Wang <lwang@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2406522666398332686==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/YlnitTt509cWPNn/cuzoW+m";
	protocol="application/pgp-signature"

--Sig_/YlnitTt509cWPNn/cuzoW+m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Sep 2014 00:40:08 +0100 Alasdair G Kergon <agk@redhat.com> wrote:

> On Wed, Sep 17, 2014 at 12:35:29AM +0100, Alasdair G Kergon wrote:
> > > > -	ret =3D read_disk_sb(rdev, rdev->sb_size);
>=20
> And if that needed changing to 4096, why does this similar instance elsew=
here
> one not also need changing?
>=20
>   static void attempt_restore_of_faulty_devices(struct raid_set *rs)
>   {
>   ...
>                     sync_page_io(r, 0, r->sb_size, r->sb_page, READ, 1)) {
>=20
> Alasdair
>=20

That suggests we should probably "fix" the problem in sync_page_io().

e.g.
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6be7146be5b3..e02de054fd9f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -777,6 +777,9 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector,=
 int size,
=20
 	bio->bi_bdev =3D (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
+	size =3D roundup(size, bdev_logical_block_size(bio->bi_bdev));
+	if (size > PAGE_SIZE)
+		return -EINVAL;
 	if (metadata_op)
 		bio->bi_iter.bi_sector =3D sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position !=3D MaxSector &&

I'll queue that up and maybe tag it for -stable.

Thanks,
NeilBrown

--Sig_/YlnitTt509cWPNn/cuzoW+m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBjgyznsnt1WYoG5AQKIyQ/+ImR14iKIkiFyml7Pq9kRK+cKSazTfTa6
AWomJKI1OvcqtYRearpxhnhE4fiMFDcBddz9P7FrdWPxz25eH3hY9YzHKQwbhcWA
P9h7S4Npz6QEHdipDYUK76kAAArZjzKnGGtHvTz8gtISdiNcccpofo4ZIkxdpOn5
/ooVJP+WtL+sU2ibmlw5GzVT9t5CAIZKYkvVVBWNDr1tjWmmc1hUKo2ryIv9Xwta
IPx4hvWz9BWDEYKOMsvzzgBI6AAWJ9fkquYrNZjftyv2HvR1M23lsmgY818nhP8y
OR/Yfp4DG9qgd80VaoLoMQ5PZhK9gKxuha0HNU5LOX02AYD59tICXzjuXJiJY1Kp
C/LeZVcuVbk/328URhPoUeUHcl+XIKQK/0wfHg5fD89dVQ9exY0X7k236eT84cHk
k9DRQPZFBbLDL6zDQ4HRoM0jVCI21JQw2AiHZAnrjcca454XmYjGRSMBxdEXZMKH
iSlPeNc0ynLShrG5dkqNkiSzVAsVEfyzKnDzKUBmkanBW/ujjoVmzH4j7pzV9Z97
4MOmF8kx72TkF9CU7a/5/Tc9cm+GsIauKQf+qmQ+crjFhymUCkcIVpUHi3kFvy4j
m7+PHd+s5VMRiutF7JnEvDt1blNowbEaT8c+YDmk+h9f+Xivq6UibYCF0mtN09J/
gM6KMNXqUQY=
=QzBf
-----END PGP SIGNATURE-----

--Sig_/YlnitTt509cWPNn/cuzoW+m--


--===============2406522666398332686==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2406522666398332686==--
