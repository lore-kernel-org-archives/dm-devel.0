From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 01/18] multipath: default fast_io_fail to 5
	seconds
Date: Sat, 12 Jan 2013 00:04:38 -0600
Message-ID: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch sets fast_io_fail to 5 seconds in the defaults section.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c   | 1 +
 libmultipath/defaults.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 0a56cd1..51b4f45 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -516,6 +516,7 @@ load_config (char * file)
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
 	conf->checkint = DEFAULT_CHECKINT;
 	conf->max_checkint = MAX_CHECKINT(conf->checkint);
+	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 74b236f..f647ee0 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -15,6 +15,7 @@
 #define DEFAULT_USER_FRIENDLY_NAMES    0
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	1
+#define DEFAULT_FAST_IO_FAIL	5
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
-- 
1.8.0
