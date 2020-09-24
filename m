From: mwilck@suse.com
Subject: [PATCH 05/11] libmultipath: prio: constify some function
	parameters
Date: Thu, 24 Sep 2020 15:36:38 +0200
Message-ID: <20200924133644.14034-6-mwilck@suse.com>
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

---
 libmultipath/prio.c | 4 ++--
 libmultipath/prio.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 194563c..3a718ba 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -18,7 +18,7 @@ unsigned int get_prio_timeout(unsigned int timeout_ms,
 	return default_timeout;
 }
 
-int init_prio (char *multipath_dir)
+int init_prio (const char *multipath_dir)
 {
 	if (!add_prio(multipath_dir, DEFAULT_PRIO))
 		return 1;
@@ -87,7 +87,7 @@ int prio_set_args (struct prio * p, const char * args)
 	return snprintf(p->args, PRIO_ARGS_LEN, "%s", args);
 }
 
-struct prio * add_prio (char *multipath_dir, char * name)
+struct prio * add_prio (const char *multipath_dir, const char * name)
 {
 	char libname[LIB_PRIO_NAMELEN];
 	struct stat stbuf;
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 599d1d8..26754f7 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -55,9 +55,9 @@ struct prio {
 
 unsigned int get_prio_timeout(unsigned int checker_timeout,
 			      unsigned int default_timeout);
-int init_prio (char *);
+int init_prio (const char *);
 void cleanup_prio (void);
-struct prio * add_prio (char *, char *);
+struct prio * add_prio (const char *, const char *);
 int prio_getprio (struct prio *, struct path *, unsigned int);
 void prio_get (char *, struct prio *, char *, char *);
 void prio_put (struct prio *);
-- 
2.28.0
