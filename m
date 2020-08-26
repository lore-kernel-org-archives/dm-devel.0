From: mwilck@suse.com
Subject: [PATCH v2 07/10] libmultipath: fix enable_foreign memory
	leak
Date: Wed, 26 Aug 2020 11:59:04 +0200
Message-ID: <20200826095907.5576-8-mwilck@suse.com>
References: <20200826095907.5576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826095907.5576-1-mwilck@suse.com>
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

enable_foreign wasn't freed in free_config(). Do it, and make
sure it's always a malloc'd string.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 2 ++
 multipath/main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 86b6733..b9bdbdb 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -631,6 +631,8 @@ free_config (struct config * conf)
 
 	if (conf->config_dir)
 		FREE(conf->config_dir);
+	if (conf->enable_foreign)
+		FREE(conf->enable_foreign);
 
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
diff --git a/multipath/main.c b/multipath/main.c
index 80bc4b5..004bce5 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -997,7 +997,7 @@ main (int argc, char *argv[])
 	}
 
 	if ((cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) && enable_foreign)
-		conf->enable_foreign = "";
+		conf->enable_foreign = strdup("");
 
 	/* Failing here is non-fatal */
 	init_foreign(conf->multipath_dir, conf->enable_foreign);
-- 
2.28.0
