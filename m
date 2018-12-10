From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 11/24] libmultipath: decrease log level of
	"prioritizer refcount" message
Date: Mon, 10 Dec 2018 10:49:46 +0100
Message-ID: <20181210094959.11338-12-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This was important during development of the refcounting code, but
now it isn't any more.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 17acfd05..0590218d 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -42,7 +42,7 @@ void free_prio (struct prio * p)
 		return;
 	p->refcount--;
 	if (p->refcount) {
-		condlog(3, "%s prioritizer refcount %d",
+		condlog(4, "%s prioritizer refcount %d",
 			p->name, p->refcount);
 		return;
 	}
-- 
2.19.2
