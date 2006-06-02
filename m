From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Maximum chunk size in dm-raid4-5.c
Date: Thu, 01 Jun 2006 17:45:42 -0700
Message-ID: <447F8A36.30908@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000500090907060305000508"
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000500090907060305000508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Is there a particular reason why CHUNK_SIZE_MAX is set to 512 sectors in
the dm raid4/5 module?  I have a fakeraid controller that can create
rather huge (1MB!) RAID5 stripes that this module rejects.  I set it to
2048 and as far as I can tell there haven't been any adverse stability
effects, though I suspect that gigantic stripes do wonders for disk
throughput. :P

Attached is a patch to increase it to 2048 sectors.  Please apply if
it's ok.

--D

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
--- a/drivers/md/dm-raid4-5.c	2006-06-01 17:42:27.000000000 -0700
+++ b/drivers/md/dm-raid4-5.c	2006-06-01 17:42:32.000000000 -0700
@@ -70,7 +70,7 @@
 #define	CHUNK_SIZE		64

 /* Maximum setable chunk size in sectors */
-#define	CHUNK_SIZE_MAX		512
+#define	CHUNK_SIZE_MAX		2048

 /* Recover chunk size in sectors */
 #define	RECOVER_CHUNK_SIZE	CHUNK_SIZE_MAX
@@ -3114,7 +3114,7 @@ static int raid_ctr(struct dm_target *ti
 		    chunk_size > CHUNK_SIZE_MAX ||
 		    chunk_size & (chunk_size - 1))
 			TI_ERR("Invalid chunk size; must "
-			       "be 2^^n and less equal 512");
+			       "be 2^^n and less equal 2048");

 		/*
 		 * In case we've got 2 or more variable raid parameters,

--------------000500090907060305000508
Content-Type: text/x-patch;
 name="dmraid45big.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dmraid45big.patch"

--- a/drivers/md/dm-raid4-5.c	2006-06-01 17:42:27.000000000 -0700
+++ b/drivers/md/dm-raid4-5.c	2006-06-01 17:42:32.000000000 -0700
@@ -70,7 +70,7 @@
 #define	CHUNK_SIZE		64
=20
 /* Maximum setable chunk size in sectors */
-#define	CHUNK_SIZE_MAX		512
+#define	CHUNK_SIZE_MAX		2048
=20
 /* Recover chunk size in sectors */
 #define	RECOVER_CHUNK_SIZE	CHUNK_SIZE_MAX
@@ -3114,7 +3114,7 @@ static int raid_ctr(struct dm_target *ti
 		    chunk_size > CHUNK_SIZE_MAX ||
 		    chunk_size & (chunk_size - 1))
 			TI_ERR("Invalid chunk size; must "
-			       "be 2^^n and less equal 512");
+			       "be 2^^n and less equal 2048");
=20
 		/*
 		 * In case we've got 2 or more variable raid parameters,

--------------000500090907060305000508
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000500090907060305000508--
