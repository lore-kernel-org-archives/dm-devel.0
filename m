From: mwilck@suse.com
Subject: [PATCH 23/23] multipath-tools: mpath-tools.supp: file
	with valgrind suppressions
Date: Thu, 24 Sep 2020 15:40:54 +0200
Message-ID: <20200924134054.14632-24-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

These leaks are caused by other libraries (libsystemd, glibc,
libgcrypt) and should be ignored when debugging with valgrind

Usage example:

valgrind --suppressions=mpath-tools.supp \
    --leak-check=full --show-leak-kinds=all $COMMAND

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 third-party/valgrind/mpath-tools.supp | 33 +++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 third-party/valgrind/mpath-tools.supp

diff --git a/third-party/valgrind/mpath-tools.supp b/third-party/valgrind/mpath-tools.supp
new file mode 100644
index 0000000..621463a
--- /dev/null
+++ b/third-party/valgrind/mpath-tools.supp
@@ -0,0 +1,33 @@
+{
+   glibc _dlerror_run leak: https://stackoverflow.com/questions/1542457/memory-leak-reported-by-valgrind-in-dlopen
+   Memcheck:Leak
+   match-leak-kinds: reachable
+   fun:calloc
+   fun:_dlerror_run
+   fun:dlopen*
+}
+
+{
+   systemd mempools are never freed: https://bugzilla.redhat.com/show_bug.cgi?id=1215670
+   Memcheck:Leak
+   match-leak-kinds: reachable
+   fun:malloc
+   fun:mempool_alloc_tile
+   fun:mempool_alloc0_tile
+   fun:hashmap_base_new
+   fun:hashmap_base_ensure_allocated
+}
+
+{
+   libgcrypt library initialization
+   Memcheck:Leak
+   match-leak-kinds: reachable
+   fun:malloc
+   ...
+   fun:_gcry_xmalloc
+   ...
+   fun:global_init.*
+   ...
+   fun:_dl_init
+}
+
-- 
2.28.0
