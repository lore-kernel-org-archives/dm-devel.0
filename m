From: mwilck@suse.com
Subject: [PATCH 11/11] libmpathcmd: add linker version script
Date: Thu, 24 Sep 2020 15:36:44 +0200
Message-ID: <20200924133644.14034-12-mwilck@suse.com>
References: <20200924133644.14034-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

For completeness, this isn't really necessary.
---
 libmpathcmd/Makefile            |  6 ++++--
 libmpathcmd/libmpathcmd.version | 13 +++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)
 create mode 100644 libmpathcmd/libmpathcmd.version

diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 08ccb81..2591019 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -3,6 +3,7 @@ include ../Makefile.inc
 SONAME = 0
 DEVLIB = libmpathcmd.so
 LIBS = $(DEVLIB).$(SONAME)
+VERSION_SCRIPT := libmpathcmd.version
 
 CFLAGS += $(LIB_CFLAGS)
 
@@ -10,8 +11,9 @@ OBJS = mpath_cmd.o
 
 all:	$(DEVLIB)
 
-$(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
+$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
 
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
diff --git a/libmpathcmd/libmpathcmd.version b/libmpathcmd/libmpathcmd.version
new file mode 100644
index 0000000..5382a9a
--- /dev/null
+++ b/libmpathcmd/libmpathcmd.version
@@ -0,0 +1,13 @@
+LIBMPATHCMD_0.8.4.0 {
+global:
+	__mpath_connect;
+	mpath_connect;
+	mpath_disconnect;
+	mpath_process_cmd;
+	mpath_recv_reply;
+	mpath_recv_reply_len;
+	mpath_recv_reply_data;
+	mpath_send_cmd;
+local:
+	*;
+};
-- 
2.28.0
