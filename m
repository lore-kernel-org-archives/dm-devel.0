From: mwilck@suse.com
Subject: [PATCH v2 16/21] mpathpersist: use {get,
	put}_multipath_config() from libmultipath
Date: Thu, 24 Sep 2020 15:37:11 +0200
Message-ID: <20200924133716.14120-17-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 mpathpersist/main.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index a6a3bcf..278e48f 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -43,17 +43,6 @@ void mpath_print_transport_id(struct prin_fulldescr *fdesc);
 int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
 
 int logsink;
-struct config *multipath_conf;
-
-struct config *get_multipath_config(void)
-{
-	return multipath_conf;
-}
-
-void put_multipath_config(__attribute__((unused)) void * arg)
-{
-	/* Noop for now */
-}
 
 void rcu_register_thread_memb(void) {}
 
@@ -653,15 +642,14 @@ int main(int argc, char *argv[])
 	}
 
 	udev = udev_new();
-	multipath_conf = mpath_lib_init();
-	if(!multipath_conf) {
+	if (libmpathpersist_init()) {
 		udev_unref(udev);
 		exit(1);
 	}
 
 	ret = handle_args(argc, argv, 0);
 
-	mpath_lib_exit(multipath_conf);
+	libmpathpersist_exit();
 	udev_unref(udev);
 
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
-- 
2.28.0
