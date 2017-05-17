From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/7] Move the declaration of mpath_mx_alloc_len
	to a header file
Date: Wed, 17 May 2017 08:43:07 -0700
Message-ID: <20170517154309.17787-6-bart.vanassche@sandisk.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517154309.17787-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This allows the compiler to verify consistency of declaration and
definition.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmpathpersist/mpath_persist.h | 3 +++
 mpathpersist/main.c             | 1 -
 multipathd/main.c               | 2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 79de5b5b..3faa8c9e 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -81,6 +81,9 @@ extern "C" {
 
 
 
+extern unsigned int mpath_mx_alloc_len;
+
+
 
 struct prin_readdescr
 {
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 2e0aba3c..9de52b98 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -40,7 +40,6 @@ void mpath_print_transport_id(struct prin_fulldescr *fdesc);
 int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
 
 int logsink;
-unsigned int mpath_mx_alloc_len;
 struct config *multipath_conf;
 
 struct config *get_multipath_config(void)
diff --git a/multipathd/main.c b/multipathd/main.c
index b167cb4c..81c76cab 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -104,8 +104,6 @@ struct mpath_event_param
 	struct multipath *mpp;
 };
 
-unsigned int mpath_mx_alloc_len;
-
 int logsink;
 int verbosity;
 int bindings_read_only;
-- 
2.12.2
