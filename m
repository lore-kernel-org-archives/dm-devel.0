From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/31] libmultipath: fix partition_delimiter
	config option
Date: Sun,  3 Sep 2017 00:38:30 +0200
Message-ID: <20170902223900.7339-2-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The partition_delimiter setting was effecitvely ignored. Fix it.

Fixes: 95bf339bb9d7 "correctly set partition delimiter on rename"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3b41a483..e701e806 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1351,10 +1351,12 @@ dm_rename_partmaps (const char * old, char * new, char *delim)
 
 	if (delim)
 		rd.delim = delim;
-	if (isdigit(new[strlen(new)-1]))
-		rd.delim = "p";
-	else
-		rd.delim = "";
+	else {
+		if (isdigit(new[strlen(new)-1]))
+			rd.delim = "p";
+		else
+			rd.delim = "";
+	}
 	return do_foreach_partmaps(old, rename_partmap, &rd);
 }
 
-- 
2.14.0
