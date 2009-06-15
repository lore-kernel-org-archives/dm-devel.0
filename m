From: heinzm@redhat.com
Subject: [PATCH 3/6] dm raid45 target: introduce message parser
Date: Mon, 15 Jun 2009 19:21:11 +0200
Message-ID: <4a368307.0ftb1qz35ivVfvJZ%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


This patch adds the dm-message parser module.

Heinz

 drivers/md/{dm-message.h.orig => dm-message.h} |   91 ++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-message.h.orig b/drivers/md/dm-message.h
index e69de29..2024534 100644
--- a/drivers/md/dm-message.h.orig
+++ b/drivers/md/dm-message.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2007,2008 Red Hat, Inc. All rights reserved.
+ *
+ * Module Author: Heinz Mauelshagen <Mauelshagen@RedHat.de>
+ *
+ * General device-mapper message interface argument parser.
+ *
+ * This file is released under the GPL.
+ *
+ */
+
+#ifndef DM_MESSAGE_H
+#define DM_MESSAGE_H
+
+/* Factor out to dm.h. */
+/* Reference to array end. */
+#define ARRAY_END(a)    ((a) + ARRAY_SIZE(a))
+
+/* Message return bits. */
+enum dm_message_return {
+	dm_msg_ret_ambiguous,		/* Action ambiguous. */
+	dm_msg_ret_inval,		/* Action invalid. */
+	dm_msg_ret_undef,		/* Action undefined. */
+
+	dm_msg_ret_option,		/* Option error. */
+	dm_msg_ret_arg,			/* Argument error. */
+	dm_msg_ret_argcount,		/* Argument count error. */
+};
+
+/* Message argument type conversions. */
+enum dm_message_argument_type {
+	dm_msg_base_t,		/* Basename string. */
+	dm_msg_str_t,		/* String. */
+	dm_msg_int_t,		/* Signed int. */
+	dm_msg_uint_t,		/* Unsigned int. */
+	dm_msg_uint64_t,	/* Unsigned int 64. */
+};
+
+/* A message option. */
+struct dm_message_option {
+	unsigned num_options;
+	char **options;
+	unsigned long *actions;
+};
+
+/* Message arguments and types. */
+struct dm_message_argument {
+	unsigned num_args;
+	unsigned long **ptr;
+	enum dm_message_argument_type types[];
+};
+
+/* Client message. */
+struct dm_msg {
+	unsigned long action;		/* Identified action. */
+	unsigned long ret;		/* Return bits. */
+	unsigned num_specs;		/* # of sepcifications listed. */
+	struct dm_msg_spec *specs;	/* Specification list. */
+	struct dm_msg_spec *spec;	/* Specification selected. */
+};
+
+/* Secification of the message. */
+struct dm_msg_spec {
+	const char *cmd;	/* Name of the command (i.e. 'bandwidth'). */
+	unsigned long action;
+	struct dm_message_option *options;
+	struct dm_message_argument *args;
+	unsigned long parm;	/* Parameter to pass through to callback. */
+	/* Function to process for action. */
+	int (*f) (struct dm_msg *msg, void *context);
+};
+
+/* Parameter access macros. */
+#define	DM_MSG_PARM(msg) ((msg)->spec->parm)
+
+#define	DM_MSG_STR_ARGS(msg, idx) ((char *) *(msg)->spec->args->ptr[idx])
+#define	DM_MSG_INT_ARGS(msg, idx) ((int) *(msg)->spec->args->ptr[idx])
+#define	DM_MSG_UINT_ARGS(msg, idx) ((unsigned) DM_MSG_INT_ARG(msg, idx))
+#define	DM_MSG_UINT64_ARGS(msg, idx) ((uint64_t)  *(msg)->spec->args->ptr[idx])
+
+#define	DM_MSG_STR_ARG(msg)	DM_MSG_STR_ARGS(msg, 0)
+#define	DM_MSG_INT_ARG(msg)	DM_MSG_INT_ARGS(msg, 0)
+#define	DM_MSG_UINT_ARG(msg)	DM_MSG_UINT_ARGS(msg, 0)
+#define	DM_MSG_UINT64_ARG(msg)	DM_MSG_UINT64_ARGS(msg, 0)
+
+
+/* Parse a message and its options and optionally call a function back. */
+int dm_message_parse(const char *caller, struct dm_msg *msg, void *context,
+		     int argc, char **argv);
+
+#endif
 drivers/md/{dm-message.c.orig => dm-message.c} |  183 ++++++++++++++++++++++++
 1 files changed, 183 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-message.c.orig b/drivers/md/dm-message.c
index e69de29..a66b015 100644
--- a/drivers/md/dm-message.c.orig
+++ b/drivers/md/dm-message.c
@@ -0,0 +1,183 @@
+/*
+ * Copyright (C) 2007,2008 Red Hat Inc. All rights reserved.
+ *
+ * Module Author: Heinz Mauelshagen <heinzm@redhat.com>
+ *
+ * General device-mapper message interface argument parser.
+ *
+ * This file is released under the GPL.
+ *
+ * device-mapper message parser.
+ *
+ */
+
+#include "dm.h"
+#include "dm-message.h"
+#include <linux/kernel.h>
+
+#define DM_MSG_PREFIX	"dm_message"
+
+/* Basename of a path. */
+static inline char *
+basename(char *s)
+{
+	char *p = strrchr(s, '/');
+
+	return p ? p + 1 : s;
+}
+
+/* Get an argument depending on type. */
+static void
+message_arguments(struct dm_msg *msg, int argc, char **argv)
+{
+
+	if (argc) {
+		int i;
+		struct dm_message_argument *args = msg->spec->args;
+
+		for (i = 0; i < args->num_args; i++) {
+			int r;
+			unsigned long **ptr = args->ptr;
+			enum dm_message_argument_type type = args->types[i];
+
+			switch (type) {
+			case dm_msg_base_t:
+				((char **) ptr)[i] = basename(argv[i]);
+				break;
+
+			case dm_msg_str_t:
+				((char **) ptr)[i] = argv[i];
+				break;
+
+			case dm_msg_int_t:
+				r = sscanf(argv[i], "%d", ((int **) ptr)[i]);
+				goto check;
+
+			case dm_msg_uint_t:
+				r = sscanf(argv[i], "%u",
+					   ((unsigned **) ptr)[i]);
+				goto check;
+
+			case dm_msg_uint64_t:
+				r = sscanf(argv[i], "%llu",
+					   ((unsigned long long **) ptr)[i]);
+
+check:
+				if (r != 1) {
+					set_bit(dm_msg_ret_undef, &msg->ret);
+					set_bit(dm_msg_ret_arg, &msg->ret);
+				}
+			}
+		}
+	}
+}
+
+/* Parse message options. */
+static void
+message_options_parse(struct dm_msg *msg, int argc, char **argv)
+{
+	int hit = 0;
+	unsigned long *action;
+	size_t l1 = strlen(*argv), l_hit = 0;
+	struct dm_message_option *o = msg->spec->options;
+	char **option, **option_end = o->options + o->num_options;
+
+	for (option = o->options, action = o->actions;
+	     option < option_end; option++, action++) {
+		size_t l2 = strlen(*option);
+
+		if (!strnicmp(*argv, *option, min(l1, l2))) {
+			hit++;
+			l_hit = l2;
+			set_bit(*action, &msg->action);
+		}
+	}
+
+	/* Assume error. */
+	msg->ret = 0;
+	set_bit(dm_msg_ret_option, &msg->ret);
+	if (!hit || l1 > l_hit)
+		set_bit(dm_msg_ret_undef, &msg->ret);	/* Undefined option. */
+	else if (hit > 1)
+		set_bit(dm_msg_ret_ambiguous, &msg->ret); /* Ambiguous option.*/
+	else {
+		clear_bit(dm_msg_ret_option, &msg->ret); /* Option OK. */
+		message_arguments(msg, --argc, ++argv);
+	}
+}
+
+static inline void
+print_ret(const char *caller, unsigned long ret)
+{
+	struct {
+		unsigned long err;
+		const char *err_str;
+	} static err_msg[] = {
+		{ dm_msg_ret_ambiguous, "message ambiguous" },
+		{ dm_msg_ret_inval, "message invalid" },
+		{ dm_msg_ret_undef, "message undefined" },
+		{ dm_msg_ret_arg, "message argument" },
+		{ dm_msg_ret_argcount, "message argument count" },
+		{ dm_msg_ret_option, "option" },
+	}, *e = ARRAY_END(err_msg);
+
+	while (e-- > err_msg) {
+		if (test_bit(e->err, &ret))
+			DMERR("%s %s", caller, e->err_str);
+	}
+}
+
+/* Parse a message action. */
+int
+dm_message_parse(const char *caller, struct dm_msg *msg, void *context,
+		 int argc, char **argv)
+{
+	int hit = 0;
+	size_t l1, l_hit = 0;
+	struct dm_msg_spec *s, *s_hit = NULL,
+			   *s_end = msg->specs + msg->num_specs;
+
+	if (argc < 2)
+		return -EINVAL;
+
+	l1 = strlen(*argv);
+	for (s = msg->specs; s < s_end; s++) {
+		size_t l2 = strlen(s->cmd);
+
+		if (!strnicmp(*argv, s->cmd, min(l1, l2))) {
+			hit++;
+			l_hit = l2;
+			s_hit = s;
+		}
+	}
+
+	msg->ret = 0;
+	if (!hit || l1 > l_hit)	/* No hit or message string too long. */
+		set_bit(dm_msg_ret_undef, &msg->ret);
+	else if (hit > 1)	/* Ambiguous message. */
+		set_bit(dm_msg_ret_ambiguous, &msg->ret);
+	else if (argc - 2 != s_hit->args->num_args) {
+		set_bit(dm_msg_ret_undef, &msg->ret);
+		set_bit(dm_msg_ret_argcount, &msg->ret);
+	}
+
+	if (msg->ret)
+		goto bad;
+
+	msg->action = 0;
+	msg->spec = s_hit;
+	set_bit(s_hit->action, &msg->action);
+	message_options_parse(msg, --argc, ++argv);
+
+	if (!msg->ret)
+		return msg->spec->f(msg, context);
+
+bad:
+	print_ret(caller, msg->ret);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dm_message_parse);
+
+MODULE_DESCRIPTION(DM_NAME " device-mapper target message parser");
+MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.com>");
+MODULE_LICENSE("GPL");
