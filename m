From: heinzm@sourceware.org
Subject: dmraid include/dmraid/format.h lib/Makefile.in ...
Date: 18 Mar 2010 16:53:22 -0000
Message-ID: <20100318165322.23563.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-03-18 16:53:17

Modified files:
	include/dmraid : format.h 
	lib            : Makefile.in 
	lib/events     : libdmraid-events-isw.c 
	lib/format/ataraid: asr.c hpt37x.c hpt45x.c isw.c jm.c lsi.c 
	                    nv.c pdc.c sil.c via.c 
	lib/format/ddf : ddf1.c 
	lib/format/partition: dos.c 
	lib/metadata   : metadata.c 

Log message:
	Remove superfluous "struct dmraid_format" memeber "events" which is replaced by metadata_handler options

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/format.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/events/libdmraid-events-isw.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt37x.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/hpt45x.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/jm.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/nv.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/via.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/partition/dos.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.9&r2=1.10

--- dmraid/include/dmraid/format.h	2009/09/16 11:45:12	1.3
+++ dmraid/include/dmraid/format.h	2010/03/18 16:53:16	1.4
@@ -50,23 +50,9 @@
 };
 
 /*
- * List of event handler functions to call for the metadata format handler.
- *
- * Return 1 for event taken, RAID device write necessary.
- * Return 0 for error and/or write unnecessary.
- */
-struct event_handlers {
-	/* Handle IO error */
-	int (*io) (struct lib_context * lc, struct event_io * e_io);
-
-	/* Handle RAID device add/remove. */
-	int (*rd) (struct lib_context * lc, struct event_rd * e_rd);
-};
-
-/*
  * Hot-spare search types list: it can be searched locally/globally 
  */
-enum scope {
+enum hot_spare_scope {
 	t_scope_local = 0x01,
 	t_scope_global = 0x02
 };
@@ -151,15 +137,11 @@
 				 enum handler_commands command,
 				 struct handler_info * info, void *ptr);
 
-	/*
-	 * Event handlers (eg, I/O error).
-	 */
-	struct event_handlers *events;
-
 	/* 
 	 * Hot-spare disk search scope 
 	 */
-	enum scope scope;
+	enum hot_spare_scope scope;
+
 	/*
 	 * Display RAID disk metadata native.
 	 */
--- dmraid/lib/Makefile.in	2010/03/16 16:02:16	1.6
+++ dmraid/lib/Makefile.in	2010/03/18 16:53:16	1.7
@@ -16,6 +16,7 @@
 	device/scan.c \
 	device/scsi.c \
 	display/display.c \
+	events/libdmraid-events-isw.c \
 	format/format.c \
 	locking/locking.c \
 	log/log.c \
--- dmraid/lib/events/libdmraid-events-isw.c	2010/03/16 15:33:50	1.3
+++ dmraid/lib/events/libdmraid-events-isw.c	2010/03/18 16:53:17	1.4
@@ -1020,11 +1020,10 @@
 		break;
 
 	case REBUILD_END:
-		if (!_lib_main('F', dev_name)) {
+		if (!_lib_main('F', dev_name) ||
+		    !_lib_main('r', dev_name))
 			syslog(LOG_NOTICE, "Rebuild of RAID set %s complete",
 					dev_name);
-			_lib_main('r', dev_name); 
-		} 
 			
 		/* Turn all RAID set LEDs off anyway, since it's in-sync.*/
 		/* Used also for manual rebuild. */
--- dmraid/lib/format/ataraid/asr.c	2009/09/16 11:45:14	1.6
+++ dmraid/lib/format/ataraid/asr.c	2010/03/18 16:53:17	1.7
@@ -560,6 +560,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -583,6 +584,7 @@
 
 	return 1;		/* Indicate that this is indeed a failure. */
 }
+#endif
 
 /*
  * Helper routines for asr_group()
@@ -1042,11 +1044,6 @@
 			      NULL, handler);
 }
 
-static struct event_handlers asr_event_handlers = {
-	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
-};
-
 /* Dump a reserved block */
 static void
 dump_rb(struct lib_context *lc, struct asr_reservedblock *rb)
@@ -1146,7 +1143,6 @@
 	.write = asr_write,
 	.group = asr_group,
 	.check = asr_check,
-	.events = &asr_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = asr_log,
 #endif
--- dmraid/lib/format/ataraid/hpt37x.c	2008/06/20 21:52:17	1.3
+++ dmraid/lib/format/ataraid/hpt37x.c	2010/03/18 16:53:17	1.4
@@ -305,6 +305,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -318,11 +319,7 @@
 	hpt->magic = HPT37X_MAGIC_BAD;
 	return 1;
 }
-
-static struct event_handlers hpt37x_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /*
@@ -376,7 +373,6 @@
 	.write = hpt37x_write,
 	.group = hpt37x_group,
 	.check = hpt37x_check,
-	.events = &hpt37x_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = hpt37x_log,
 #endif
--- dmraid/lib/format/ataraid/hpt45x.c	2008/06/20 21:52:17	1.3
+++ dmraid/lib/format/ataraid/hpt45x.c	2010/03/18 16:53:17	1.4
@@ -254,6 +254,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -267,11 +268,7 @@
 	hpt->magic = HPT45X_MAGIC_BAD;
 	return 1;
 }
-
-static struct event_handlers hpt45x_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /*
@@ -313,7 +310,6 @@
 	.write = hpt45x_write,
 	.group = hpt45x_group,
 	.check = hpt45x_check,
-	.events = &hpt45x_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = hpt45x_log,
 #endif
--- dmraid/lib/format/ataraid/isw.c	2010/03/18 13:10:42	1.8
+++ dmraid/lib/format/ataraid/isw.c	2010/03/18 16:53:17	1.9
@@ -1389,8 +1389,8 @@
 			check_raid_set(lc, r, devices_per_domain, NULL,
 				       check_rd, NULL, handler);
 		else
-			check_raid_set(lc, r, devices, NULL, check_rd,
-				       NULL, handler);
+			check_raid_set(lc, r, devices, NULL,
+				       check_rd, NULL, handler);
 	}
 
 	return 1;
@@ -2133,33 +2133,6 @@
 		return T_GROUP(rs) ? _isw_check(lc, rs) : 0;
 }
 
-/*
- * IO error event handler.
- */
-static int
-event_io(struct lib_context *lc, struct event_io *e_io)
-{
-	struct raid_dev *rd = e_io->rd;
-	struct isw *isw = META(rd, isw);
-	struct isw_disk *disk;
-
-	if (!(disk = get_disk(lc, rd->di, isw)))
-		LOG_ERR(lc, 0, "%s: disk", handler);
-
-	/* Avoid write trashing. */
-	if (S_BROKEN(status(lc, rd)))
-		return 0;
-
-	disk->status &= ~USABLE_DISK;
-	disk->status |= FAILED_DISK;
-	return 1;
-}
-
-static struct event_handlers isw_event_handlers = {
-	.io = event_io,
-	.rd = NULL,	/* FIXME: no device add/remove event handler yet. */
-};
-
 static void
 _isw_log(struct lib_context *lc, struct isw *isw)
 {
@@ -2547,7 +2520,6 @@
 	.group = isw_group,
 	.check = isw_check,
 	.metadata_handler = isw_metadata_handler,
-	.events = &isw_event_handlers,
 	.scope = t_scope_global /* | t_scope_local */ ,
 #ifdef DMRAID_NATIVE_LOG
 	.log = isw_log,
--- dmraid/lib/format/ataraid/jm.c	2010/03/18 13:10:42	1.6
+++ dmraid/lib/format/ataraid/jm.c	2010/03/18 16:53:17	1.7
@@ -292,6 +292,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -305,11 +306,7 @@
 	jm->checksum = 1;	/* FIXME: how to flag a JMicron disk bad? */
 	return 1;
 }
-
-static struct event_handlers jm_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /*
@@ -353,7 +350,6 @@
 	.write = jm_write,
 	.group = jm_group,
 	.check = jm_check,
-	.events = &jm_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = jm_log,
 #endif
--- dmraid/lib/format/ataraid/lsi.c	2008/06/20 21:52:17	1.4
+++ dmraid/lib/format/ataraid/lsi.c	2010/03/18 16:53:17	1.5
@@ -263,6 +263,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -276,11 +277,7 @@
 	// FIXME: lsi->? = BAD;
 	return 1;
 }
-
-static struct event_handlers lsi_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /* Log native information about an LSI Logic RAID device. */
@@ -339,7 +336,6 @@
 	.write = lsi_write,
 	.group = lsi_group,
 	.check = lsi_check,
-	.events = &lsi_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = lsi_log,
 #endif
--- dmraid/lib/format/ataraid/nv.c	2008/06/20 21:52:17	1.4
+++ dmraid/lib/format/ataraid/nv.c	2010/03/18 16:53:17	1.5
@@ -313,6 +313,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -328,11 +329,7 @@
 
 	return 1;
 }
-
-static struct event_handlers nv_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /*
@@ -404,7 +401,6 @@
 	.write = nv_write,
 	.group = nv_group,
 	.check = nv_check,
-	.events = &nv_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = nv_log,
 #endif
--- dmraid/lib/format/ataraid/pdc.c	2009/12/14 14:33:13	1.8
+++ dmraid/lib/format/ataraid/pdc.c	2010/03/18 16:53:17	1.9
@@ -523,6 +523,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -536,11 +537,7 @@
 	PDC_SET_BROKEN(pdc);
 	return 1;
 }
-
-static struct event_handlers pdc_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /* Log native information about a Promise RAID device. */
@@ -619,7 +616,6 @@
 	.write = pdc_write,
 	.group = pdc_group,
 	.check = pdc_check,
-	.events = &pdc_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = pdc_log,
 #endif
--- dmraid/lib/format/ataraid/sil.c	2009/12/01 13:26:04	1.5
+++ dmraid/lib/format/ataraid/sil.c	2010/03/18 16:53:17	1.6
@@ -421,6 +421,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -435,11 +436,7 @@
 
 	return 1;
 }
-
-static struct event_handlers sil_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /*
@@ -509,7 +506,6 @@
 	.write = sil_write,
 	.group = sil_group,
 	.check = sil_check,
-	.events = &sil_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = sil_log,
 #endif
--- dmraid/lib/format/ataraid/via.c	2008/06/20 21:52:17	1.3
+++ dmraid/lib/format/ataraid/via.c	2010/03/18 16:53:17	1.4
@@ -318,6 +318,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -332,12 +333,7 @@
 
 	return 1;
 }
-
-static struct event_handlers via_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
-
+#endif
 
 #ifdef DMRAID_NATIVE_LOG
 /*
@@ -394,7 +390,6 @@
 	.write = via_write,
 	.group = via_group,
 	.check = via_check,
-	.events = &via_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = via_log,
 #endif
--- dmraid/lib/format/ddf/ddf1.c	2010/03/12 11:33:01	1.7
+++ dmraid/lib/format/ddf/ddf1.c	2010/03/18 16:53:17	1.8
@@ -626,6 +626,7 @@
 /*
  * IO error event handler.
  */
+#if 0
 static int
 event_io(struct lib_context *lc, struct event_io *e_io)
 {
@@ -634,6 +635,7 @@
 
 	LOG_ERR(lc, 0, "%s: PANIC - don't know about event_io!", handler);
 }
+#endif
 
 #if 0
 	/* FIXME: This should not use META() directly? */
@@ -897,11 +899,6 @@
 			      NULL, handler);
 }
 
-static struct event_handlers ddf1_event_handlers = {
-	.io = event_io,
-	.rd = NULL,		/* FIXME: no device add/remove event handler yet. */
-};
-
 #ifdef DMRAID_NATIVE_LOG
 /*
  * Log native information about the RAID device.
@@ -922,7 +919,6 @@
 	.write = ddf1_write,
 	.group = ddf1_group,
 	.check = ddf1_check,
-	.events = &ddf1_event_handlers,
 #ifdef DMRAID_NATIVE_LOG
 	.log = ddf1_log,
 #endif
--- dmraid/lib/format/partition/dos.c	2009/09/16 11:45:15	1.5
+++ dmraid/lib/format/partition/dos.c	2010/03/18 16:53:17	1.6
@@ -391,7 +391,6 @@
 	.write = NULL,		/* Not supported */
 	.group = dos_group,
 	.check = dos_check,
-	.events = NULL,		/* Not supported */
 #ifdef DMRAID_NATIVE_LOG
 	.log = NULL,		/* Not supported; use fdisk and friends */
 #endif
--- dmraid/lib/metadata/metadata.c	2010/01/12 12:15:59	1.9
+++ dmraid/lib/metadata/metadata.c	2010/03/18 16:53:17	1.10
@@ -921,7 +921,7 @@
 				   "dropping unwanted RAID set \"%s\"",
 				   rs->name);
 			/*
-			 * ddf1 carries a private pointer to it's contianing
+			 * ddf1 carries a private pointer to it's containing
 			 * set which is cleared as part of the check. So we
 			 * must call it's check method before freeing the
 			 * set. Whats more, it looks like ddf1 check can
