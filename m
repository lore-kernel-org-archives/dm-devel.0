From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 01/16] Revert "multipath: ignore -i if
	find_multipaths is set"
Date: Fri, 19 Jan 2018 01:29:01 +0100
Message-ID: <20180119002916.10323-2-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This reverts commit ffbb886a8a16cb063d669cd76a1e656fd3ec8c4b.
---
 multipath/main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 52bf1658bbca..21cc45145dbb 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -761,16 +761,6 @@ main (int argc, char *argv[])
 		}
 	}
 
-	/*
-	 * FIXME: new device detection with find_multipaths currently
-	 * doesn't work reliably.
-	 */
-	if (cmd ==  CMD_VALID_PATH &&
-	    conf->find_multipaths && conf->ignore_wwids) {
-		condlog(2, "ignoring -i flag because find_multipath is set in multipath.conf");
-		conf->ignore_wwids = 0;
-	}
-
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
 		exit(1);
-- 
2.15.1
