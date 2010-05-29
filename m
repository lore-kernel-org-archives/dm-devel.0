From: zkabelac@sourceware.org
Subject: dmraid lib/Makefile.in ./make.tmpl.in
Date: 29 May 2010 21:34:42 -0000
Message-ID: <20100529213442.29766.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-29 21:34:42

Modified files:
	lib            : Makefile.in 
	.              : make.tmpl.in 

Log message:
	Remove global %.so target
	Add target for plugin.so
	Add target for libdmraid.so
	Hardcoded major version for libdmraid.so -> libdmraid.so.1

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.9&r2=1.10

--- dmraid/lib/Makefile.in	2010/05/28 12:35:01	1.12
+++ dmraid/lib/Makefile.in	2010/05/29 21:34:41	1.13
@@ -73,10 +73,16 @@
 
 all: $(TARGETS)
 
+# FIXME  Use major version for -soname
+$(LIB_SHARED): $(OBJECTS) $(top_srcdir)/lib/.export.sym
+	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS) \
+		-shared -Wl,-soname,$(notdir $@).1 \
+		-Wl,--version-script,$(top_srcdir)/lib/.export.sym \
+		-ldevmapper-event
+
 $(LIB_EVENTS_SHARED): $(OBJECTS2)
-	$(CC) -o $@ $(INCLUDES) $(CFLAGS) $(LDFLAGS) $(OBJECTS2) \
-	  -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
-	  $(LIB_SHARED) -ldevmapper-event -lpthread
+	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS2) \
+		-shared  -Wl,-soname,$(notdir $@) -ldevmapper-event -lpthread
 
 .PHONY: $(addprefix install_,$(TARGETS)) $(addprefix remove_,$(TARGETS))
 
--- dmraid/make.tmpl.in	2010/05/28 12:31:39	1.9
+++ dmraid/make.tmpl.in	2010/05/29 21:34:41	1.10
@@ -130,8 +130,8 @@
 
 $(TARGETS): $(OBJECTS)
 
-%.o: %.c
-	$(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@
+%.o: %.c $(top_builddir)/include/config.h
+	$(CC) -o $@ -c $(INCLUDES) $(CFLAGS) -include $(top_builddir)/include/config.h $<
 
 %.d: %.c
 	$(MKDIR_P) $(dir $@); \
@@ -142,12 +142,6 @@
 	sed -i "s/\(.*\)\.o[ :]*/$$FILE.o $$FILE.d $$FILE.pot: $$DEPS /g" $@; \
 	[ -s $@ ] || $(RM) $@
 
-%.so: $(OBJECTS) $(top_srcdir)/lib/.export.sym
-
-%.so: $(OBJECTS)
-	$(CC) -shared -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
-	-Wl,--version-script,$(top_srcdir)/lib/.export.sym $(OBJECTS) -o $@ -ldevmapper-event
-
 $(LIB_STATIC): $(OBJECTS)
 	$(RM) $@
 	$(AR) r $@ $(OBJECTS)
