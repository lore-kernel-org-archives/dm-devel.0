From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [Bug 177035] upstream fix
Date: Thu, 05 Jan 2006 23:24:45 +0100
Message-ID: <1136499885.14925.7.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

here is the upstream patch I just merge for Redhat Bug 177035.
Upstream was vulnerable to 1 out of the 3 flaws spoted by Kiyoshi Ueda.

Regards,
cvaroqui

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -106,7 +106,8 @@ lock_bindings_file(int fd)

        if (err) {
                if (errno != EINTR)
-                       condlog(0, "Cannot lock bindings file : %s");
+                       condlog(0, "Cannot lock bindings file : %s",
+                                       strerror(errno));
                else
                        condlog(0, "Bindings file is locked. Giving
up.");
        }
diff --git a/libmultipath/debug.h b/libmultipath/debug.h
--- a/libmultipath/debug.h
+++ b/libmultipath/debug.h
@@ -1,4 +1,5 @@
-void dlog (int sink, int prio, char * fmt, ...);
+void dlog (int sink, int prio, char * fmt, ...)
+       __attribute__((format(printf, 3, 4)));

 #if DAEMON
