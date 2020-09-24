From: mwilck@suse.com
Subject: [PATCH 10/11] libmpathpersist: add linker version script
Date: Thu, 24 Sep 2020 15:36:43 +0200
Message-ID: <20200924133644.14034-11-mwilck@suse.com>
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

This defines the ABI of libmpathpersist in the current state.
---
 libmpathpersist/Makefile                |  6 ++++--
 libmpathpersist/libmpathpersist.version | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100644 libmpathpersist/libmpathpersist.version

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 9e869fd..456ce4c 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -3,6 +3,7 @@ include ../Makefile.inc
 SONAME = 0
 DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
+VERSION_SCRIPT := libmpathpersist.version
 
 CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 
@@ -13,8 +14,9 @@ OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
 all: $(DEVLIB) man
 
-$(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
+$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS)
 
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
new file mode 100644
index 0000000..1bb8212
--- /dev/null
+++ b/libmpathpersist/libmpathpersist.version
@@ -0,0 +1,20 @@
+LIBMPATHPERSIST_0.8.4.0 {
+global:
+
+	__mpath_persistent_reserve_in;
+	__mpath_persistent_reserve_out;
+	dumpHex;
+	mpath_alloc_prin_response;
+	mpath_lib_exit;
+	mpath_lib_init;
+	mpath_mx_alloc_len;
+	mpath_persistent_reserve_in;
+	mpath_persistent_reserve_init_vecs;
+	mpath_persistent_reserve_out;
+	mpath_persistent_reserve_free_vecs;
+	prin_do_scsi_ioctl;
+	prout_do_scsi_ioctl;
+	update_map_pr;
+
+local: *;
+};
-- 
2.28.0
