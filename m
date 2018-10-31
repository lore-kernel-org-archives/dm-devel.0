From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 03/22] libmultipath/checkers: replace message
	by msgid
Date: Wed, 31 Oct 2018 11:59:38 +0100
Message-ID: <20181031105939.22202-2-mwilck@suse.com>
References: <20181031105939.22202-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181031105939.22202-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Replace the character array "message" in struct checker with
a "message ID" field.

The generic checker code defines a couple of standard message IDs
and corresponding messages. Checker-specific message IDs start
at CHECKER_FIRST_MSG. Checkers that implement specific message
IDs must provide a table for converting the IDs into actual log
messages.

This simplifies the checker data structure and the handling of
checker messages in the critical checker code path. It comes at
the cost that only constant message strings are supported. It
turns out that only a single checker log message (in the emc_clariion
checker) was dynamically generated, and the missing information can
be provided with a standard condlog message.

Follow-up patches implement this for the existing checkers.
checker_message() isn't thread-safe in its current form.
This will be fixed in another follow-up patch.
---
 libmultipath/checkers.c | 70 +++++++++++++++++++++++++++++++++++------
 libmultipath/checkers.h | 39 +++++++++++++++++++----
 2 files changed, 94 insertions(+), 15 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 0bacc864..96086686 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -141,6 +141,22 @@ struct checker * add_checker (char *multipath_dir, char * name)
 	if (!c->free)
 		goto out;
 
+	c->msgtable_size = 0;
+	c->msgtable = dlsym(c->handle, "libcheck_msgtable");
+
+	if (c->msgtable != NULL) {
+		const char **p;
+
+		for (p = c->msgtable;
+		     *p && (p - c->msgtable) < CHECKER_MSGTABLE_SIZE; p++)
+			/* nothing */;
+
+		c->msgtable_size = p - c->msgtable;
+	} else
+		c->msgtable_size = 0;
+	condlog(3, "checker %s: message table size = %d",
+		c->name, c->msgtable_size);
+
 done:
 	c->fd = -1;
 	c->sync = 1;
@@ -222,16 +238,16 @@ int checker_check (struct checker * c, int path_state)
 	if (!c)
 		return PATH_WILD;
 
-	c->message[0] = '\0';
+	c->msgid = CHECKER_MSGID_NONE;
 	if (c->disable) {
-		MSG(c, "checker disabled");
+		c->msgid = CHECKER_MSGID_DISABLED;
 		return PATH_UNCHECKED;
 	}
 	if (!strncmp(c->name, NONE, 4))
 		return path_state;
 
 	if (c->fd < 0) {
-		MSG(c, "no usable fd");
+		c->msgid = CHECKER_MSGID_NO_FD;
 		return PATH_WILD;
 	}
 	r = c->check(c);
@@ -248,25 +264,59 @@ int checker_selected (struct checker * c)
 	return (c->check) ? 1 : 0;
 }
 
-char * checker_name (struct checker * c)
+const char *checker_name(const struct checker *c)
 {
 	if (!c)
 		return NULL;
 	return c->name;
 }
 
-char * checker_message (struct checker * c)
+static const char *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
+	[CHECKER_MSGID_NONE] = "",
+	[CHECKER_MSGID_DISABLED] = " is disabled",
+	[CHECKER_MSGID_NO_FD] = " has no usable fd",
+	[CHECKER_MSGID_INVALID] = " provided invalid message id",
+	[CHECKER_MSGID_UP] = " reports path is up",
+	[CHECKER_MSGID_DOWN] = " reports path is down",
+	[CHECKER_MSGID_GHOST] = " reports path is ghost",
+};
+
+static const char *_checker_message(const struct checker *c)
 {
-	if (!c)
+	int id;
+
+	if (!c || c->msgid < 0 ||
+	    (c->msgid >= CHECKER_GENERIC_MSGTABLE_SIZE &&
+	     c->msgid < CHECKER_FIRST_MSGID))
 		return NULL;
-	return c->message;
+
+	if (c->msgid < CHECKER_GENERIC_MSGTABLE_SIZE)
+		return generic_msg[c->msgid];
+
+	id = c->msgid - CHECKER_FIRST_MSGID;
+	if (id < c->msgtable_size)
+		return c->msgtable[id];
+	return NULL;
+}
+
+char *checker_message(const struct checker *c)
+{
+	static char buf[CHECKER_MSG_LEN];
+	const char *msg = _checker_message(c);
+
+	if (msg == NULL || *msg == '\0')
+		*buf = '\0';
+	else
+		snprintf(buf, sizeof(buf), "%s checker%s",
+			 c->name, msg);
+	return buf;
 }
 
 void checker_clear_message (struct checker *c)
 {
 	if (!c)
 		return;
-	c->message[0] = '\0';
+	c->msgid = CHECKER_MSGID_NONE;
 }
 
 void checker_get (char *multipath_dir, struct checker * dst, char * name)
@@ -288,10 +338,12 @@ void checker_get (char *multipath_dir, struct checker * dst, char * name)
 	dst->fd = src->fd;
 	dst->sync = src->sync;
 	strncpy(dst->name, src->name, CHECKER_NAME_LEN);
-	strncpy(dst->message, src->message, CHECKER_MSG_LEN);
+	dst->msgid = CHECKER_MSGID_NONE;
 	dst->check = src->check;
 	dst->init = src->init;
 	dst->free = src->free;
+	dst->msgtable = src->msgtable;
+	dst->msgtable_size = src->msgtable_size;
 	dst->handle = NULL;
 	src->refcount++;
 }
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 7b18a1ac..60b1321b 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -97,6 +97,22 @@ enum path_check_state {
 #define CHECKER_DEV_LEN 256
 #define LIB_CHECKER_NAMELEN 256
 
+/*
+ * Generic message IDs for use in checkers.
+ */
+enum {
+	CHECKER_MSGID_NONE = 0,
+	CHECKER_MSGID_DISABLED,
+	CHECKER_MSGID_NO_FD,
+	CHECKER_MSGID_INVALID,
+	CHECKER_MSGID_UP,
+	CHECKER_MSGID_DOWN,
+	CHECKER_MSGID_GHOST,
+	CHECKER_GENERIC_MSGTABLE_SIZE,
+	CHECKER_FIRST_MSGID = 100,	/* lowest msgid for checkers */
+	CHECKER_MSGTABLE_SIZE = 100,	/* max msg table size for checkers */
+};
+
 struct checker {
 	struct list_head node;
 	void *handle;
@@ -106,7 +122,7 @@ struct checker {
 	unsigned int timeout;
 	int disable;
 	char name[CHECKER_NAME_LEN];
-	char message[CHECKER_MSG_LEN];       /* comm with callers */
+	short msgid;		             /* checker-internal extra status */
 	void * context;                      /* store for persistent data */
 	void ** mpcontext;                   /* store for persistent data shared
 						multipath-wide. Use MALLOC if
@@ -114,10 +130,10 @@ struct checker {
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
+	const char**msgtable;
+	short msgtable_size;
 };
 
-#define MSG(c, fmt, args...) snprintf((c)->message, CHECKER_MSG_LEN, fmt, ##args);
-
 char * checker_state_name (int);
 int init_checkers (char *);
 void cleanup_checkers (void);
@@ -134,14 +150,25 @@ void checker_enable (struct checker *);
 void checker_disable (struct checker *);
 int checker_check (struct checker *, int);
 int checker_selected (struct checker *);
-char * checker_name (struct checker *);
-char * checker_message (struct checker *);
+const char *checker_name (const struct checker *);
+char *checker_message (const struct checker *);
 void checker_clear_message (struct checker *c);
 void checker_get (char *, struct checker *, char *);
 
-/* Functions exported by path checker dynamic libraries (.so) */
+/* Prototypes for symbols exported by path checker dynamic libraries (.so) */
 int libcheck_check(struct checker *);
 int libcheck_init(struct checker *);
 void libcheck_free(struct checker *);
+/*
+ * msgid => message map.
+ *
+ * It only needs to be provided if the checker defines specific
+ * message IDs.
+ * Message IDs available to checkers start at CHECKER_FIRST_MSG.
+ * The msgtable array is 0-based, i.e. msgtable[0] is the message
+ * for msgid == __CHECKER_FIRST_MSG.
+ * The table ends with a NULL element.
+ */
+extern const char *libcheck_msgtable[];
 
 #endif /* _CHECKERS_H */
-- 
2.19.1
