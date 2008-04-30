From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Fixup Makefiles
Date: Wed, 30 Apr 2008 11:04:55 +0200
Message-ID: <20080430090456.2F2BB18C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We're now using dlopen() etc, so we should link to libdl
explicitely instead of relying on some other library to do
this for us.
And '-fPIC' is a mandatory CFLAGS setting now, not an
optimisation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Makefile.inc        |    4 ++--
 multipath/Makefile  |    2 +-
 multipathd/Makefile |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 622f557..3e5bca0 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -26,8 +26,8 @@ libdir	    = $(prefix)/lib/multipath
 GZIP        = /bin/gzip -9 -c
 INSTALL_PROGRAM = install
 
-OPTFLAGS     = -pipe -g -Wall -Wunused -Wstrict-prototypes -fPIC
-CFLAGS	     = $(OPTFLAGS)
+OPTFLAGS     = -pipe -g -Wall -Wunused -Wstrict-prototypes
+CFLAGS	     = $(OPTFLAGS) -fPIC
 SHARED_FLAGS = -shared
 
 %.o:	%.c
diff --git a/multipath/Makefile b/multipath/Makefile
index 71df431..2d74ffe 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -7,7 +7,7 @@ include ../Makefile.inc
 OBJS = main.o
 
 CFLAGS += -I$(multipathdir) -Wl,-rpath,$(libdir)
-LDFLAGS += -laio -ldevmapper -lpthread \
+LDFLAGS += -lpthread -ldevmapper -laio -ldl \
 	   -lmultipath -L$(multipathdir)
 
 EXEC = multipath
diff --git a/multipathd/Makefile b/multipathd/Makefile
index dd223c4..b1af76c 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,7 +6,7 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -I$(multipathdir) -Wl,-rpath,$(libdir)
-LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -laio \
+LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -laio -ldl \
 	   -lmultipath -L$(multipathdir)
 
 #
-- 
1.5.2.4
