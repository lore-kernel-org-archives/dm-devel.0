From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: submit MMP reads REQ_SYNC to bypass
 RAID5 cache
Date: Tue, 4 Nov 2014 09:04:36 +1100
Message-ID: <20141104090436.355a8fb1@notabene.brown>
References: <CAOdCWHxeE47jwjJvyWOoHdjZ4LaDFQiZZbGpqdLZzd+PjzpyRw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8540295840929603654=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOdCWHxeE47jwjJvyWOoHdjZ4LaDFQiZZbGpqdLZzd+PjzpyRw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Simmons <uja.ornl@gmail.com>
Cc: dm-devel@redhat.com, andreas.dilger@intel.com, bruno.faccini@intel.com
List-Id: dm-devel.ids

--===============8540295840929603654==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/t400L_kkxol7zVZ6Ge+RpAS";
	protocol="application/pgp-signature"

--Sig_/t400L_kkxol7zVZ6Ge+RpAS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Nov 2014 14:01:10 -0700 James Simmons <uja.ornl@gmail.com> wrote:

> Hello.
>=20
>    This is a patch against the latest kernel source which is based on
> a patch used by Lustre. The below describes what we are trying to
> achieve. I like to get a feedback if this is the right approach.
>=20
> ----------------------------------------------------------------------
>=20
> The ext4 MMP block reads always need to get fresh data from the
> underlying disk.  Otherwise, if a remote node is updating the MMP
> block and the reads are fetched from the MD RAID5 stripe cache,
> it is possible that the local node will incorrectly decide the
> remote node has died and allow the filesystem to be mounted on
> two nodes at the same time.

It is preferred for patches to be inline, rather than as attachments, as it
makes it easier to comment on them....

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9c66e59..11b749c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2678,6 +2678,9 @@ static int add_stripe_bio(struct stripe_head *sh, str=
uct bio *bi, int dd_idx, in
 		}
 		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
+	} else if (bi->bi_rw & REQ_NOCACHE) {
+		/* force to read from underlying disk if requested */
+		clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 	}
=20
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",


This doesn't provide a useful guarantee.  If the device that stores that
block has failed, the md/raid5 will read all other devices to recover the
block.
If that recently happened and you just clear the UPTODATE bit on the block,
md/raid5 will recover the data from all the other blocks, without reading
them.

But considering this at a higher level: if two different nodes try to
assemble the same RAID5 array then you already potentially have a problem.
You really want some sensible cluster co-ordinator and let it make these
decisions.   Hoping the a block device can be a reliable semaphore seems ...
misguided.

NeilBrown

--Sig_/t400L_kkxol7zVZ6Ge+RpAS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFf79Dnsnt1WYoG5AQIt+A//fiLCxXm34qPiWjjS1R9tSOtV3pfQZFpj
wmIsANvX6sGhl/uslCSQJIXce04a9LTczylur6O4ubH7NBDhMGs7Ny1ppMDJy6eQ
XfcDUx584Jmkn1Fyt5ffylDJ5GseCH2x1hc6NUz419lQ3ZeoomsbKbvaDBQLr+SZ
npv6PfcMV7FdzuYakBiFBEtMFNGhcC0itU3IXWDo2TEd6vEOv/YhWV6BNnlIq9QB
HPxRDTdVdMRAOm6gw943Q0+tgR5LNZIyKohx7/5otphDsAEUuUH+YLciz3/Kb8WC
zwTrq6iwUPwE5+o5YO2ElXOUZsAymfEtkVyCmFju64D8IEdaLeDHK5zceIFvOqhF
bgTNH0sKsboa4XGBZvvwmJZL7wwilALTSSYBlcdgu9+oSnVAdN/R+W6uKgY/QS88
aljqGGpN9qZ2auhFx4ozt+Z0AUevQD3LxHJ493Rn0m9lcnr7Bd8cvQ/YH+zmS/GS
E00qas5UzF2Ne6WGMNCtGrUyMuizdJJuL4UcSYe7Wf4FheQxpEti2F034ObuVGJs
6LLB8OccE0dUgdZVouJBB/hJXYxlDbxseXo0luHBGcnxSyFbqvqn2d2Jx8Z/AtVS
EVfbuNX7xy45BlHmj28kGZYtdjhWp+gz+6Yrl8Ljz2wWN81x2iNuU4YtKnR41A3p
kjSfXlN+WJk=
=lk6n
-----END PGP SIGNATURE-----

--Sig_/t400L_kkxol7zVZ6Ge+RpAS--


--===============8540295840929603654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8540295840929603654==--
