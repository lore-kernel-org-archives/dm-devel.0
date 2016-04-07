From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 18/18] multipath: add wwn keyword to
	weightedpath prio
Date: Thu,  7 Apr 2016 18:20:12 -0500
Message-ID: <1460071212-21018-19-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

multipath's weightedpath prioritizer now supports a "wwn" keyword,
instead of just the "hbtl" and "devname" keywords. If this is used the
regular expression for matching the device is of the form
"host_wwnn:host_wwpn:target_wwnn:target_wwpn". These identifiers can
either be looked up through sysfs, or using the following "multipathd
show paths format" wildcards "%N:%R:%n:%r"

For instance, you could do something like this
        prio weightedpath
        prio_args "wwn 0x200000e08b80aea0:.*:.*:.* 30
0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* 20
.*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.* 10"

This would map:
- all paths with the FC Host WWNN of 0x200000e08b80aea0 to a priority of
  30
- all paths with the FC Host WWNN of 0x200100e08ba0aea0 and the Host
  WWPN of 0x210100e08ba0aea0 to a priority of 20
- all paths with the iscsi target name of
  iqn.2009-10.com.redhat.msp.lab.ask-06 (which multipath has always
  treated as the same as the FC Target WWNN) to a priority of 10
- and all other paths to a priority of 0

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c                     |  8 +++----
 libmultipath/print.h                     |  4 ++++
 libmultipath/prioritizers/weightedpath.c | 37 ++++++++++++++++++++++++++++++++
 libmultipath/prioritizers/weightedpath.h |  1 +
 multipath/multipath.conf.5               |  7 +++++-
 5 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 13d076a..76bda93 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -489,19 +489,19 @@ out:
 	return ret;
 }
 
-static int
+int
 snprint_host_wwnn (char * buff, size_t len, struct path * pp)
 {
 	return snprint_host_attr(buff, len, pp, "node_name");
 }
 
-static int
+int
 snprint_host_wwpn (char * buff, size_t len, struct path * pp)
 {
 	return snprint_host_attr(buff, len, pp, "port_name");
 }
 
-static int
+int
 snprint_tgt_wwpn (char * buff, size_t len, struct path * pp)
 {
 	struct udev_device *rport_dev = NULL;
@@ -531,7 +531,7 @@ out:
 }
 
 
-static int
+int
 snprint_tgt_wwnn (char * buff, size_t len, struct path * pp)
 {
 	if (pp->tgt_node_name[0] == '\0')
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 9344271..8bd0bbc 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -51,6 +51,10 @@ int snprint_devices (char *, int, struct vectors *);
 int snprint_hwtable (char *, int, vector);
 int snprint_mptable (char *, int, vector);
 int snprint_overrides (char *, int, struct hwentry *);
+int snprint_host_wwnn (char *, size_t, struct path *);
+int snprint_host_wwpn (char *, size_t, struct path *);
+int snprint_tgt_wwnn (char *, size_t, struct path *);
+int snprint_tgt_wwpn (char *, size_t, struct path *);
 
 void print_multipath_topology (struct multipath * mpp, int verbosity);
 void print_path (struct path * pp, char * style);
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 13bc52f..ba8c555 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -32,6 +32,8 @@
 #include <memory.h>
 #include <debug.h>
 #include <regex.h>
+#include <structs_vec.h>
+#include <print.h>
 
 char *get_next_string(char **temp, char *split_char)
 {
@@ -42,6 +44,36 @@ char *get_next_string(char **temp, char *split_char)
 	return token;
 }
 
+#define CHECK_LEN \
+do { \
+	if ((p - str) >= (len - 1)) { \
+		condlog(0, "%s: %s - buffer size too small", pp->dev, pp->prio.name); \
+		return -1; \
+	} \
+} while(0)
+
+static int
+build_wwn_path(struct path *pp, char *str, int len)
+{
+	char *p = str;
+
+	p += snprint_host_wwnn(p, str + len - p, pp);
+	CHECK_LEN;
+	p += snprintf(p, str + len - p, ":");
+	CHECK_LEN;
+	p += snprint_host_wwpn(p, str + len - p, pp);
+	CHECK_LEN;
+	p += snprintf(p, str + len - p, ":");
+	CHECK_LEN;
+	p += snprint_tgt_wwnn(p, str + len - p, pp);
+	CHECK_LEN;
+	p += snprintf(p, str + len - p, ":");
+	CHECK_LEN;
+	p += snprint_tgt_wwpn(p, str + len - p, pp);
+	CHECK_LEN;
+	return 0;
+}
+
 /* main priority routine */
 int prio_path_weight(struct path *pp, char *prio_args)
 {
@@ -71,6 +103,11 @@ int prio_path_weight(struct path *pp, char *prio_args)
 			pp->sg_id.channel, pp->sg_id.scsi_id, pp->sg_id.lun);
 	} else if (!strcmp(regex, DEV_NAME)) {
 		strcpy(path, pp->dev);
+	} else if (!strcmp(regex, WWN)) {
+		if (build_wwn_path(pp, path, FILE_NAME_SIZE) != 0) {
+			FREE(arg);
+			return priority;
+		}
 	} else {
 		condlog(0, "%s: %s - Invalid arguments", pp->dev,
 			pp->prio.name);
diff --git a/libmultipath/prioritizers/weightedpath.h b/libmultipath/prioritizers/weightedpath.h
index 509f215..93d8c43 100644
--- a/libmultipath/prioritizers/weightedpath.h
+++ b/libmultipath/prioritizers/weightedpath.h
@@ -4,6 +4,7 @@
 #define PRIO_WEIGHTED_PATH "weightedpath"
 #define HBTL "hbtl"
 #define DEV_NAME "devname"
+#define WWN "wwn"
 #define DEFAULT_PRIORITY 0
 
 int prio_path_weight(struct path *pp, char *prio_args);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 7a4c452..0d4df0f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -227,11 +227,16 @@ prioritizers
 .TP 12
 .B weighted
 Needs a value of the form
-.I "<hbtl|devname> <regex1> <prio1> <regex2> <prio2> ..."
+.I "<hbtl|devname|wwn> <regex1> <prio1> <regex2> <prio2> ..."
 .I hbtl
 regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
 .I devname
 regex can be of device name format  Ex: sda , sd.e
+.I wwn
+regex can be of the form
+.I "host_wwnn:host_wwpn:target_wwnn:target_wwpn"
+these values can be looked up through sysfs or by running
+.I mulitpathd show paths format "%N:%R:%n:%r" Ex: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .TP
 .B alua
 If
-- 
1.8.3.1
