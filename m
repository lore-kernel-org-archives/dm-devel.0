From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] libmultipath: group_by_prio: fix signedness
	bug
Date: Thu, 11 Apr 2019 12:49:20 +0200
Message-ID: <20190411104923.13470-2-mwilck@suse.com>
References: <20190411104923.13470-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190411104923.13470-1-mwilck@suse.com>
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

pp->priority can be negative, so we we shouldn't compare
it with an unsigned int.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/pgpolicies.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index ac2596ad..660768a4 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -312,7 +312,7 @@ out:
 int group_by_prio(struct multipath *mp)
 {
 	int i;
-	unsigned int prio;
+	int prio;
 	struct path * pp;
 	struct pathgroup * pgp;
 	vector pathvec = NULL;
-- 
2.21.0
