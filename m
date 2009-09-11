From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: Add preferred TPG prioritizer
Date: Fri, 11 Sep 2009 13:23:09 -0500
Message-ID: <20090911182308.GN15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Instead of using the Target port's Asymmetric Access State to determine
priority, some users what to use the preferred port bit.  This patch makes
a new prioritizer, based off the ALUA prioritizer, but using the preferred
port bit instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prio.h                   |    1 +
 libmultipath/prioritizers/Makefile    |   10 ++++++++++
 libmultipath/prioritizers/alua.c      |    7 +++++++
 libmultipath/prioritizers/alua_rtpg.c |    4 ++++
 libmultipath/prioritizers/alua_spc3.h |    6 ++++++
 5 files changed, 28 insertions(+)

Index: multipath-tools-090902/libmultipath/prio.h
===================================================================
--- multipath-tools-090902.orig/libmultipath/prio.h
+++ multipath-tools-090902/libmultipath/prio.h
@@ -16,6 +16,7 @@
  * Known prioritizers for use in hwtable.c
  */
 #define PRIO_ALUA "alua"
+#define PRIO_TPG_PREF "tpg_pref"
 #define PRIO_CONST "const"
 #define PRIO_EMC "emc"
 #define PRIO_HDS "hds"
Index: multipath-tools-090902/libmultipath/prioritizers/alua.c
===================================================================
--- multipath-tools-090902.orig/libmultipath/prioritizers/alua.c
+++ multipath-tools-090902/libmultipath/prioritizers/alua.c
@@ -28,6 +28,12 @@
 int
 get_alua_info(int fd)
 {
+#ifdef TPG_PREF
+	char * aas_string[] = {
+		[AAS_OPTIMIZED]		= "preferred",
+		[AAS_STANDBY]		= "non-preferred",
+	};
+#else
 	char *	aas_string[] = {
 		[AAS_OPTIMIZED]		= "active/optimized",
 		[AAS_NON_OPTIMIZED]	= "active/non-optimized",
@@ -35,6 +41,7 @@ get_alua_info(int fd)
 		[AAS_UNAVAILABLE]	= "unavailable",
 		[AAS_TRANSITIONING]	= "transitioning between states",
 	};
+#endif
 	int	rc;
 	int	tpg;
 
Index: multipath-tools-090902/libmultipath/prioritizers/alua_rtpg.c
===================================================================
--- multipath-tools-090902.orig/libmultipath/prioritizers/alua_rtpg.c
+++ multipath-tools-090902/libmultipath/prioritizers/alua_rtpg.c
@@ -293,7 +293,11 @@ get_asymmetric_access_state(int fd, unsi
 					"group.\n");
 			} else {
 				PRINT_DEBUG("pref=%i\n", dscr->b0);
+#ifdef TPG_PREF
+				rc = rtpg_tpg_dscr_get_pref(dscr);
+#else
 				rc = rtpg_tpg_dscr_get_aas(dscr);
+#endif
 			}
 		}
 	}
Index: multipath-tools-090902/libmultipath/prioritizers/alua_spc3.h
===================================================================
--- multipath-tools-090902.orig/libmultipath/prioritizers/alua_spc3.h
+++ multipath-tools-090902/libmultipath/prioritizers/alua_spc3.h
@@ -302,6 +302,12 @@ rtpg_tpg_dscr_get_aas(struct rtpg_tpg_ds
 	return (d->b0 & 0x0f);
 }
 
+static inline int
+rtpg_tpg_dscr_get_pref(struct rtpg_tpg_dscr *d)
+{
+	return ((d->b0 & 0x80)?AAS_OPTIMIZED:AAS_STANDBY);
+}
+
 struct rtpg_data {
 	unsigned char			length[4];		/* size-4 */
 	struct rtpg_tpg_dscr		data[0];
Index: multipath-tools-090902/libmultipath/prioritizers/Makefile
===================================================================
--- multipath-tools-090902.orig/libmultipath/prioritizers/Makefile
+++ multipath-tools-090902/libmultipath/prioritizers/Makefile
@@ -11,6 +11,7 @@ LIBS = \
 	libprioemc.so \
 	libpriordac.so \
 	libprioalua.so \
+	libpriotpg_pref.so \
 	libprionetapp.so \
 	libpriohds.so
 
@@ -21,9 +22,18 @@ all: $(LIBS)
 libprioalua.so: alua.o alua_rtpg.o
 	$(CC) $(SHARED_FLAGS) -o $@ $^
 
+libpriotpg_pref.so: pref.o pref_rtpg.o
+	$(CC) $(SHARED_FLAGS) -o $@ $^
+
 libprio%.so: %.o
 	$(CC) $(SHARED_FLAGS) -o $@ $^
 
+pref.o: alua.c
+	$(CC) $(CFLAGS) -DTPG_PREF -c -o $@ $<
+
+pref_rtpg.o: alua_rtpg.c
+	$(CC) $(CFLAGS) -DTPG_PREF -c -o $@ $<
+
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
 
