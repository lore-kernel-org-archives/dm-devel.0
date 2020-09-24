From: mwilck@suse.com
Subject: [PATCH 08/23] multipathd: move pid destruction into
	separate function
Date: Thu, 24 Sep 2020 15:40:39 +0200
Message-ID: <20200924134054.14632-9-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4d5b40b..3db051b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2892,6 +2892,12 @@ set_oom_adj (void)
 	condlog(0, "couldn't adjust oom score");
 }
 
+static void cleanup_pidfile(void)
+{
+	condlog(3, "unlink pidfile");
+	unlink(DEFAULT_PIDFILE);
+}
+
 static void cleanup_conf(void) {
 	struct config *conf;
 
@@ -3199,9 +3205,7 @@ child (__attribute__((unused)) void *param)
 	dm_lib_exit();
 
 	/* We're done here */
-	condlog(3, "unlink pidfile");
-	unlink(DEFAULT_PIDFILE);
-
+	cleanup_pidfile();
 	condlog(2, "--------shut down-------");
 
 	if (logsink == 1) {
-- 
2.28.0
