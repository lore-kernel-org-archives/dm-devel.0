From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 11/16] libmultipath: show default configurations
Date: Wed, 11 Dec 2013 00:43:05 -0600
Message-ID: <1386744190-1295-12-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

"multipathd show config" should show the current configuration, even if
the current values match the default values.  Omitting the values when
they match the compiled in defaults just makes it harder for users to
see how multipath configured.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0bf9587..9db4725 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -2459,16 +2459,12 @@ snprint_def_verbosity (char * buff, int len, void * data)
 static int
 snprint_def_max_polling_interval (char * buff, int len, void * data)
 {
-	if (conf->max_checkint == MAX_CHECKINT(conf->checkint))
-		return 0;
 	return snprintf(buff, len, "%i", conf->max_checkint);
 }
 
 static int
 snprint_reassign_maps (char * buff, int len, void * data)
 {
-	if (conf->reassign_maps == DEFAULT_REASSIGN_MAPS)
-		return 0;
 	return snprintf(buff, len, "\"%s\"",
 			conf->reassign_maps?"yes":"no");
 }
-- 
1.8.4.2
