From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/28] libmultipath/prio: constify simple getters
Date: Fri,  8 Jun 2018 12:20:20 +0200
Message-ID: <20180608102041.22904-8-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

One day we should also constify getprio(), but that requires
touching all prioritizers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prio.c | 8 ++++----
 libmultipath/prio.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 7fce9215..17acfd05 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -81,7 +81,7 @@ static struct prio * prio_lookup (char * name)
 	return NULL;
 }
 
-int prio_set_args (struct prio * p, char * args)
+int prio_set_args (struct prio * p, const char * args)
 {
 	return snprintf(p->args, PRIO_ARGS_LEN, "%s", args);
 }
@@ -130,19 +130,19 @@ int prio_getprio (struct prio * p, struct path * pp, unsigned int timeout)
 	return p->getprio(pp, p->args, timeout);
 }
 
-int prio_selected (struct prio * p)
+int prio_selected (const struct prio * p)
 {
 	if (!p)
 		return 0;
 	return (p->getprio) ? 1 : 0;
 }
 
-char * prio_name (struct prio * p)
+const char * prio_name (const struct prio * p)
 {
 	return p->name;
 }
 
-char * prio_args (struct prio * p)
+const char * prio_args (const struct prio * p)
 {
 	return p->args;
 }
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index c97fe397..aa587ccd 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -60,10 +60,10 @@ struct prio * add_prio (char *, char *);
 int prio_getprio (struct prio *, struct path *, unsigned int);
 void prio_get (char *, struct prio *, char *, char *);
 void prio_put (struct prio *);
-int prio_selected (struct prio *);
-char * prio_name (struct prio *);
-char * prio_args (struct prio *);
-int prio_set_args (struct prio *, char *);
+int prio_selected (const struct prio *);
+const char * prio_name (const struct prio *);
+const char * prio_args (const struct prio *);
+int prio_set_args (struct prio *, const char *);
 
 /* The only function exported by prioritizer dynamic libraries (.so) */
 int getprio(struct path *, char *, unsigned int);
-- 
2.17.0
