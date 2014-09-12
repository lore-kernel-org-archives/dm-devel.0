From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6/6] Always put watchdog in the config structure
Date: Fri, 12 Sep 2014 12:44:52 -0500
Message-ID: <1410543892-29826-7-git-send-email-bmarzins@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
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

Only multipathd and libmultipath ever get compiled with USE_SYSTEMD
enabled. If the watchdog variable is only in the config structure when
USE_SYSTEMD is enabled, it means that the multipath and libmultipath
code have different views of the config structure. This causes all sorts
of errors when multipath calls a libmultipath function.

The other alternative would be to leave the preprocessor #ifdef and
make sure to compile all tools with

CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)

Removing the #ifdef in the config structure means we don't have to worry
about this mistake happening again in the future, and only takes up 8
extra bytes in the structure.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2097879..5b6d107 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -110,9 +110,7 @@ struct config {
 	int ignore_wwids;
 	int checker_timeout;
 	int daemon;
-#ifdef USE_SYSTEMD
 	int watchdog;
-#endif
 	int flush_on_last_del;
 	int attribute_flags;
 	int fast_io_fail;
-- 
1.8.3.1
