From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/30] tests/hwtable: decrease log verbosity
Date: Mon, 24 Jun 2019 11:27:37 +0200
Message-ID: <20190624092756.7769-13-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 13da1d99..f436f52d 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -457,7 +457,7 @@ static void replicate_config(const struct hwt_state *hwt, bool local)
 	vector hwtable;
 	struct config *conf;
 
-	condlog(1, "--- %s: replicating %s configuration", __func__,
+	condlog(3, "--- %s: replicating %s configuration", __func__,
 		local ? "local" : "full");
 
 	conf = get_multipath_config();
-- 
2.21.0
