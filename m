From: mwilck@suse.com
Subject: [PATCH v2 20/21] mpathpersist: remove logsink and udev
Date: Thu, 24 Sep 2020 15:37:15 +0200
Message-ID: <20200924133716.14120-21-mwilck@suse.com>
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

We can use libmultipath's internal symbols now. The libmultipath
initialization is taken care of by libmpathpersist_init().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 mpathpersist/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 278e48f..3c2e657 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -42,13 +42,10 @@ void * mpath_alloc_prin_response(int prin_sa);
 void mpath_print_transport_id(struct prin_fulldescr *fdesc);
 int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
 
-int logsink;
-
 void rcu_register_thread_memb(void) {}
 
 void rcu_unregister_thread_memb(void) {}
 
-struct udev *udev;
 
 static int verbose, loglevel, noisy;
 
@@ -641,16 +638,13 @@ int main(int argc, char *argv[])
 		exit (1);
 	}
 
-	udev = udev_new();
 	if (libmpathpersist_init()) {
-		udev_unref(udev);
 		exit(1);
 	}
 
 	ret = handle_args(argc, argv, 0);
 
 	libmpathpersist_exit();
-	udev_unref(udev);
 
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
 }
-- 
2.28.0
