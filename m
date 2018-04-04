From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 01/20] Revert "multipath: ignore -i if
	find_multipaths is set"
Date: Wed,  4 Apr 2018 18:16:08 +0200
Message-ID: <20180404161627.6244-2-mwilck@suse.com>
References: <20180404161627.6244-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404161627.6244-1-mwilck@suse.com>
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
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This reverts commit ffbb886a8a16cb063d669cd76a1e656fd3ec8c4b.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index d08c688..d26c744 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -776,16 +776,6 @@ main (int argc, char *argv[])
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
2.16.1
