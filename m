From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 03/10] do not allow in-use path to change wwid
Date: Fri, 28 Oct 2016 21:55:19 -0500
Message-ID: <1477709726-5442-4-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

When a path is part of a multipath device, it must not change it's wwid.
If it can, when multipathd is reconfigured, you can end up with two
multipath devices owning the same path, eventually leading to a crash.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 9e79ecd..87e8398 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -380,6 +380,14 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp,
 				strncpy(pp->wwid, mpp->wwid,
 					WWID_SIZE - 1);
 
+			/*
+			 * Do not allow in-use patch to change wwid
+			 */
+			else if (strcmp(pp->wwid, mpp->wwid) != 0) {
+				condlog(0, "%s: path wwid appears to have changed. Using map wwid.\n", pp->dev_t);
+				strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
+			}
+
 			pgp->id ^= (long)pp;
 			pp->pgindex = i + 1;
 
-- 
1.8.3.1
