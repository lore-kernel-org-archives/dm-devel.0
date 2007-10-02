From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: [PATCH] dm-mpath-rdac.c init race
Date: Tue, 02 Oct 2007 16:07:32 +0100
Message-ID: <47025EB4.9030801@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080502000903090108070707"
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080502000903090108070707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The current dm-mpath-rdac has a race in the init function since the hw
handler is registered with DM core before allocating the workqueue.

This patch just re-orders the allocation to be before the call to
dm_register_hw_handler and adds calls to destroys the workqueue in error
paths.

Cheers,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHAl606YSQoMYUY94RAoyvAJ44CB5yY5B+6y66c7DgL/nFId+jcgCgwWYX
rh+hKlNANqNZRw6KkyrYCL0=
=mzHx
-----END PGP SIGNATURE-----

--------------080502000903090108070707
Content-Type: text/x-patch;
 name="rdac-init-race.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdac-init-race.patch"

Re-order the initialisation of dm-rdac to avoid registering the hw
handler before the workqueue has been initialised. Closes a race
that would potentially give an oops.

Signed-off-by: Bryn M. Reeves <breeves@redhat.com>

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index 16b1613..a3d9d67 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -664,20 +664,21 @@ static struct hw_handler_type rdac_handler = {
 
 static int __init rdac_init(void)
 {
-	int r = dm_register_hw_handler(&rdac_handler);
-
-	if (r < 0) {
-		DMERR("%s: register failed %d", RDAC_DM_HWH_NAME, r);
-		return r;
-	}
+	int r;	
 
 	rdac_wkqd = create_singlethread_workqueue("rdac_wkqd");
 	if (!rdac_wkqd) {
 		DMERR("Failed to create workqueue rdac_wkqd.");
-		dm_unregister_hw_handler(&rdac_handler);
 		return -ENOMEM;
 	}
 
+	r = dm_register_hw_handler(&rdac_handler);
+	if (r < 0) {
+		DMERR("%s: register failed %d", RDAC_DM_HWH_NAME, r);
+		destroy_workqueue(rdac_wkqd);
+		return r;
+	}
+
 	DMINFO("%s: version %s loaded", RDAC_DM_HWH_NAME, RDAC_DM_HWH_VER);
 	return 0;
 }

--------------080502000903090108070707
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080502000903090108070707--
