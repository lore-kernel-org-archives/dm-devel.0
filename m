From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW include/list.h
Date: 8 Jun 2008 14:53:52 -0000
Message-ID: <20080608145352.23263.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-08 14:53:51

Modified files:
	.              : WHATS_NEW 
	include        : list.h 

Log message:
	bring list.h into line with lvm2

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.239&r2=1.240
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/list.h.diff?cvsroot=dm&r1=1.6&r2=1.7

--- device-mapper/WHATS_NEW	2008/06/06 20:45:41	1.239
+++ device-mapper/WHATS_NEW	2008/06/08 14:53:51	1.240
@@ -1,7 +1,7 @@
 Version 1.02.27 -
 ===============================
   Remove --enable-jobs from configure. (Set at runtime instead.)
-  Bring configure.in into line with the lvm2 version.
+  Bring configure.in and list.h into line with the lvm2 versions.
 
 Version 1.02.26 - 6th June 2008
 ===============================
--- device-mapper/include/list.h	2007/08/21 16:26:06	1.6
+++ device-mapper/include/list.h	2008/06/08 14:53:51	1.7
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -81,9 +81,18 @@
 }
 
 /*
+ * Remove an element from existing list and insert before 'head'.
+ */
+static inline void list_move(struct list *head, struct list *elem)
+{
+	list_del(elem);
+	list_add(head, elem);
+}
+
+/*
  * Is the list empty?
  */
-static inline int list_empty(struct list *head)
+static inline int list_empty(const struct list *head)
 {
 	return head->n == head;
 }
@@ -91,7 +100,7 @@
 /*
  * Is this the first element of the list?
  */
-static inline int list_start(struct list *head, struct list *elem)
+static inline int list_start(const struct list *head, const struct list *elem)
 {
 	return elem->p == head;
 }
@@ -99,7 +108,7 @@
 /*
  * Is this the last element of the list?
  */
-static inline int list_end(struct list *head, struct list *elem)
+static inline int list_end(const struct list *head, const struct list *elem)
 {
 	return elem->n == head;
 }
@@ -107,7 +116,7 @@
 /*
  * Return first element of the list or NULL if empty
  */
-static inline struct list *list_first(struct list *head)
+static inline struct list *list_first(const struct list *head)
 {
 	return (list_empty(head) ? NULL : head->n);
 }
@@ -115,7 +124,7 @@
 /*
  * Return last element of the list or NULL if empty
  */
-static inline struct list *list_last(struct list *head)
+static inline struct list *list_last(const struct list *head)
 {
 	return (list_empty(head) ? NULL : head->p);
 }
@@ -123,7 +132,7 @@
 /*
  * Return the previous element of the list, or NULL if we've reached the start.
  */
-static inline struct list *list_prev(struct list *head, struct list *elem)
+static inline struct list *list_prev(const struct list *head, const struct list *elem)
 {
 	return (list_start(head, elem) ? NULL : elem->p);
 }
@@ -131,7 +140,7 @@
 /*
  * Return the next element of the list, or NULL if we've reached the end.
  */
-static inline struct list *list_next(struct list *head, struct list *elem)
+static inline struct list *list_next(const struct list *head, const struct list *elem)
 {
 	return (list_end(head, elem) ? NULL : elem->n);
 }
@@ -204,6 +213,26 @@
 #define list_iterate_items(v, head) list_iterate_items_gen(v, (head), list)
 
 /*
+ * Walk a list, setting 'v' in turn to the containing structure of each item.
+ * The containing structure should be the same type as 'v'.
+ * The 'struct list' variable within the containing structure is 'field'.
+ * t must be defined as a temporary variable of the same type as v.
+ */
+#define list_iterate_items_gen_safe(v, t, head, field) \
+	for (v = list_struct_base((head)->n, typeof(*v), field), \
+	     t = list_struct_base(v->field.n, typeof(*v), field); \
+	     &v->field != (head); \
+	     v = t, t = list_struct_base(v->field.n, typeof(*v), field))
+/*
+ * Walk a list, setting 'v' in turn to the containing structure of each item.
+ * The containing structure should be the same type as 'v'.
+ * The list should be 'struct list list' within the containing structure.
+ * t must be defined as a temporary variable of the same type as v.
+ */
+#define list_iterate_items_safe(v, t, head) \
+	list_iterate_items_gen_safe(v, t, (head), list)
+
+/*
  * Walk a list backwards, setting 'v' in turn to the containing structure 
  * of each item.
  * The containing structure should be the same type as 'v'.
