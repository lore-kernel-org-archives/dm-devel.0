From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] [RFC] dm-multipath: typo,
	strncat instead of strncpy
Date: Tue, 27 Jul 2010 17:46:19 -0700
Message-ID: <07a9bab4a67f78564b22.1280277979@malahal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

strncat here doesn't seem right, strncpy should be correct!

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

PS: But why bother correcting an entry that is going to be deleted
anyway? IMO, just deleting the strncat/strncpy line should be fine too.
Any comments???

diff -r 62c20b65bffe -r 07a9bab4a67f libmultipath/configure.c
--- a/libmultipath/configure.c	Tue Jul 20 17:08:44 2010 -0700
+++ b/libmultipath/configure.c	Tue Jul 27 17:45:48 2010 -0700
@@ -170,7 +170,7 @@ select_action (struct multipath * mpp, v
 	if (!find_mp_by_wwid(curmp, mpp->wwid)) {
 		condlog(2, "%s: remove (wwid changed)", cmpp->alias);
 		dm_flush_map(mpp->alias);
-		strncat(cmpp->wwid, mpp->wwid, WWID_SIZE);
+		strncpy(cmpp->wwid, mpp->wwid, WWID_SIZE);
 		drop_multipath(curmp, cmpp->wwid, KEEP_PATHS);
 		mpp->action = ACT_CREATE;
 		condlog(3, "%s: set ACT_CREATE (map wwid change)",
