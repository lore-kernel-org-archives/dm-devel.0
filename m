From: Hannes Reinecke <hare@suse.de>
Subject: [multipath] hwtable update
Date: Tue, 13 Dec 2005 12:27:02 +0100
Message-ID: <439EB006.2070009@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060909060905090808010302"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060909060905090808010302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

here's a small update for the hardware table.
I've added a new controller (IBM DS4100), which uses the same controller
than SGI TPC. For a proper support I had to relax the checks in pp_tpc
slightly.
Secondly, it sets the FAILBACK for all machines supported by pp_tpc to
-FAILBACK_IMMEDIATE, as we cannot (yet) adjust the path setting. Hence
we need to switch back to the preferred path as soon as it becomes
available again.

If I ever get my hands on the manual I'll be probably adding a hardware
handler for it. So anyone having a PDF called 'Sofware Interface
Specification' describing amongs others SCSI INQUIRY commands, please
speak up :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------060909060905090808010302
Content-Type: text/x-patch;
 name="hwtable-update.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hwtable-update.patch"

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -37,6 +37,11 @@ setup_default_hwtable (vector hw)
 	r += store_hwe_ext(hw, "DGC", "^[^LUN_Z]", GROUP_BY_PRIO,
 		   DEFAULT_GETUID, "/sbin/mpath_prio_emc /dev/%n", "1 emc",
 		   "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE);
+	/* IBM DS4100 / FAStT100 */
+	r += store_hwe_ext(hw, "IBM", "1742", GROUP_BY_PRIO, DEFAULT_GETUID,
+		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur",
+		   -FAILBACK_IMMEDIATE);
+	/* IBM DS4200 / FAStT200 */
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
 	/* IBM ESS F20 aka Shark */
@@ -46,13 +51,14 @@ setup_default_hwtable (vector hw)
        /* IBM DS6000 */
 	r += store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO, DEFAULT_GETUID,
 		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
-		   "tur", FAILBACK_UNDEF);
+		   "tur", -FAILBACK_IMMEDIATE);
 	/* IBM DS8000 */
 	r += store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
 	/* IBM SAN Volume Controller */
-	r += store_hwe_ext(hw, "IBM", "2145", MULTIBUS, DEFAULT_GETUID,
-		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
+	r += store_hwe_ext(hw, "IBM", "2145", GROUP_BY_PRIO, DEFAULT_GETUID,
+		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
+		   "tur", -FAILBACK_IMMEDIATE);
 	/* IBM S/390 ECKD DASD */
 	r += store_hwe_ext(hw, "IBM", "S/390 DASD ECKD", MULTIBUS,
 		   "/sbin/dasdview -j /dev/%n", NULL, "0", "0",
@@ -64,9 +70,11 @@ setup_default_hwtable (vector hw)
 		   DEFAULT_GETUID, "/sbin/mpath_prio_alua %d", "0", "0",
 		   "tur", FAILBACK_UNDEF);
 	r += store_hwe_ext(hw, "SGI", "TP9400", GROUP_BY_PRIO, DEFAULT_GETUID,
-		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur", FAILBACK_UNDEF);
+		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur",
+		   -FAILBACK_IMMEDIATE);
 	r += store_hwe_ext(hw, "SGI", "TP9500", GROUP_BY_PRIO, DEFAULT_GETUID,
-		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur", FAILBACK_UNDEF);
+		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur",
+		   -FAILBACK_IMMEDIATE);
 
 	return r;
 }
diff --git a/path_priority/pp_tpc/pp_tpc.c b/path_priority/pp_tpc/pp_tpc.c
--- a/path_priority/pp_tpc/pp_tpc.c
+++ b/path_priority/pp_tpc/pp_tpc.c
@@ -54,10 +54,10 @@ int sgi_tpc_prio(const char *dev)
 	
 	if (/* Verify the code page - right page & page identifier */
 	    sense_buffer[1] != 0xc9 || 
+	    sense_buffer[3] != 0x2c ||
 	    sense_buffer[4] != 'v' ||
 	    sense_buffer[5] != 'a' ||
-	    sense_buffer[6] != 'c' ||
-	    sense_buffer[7] != '1' ) {
+	    sense_buffer[6] != 'c' ) {
 		fprintf(stderr, "Volume access control page in unknown format");
 		goto out;
 	}

--------------060909060905090808010302
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060909060905090808010302--
