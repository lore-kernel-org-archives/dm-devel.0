From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 03/18] multipath: change default path_selector
	to
Date: Sat, 12 Jan 2013 00:04:40 -0600
Message-ID: <1357970695-3396-3-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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

My testing has showed service-time to be as good and occassionally
noticeably better than round-robin.  So the patch switches the
default selector to give better performance out of the box.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index f647ee0..097c66f 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,7 +1,7 @@
 #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
-#define DEFAULT_SELECTOR	"round-robin 0"
+#define DEFAULT_SELECTOR	"service-time 0"
 #define DEFAULT_ALIAS_PREFIX	"mpath"
 #define DEFAULT_FEATURES	"0"
 #define DEFAULT_HWHANDLER	"0"
-- 
1.8.0
