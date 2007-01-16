From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/.exported_s ...
Date: 16 Jan 2007 18:03:42 -0000
Message-ID: <20070116180342.21072.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-16 18:03:40

Modified files:
	.              : WHATS_NEW 
	dmeventd       : .exported_symbols dmeventd.c 
	                 libdevmapper-event.c libdevmapper-event.h 
	lib            : .exported_symbols Makefile.in libdevmapper.h 

Log message:
	Add basic reporting functions to libdevmapper.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.148&r2=1.149
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/.exported_symbols.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.34&r2=1.35
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.15&r2=1.16
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.27&r2=1.28
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.30&r2=1.31
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.63&r2=1.64

--- device-mapper/WHATS_NEW	2007/01/15 22:05:50	1.148
+++ device-mapper/WHATS_NEW	2007/01/16 18:03:39	1.149
@@ -1,5 +1,6 @@
 Version 1.02.15 -
 ===================================
+  Add basic reporting functions to libdevmapper.
   Fix a malloc error path in dmsetup message.
   More libdevmapper-event interface changes and fixes.
   Rename dm_saprintf() to dm_asprintf().
--- device-mapper/dmeventd/.exported_symbols	2007/01/15 18:21:01	1.7
+++ device-mapper/dmeventd/.exported_symbols	2007/01/16 18:03:40	1.8
@@ -1,7 +1,7 @@
 dm_event_handler_create
 dm_event_handler_destroy
 dm_event_handler_set_dso
-dm_event_handler_set_devname
+dm_event_handler_set_dev_name
 dm_event_handler_set_uuid
 dm_event_handler_set_major
 dm_event_handler_set_minor
--- device-mapper/dmeventd/dmeventd.c	2007/01/15 22:37:40	1.34
+++ device-mapper/dmeventd/dmeventd.c	2007/01/16 18:03:40	1.35
@@ -31,8 +31,10 @@
 #include <errno.h>
 #include <pthread.h>
 #include <sys/file.h>
+#include <sys/stat.h>
 #include <sys/wait.h>
-
+#include <sys/time.h>
+#include <sys/resource.h>
 #include <unistd.h>
 #include <arpa/inet.h>		/* for htonl, ntohl */
 
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/15 19:47:49	1.15
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/16 18:03:40	1.16
@@ -33,7 +33,7 @@
 struct dm_event_handler {
 	const char *dso;
 
-	const char *devname;
+	const char *dev_name;
 
 	const char *uuid;
 	int major;
@@ -42,9 +42,9 @@
 	enum dm_event_mask mask;
 };
 
-static void dm_event_handler_clear_devname(struct dm_event_handler *dmevh)
+static void dm_event_handler_clear_dev_name(struct dm_event_handler *dmevh)
 {
-	dmevh->devname = dmevh->uuid = NULL;
+	dmevh->dev_name = dmevh->uuid = NULL;
 	dmevh->major = dmevh->minor = 0;
 }
 
@@ -55,7 +55,7 @@
 	if (!(dmevh = dm_malloc(sizeof(*dmevh))))
 		return NULL;
 
-	dmevh->dso = dmevh->devname = dmevh->uuid = NULL;
+	dmevh->dso = dmevh->dev_name = dmevh->uuid = NULL;
 	dmevh->major = dmevh->minor = 0;
 	dmevh->mask = 0;
 
@@ -72,16 +72,16 @@
 	dmevh->dso = path;
 }
 
-void dm_event_handler_set_devname(struct dm_event_handler *dmevh, const char *devname)
+void dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name)
 {
-	dm_event_handler_clear_devname(dmevh);
+	dm_event_handler_clear_dev_name(dmevh);
 
-	dmevh->devname = devname;
+	dmevh->dev_name = dev_name;
 }
 
 void dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid)
 {
-	dm_event_handler_clear_devname(dmevh);
+	dm_event_handler_clear_dev_name(dmevh);
 
 	dmevh->uuid = uuid;
 }
@@ -90,7 +90,7 @@
 {
 	int minor = dmevh->minor;
 
-	dm_event_handler_clear_devname(dmevh);
+	dm_event_handler_clear_dev_name(dmevh);
 
 	dmevh->major = major;
 	dmevh->minor = minor;
@@ -100,7 +100,7 @@
 {
 	int major = dmevh->major;
 
-	dm_event_handler_clear_devname(dmevh);
+	dm_event_handler_clear_dev_name(dmevh);
 
 	dmevh->major = major;
 	dmevh->minor = minor;
@@ -117,9 +117,9 @@
 	return dmevh->dso;
 }
 
-const char *dm_event_handler_get_devname(const struct dm_event_handler *dmevh)
+const char *dm_event_handler_get_dev_name(const struct dm_event_handler *dmevh)
 {
-	return dmevh->devname;
+	return dmevh->dev_name;
 }
 
 const char *dm_event_handler_get_uuid(const struct dm_event_handler *dmevh)
@@ -256,11 +256,11 @@
 
 static int _daemon_talk(struct dm_event_fifos *fifos,
 			struct dm_event_daemon_message *msg, int cmd,
-			const char *dso_name, const char *devname,
+			const char *dso_name, const char *dev_name,
 			enum dm_event_mask evmask, uint32_t timeout)
 {
 	const char *dso = dso_name ? dso_name : "";
-	const char *dev = devname ? devname : "";
+	const char *dev = dev_name ? dev_name : "";
 	const char *fmt = "%s %s %u %" PRIu32;
 	memset(msg, 0, sizeof(*msg));
 
@@ -421,8 +421,8 @@
 
 	if (dmevh->uuid)
 		dm_task_set_uuid(dmt, dmevh->uuid);
-	else if (dmevh->devname)
-		dm_task_set_name(dmt, dmevh->devname);
+	else if (dmevh->dev_name)
+		dm_task_set_name(dmt, dmevh->dev_name);
 	else if (dmevh->major && dmevh->minor) {
 		dm_task_set_major(dmt, dmevh->major);
 		dm_task_set_minor(dmt, dmevh->minor);
@@ -453,7 +453,7 @@
 
 /* Handle the event (de)registration call and return negative error codes. */
 static int _do_event(int cmd, struct dm_event_daemon_message *msg,
-		    const char *dso_name, const char *devname,
+		    const char *dso_name, const char *dev_name,
 		    enum dm_event_mask evmask, uint32_t timeout)
 {
 	int ret;
@@ -464,7 +464,7 @@
 		return -ESRCH;
 	}
 
-	ret = _daemon_talk(&fifos, msg, cmd, dso_name, devname, evmask, timeout);
+	ret = _daemon_talk(&fifos, msg, cmd, dso_name, dev_name, evmask, timeout);
 
 	/* what is the opposite of init? */
 	_dtr_client(&fifos);
@@ -553,12 +553,12 @@
 
 /* Parse a device message from the daemon. */
 static int _parse_message(struct dm_event_daemon_message *msg, char **dso_name,
-			 char **devname, enum dm_event_mask *evmask)
+			 char **dev_name, enum dm_event_mask *evmask)
 {
 	char *p = msg->data;
 
 	if ((*dso_name = _fetch_string(&p, ' ')) &&
-	    (*devname = _fetch_string(&p, ' '))) {
+	    (*dev_name = _fetch_string(&p, ' '))) {
 		*evmask = atoi(p);
 
 		return 0;
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/15 18:21:01	1.7
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/16 18:03:40	1.8
@@ -59,9 +59,9 @@
 
 /*
  * Identify the device to monitor by exactly one of
- * devname, uuid or device number.
+ * dev_name, uuid or device number.
  */
-void dm_event_handler_set_devname(struct dm_event_handler *dmevh, const char *devname);
+void dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name);
 
 void dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid);
 
@@ -75,7 +75,7 @@
 				     enum dm_event_mask evmask);
 
 const char *dm_event_handler_get_dso(const struct dm_event_handler *dmevh);
-const char *dm_event_handler_get_devname(const struct dm_event_handler *dmevh);
+const char *dm_event_handler_get_dev_name(const struct dm_event_handler *dmevh);
 const char *dm_event_handler_get_uuid(const struct dm_event_handler *dmevh);
 int dm_event_handler_get_major(const struct dm_event_handler *dmevh);
 int dm_event_handler_get_minor(const struct dm_event_handler *dmevh);
@@ -94,8 +94,8 @@
 /* Prototypes for DSO interface, see dmeventd.c, struct dso_data for
    detailed descriptions. */
 void process_event(struct dm_task *dmt, enum dm_event_mask evmask);
-int register_device(const char *devname, const char *uuid, int major, int minor);
-int unregister_device(const char *devname, const char *uuid, int major,
+int register_device(const char *dev_name, const char *uuid, int major, int minor);
+int unregister_device(const char *dev_name, const char *uuid, int major,
 		      int minor);
 
 #endif
--- device-mapper/lib/.exported_symbols	2007/01/15 18:21:01	1.27
+++ device-mapper/lib/.exported_symbols	2007/01/16 18:03:40	1.28
@@ -116,3 +116,14 @@
 dm_snprintf
 dm_basename
 dm_asprintf
+dm_report_init
+dm_report_object
+dm_report_output
+dm_report_free
+dm_report_get_private
+dm_report_field_string
+dm_report_field_int
+dm_report_field_int32
+dm_report_field_uint32
+dm_report_field_uint64
+dm_report_field_set_value
--- device-mapper/lib/Makefile.in	2007/01/11 16:23:22	1.30
+++ device-mapper/lib/Makefile.in	2007/01/16 18:03:40	1.31
@@ -24,6 +24,7 @@
 	libdm-file.c \
 	libdm-deptree.c \
 	libdm-string.c \
+	libdm-report.c \
 	mm/dbg_malloc.c \
 	mm/pool.c \
 	$(interface)/libdm-iface.c
--- device-mapper/lib/libdevmapper.h	2007/01/15 18:21:01	1.63
+++ device-mapper/lib/libdevmapper.h	2007/01/16 18:03:40	1.64
@@ -124,10 +124,10 @@
 };
 
 struct dm_versions {
-        uint32_t next;		/* Offset to next struct from start of this struct */
-        uint32_t version[3];
+	uint32_t next;		/* Offset to next struct from start of this struct */
+	uint32_t version[3];
 
-        char name[0];
+	char name[0];
 };
 
 int dm_get_library_version(char *version, size_t size);
@@ -236,12 +236,12 @@
  * Add a new node to the tree if it doesn't already exist.
  */
 struct dm_tree_node *dm_tree_add_new_dev(struct dm_tree *tree,
-                                            const char *name,
-                                            const char *uuid,
-                                            uint32_t major, uint32_t minor,
-                                            int read_only,
-                                            int clear_inactive,
-                                            void *context);
+					 const char *name,
+					 const char *uuid,
+					 uint32_t major, uint32_t minor,
+					 int read_only,
+					 int clear_inactive,
+					 void *context);
 
 /*
  * Search for a node in the tree.
@@ -289,16 +289,16 @@
  * Ignores devices that don't have a uuid starting with uuid_prefix.
  */
 int dm_tree_preload_children(struct dm_tree_node *dnode,
-                                 const char *uuid_prefix,
-                                 size_t uuid_prefix_len);
+			     const char *uuid_prefix,
+			     size_t uuid_prefix_len);
 
 /*
  * Resume a device plus all dependencies.
  * Ignores devices that don't have a uuid starting with uuid_prefix.
  */
 int dm_tree_activate_children(struct dm_tree_node *dnode,
-                                 const char *uuid_prefix,
-                                 size_t uuid_prefix_len);
+			      const char *uuid_prefix,
+			      size_t uuid_prefix_len);
 
 /*
  * Suspend a device plus all dependencies.
@@ -630,4 +630,81 @@
  */
 int dm_asprintf(char **buf, const char *format, ...);
 
+/*********************
+ * reporting functions
+ *********************/
+
+struct dm_report_object_type {
+	uint32_t id;			/* Powers of 2 */
+	const char *desc;
+	const char *prefix;		/* field id string prefix (optional) */
+	void *(*data_fn)(void *object);	/* callback from report_object() */
+};
+
+struct dm_report_field;
+
+/*
+ * dm_report_field_type flags
+ */
+#define DM_REPORT_FIELD_MASK		0x0000000F
+#define DM_REPORT_FIELD_ALIGN_LEFT	0x00000001
+#define DM_REPORT_FIELD_ALIGN_RIGHT	0x00000002
+#define DM_REPORT_FIELD_STRING		0x00000004
+#define DM_REPORT_FIELD_NUMBER		0x00000008
+
+struct dm_report;
+struct dm_report_field_type {
+	uint32_t type;		/* object type id */
+	const char id[32];	/* string used to specify the field */
+	unsigned int offset;	/* byte offset in the object */
+	const char heading[32];	/* string printed in header */
+	int width;		/* default width */
+	uint32_t flags;		/* DM_REPORT_FIELD_* */
+	int (*report_fn)(struct dm_report *rh, struct dm_pool *mem,
+			 struct dm_report_field *field, const void *data,
+			 void *private);
+};
+
+/*
+ * dm_report_init output_flags
+ */
+#define DM_REPORT_OUTPUT_MASK		0x00000007
+#define DM_REPORT_OUTPUT_ALIGNED	0x00000001
+#define DM_REPORT_OUTPUT_BUFFERED	0x00000002
+#define DM_REPORT_OUTPUT_HEADINGS	0x00000004
+
+struct dm_report *dm_report_init(uint32_t *report_types,
+				 const struct dm_report_object_type *types,
+				 const struct dm_report_field_type *fields,
+				 const char *output_fields,
+				 const char *output_separator,
+				 uint32_t output_flags,
+				 const char *sort_keys,
+				 void *private);
+int dm_report_object(struct dm_report *rh, void *object);
+int dm_report_output(struct dm_report *rh);
+void dm_report_free(struct dm_report *rh);
+
+/* report functions for common types */
+int dm_report_field_string(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data);
+int dm_report_field_int32(struct dm_report *rh, struct dm_pool *mem,
+			  struct dm_report_field *field, const void *data);
+int dm_report_field_uint32(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data);
+int dm_report_field_int(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data);
+int dm_report_field_uint64(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data);
+
+/*
+ * Helper function for custom reporting functions
+ */
+
+/*
+ * sortvalue may be NULL if it's the same as value
+ */
+void dm_report_field_set_value(struct dm_report_field *field,
+			       const void *value, const void *sortvalue);
+
 #endif				/* LIB_DEVICE_MAPPER_H */
