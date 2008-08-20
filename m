From: Andrey Panin <pazke@pazke.donpac.ru>
Subject: [PATCH] multipath_tools: Add IBM DS3400 to hwtable
Date: Wed, 20 Aug 2008 16:36:31 +0400
Message-ID: <20080820123631.GA7088@pazke.donpac.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0119612158=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0119612158==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Add IBM DS3400 support.

Signed-off-by: Andrey Panin <pazke@donpac.ru>

--
 hwtable.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0a94f10..d3f01a8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -337,6 +337,22 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
+		/* IBM DS3400 */
+		.vendor        = "IBM",
+		.product       = "1726-4xx",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 300,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
 		/* IBM DS4400 / FAStT700 */
 		.vendor        = "IBM",
 		.product       = "1742",

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIrA/OIWZCBzwS8mkRAi3iAJwNu9AqnifCNhs2kk6yxQOuW2cATQCfelpg
Rq8SHklkJuD6UjKJffVBYhs=
=vcBj
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--


--===============0119612158==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0119612158==--
