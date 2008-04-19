From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 19 Apr 2008 15:50:19 -0000
Message-ID: <20080419155019.3381.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-04-19 15:50:18

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-report.c 
	lib/mm         : pool-debug.c pool-fast.c 

Log message:
	Calculate string size within dm_pool_grow_object.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.227&r2=1.228
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.103&r2=1.104
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.79&r2=1.80
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.16&r2=1.17
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool-debug.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool-fast.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- device-mapper/WHATS_NEW	2008/04/10 18:04:31	1.227
+++ device-mapper/WHATS_NEW	2008/04/19 15:50:17	1.228
@@ -1,5 +1,6 @@
 Version 1.02.26 - 
 =================================
+  Calculate string size within dm_pool_grow_object.
 
 Version 1.02.25 - 10th April 2008
 =================================
--- device-mapper/dmsetup/dmsetup.c	2007/12/05 17:05:04	1.103
+++ device-mapper/dmsetup/dmsetup.c	2008/04/19 15:50:17	1.104
@@ -1697,7 +1697,7 @@
 			log_error("dm_pool_grow_object failed");
 			goto out_abandon;
 		}
-		if (!dm_pool_grow_object(mem, name, strlen(name))) {
+		if (!dm_pool_grow_object(mem, name, 0)) {
 			log_error("dm_pool_grow_object failed");
 			goto out_abandon;
 		}
@@ -1763,7 +1763,7 @@
 			log_error("dm_snprintf failed");
 			goto out_abandon;
 		}
-		if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+		if (!dm_pool_grow_object(mem, buf, 0)) {
 			log_error("dm_pool_grow_object failed");
 			goto out_abandon;
 		}
@@ -1816,7 +1816,7 @@
 			log_error("dm_snprintf failed");
 			goto out_abandon;
 		}
-		if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+		if (!dm_pool_grow_object(mem, buf, 0)) {
 			log_error("dm_pool_grow_object failed");
 			goto out_abandon;
 		}
--- device-mapper/lib/libdevmapper.h	2007/12/05 16:28:19	1.79
+++ device-mapper/lib/libdevmapper.h	2008/04/19 15:50:18	1.80
@@ -500,7 +500,7 @@
  *
  *      for (i = 0; i < 50; i++) {
  *              snprintf(buffer, sizeof(buffer), "%d, ", i);
- *              if (!dm_pool_grow_object(mem, buffer, strlen(buffer)))
+ *              if (!dm_pool_grow_object(mem, buffer, 0))
  *                      goto bad;
  *      }
  *
@@ -524,6 +524,7 @@
  * dm_pool_grow_object.  Finally get your object with
  * a call to dm_pool_end_object.
  *
+ * Setting delta to 0 means it will use strlen(extra).
  */
 int dm_pool_begin_object(struct dm_pool *p, size_t hint);
 int dm_pool_grow_object(struct dm_pool *p, const void *extra, size_t delta);
--- device-mapper/lib/libdm-report.c	2008/01/20 01:14:38	1.16
+++ device-mapper/lib/libdm-report.c	2008/04/19 15:50:18	1.17
@@ -668,15 +668,13 @@
 				log_error("dm_report: Failed to generate report headings for printing");
 				goto bad;
 			}
-		} else if (!dm_pool_grow_object(rh->mem, heading,
-						strlen(heading))) {
+		} else if (!dm_pool_grow_object(rh->mem, heading, 0)) {
 			log_error("dm_report: Failed to generate report headings for printing");
 			goto bad;
 		}
 
 		if (!list_end(&rh->field_props, &fp->list))
-			if (!dm_pool_grow_object(rh->mem, rh->separator,
-					      strlen(rh->separator))) {
+			if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
 				log_error("dm_report: Failed to generate report headings for printing");
 				goto bad;
 			}
@@ -803,8 +801,7 @@
 			repstr = field->report_string;
 			width = field->props->width;
 			if (!(rh->flags & DM_REPORT_OUTPUT_ALIGNED)) {
-				if (!dm_pool_grow_object(rh->mem, repstr,
-						      strlen(repstr))) {
+				if (!dm_pool_grow_object(rh->mem, repstr, 0)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
 				}
@@ -836,8 +833,7 @@
 			}
 
 			if (!list_end(&row->fields, fh))
-				if (!dm_pool_grow_object(rh->mem, rh->separator,
-						      strlen(rh->separator))) {
+				if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
 				}
--- device-mapper/lib/mm/pool-debug.c	2007/08/21 16:26:07	1.3
+++ device-mapper/lib/mm/pool-debug.c	2008/04/19 15:50:18	1.4
@@ -216,10 +216,10 @@
 	return 1;
 }
 
-int dm_pool_grow_object(struct dm_pool *p, const void *buffer, size_t delta)
+int dm_pool_grow_object(struct dm_pool *p, const void *extra, size_t delta)
 {
 	struct block *new;
-	size_t size = delta;
+	size_t size = delta ? : strlen(extra);
 
 	assert(p->begun);
 
@@ -238,7 +238,7 @@
 	}
 	p->object = new;
 
-	memcpy(new->data + size - delta, buffer, delta);
+	memcpy(new->data + size - delta, extra, delta);
 
 	return 1;
 }
--- device-mapper/lib/mm/pool-fast.c	2007/08/21 16:26:07	1.4
+++ device-mapper/lib/mm/pool-fast.c	2008/04/19 15:50:18	1.5
@@ -162,14 +162,17 @@
 	return 1;
 }
 
-int dm_pool_grow_object(struct dm_pool *p, const void *extra, size_t n)
+int dm_pool_grow_object(struct dm_pool *p, const void *extra, size_t delta)
 {
 	struct chunk *c = p->chunk, *nc;
 
-	if (c->end - (c->begin + p->object_len) < n) {
+	if (!delta)
+		delta = strlen(extra);
+
+	if (c->end - (c->begin + p->object_len) < delta) {
 		/* move into a new chunk */
-		if (p->object_len + n > (p->chunk_size / 2))
-			nc = _new_chunk(p, (p->object_len + n) * 2);
+		if (p->object_len + delta > (p->chunk_size / 2))
+			nc = _new_chunk(p, (p->object_len + delta) * 2);
 		else
 			nc = _new_chunk(p, p->chunk_size);
 
@@ -181,8 +184,8 @@
 		c = p->chunk;
 	}
 
-	memcpy(c->begin + p->object_len, extra, n);
-	p->object_len += n;
+	memcpy(c->begin + p->object_len, extra, delta);
+	p->object_len += delta;
 	return 1;
 }
 
