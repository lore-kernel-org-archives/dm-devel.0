From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5/5] multipath-tools: miscellaneous code cleanups
Date: Mon, 3 Aug 2009 17:03:22 -0500
Message-ID: <20090803220321.GV15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

io_getevents can return < 0 if it is interrupted, but it doesn't set errno.
This patch sets errno to zero first to avoid printing garbage. Also the
log_thread and uevq_thread functions need to return NULL to avoid compiler
warnings. 

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/directio.c |    1 +
 libmultipath/log_pthread.c       |    1 +
 libmultipath/uevent.c            |    1 +
 3 files changed, 3 insertions(+)

Index: multipath-tools/libmultipath/checkers/directio.c
===================================================================
--- multipath-tools.orig/libmultipath/checkers/directio.c
+++ multipath-tools/libmultipath/checkers/directio.c
@@ -148,6 +148,7 @@ check_state(int fd, struct directio_cont
 	}
 	ct->running++;
 
+	errno = 0;
 	r = io_getevents(ct->ioctx, 1L, 1L, &event, &timeout);
 
 	if (r < 0 ) {
Index: multipath-tools/libmultipath/log_pthread.c
===================================================================
--- multipath-tools.orig/libmultipath/log_pthread.c
+++ multipath-tools/libmultipath/log_pthread.c
@@ -56,6 +56,7 @@ static void * log_thread (void * et)
 
 		flush_logqueue();
 	}
+	return NULL;
 }
 
 void log_thread_start (pthread_attr_t *attr)
Index: multipath-tools/libmultipath/uevent.c
===================================================================
--- multipath-tools.orig/libmultipath/uevent.c
+++ multipath-tools/libmultipath/uevent.c
@@ -101,6 +101,7 @@ uevq_thread(void * et)
 
 		service_uevq();
 	}
+	return NULL;
 }
 
 int uevent_listen(int (*uev_trigger)(struct uevent *, void * trigger_data),
