From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] disable debug output for pp_tpc
Date: Fri, 01 Sep 2006 09:01:24 +0200
Message-ID: <44F7DAC4.6090804@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070902050403090009080206"
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
--------------070902050403090009080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch removes the debug output for pp_tpc and also decreases the=20
priority ratings so that the passive path will have a priority of 0.

Please apply,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070902050403090009080206
Content-Type: text/x-patch;
	name="multipath-tools-pp_tpc-disable-debug-output.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath-tools-pp_tpc-disable-debug-output.patch"

diff --git a/path_priority/pp_tpc/pp_tpc.c b/path_priority/pp_tpc/pp_tpc.c
index 76e7c47..a7ed7ad 100644
--- a/path_priority/pp_tpc/pp_tpc.c
+++ b/path_priority/pp_tpc/pp_tpc.c
@@ -62,18 +62,13 @@ int sgi_tpc_prio(const char *dev)
 		goto out;
 	}
 	
-	if ( /* Auto-volume Transfer Enabled */
-	    	(sense_buffer[8] & 0x80) != 0x80 ) {
-		fprintf(stderr, "Auto-volume Transfer not enabled");
-	}
-
 	if ( /* Current Volume Path Bit */
 		( sense_buffer[8] & 0x01) == 0x01 ) {
 		/* 
 		 * This volume was owned by the controller receiving
 		 * the inquiry command.
 		 */
-		ret |= 0x02;
+		ret |= 0x01;
 	}
 
 	/* Volume Preferred Path Priority */
@@ -83,7 +78,7 @@ int sgi_tpc_prio(const char *dev)
 		 * Access to this volume is most preferred through
 		 * this path and other paths with this value.
 		 */
-		ret |= 0x04;
+		ret |= 0x02;
 		break;
 	case 0x02:
 		/*
@@ -91,8 +86,7 @@ int sgi_tpc_prio(const char *dev)
 		 * as a secondary path. Typically this path would be used
 		 * for fail-over situations.
 		 */
-		ret |= 0x01;
-		break;
+		/* Fallthrough */
 	default:
 		/* Reserved values */
 		break;

--------------070902050403090009080206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070902050403090009080206--
