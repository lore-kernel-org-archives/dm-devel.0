From: tang.wenji@zte.com.cn
Subject: [PATCH] libmultipath: add missing character '(' in
	select_prio()
Date: Mon, 7 Nov 2016 16:45:47 +0800
Message-ID: <1478508347-9248-1-git-send-email-tang.wenji@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang wenji <tang.wenji@zte.com.cn>
List-Id: dm-devel.ids

From: tang wenji <tang.wenji@zte.com.cn>

Signed-off-by: tang wenji <tang.wenji@zte.com.cn>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ec1fd92..cff9a33 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -417,7 +417,7 @@ select_prio (struct config *conf, struct path * pp)
 	mpe = find_mpe(conf->mptable, pp->wwid);
 	set_prio(conf->multipath_dir, mpe, "(LUN setting)");
 	set_prio(conf->multipath_dir, conf->overrides, "(overrides setting)");
-	set_prio(conf->multipath_dir, pp->hwe, "controller setting)");
+	set_prio(conf->multipath_dir, pp->hwe, "(controller setting)");
 	set_prio(conf->multipath_dir, conf, "(config file default)");
 	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 	origin = "(internal default)";
-- 
2.8.1.windows.1
