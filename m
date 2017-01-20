From: Gris Ge <fge@redhat.com>
Subject: [PATCH 1/5] multipath-tools: libmultipath: fix gcc link
	failure on rcu_register_thread_mb.
Date: Fri, 20 Jan 2017 21:38:58 +0800
Message-ID: <1484919542-11087-2-git-send-email-fge@redhat.com>
References: <1484919542-11087-1-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484919542-11087-1-git-send-email-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Error:
    ../libmultipath/libmultipath.so: undefined reference to
    `rcu_register_thread_mb'
    ../libmultipath/libmultipath.so: undefined reference to
    `rcu_unregister_thread_mb'

Fix:
    Link the libmultipath with -lurcu

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmultipath/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index b5d54d8..1f5ec25 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -9,7 +9,7 @@ LIBS = $(DEVLIB).$(SONAME)
 
 CFLAGS += -I$(mpathcmddir)
 
-LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
+LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu
 
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
-- 
1.8.3.1
