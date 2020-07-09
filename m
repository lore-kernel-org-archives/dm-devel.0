From: mwilck@suse.com
Subject: [PATCH 73/74] libmultipath: decrease loglevel in
	store_path()
Date: Thu,  9 Jul 2020 12:51:44 +0200
Message-ID: <20200709105145.9211-21-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

"Empty device name" in store_path() can happen regularly and
shouldn't be logged at -v2.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 056a205..f4de542 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -322,7 +322,7 @@ store_path (vector pathvec, struct path * pp)
 		err++;
 	}
 	if (!strlen(pp->dev)) {
-		condlog(2, "%s: Empty device name", pp->dev_t);
+		condlog(3, "%s: Empty device name", pp->dev_t);
 		err++;
 	}
 
-- 
2.26.2
