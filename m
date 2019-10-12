From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 21/72] libmultipath: process_config_dir(): remove
 unused argument
Date: Sat, 12 Oct 2019 21:28:03 +0000
Message-ID: <20191012212703.12989-22-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 20e3b8bf..49723add 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -644,7 +644,7 @@ free_config (struct config * conf)
 /* if multipath fails to process the config directory, it should continue,
  * with just a warning message */
 static void
-process_config_dir(struct config *conf, vector keywords, char *dir)
+process_config_dir(struct config *conf, char *dir)
 {
 	struct dirent **namelist;
 	struct scandir_result sr;
@@ -749,7 +749,7 @@ load_config (char * file)
 	if (conf->config_dir == NULL)
 		conf->config_dir = set_default(DEFAULT_CONFIG_DIR);
 	if (conf->config_dir && conf->config_dir[0] != '\0')
-		process_config_dir(conf, conf->keywords, conf->config_dir);
+		process_config_dir(conf, conf->config_dir);
 
 	/*
 	 * fill the voids left in the config file
-- 
2.23.0
