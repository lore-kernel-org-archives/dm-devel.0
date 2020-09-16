From: mwilck@suse.com
Subject: [PATCH 1/2] libmultipath: find_mpe(): don't match with
	empty WWID
Date: Wed, 16 Sep 2020 22:33:42 +0200
Message-ID: <20200916203343.2262-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b9bdbdb..df0f8f4 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -147,7 +147,7 @@ struct mpentry *find_mpe(vector mptable, char *wwid)
 	int i;
 	struct mpentry * mpe;
 
-	if (!wwid)
+	if (!wwid || !*wwid)
 		return NULL;
 
 	vector_foreach_slot (mptable, mpe, i)
-- 
2.28.0
