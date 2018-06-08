From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/28] libmultipath: fix memory leak in
	process_config_dir()
Date: Fri,  8 Jun 2018 12:20:15 +0200
Message-ID: <20180608102041.22904-3-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 085a3e12..8769441c 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -551,6 +551,11 @@ free_config (struct config * conf)
 	FREE(conf);
 }
 
+static void free_namelist(void *nl)
+{
+	free(nl);
+}
+
 /* if multipath fails to process the config directory, it should continue,
  * with just a warning message */
 static void
@@ -574,7 +579,9 @@ process_config_dir(struct config *conf, vector keywords, char *dir)
 			condlog(0, "couldn't open configuration dir '%s': %s",
 				dir, strerror(errno));
 		return;
-	}
+	} else if (n == 0)
+		return;
+	pthread_cleanup_push(free_namelist, namelist);
 	for (i = 0; i < n; i++) {
 		if (!strstr(namelist[i]->d_name, ".conf"))
 			continue;
@@ -586,6 +593,7 @@ process_config_dir(struct config *conf, vector keywords, char *dir)
 			factorize_hwtable(conf->hwtable, old_hwtable_size);
 
 	}
+	pthread_cleanup_pop(1);
 }
 
 struct config *
-- 
2.17.0
