From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] dm: Deal with merge_bvec_fn in component devices
	better
Date: Sun, 01 Sep 2013 17:01:46 +0100
Message-ID: <1378051306.25743.18.camel@deadeye.wl.decadent.org.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3374093683844451449=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: 604457@bugs.debian.org, dm-devel@redhat.com
List-Id: dm-devel.ids


--===============3374093683844451449==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8pBZAhqzwq5bRbwZOcTe"


--=-8pBZAhqzwq5bRbwZOcTe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is analogous to commit 627a2d3c29427637f4c5d31ccc7fcbd8d312cd71
('md: deal with merge_bvec_fn in component devices better.'),
which does the same for md-devices at the top of the stack.  The
following explanation is taken from that commit.  Thanks to Neil Brown
<neilb@suse.de> for the advice.

If a component device has a merge_bvec_fn then as we never call it
we must ensure we never need to.  Currently this is done by setting
max_sector to 1 PAGE, however this does not stop a bio being created
with several sub-page iovecs that would violate the merge_bvec_fn.

So instead set max_segments to 1 and set the segment boundary to the
same as a page boundary to ensure there is only ever one single-page
segment of IO requested at a time.

This can particularly be an issue when 'xen' is used as it is
known to submit multiple small buffers in a single bio.

References: http://bugs.debian.org/604457
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
We've been carrying this in Debian for about 3 years and it's about time
it got reviewed...  It's basically Neil's work so should probably have
his sign-off as well.

Ben.

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -536,13 +536,15 @@ int dm_set_device_limits(struct dm_target *ti, struct=
 dm_dev *dev,
 		       (unsigned long long) start << SECTOR_SHIFT);
=20
 	/*
-	 * Check if merge fn is supported.
-	 * If not we'll force DM to use PAGE_SIZE or
-	 * smaller I/O, just to be safe.
+	 * If we don't call merge_bvec_fn, we must never risk
+	 * violating it, so limit max_phys_segments to 1 lying within
+	 * a single page.
 	 */
-	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
-		blk_limits_max_hw_sectors(limits,
-					  (unsigned int) (PAGE_SIZE >> 9));
+	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge) {
+		limits->max_segments =3D 1;
+		limits->seg_boundary_mask =3D PAGE_CACHE_SIZE - 1;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow Lindber=
g

--=-8pBZAhqzwq5bRbwZOcTe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiNk6ue/yOyVhhEJAQo6fRAAlR40WBZbIr+iVU0LNePxAGYlBpnA2R+c
zH47TaLxuluVTrSp/VJoOm1u7F5GVD57pnSgUJUhQ2GTO+zmPGZ8KMSkWNDbYmsv
zdPfQCbAQEjw3mzaP1EMy4LY2gKi+e/XIxbS1GDeeaTVFbpPqxPeFF9Q9CgipNoh
1jT4nZfvQJFzBJPtzWwbr7y3DfyDByPX8bZlwsCzFP0YOXcCbFua6+AXnpjRyKZ3
N3phsXSxG2iQntbtuljhtM5aVdxxSzB6mVFEA6z3KzlVpwo1xGWSpsrAfKZ4XsZe
nIf226boU++XUmBmhchu5MHW8VPySMNckKi7NLXkqa7YfMVyquYUbBbwQBhATYkV
DKy74KFhavjVyk5jDq3vH2NRCFcPE3SKyV/iRvlbk5xzuQUYfVJ/+eANwZSafFaG
yyjRFSE0ilOyzy6Mtm613ypgrwa+0lONONhtcJg4rezmICouBMqjm2t2peYKxCkj
oZi2P2UcHAc06LPKfEibkd6/pMM43gOe0c90SL+Ong0THdZokgYyJRX8nMoZwEwu
++jxOEjreIZocA46ghnWlLZ3a/27hefVNGvevb0CZ2y3PrJCdiIhd9GL5ktSaZZj
PBg6SlKjPb+HgjwV2Pf6bAgkrgkXH+Z47fNGUTDAatbs3W1EW4PqZEQbhtM3CAuX
KWBVGN5acrc=
=yU4J
-----END PGP SIGNATURE-----

--=-8pBZAhqzwq5bRbwZOcTe--


--===============3374093683844451449==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3374093683844451449==--
