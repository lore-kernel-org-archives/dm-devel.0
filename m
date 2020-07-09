From: mwilck@suse.com
Subject: [PATCH 49/54] libmultipath: get_refwwid(): get rid of
	"check" label
Date: Thu,  9 Jul 2020 12:36:18 +0200
Message-ID: <20200709103623.8302-8-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This was necessary with with the interspersed pthread_cleanup_push()/pop()
statements, now we can write the code more cleanly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c4712d7..defc54b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1449,32 +1449,23 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	if (dev_type == DEV_DEVMAP) {
 
 		if (((dm_get_uuid(dev, tmpwwid, WWID_SIZE)) == 0)
-		    && (strlen(tmpwwid))) {
+		    && (strlen(tmpwwid)))
 			refwwid = tmpwwid;
-			goto check;
-		}
 
-		/*
-		 * may be a binding
-		 */
-		if (get_user_friendly_wwid(dev, tmpwwid,
-					   conf->bindings_file) == 0) {
+		/* or may be a binding */
+		else if (get_user_friendly_wwid(dev, tmpwwid,
+						conf->bindings_file) == 0)
 			refwwid = tmpwwid;
-			goto check;
-		}
 
-		/*
-		 * or may be an alias
-		 */
-		refwwid = get_mpe_wwid(conf->mptable, dev);
+		/* or may be an alias */
+		else {
+			refwwid = get_mpe_wwid(conf->mptable, dev);
 
-		/*
-		 * or directly a wwid
-		 */
-		if (!refwwid)
-			refwwid = dev;
+			/* or directly a wwid */
+			if (!refwwid)
+				refwwid = dev;
+		}
 
-check:
 		if (refwwid && strlen(refwwid) &&
 		    filter_wwid(conf->blist_wwid, conf->elist_wwid, refwwid,
 				NULL) > 0)
-- 
2.26.2
