From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 13/15] libmultipath/prioritizers: Make getprio()
 prototypes consistent
Date: Fri, 21 Oct 2016 11:46:19 -0700
Message-ID: <1e6ca95e-ff82-8d54-2367-ccaf92c1a6fd@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Additionally, ensure that the compiler checks the getprio()
prototype.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/prio.h                      | 3 +++
 libmultipath/prioritizers/const.c        | 2 +-
 libmultipath/prioritizers/datacore.c     | 2 +-
 libmultipath/prioritizers/iet.c          | 2 +-
 libmultipath/prioritizers/random.c       | 2 +-
 libmultipath/prioritizers/weightedpath.c | 2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 261105b..0193c52 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -64,4 +64,7 @@ char * prio_name (struct prio *);
 char * prio_args (struct prio *);
 int prio_set_args (struct prio *, char *);
 
+/* The only function exported by prioritizer dynamic libraries (.so) */
+int getprio(struct path *, char *, unsigned int);
+
 #endif /* _PRIO_H */
diff --git a/libmultipath/prioritizers/const.c b/libmultipath/prioritizers/const.c
index 9d9d003..aad6927 100644
--- a/libmultipath/prioritizers/const.c
+++ b/libmultipath/prioritizers/const.c
@@ -2,7 +2,7 @@
 
 #include "prio.h"
 
-int getprio (struct path * pp, char * args)
+int getprio(struct path * pp, char * args, unsigned int timeout)
 {
 	return 1;
 }
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 050a94c..36465ac 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -106,7 +106,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	return 0;
 }
 
-int getprio (struct path * pp, char * args)
+int getprio(struct path * pp, char * args, unsigned int timeout)
 {
 	return datacore_prio(pp->dev, pp->fd, args);
 }
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index aa852a0..a4ea61e 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -138,7 +138,7 @@ int iet_prio(const char *dev, char * args)
 	return 10;
 }
 
-int getprio(struct path * pp, char * args)
+int getprio(struct path * pp, char * args, unsigned int timeout)
 {
 	return iet_prio(pp->dev, args);
 }
diff --git a/libmultipath/prioritizers/random.c b/libmultipath/prioritizers/random.c
index c3ea3ac..4a27123 100644
--- a/libmultipath/prioritizers/random.c
+++ b/libmultipath/prioritizers/random.c
@@ -5,7 +5,7 @@
 
 #include "prio.h"
 
-int getprio (struct path * pp, char * args)
+int getprio(struct path * pp, char * args, unsigned int timeout)
 {
 	struct timeval tv;
 
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index a62b86e..34a43a8 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -151,7 +151,7 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	return priority;
 }
 
-int getprio(struct path *pp, char *args)
+int getprio(struct path *pp, char *args, unsigned int timeout)
 {
 	return prio_path_weight(pp, args);
 }
-- 
2.10.1
