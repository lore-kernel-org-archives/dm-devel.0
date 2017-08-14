From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] multipath-tools: link internal libraries
	before foreigns
Date: Mon, 14 Aug 2017 22:40:43 +0200
Message-ID: <20170814204043.17640-4-mwilck@suse.com>
References: <20170814204043.17640-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170814204043.17640-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Otherwise, the runtime linker may resolve foreign symbols instead of
internal ones for certain symbol names (observed with xfree()
from libreadline).

Reported-by: nikola.pajkovsky@suse.com
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 mpathpersist/Makefile | 4 ++--
 multipath/Makefile    | 4 ++--
 multipathd/Makefile   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index bd1c0df9..6e5acd3b 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -3,8 +3,8 @@ include ../Makefile.inc
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir)
 LDFLAGS += $(BIN_LDFLAGS)
 
-LIBDEPS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
-	   -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
+LIBDEPS += -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath \
+	-L$(mpathcmddir) -lmpathcmd -lpthread -ldevmapper -ludev
 
 EXEC = mpathpersist
 
diff --git a/multipath/Makefile b/multipath/Makefile
index c85314e3..468c056d 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -5,8 +5,8 @@ include ../Makefile.inc
 
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
 LDFLAGS += $(BIN_LDFLAGS)
-LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
-	   -L$(mpathcmddir) -lmpathcmd
+LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathcmddir) -lmpathcmd \
+	-lpthread -ldevmapper -ldl -ludev
 
 EXEC = multipath
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index d5782a18..e6f140bf 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -9,8 +9,8 @@ include ../Makefile.inc
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) \
 	  -I$(mpathcmddir) -I$(thirdpartydir)
 LDFLAGS += $(BIN_LDFLAGS)
-LIBDEPS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir) \
-	   -lmpathpersist -L$(mpathcmddir) -lmpathcmd -lurcu -lpthread \
+LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
+	   -L$(mpathcmddir) -lmpathcmd -ludev -ldl -lurcu -lpthread \
 	   -ldevmapper -lreadline
 
 ifdef SYSTEMD
-- 
2.14.0
