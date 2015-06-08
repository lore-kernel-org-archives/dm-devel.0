From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/4] Make use of /run depend on systemd
Date: Mon,  8 Jun 2015 13:16:45 -0500
Message-ID: <1433787405-24716-5-git-send-email-bmarzins@redhat.com>
References: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
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

While there are other ways to decide whether to use /run or /var/run,
I believe this should be good enough, and it uses a Makefile define
that already exists.  If it doesn't work for everyone, I'll switch it
to actually test the directories and add a new define to CFLAGS.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index e2d2779..a313d75 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -27,7 +27,11 @@
 #define MAX_CHECKINT(a)		(a << 2)
 
 #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
+#ifdef USE_SYSTEMD
 #define DEFAULT_PIDFILE		"/run/multipathd.pid"
+#else
+#define DEFAULT_PIDFILE         "/var/run/multipathd.pid"
+#endif
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
-- 
1.8.3.1
