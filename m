From: "Balasubramanian, Vijayakumar (STSD)" <vijayakumar@hp.com>
Subject: [patch] multipath-tools weighted path priority routine
Date: Thu, 13 Nov 2008 17:53:03 +0000
Message-ID: <2118D41AB77C214BBF7D2330CD977BCF1BB3958036@GVW1162EXB.americas.hpqcorp.net>
References: <2118D41AB77C214BBF7D2330CD977BCF1BB395790D@GVW1162EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_2118D41AB77C214BBF7D2330CD977BCF1BB3958036GVW1162EXBame_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2118D41AB77C214BBF7D2330CD977BCF1BB395790D@GVW1162EXB.americas.hpqcorp.net>
Content-Language: en-US
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

--_002_2118D41AB77C214BBF7D2330CD977BCF1BB3958036GVW1162EXBame_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
'Weighted path' is a new path prioritizer for device mapper multipath, wher=
e specific paths and the corresponding priority values can be provided as a=
rguments.
This prioritizer assigns the priority value provided in the configuration f=
ile based on the comparison made between the specified paths and the path i=
nstance for which this is called. Paths can be specified as a regular expre=
ssion of devname of the path or as hbtl information of the path.

Syntax:
weightedpath  <hbtl|devname> <regex1> <prio1> <regex2> <prio2> ...

Examples:
prio  "weightedpath hbtl 1:.:.:. 2 4:.:.:. 4"   #All paths through SCSI 'H'=
 as '1' will take prio 2 and all paths with SCSI 'H' as 4 will take prio as=
 4.
prio  "weightedpath devname sda$ 10 sde$ 20"    #Path sda takes prio 10 and=
 path sde takes prio 20. can be provided in multipath section.


This prioritizer allows user to set static load balancing for devices. Usef=
ul when user has prior knowledge of path performance difference or unavaila=
bility of certain paths.


The below patch
Allows 'prio' parameter to be set in "multipath" section,
Allows 'prio' priority routine to take arguments in multipath.conf file,
Adds 'weightedpath' priority routine.

Can we have this patch included in the source tree?

Thanks,
Vijay


---------------------------------------------------------------------------=
--------

Patch to implement weighted path priority routine in multipath-tools.

Signed-off-by:
                Veena T S <veena-s.t@hp.com>
                Sakshi Chaitanya Veni <sakshi-chaitanya.veni@hp.com>
                Vijayakumar Balasubramanian <vijayakumar@hp.com>

diff -pNur multipath-tools-0.4.8.org/libmultipath/config.c multipath-tools-=
0.4.8/libmultipath/config.c
--- multipath-tools-0.4.8.org/libmultipath/config.c     2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/config.c 2008-11-12 10:26:55.0000000=
00 +0530
@@ -201,6 +201,12 @@ free_mpe (struct mpentry * mpe)
        if (mpe->alias)
                FREE(mpe->alias);

+       if (mpe->prio_name)
+               FREE(mpe->prio_name);
+
+       if (mpe->prio_arg)
+               FREE(mpe->prio_arg);
+
        FREE(mpe);
 }

@@ -285,6 +291,7 @@ merge_hwe (struct hwentry * hwe1, struct
        merge_str(selector);
        merge_str(checker_name);
        merge_str(prio_name);
+       merge_str(prio_arg);
        merge_str(bl_product);
        merge_num(pgpolicy);
        merge_num(pgfailback);
@@ -333,6 +340,9 @@ store_hwe (vector hwtable, struct hwentr
        if (dhwe->prio_name && !(hwe->prio_name =3D set_param_str(dhwe->pri=
o_name)))
                goto out;

+       if (dhwe->prio_arg && !(hwe->prio_arg =3D set_param_str(dhwe->prio_=
arg)))
+               goto out;
+
        hwe->pgpolicy =3D dhwe->pgpolicy;
        hwe->pgfailback =3D dhwe->pgfailback;
        hwe->rr_weight =3D dhwe->rr_weight;
@@ -547,8 +557,10 @@ load_config (char * file)
            !conf->hwhandler || !conf->bindings_file)
                goto out;

-       if (!conf->prio_name)
+       if (!conf->prio_name) {
                conf->prio_name =3D set_default(DEFAULT_PRIO);
+               conf->prio_arg =3D NULL;
+       }

        if (!conf->checker_name)
                conf->checker_name =3D set_default(DEFAULT_CHECKER);
diff -pNur multipath-tools-0.4.8.org/libmultipath/config.h multipath-tools-=
0.4.8/libmultipath/config.h
--- multipath-tools-0.4.8.org/libmultipath/config.h     2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/config.h 2008-11-12 10:23:28.0000000=
00 +0530
@@ -21,6 +21,7 @@ struct hwentry {
        char * selector;
        char * checker_name;
        char * prio_name;
+       char * prio_arg;

        int pgpolicy;
        int pgfailback;
@@ -37,6 +38,8 @@ struct mpentry {
        char * getuid;
        char * selector;

+       char * prio_name;
+       char * prio_arg;
        int pgpolicy;
        int pgfailback;
        int rr_weight;
@@ -75,6 +78,7 @@ struct config {
        char * hwhandler;
        char * bindings_file;
        char * prio_name;
+       char * prio_arg;
        char * checker_name;

        vector keywords;
diff -pNur multipath-tools-0.4.8.org/libmultipath/dict.c multipath-tools-0.=
4.8/libmultipath/dict.c
--- multipath-tools-0.4.8.org/libmultipath/dict.c       2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/dict.c   2008-11-13 20:03:10.0000000=
00 +0530
@@ -4,6 +4,7 @@
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
+#include <string.h>
 #include "checkers.h"
 #include "vector.h"
 #include "hwtable.h"
@@ -95,11 +96,29 @@ def_getuid_callout_handler(vector strvec
 static int
 def_prio_handler(vector strvec)
 {
-       conf->prio_name =3D set_value(strvec);
+       char *buff, *result, *temp;
+       char split_char[] =3D " \t";

-       if (!conf->prio_name)
+       buff =3D set_value(strvec);
+       if (!buff)
                return 1;
+       temp =3D buff;
+
+       while (temp) {
+               result =3D strsep(&temp, split_char);
+               if (strcmp(result, "")) {
+                       if (prio_lookup(result)) {
+                               conf->prio_name =3D STRDUP(result);
+                               if (temp)
+                                       conf->prio_arg =3D STRDUP(temp);
+                               else
+                                       conf->prio_arg =3D NULL;
+                               break;
+                       }
+               }
+       }

+       FREE(buff);
        return 0;
 }

@@ -602,15 +621,32 @@ static int
 hw_prio_handler(vector strvec)
 {
        struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hwtable);
+       char *buff, *result, *temp;
+       char split_char[] =3D " \t";

        if (!hwe)
                return 1;

-       hwe->prio_name =3D set_value(strvec);
-
-       if (!hwe->prio_name)
+       buff =3D set_value(strvec);
+       if (!buff)
                return 1;
+       temp =3D buff;

+       while (temp) {
+               result =3D strsep(&temp, split_char);
+               if (strcmp(result, "")) {
+                       if (prio_lookup(result)) {
+                               hwe->prio_name =3D STRDUP(result);
+                               if (temp)
+                                       hwe->prio_arg =3D STRDUP(temp);
+                               else
+                                       hwe->prio_arg =3D NULL;
+                               break;
+                       }
+               }
+       }
+
+       FREE(buff);
        return 0;
 }

@@ -956,6 +992,41 @@ mp_pg_timeout_handler(vector strvec)
        return 0;
 }

+static int
+mp_prio_handler (vector strvec)
+{
+       struct mpentry *mpe =3D VECTOR_LAST_SLOT(conf->mptable);
+       char *buff, *result, *temp;
+       char split_char[] =3D " \t";
+
+       if (!mpe)
+               return 1;
+
+       buff =3D set_value(strvec);
+
+       if (!buff)
+               return 1;
+
+       temp =3D buff;
+
+       while (temp) {
+               result =3D strsep(&temp, split_char);
+               if (strcmp(result, "")) {
+                       if (prio_lookup(result)) {
+                               mpe->prio_name =3D STRDUP(result);
+                               if (temp)
+                                       mpe->prio_arg =3D STRDUP(temp);
+                               else
+                                       mpe->prio_arg =3D NULL;
+                               break;
+                       }
+               }
+       }
+
+       FREE(buff);
+       return 0;
+}
+
 /*
  * config file keywords printing
  */
@@ -1091,6 +1162,17 @@ snprint_mp_pg_timeout (char * buff, int
 }

 static int
+snprint_mp_prio(char * buff, int len, void * data)
+{
+       struct mpentry * mpe =3D (struct mpentry *)data;
+
+       if (!mpe->prio_name)
+               return 0;
+
+       return snprintf(buff, len, "%s", mpe->prio_name);
+}
+
+static int
 snprint_hw_vendor (char * buff, int len, void * data)
 {
        struct hwentry * hwe =3D (struct hwentry *)data;
@@ -1652,6 +1734,7 @@ init_keywords(void)
        install_keyword("alias", &alias_handler, &snprint_mp_alias);
        install_keyword("path_grouping_policy", &mp_pgpolicy_handler, &snpr=
int_mp_path_grouping_policy);
        install_keyword("path_selector", &mp_selector_handler, &snprint_mp_=
selector);
+       install_keyword("prio", &mp_prio_handler, &snprint_mp_prio);
        install_keyword("failback", &mp_failback_handler, &snprint_mp_failb=
ack);
        install_keyword("rr_weight", &mp_weight_handler, &snprint_mp_rr_wei=
ght);
        install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprin=
t_mp_no_path_retry);
diff -pNur multipath-tools-0.4.8.org/libmultipath/discovery.c multipath-too=
ls-0.4.8/libmultipath/discovery.c
--- multipath-tools-0.4.8.org/libmultipath/discovery.c  2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/discovery.c      2008-11-13 19:43:55=
.000000000 +0530
@@ -759,8 +759,11 @@ pathinfo (struct path *pp, vector hwtabl
          * been successfully obtained before.
          */
        if (mask & DI_PRIO &&
-           (pp->state !=3D PATH_DOWN || pp->priority =3D=3D PRIO_UNDEF))
+           (pp->state !=3D PATH_DOWN || pp->priority =3D=3D PRIO_UNDEF)) {
+               if (!strlen(pp->wwid))
+                       get_uid(pp);
                get_prio(pp);
+       }

        if (mask & DI_WWID && !strlen(pp->wwid))
                get_uid(pp);
diff -pNur multipath-tools-0.4.8.org/libmultipath/prio.h multipath-tools-0.=
4.8/libmultipath/prio.h
--- multipath-tools-0.4.8.org/libmultipath/prio.h       2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/prio.h   2008-11-13 22:41:11.0000000=
00 +0530
@@ -24,6 +24,7 @@
 #define PRIO_ONTAP "ontap"
 #define PRIO_RANDOM "random"
 #define PRIO_RDAC "rdac"
+#define PRIO_WEIGHTED_PATH "weightedpath"

 /*
  * Value used to mark the fact prio was not defined
diff -pNur multipath-tools-0.4.8.org/libmultipath/prioritizers/Makefile mul=
tipath-tools-0.4.8/libmultipath/prioritizers/Makefile
--- multipath-tools-0.4.8.org/libmultipath/prioritizers/Makefile        200=
8-11-11 18:11:56.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/prioritizers/Makefile    2008-11-11 =
18:11:07.000000000 +0530
@@ -12,7 +12,8 @@ LIBS =3D \
        libpriordac.so \
        libprioalua.so \
        libprioontap.so \
-       libpriohds.so
+       libpriohds.so \
+       libprioweightedpath.so

 CFLAGS +=3D -I..

diff -pNur multipath-tools-0.4.8.org/libmultipath/prioritizers/weightedpath=
.c multipath-tools-0.4.8/libmultipath/prioritizers/weightedpath.c
--- multipath-tools-0.4.8.org/libmultipath/prioritizers/weightedpath.c  197=
0-01-01 05:30:00.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/prioritizers/weightedpath.c      200=
8-11-13 20:04:47.000000000 +0530
@@ -0,0 +1,99 @@
+/*
+ *
+ *  (C)  Copyright 2008 Hewlett-Packard Development Company, L.P
+ *
+ *  This file is released under the GPL
+ */
+
+/*
+ * Prioritizer for device mapper multipath, where specific paths and the
+ * corresponding priority values are provided as arguments.
+ *
+ * This prioritizer assigns the priority value provided in the configurati=
on
+ * file based on the comparison made between the specified paths and the p=
ath
+ * instance for which this is called.
+ * Paths can be specified as a regular expression of devname of the path o=
r
+ * as hbtl information of the path.
+ *
+ * Examples:
+ *     prio            "weightedpath hbtl 1:.:.:. 2 4:.:.:. 4"
+ *     prio            "weightedpath devname sda 10 sde 20"
+ *
+ * Returns zero as the default priority.
+ */
+
+#include <stdio.h>
+#include <string.h>
+
+#include <prio.h>
+#include "weightedpath.h"
+#include <config.h>
+#include <structs.h>
+#include <memory.h>
+#include <debug.h>
+#include <regex.h>
+
+char *get_next_string(char **temp, char *split_char)
+{
+       char *token =3D NULL;
+       token =3D strsep(temp, split_char);
+       while (token !=3D NULL && !strcmp(token, ""))
+               token =3D strsep(temp, split_char);
+       return token;
+}
+
+/* main priority routine */
+int prio_path_weight(struct path *pp)
+{
+       char path[FILE_NAME_SIZE];
+       char *arg;
+       char *temp, *regex, *prio;
+       char split_char[] =3D " \t";
+       int priority =3D DEFAULT_PRIORITY, path_found =3D 0;
+       regex_t pathe;
+
+       /* Return default priority if there is no argument */
+       if (!pp->prio_arg)
+               return priority;
+
+       arg =3D temp =3D STRDUP(pp->prio_arg);
+
+       regex =3D get_next_string(&temp, split_char);
+
+       if (!strcmp(regex, HBTL)) {
+               sprintf(path, "%d:%d:%d:%d", pp->sg_id.host_no,
+                       pp->sg_id.channel, pp->sg_id.scsi_id, pp->sg_id.lun=
);
+       } else if (!strcmp(regex, DEV_NAME)) {
+               strcpy(path, pp->dev);
+       } else {
+               condlog(0, "%s: %s - Invalid arguments", pp->dev,
+                       pp->prio->name);
+               return priority;
+       }
+
+       while (!path_found) {
+               if (!temp)
+                       break;
+               if (!(regex =3D get_next_string(&temp, split_char)))
+                       break;
+               if (!(prio =3D get_next_string(&temp, split_char)))
+                       break;
+
+               if (!regcomp(&pathe, regex, REG_EXTENDED|REG_NOSUB)) {
+                       if (!regexec(&pathe, path, 0, NULL, 0)) {
+                               path_found =3D 1;
+                               priority =3D atoi(prio);
+                       }
+                       regfree(&pathe);
+               }
+       }
+
+       FREE(arg);
+       return priority;
+}
+
+int getprio(struct path *pp)
+{
+       return prio_path_weight(pp);
+}
+
diff -pNur multipath-tools-0.4.8.org/libmultipath/prioritizers/weightedpath=
.h multipath-tools-0.4.8/libmultipath/prioritizers/weightedpath.h
--- multipath-tools-0.4.8.org/libmultipath/prioritizers/weightedpath.h  197=
0-01-01 05:30:00.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/prioritizers/weightedpath.h      200=
8-11-13 19:56:10.000000000 +0530
@@ -0,0 +1,11 @@
+#ifndef _WEIGHTED_PATH_H
+#define _WEIGHTED_PATH_H
+
+#define PRIO_WEIGHTED_PATH "weightedpath"
+#define HBTL "hbtl"
+#define DEV_NAME "devname"
+#define DEFAULT_PRIORITY 0
+
+int prio_path_weight(struct path *pp);
+
+#endif
diff -pNur multipath-tools-0.4.8.org/libmultipath/propsel.c multipath-tools=
-0.4.8/libmultipath/propsel.c
--- multipath-tools-0.4.8.org/libmultipath/propsel.c    2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/propsel.c        2008-11-13 19:58:58=
.000000000 +0530
@@ -258,14 +258,28 @@ select_getuid (struct path * pp)
 extern int
 select_prio (struct path * pp)
 {
+       struct mpentry * mpe;
+
+       if ((mpe =3D find_mpe(pp->wwid))) {
+               if (mpe->prio_name) {
+                       pp->prio =3D prio_lookup(mpe->prio_name);
+                       pp->prio_arg =3D mpe->prio_arg;
+                       condlog(3, "%s: prio =3D %s (LUN setting)",
+                               pp->dev, pp->prio->name);
+                       return 0;
+               }
+       }
+
        if (pp->hwe && pp->hwe->prio_name) {
                pp->prio =3D prio_lookup(pp->hwe->prio_name);
+               pp->prio_arg =3D pp->hwe->prio_arg;
                condlog(3, "%s: prio =3D %s (controller setting)",
                        pp->dev, pp->hwe->prio_name);
                return 0;
        }
        if (conf->prio_name) {
                pp->prio =3D prio_lookup(conf->prio_name);
+               pp->prio_arg =3D conf->prio_arg;
                condlog(3, "%s: prio =3D %s (config file default)",
                        pp->dev, conf->prio_name);
                return 0;
diff -pNur multipath-tools-0.4.8.org/libmultipath/structs.h multipath-tools=
-0.4.8/libmultipath/structs.h
--- multipath-tools-0.4.8.org/libmultipath/structs.h    2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/libmultipath/structs.h        2008-11-11 18:11:07=
.000000000 +0530
@@ -121,6 +121,7 @@ struct path {
        int pgindex;
        char * getuid;
        struct prio * prio;
+       char * prio_arg;
        struct checker checker;
        struct multipath * mpp;
        int fd;
diff -pNur multipath-tools-0.4.8.org/multipath/multipath.conf.5 multipath-t=
ools-0.4.8/multipath/multipath.conf.5
--- multipath-tools-0.4.8.org/multipath/multipath.conf.5        2008-11-11 =
18:11:56.000000000 +0530
+++ multipath-tools-0.4.8/multipath/multipath.conf.5    2008-11-13 22:36:05=
.000000000 +0530
@@ -146,6 +146,24 @@ Generate the path priority for Hitachi H
 Default value is \fBnone\fR.
 .RE
 .TP
+.B prio
+The default program and args to path priority routine. The specified
+routine should return a numeric value specifying the relative priority
+of this path. Higher number have a higher priority.
+.RS
+.TP 12
+.B alua
+Generate the path priority based on ALUA status of the path.
+.TP 12
+.B weightedpath <hbtl|devname> <regex1> <prio1> <regex2> <prio2> ...
+.I hbtl
+regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
+.I devname
+regex can be of device name format  Ex: sda , sd.e
+Generate the path priority based on the regular expression and the
+priority provided as argument.
+.RE
+.TP
 .B features
 Specify any device-mapper features to be used. Syntax is
 .I num list
@@ -322,6 +340,8 @@ section:
 .TP
 .B path_selector
 .TP
+.B prio
+.TP
 .B failback
 .TP
 .B no_path_retry
@@ -375,6 +395,8 @@ section:
 .TP
 .B path_checker
 .TP
+.B prio
+.TP
 .B features
 .TP
 .B prio_callout
diff -pNur multipath-tools-0.4.8.org/multipath.conf.annotated multipath-too=
ls-0.4.8/multipath.conf.annotated
--- multipath-tools-0.4.8.org/multipath.conf.annotated  2008-11-11 18:11:56=
.000000000 +0530
+++ multipath-tools-0.4.8/multipath.conf.annotated      2008-11-12 18:29:01=
.000000000 +0530
@@ -261,6 +261,18 @@
 #              # default : 1000
 #              #
 #              rr_min_io       100
+#
+#              #
+#              #name     : prio
+#              #scope    : multipath
+#              #desc     : the function to call to obtain a path weight.
+#              #           Weights are summed for each path group to
+#              #           determine the next PG to use case of failure.
+#              #default : no callout, all paths equals
+#              # Ex:
+#              # prio  alua
+#              # prio  "weightedpath devname sda 50 sde 10 sdc 50 sdf 10"
+#              prio          "weightedpath hbtl 1:.:.:. 2 4:.:.:. 4"
 #      }
 #      multipath {
 #              wwid    1DEC_____321816758474

--_002_2118D41AB77C214BBF7D2330CD977BCF1BB3958036GVW1162EXBame_
Content-Type: application/octet-stream;
	name="multipath-tools-add-weightedpath.patch"
Content-Description: multipath-tools-add-weightedpath.patch
Content-Disposition: attachment;
	filename="multipath-tools-add-weightedpath.patch"; size=14467;
	creation-date="Thu, 13 Nov 2008 16:21:54 GMT";
	modification-date="Thu, 13 Nov 2008 17:18:32 GMT"
Content-Transfer-Encoding: base64

UGF0Y2ggdG8gaW1wbGVtZW50IHdlaWdodGVkIHBhdGggcHJpb3JpdHkgcm91dGluZSBpbiBtdWx0
aXBhdGgtdG9vbHMuCgpTaWduZWQtb2ZmLWJ5OgogICAgICAgICAgICAgICAgVmVlbmEgVCBTIDx2
ZWVuYS1zLnRAaHAuY29tPgogICAgICAgICAgICAgICAgU2Frc2hpIENoYWl0YW55YSBWZW5pIDxz
YWtzaGktY2hhaXRhbnlhLnZlbmlAaHAuY29tPgogICAgICAgICAgICAgICAgVmlqYXlha3VtYXIg
QmFsYXN1YnJhbWFuaWFuIDx2aWpheWFrdW1hckBocC5jb20+CgpkaWZmIC1wTnVyIG11bHRpcGF0
aC10b29scy0wLjQuOC5vcmcvbGlibXVsdGlwYXRoL2NvbmZpZy5jIG11bHRpcGF0aC10b29scy0w
LjQuOC9saWJtdWx0aXBhdGgvY29uZmlnLmMKLS0tIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcv
bGlibXVsdGlwYXRoL2NvbmZpZy5jCTIwMDgtMTEtMTEgMTg6MTE6NTYuMDAwMDAwMDAwICswNTMw
CisrKyBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbGlibXVsdGlwYXRoL2NvbmZpZy5jCTIwMDgtMTEt
MTIgMTA6MjY6NTUuMDAwMDAwMDAwICswNTMwCkBAIC0yMDEsNiArMjAxLDEyIEBAIGZyZWVfbXBl
IChzdHJ1Y3QgbXBlbnRyeSAqIG1wZSkKIAlpZiAobXBlLT5hbGlhcykKIAkJRlJFRShtcGUtPmFs
aWFzKTsKIAorCWlmIChtcGUtPnByaW9fbmFtZSkKKwkJRlJFRShtcGUtPnByaW9fbmFtZSk7CisK
KwlpZiAobXBlLT5wcmlvX2FyZykKKwkJRlJFRShtcGUtPnByaW9fYXJnKTsKKwogCUZSRUUobXBl
KTsKIH0KIApAQCAtMjg1LDYgKzI5MSw3IEBAIG1lcmdlX2h3ZSAoc3RydWN0IGh3ZW50cnkgKiBo
d2UxLCBzdHJ1Y3QKIAltZXJnZV9zdHIoc2VsZWN0b3IpOwogCW1lcmdlX3N0cihjaGVja2VyX25h
bWUpOwogCW1lcmdlX3N0cihwcmlvX25hbWUpOworCW1lcmdlX3N0cihwcmlvX2FyZyk7CiAJbWVy
Z2Vfc3RyKGJsX3Byb2R1Y3QpOwogCW1lcmdlX251bShwZ3BvbGljeSk7CiAJbWVyZ2VfbnVtKHBn
ZmFpbGJhY2spOwpAQCAtMzMzLDYgKzM0MCw5IEBAIHN0b3JlX2h3ZSAodmVjdG9yIGh3dGFibGUs
IHN0cnVjdCBod2VudHIKIAlpZiAoZGh3ZS0+cHJpb19uYW1lICYmICEoaHdlLT5wcmlvX25hbWUg
PSBzZXRfcGFyYW1fc3RyKGRod2UtPnByaW9fbmFtZSkpKQogCQlnb3RvIG91dDsKIAorCWlmIChk
aHdlLT5wcmlvX2FyZyAmJiAhKGh3ZS0+cHJpb19hcmcgPSBzZXRfcGFyYW1fc3RyKGRod2UtPnBy
aW9fYXJnKSkpCisJCWdvdG8gb3V0OworCiAJaHdlLT5wZ3BvbGljeSA9IGRod2UtPnBncG9saWN5
OwogCWh3ZS0+cGdmYWlsYmFjayA9IGRod2UtPnBnZmFpbGJhY2s7CiAJaHdlLT5ycl93ZWlnaHQg
PSBkaHdlLT5ycl93ZWlnaHQ7CkBAIC01NDcsOCArNTU3LDEwIEBAIGxvYWRfY29uZmlnIChjaGFy
ICogZmlsZSkKIAkgICAgIWNvbmYtPmh3aGFuZGxlciB8fCAhY29uZi0+YmluZGluZ3NfZmlsZSkK
IAkJZ290byBvdXQ7CiAKLQlpZiAoIWNvbmYtPnByaW9fbmFtZSkKKwlpZiAoIWNvbmYtPnByaW9f
bmFtZSkgewogCQljb25mLT5wcmlvX25hbWUgPSBzZXRfZGVmYXVsdChERUZBVUxUX1BSSU8pOwor
CQljb25mLT5wcmlvX2FyZyA9IE5VTEw7CisJfQogCiAJaWYgKCFjb25mLT5jaGVja2VyX25hbWUp
CiAJCWNvbmYtPmNoZWNrZXJfbmFtZSA9IHNldF9kZWZhdWx0KERFRkFVTFRfQ0hFQ0tFUik7CmRp
ZmYgLXBOdXIgbXVsdGlwYXRoLXRvb2xzLTAuNC44Lm9yZy9saWJtdWx0aXBhdGgvY29uZmlnLmgg
bXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0aC9jb25maWcuaAotLS0gbXVsdGlwYXRo
LXRvb2xzLTAuNC44Lm9yZy9saWJtdWx0aXBhdGgvY29uZmlnLmgJMjAwOC0xMS0xMSAxODoxMTo1
Ni4wMDAwMDAwMDAgKzA1MzAKKysrIG11bHRpcGF0aC10b29scy0wLjQuOC9saWJtdWx0aXBhdGgv
Y29uZmlnLmgJMjAwOC0xMS0xMiAxMDoyMzoyOC4wMDAwMDAwMDAgKzA1MzAKQEAgLTIxLDYgKzIx
LDcgQEAgc3RydWN0IGh3ZW50cnkgewogCWNoYXIgKiBzZWxlY3RvcjsKIAljaGFyICogY2hlY2tl
cl9uYW1lOwogCWNoYXIgKiBwcmlvX25hbWU7CisJY2hhciAqIHByaW9fYXJnOwogCiAJaW50IHBn
cG9saWN5OwogCWludCBwZ2ZhaWxiYWNrOwpAQCAtMzcsNiArMzgsOCBAQCBzdHJ1Y3QgbXBlbnRy
eSB7CiAJY2hhciAqIGdldHVpZDsKIAljaGFyICogc2VsZWN0b3I7CiAKKwljaGFyICogcHJpb19u
YW1lOworCWNoYXIgKiBwcmlvX2FyZzsKIAlpbnQgcGdwb2xpY3k7CiAJaW50IHBnZmFpbGJhY2s7
CiAJaW50IHJyX3dlaWdodDsKQEAgLTc1LDYgKzc4LDcgQEAgc3RydWN0IGNvbmZpZyB7CiAJY2hh
ciAqIGh3aGFuZGxlcjsKIAljaGFyICogYmluZGluZ3NfZmlsZTsKIAljaGFyICogcHJpb19uYW1l
OworCWNoYXIgKiBwcmlvX2FyZzsKIAljaGFyICogY2hlY2tlcl9uYW1lOwogCiAJdmVjdG9yIGtl
eXdvcmRzOwpkaWZmIC1wTnVyIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcvbGlibXVsdGlwYXRo
L2RpY3QuYyBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbGlibXVsdGlwYXRoL2RpY3QuYwotLS0gbXVs
dGlwYXRoLXRvb2xzLTAuNC44Lm9yZy9saWJtdWx0aXBhdGgvZGljdC5jCTIwMDgtMTEtMTEgMTg6
MTE6NTYuMDAwMDAwMDAwICswNTMwCisrKyBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbGlibXVsdGlw
YXRoL2RpY3QuYwkyMDA4LTExLTEzIDIwOjAzOjEwLjAwMDAwMDAwMCArMDUzMApAQCAtNCw2ICs0
LDcgQEAKICAqIENvcHlyaWdodCAoYykgMjAwNSBCZW5qYW1pbiBNYXJ6aW5za2ksIFJlZGhhdAog
ICogQ29weXJpZ2h0IChjKSAyMDA1IEtpeW9zaGkgVWVkYSwgTkVDCiAgKi8KKyNpbmNsdWRlIDxz
dHJpbmcuaD4KICNpbmNsdWRlICJjaGVja2Vycy5oIgogI2luY2x1ZGUgInZlY3Rvci5oIgogI2lu
Y2x1ZGUgImh3dGFibGUuaCIKQEAgLTk1LDExICs5NiwyOSBAQCBkZWZfZ2V0dWlkX2NhbGxvdXRf
aGFuZGxlcih2ZWN0b3Igc3RydmVjCiBzdGF0aWMgaW50CiBkZWZfcHJpb19oYW5kbGVyKHZlY3Rv
ciBzdHJ2ZWMpCiB7Ci0JY29uZi0+cHJpb19uYW1lID0gc2V0X3ZhbHVlKHN0cnZlYyk7CisJY2hh
ciAqYnVmZiwgKnJlc3VsdCwgKnRlbXA7CisJY2hhciBzcGxpdF9jaGFyW10gPSAiIFx0IjsKIAot
CWlmICghY29uZi0+cHJpb19uYW1lKQorCWJ1ZmYgPSBzZXRfdmFsdWUoc3RydmVjKTsKKwlpZiAo
IWJ1ZmYpCiAJCXJldHVybiAxOworCXRlbXAgPSBidWZmOworCisJd2hpbGUgKHRlbXApIHsKKwkJ
cmVzdWx0ID0gc3Ryc2VwKCZ0ZW1wLCBzcGxpdF9jaGFyKTsKKwkJaWYgKHN0cmNtcChyZXN1bHQs
ICIiKSkgeworCQkJaWYgKHByaW9fbG9va3VwKHJlc3VsdCkpIHsKKwkJCQljb25mLT5wcmlvX25h
bWUgPSBTVFJEVVAocmVzdWx0KTsKKwkJCQlpZiAodGVtcCkKKwkJCQkJY29uZi0+cHJpb19hcmcg
PSBTVFJEVVAodGVtcCk7CisJCQkJZWxzZQorCQkJCQljb25mLT5wcmlvX2FyZyA9IE5VTEw7CisJ
CQkJYnJlYWs7CisJCQl9CisJCX0KKwl9CiAKKwlGUkVFKGJ1ZmYpOwogCXJldHVybiAwOwogfQog
CkBAIC02MDIsMTUgKzYyMSwzMiBAQCBzdGF0aWMgaW50CiBod19wcmlvX2hhbmRsZXIodmVjdG9y
IHN0cnZlYykKIHsKIAlzdHJ1Y3QgaHdlbnRyeSAqIGh3ZSA9IFZFQ1RPUl9MQVNUX1NMT1QoY29u
Zi0+aHd0YWJsZSk7CisJY2hhciAqYnVmZiwgKnJlc3VsdCwgKnRlbXA7CisJY2hhciBzcGxpdF9j
aGFyW10gPSAiIFx0IjsKIAogCWlmICghaHdlKQogCQlyZXR1cm4gMTsKIAotCWh3ZS0+cHJpb19u
YW1lID0gc2V0X3ZhbHVlKHN0cnZlYyk7Ci0KLQlpZiAoIWh3ZS0+cHJpb19uYW1lKQorCWJ1ZmYg
PSBzZXRfdmFsdWUoc3RydmVjKTsKKwlpZiAoIWJ1ZmYpCiAJCXJldHVybiAxOworCXRlbXAgPSBi
dWZmOwogCisJd2hpbGUgKHRlbXApIHsKKwkJcmVzdWx0ID0gc3Ryc2VwKCZ0ZW1wLCBzcGxpdF9j
aGFyKTsKKwkJaWYgKHN0cmNtcChyZXN1bHQsICIiKSkgeworCQkJaWYgKHByaW9fbG9va3VwKHJl
c3VsdCkpIHsKKwkJCQlod2UtPnByaW9fbmFtZSA9IFNUUkRVUChyZXN1bHQpOworCQkJCWlmICh0
ZW1wKQorCQkJCQlod2UtPnByaW9fYXJnID0gU1RSRFVQKHRlbXApOworCQkJCWVsc2UKKwkJCQkJ
aHdlLT5wcmlvX2FyZyA9IE5VTEw7CisJCQkJYnJlYWs7CisJCQl9CisJCX0KKwl9CisKKwlGUkVF
KGJ1ZmYpOwogCXJldHVybiAwOwogfQogCkBAIC05NTYsNiArOTkyLDQxIEBAIG1wX3BnX3RpbWVv
dXRfaGFuZGxlcih2ZWN0b3Igc3RydmVjKQogCXJldHVybiAwOwogfQogCitzdGF0aWMgaW50Citt
cF9wcmlvX2hhbmRsZXIgKHZlY3RvciBzdHJ2ZWMpCit7CisJc3RydWN0IG1wZW50cnkgKm1wZSA9
IFZFQ1RPUl9MQVNUX1NMT1QoY29uZi0+bXB0YWJsZSk7CisJY2hhciAqYnVmZiwgKnJlc3VsdCwg
KnRlbXA7CisJY2hhciBzcGxpdF9jaGFyW10gPSAiIFx0IjsKKworCWlmICghbXBlKQorCQlyZXR1
cm4gMTsKKworCWJ1ZmYgPSBzZXRfdmFsdWUoc3RydmVjKTsKKworCWlmICghYnVmZikKKwkJcmV0
dXJuIDE7CisKKwl0ZW1wID0gYnVmZjsKKworCXdoaWxlICh0ZW1wKSB7CisJCXJlc3VsdCA9IHN0
cnNlcCgmdGVtcCwgc3BsaXRfY2hhcik7CisJCWlmIChzdHJjbXAocmVzdWx0LCAiIikpIHsKKwkJ
CWlmIChwcmlvX2xvb2t1cChyZXN1bHQpKSB7CisJCQkJbXBlLT5wcmlvX25hbWUgPSBTVFJEVVAo
cmVzdWx0KTsKKwkJCQlpZiAodGVtcCkKKwkJCQkJbXBlLT5wcmlvX2FyZyA9IFNUUkRVUCh0ZW1w
KTsKKwkJCQllbHNlCisJCQkJCW1wZS0+cHJpb19hcmcgPSBOVUxMOworCQkJCWJyZWFrOworCQkJ
fQorCQl9CisJfQorCisJRlJFRShidWZmKTsKKwlyZXR1cm4gMDsKK30KKwogLyoKICAqIGNvbmZp
ZyBmaWxlIGtleXdvcmRzIHByaW50aW5nCiAgKi8KQEAgLTEwOTEsNiArMTE2MiwxNyBAQCBzbnBy
aW50X21wX3BnX3RpbWVvdXQgKGNoYXIgKiBidWZmLCBpbnQKIH0KIAogc3RhdGljIGludAorc25w
cmludF9tcF9wcmlvKGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICogZGF0YSkKK3sKKwlzdHJ1
Y3QgbXBlbnRyeSAqIG1wZSA9IChzdHJ1Y3QgbXBlbnRyeSAqKWRhdGE7CisKKwlpZiAoIW1wZS0+
cHJpb19uYW1lKQorCQlyZXR1cm4gMDsKKworCXJldHVybiBzbnByaW50ZihidWZmLCBsZW4sICIl
cyIsIG1wZS0+cHJpb19uYW1lKTsKK30KKworc3RhdGljIGludAogc25wcmludF9od192ZW5kb3Ig
KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICogZGF0YSkKIHsKIAlzdHJ1Y3QgaHdlbnRyeSAq
IGh3ZSA9IChzdHJ1Y3QgaHdlbnRyeSAqKWRhdGE7CkBAIC0xNjUyLDYgKzE3MzQsNyBAQCBpbml0
X2tleXdvcmRzKHZvaWQpCiAJaW5zdGFsbF9rZXl3b3JkKCJhbGlhcyIsICZhbGlhc19oYW5kbGVy
LCAmc25wcmludF9tcF9hbGlhcyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJwYXRoX2dyb3VwaW5nX3Bv
bGljeSIsICZtcF9wZ3BvbGljeV9oYW5kbGVyLCAmc25wcmludF9tcF9wYXRoX2dyb3VwaW5nX3Bv
bGljeSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJwYXRoX3NlbGVjdG9yIiwgJm1wX3NlbGVjdG9yX2hh
bmRsZXIsICZzbnByaW50X21wX3NlbGVjdG9yKTsKKwlpbnN0YWxsX2tleXdvcmQoInByaW8iLCAm
bXBfcHJpb19oYW5kbGVyLCAmc25wcmludF9tcF9wcmlvKTsKIAlpbnN0YWxsX2tleXdvcmQoImZh
aWxiYWNrIiwgJm1wX2ZhaWxiYWNrX2hhbmRsZXIsICZzbnByaW50X21wX2ZhaWxiYWNrKTsKIAlp
bnN0YWxsX2tleXdvcmQoInJyX3dlaWdodCIsICZtcF93ZWlnaHRfaGFuZGxlciwgJnNucHJpbnRf
bXBfcnJfd2VpZ2h0KTsKIAlpbnN0YWxsX2tleXdvcmQoIm5vX3BhdGhfcmV0cnkiLCAmbXBfbm9f
cGF0aF9yZXRyeV9oYW5kbGVyLCAmc25wcmludF9tcF9ub19wYXRoX3JldHJ5KTsKZGlmZiAtcE51
ciBtdWx0aXBhdGgtdG9vbHMtMC40Ljgub3JnL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyBtdWx0
aXBhdGgtdG9vbHMtMC40LjgvbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jCi0tLSBtdWx0aXBhdGgt
dG9vbHMtMC40Ljgub3JnL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwkyMDA4LTExLTExIDE4OjEx
OjU2LjAwMDAwMDAwMCArMDUzMAorKysgbXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0
aC9kaXNjb3ZlcnkuYwkyMDA4LTExLTEzIDE5OjQzOjU1LjAwMDAwMDAwMCArMDUzMApAQCAtNzU5
LDggKzc1OSwxMSBAQCBwYXRoaW5mbyAoc3RydWN0IHBhdGggKnBwLCB2ZWN0b3IgaHd0YWJsCiAJ
ICAqIGJlZW4gc3VjY2Vzc2Z1bGx5IG9idGFpbmVkIGJlZm9yZS4KIAkgICovCiAJaWYgKG1hc2sg
JiBESV9QUklPICYmCi0JICAgIChwcC0+c3RhdGUgIT0gUEFUSF9ET1dOIHx8IHBwLT5wcmlvcml0
eSA9PSBQUklPX1VOREVGKSkKKwkgICAgKHBwLT5zdGF0ZSAhPSBQQVRIX0RPV04gfHwgcHAtPnBy
aW9yaXR5ID09IFBSSU9fVU5ERUYpKSB7CisJCWlmICghc3RybGVuKHBwLT53d2lkKSkKKwkJCWdl
dF91aWQocHApOwogCQlnZXRfcHJpbyhwcCk7CisJfQogCiAJaWYgKG1hc2sgJiBESV9XV0lEICYm
ICFzdHJsZW4ocHAtPnd3aWQpKQogCQlnZXRfdWlkKHBwKTsKZGlmZiAtcE51ciBtdWx0aXBhdGgt
dG9vbHMtMC40Ljgub3JnL2xpYm11bHRpcGF0aC9wcmlvLmggbXVsdGlwYXRoLXRvb2xzLTAuNC44
L2xpYm11bHRpcGF0aC9wcmlvLmgKLS0tIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcvbGlibXVs
dGlwYXRoL3ByaW8uaAkyMDA4LTExLTExIDE4OjExOjU2LjAwMDAwMDAwMCArMDUzMAorKysgbXVs
dGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0aC9wcmlvLmgJMjAwOC0xMS0xMyAyMjo0MTox
MS4wMDAwMDAwMDAgKzA1MzAKQEAgLTI0LDYgKzI0LDcgQEAKICNkZWZpbmUgUFJJT19PTlRBUCAi
b250YXAiCiAjZGVmaW5lIFBSSU9fUkFORE9NICJyYW5kb20iCiAjZGVmaW5lIFBSSU9fUkRBQyAi
cmRhYyIKKyNkZWZpbmUgUFJJT19XRUlHSFRFRF9QQVRIICJ3ZWlnaHRlZHBhdGgiCiAKIC8qCiAg
KiBWYWx1ZSB1c2VkIHRvIG1hcmsgdGhlIGZhY3QgcHJpbyB3YXMgbm90IGRlZmluZWQKZGlmZiAt
cE51ciBtdWx0aXBhdGgtdG9vbHMtMC40Ljgub3JnL2xpYm11bHRpcGF0aC9wcmlvcml0aXplcnMv
TWFrZWZpbGUgbXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0aC9wcmlvcml0aXplcnMv
TWFrZWZpbGUKLS0tIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcvbGlibXVsdGlwYXRoL3ByaW9y
aXRpemVycy9NYWtlZmlsZQkyMDA4LTExLTExIDE4OjExOjU2LjAwMDAwMDAwMCArMDUzMAorKysg
bXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0aC9wcmlvcml0aXplcnMvTWFrZWZpbGUJ
MjAwOC0xMS0xMSAxODoxMTowNy4wMDAwMDAwMDAgKzA1MzAKQEAgLTEyLDcgKzEyLDggQEAgTElC
UyA9IFwKIAlsaWJwcmlvcmRhYy5zbyBcCiAJbGlicHJpb2FsdWEuc28gXAogCWxpYnByaW9vbnRh
cC5zbyBcCi0JbGlicHJpb2hkcy5zbworCWxpYnByaW9oZHMuc28gXAorCWxpYnByaW93ZWlnaHRl
ZHBhdGguc28KIAogQ0ZMQUdTICs9IC1JLi4KIApkaWZmIC1wTnVyIG11bHRpcGF0aC10b29scy0w
LjQuOC5vcmcvbGlibXVsdGlwYXRoL3ByaW9yaXRpemVycy93ZWlnaHRlZHBhdGguYyBtdWx0aXBh
dGgtdG9vbHMtMC40LjgvbGlibXVsdGlwYXRoL3ByaW9yaXRpemVycy93ZWlnaHRlZHBhdGguYwot
LS0gbXVsdGlwYXRoLXRvb2xzLTAuNC44Lm9yZy9saWJtdWx0aXBhdGgvcHJpb3JpdGl6ZXJzL3dl
aWdodGVkcGF0aC5jCTE5NzAtMDEtMDEgMDU6MzA6MDAuMDAwMDAwMDAwICswNTMwCisrKyBtdWx0
aXBhdGgtdG9vbHMtMC40LjgvbGlibXVsdGlwYXRoL3ByaW9yaXRpemVycy93ZWlnaHRlZHBhdGgu
YwkyMDA4LTExLTEzIDIwOjA0OjQ3LjAwMDAwMDAwMCArMDUzMApAQCAtMCwwICsxLDk5IEBACisv
KgorICoKKyAqICAoQykgIENvcHlyaWdodCAyMDA4IEhld2xldHQtUGFja2FyZCBEZXZlbG9wbWVu
dCBDb21wYW55LCBMLlAKKyAqCisgKiAgVGhpcyBmaWxlIGlzIHJlbGVhc2VkIHVuZGVyIHRoZSBH
UEwKKyAqLworCisvKgorICogUHJpb3JpdGl6ZXIgZm9yIGRldmljZSBtYXBwZXIgbXVsdGlwYXRo
LCB3aGVyZSBzcGVjaWZpYyBwYXRocyBhbmQgdGhlCisgKiBjb3JyZXNwb25kaW5nIHByaW9yaXR5
IHZhbHVlcyBhcmUgcHJvdmlkZWQgYXMgYXJndW1lbnRzLgorICoKKyAqIFRoaXMgcHJpb3JpdGl6
ZXIgYXNzaWducyB0aGUgcHJpb3JpdHkgdmFsdWUgcHJvdmlkZWQgaW4gdGhlIGNvbmZpZ3VyYXRp
b24KKyAqIGZpbGUgYmFzZWQgb24gdGhlIGNvbXBhcmlzb24gbWFkZSBiZXR3ZWVuIHRoZSBzcGVj
aWZpZWQgcGF0aHMgYW5kIHRoZSBwYXRoCisgKiBpbnN0YW5jZSBmb3Igd2hpY2ggdGhpcyBpcyBj
YWxsZWQuCisgKiBQYXRocyBjYW4gYmUgc3BlY2lmaWVkIGFzIGEgcmVndWxhciBleHByZXNzaW9u
IG9mIGRldm5hbWUgb2YgdGhlIHBhdGggb3IKKyAqIGFzIGhidGwgaW5mb3JtYXRpb24gb2YgdGhl
IHBhdGguCisgKgorICogRXhhbXBsZXM6CisgKglwcmlvICAgICAgICAgICAgIndlaWdodGVkcGF0
aCBoYnRsIDE6LjouOi4gMiA0Oi46LjouIDQiCisgKglwcmlvICAgICAgICAgICAgIndlaWdodGVk
cGF0aCBkZXZuYW1lIHNkYSAxMCBzZGUgMjAiCisgKgorICogUmV0dXJucyB6ZXJvIGFzIHRoZSBk
ZWZhdWx0IHByaW9yaXR5LgorICovCisKKyNpbmNsdWRlIDxzdGRpby5oPgorI2luY2x1ZGUgPHN0
cmluZy5oPgorCisjaW5jbHVkZSA8cHJpby5oPgorI2luY2x1ZGUgIndlaWdodGVkcGF0aC5oIgor
I2luY2x1ZGUgPGNvbmZpZy5oPgorI2luY2x1ZGUgPHN0cnVjdHMuaD4KKyNpbmNsdWRlIDxtZW1v
cnkuaD4KKyNpbmNsdWRlIDxkZWJ1Zy5oPgorI2luY2x1ZGUgPHJlZ2V4Lmg+CisKK2NoYXIgKmdl
dF9uZXh0X3N0cmluZyhjaGFyICoqdGVtcCwgY2hhciAqc3BsaXRfY2hhcikKK3sKKwljaGFyICp0
b2tlbiA9IE5VTEw7CisJdG9rZW4gPSBzdHJzZXAodGVtcCwgc3BsaXRfY2hhcik7CisJd2hpbGUg
KHRva2VuICE9IE5VTEwgJiYgIXN0cmNtcCh0b2tlbiwgIiIpKQorCQl0b2tlbiA9IHN0cnNlcCh0
ZW1wLCBzcGxpdF9jaGFyKTsKKwlyZXR1cm4gdG9rZW47Cit9CisKKy8qIG1haW4gcHJpb3JpdHkg
cm91dGluZSAqLworaW50IHByaW9fcGF0aF93ZWlnaHQoc3RydWN0IHBhdGggKnBwKQoreworCWNo
YXIgcGF0aFtGSUxFX05BTUVfU0laRV07CisJY2hhciAqYXJnOworCWNoYXIgKnRlbXAsICpyZWdl
eCwgKnByaW87CisJY2hhciBzcGxpdF9jaGFyW10gPSAiIFx0IjsKKwlpbnQgcHJpb3JpdHkgPSBE
RUZBVUxUX1BSSU9SSVRZLCBwYXRoX2ZvdW5kID0gMDsKKwlyZWdleF90IHBhdGhlOworCisJLyog
UmV0dXJuIGRlZmF1bHQgcHJpb3JpdHkgaWYgdGhlcmUgaXMgbm8gYXJndW1lbnQgKi8KKwlpZiAo
IXBwLT5wcmlvX2FyZykKKwkJcmV0dXJuIHByaW9yaXR5OworCisJYXJnID0gdGVtcCA9IFNUUkRV
UChwcC0+cHJpb19hcmcpOworCisJcmVnZXggPSBnZXRfbmV4dF9zdHJpbmcoJnRlbXAsIHNwbGl0
X2NoYXIpOworCisJaWYgKCFzdHJjbXAocmVnZXgsIEhCVEwpKSB7CisJCXNwcmludGYocGF0aCwg
IiVkOiVkOiVkOiVkIiwgcHAtPnNnX2lkLmhvc3Rfbm8sCisJCQlwcC0+c2dfaWQuY2hhbm5lbCwg
cHAtPnNnX2lkLnNjc2lfaWQsIHBwLT5zZ19pZC5sdW4pOworCX0gZWxzZSBpZiAoIXN0cmNtcChy
ZWdleCwgREVWX05BTUUpKSB7CisJCXN0cmNweShwYXRoLCBwcC0+ZGV2KTsKKwl9IGVsc2Ugewor
CQljb25kbG9nKDAsICIlczogJXMgLSBJbnZhbGlkIGFyZ3VtZW50cyIsIHBwLT5kZXYsCisJCQlw
cC0+cHJpby0+bmFtZSk7CisJCXJldHVybiBwcmlvcml0eTsKKwl9CisKKwl3aGlsZSAoIXBhdGhf
Zm91bmQpIHsKKwkJaWYgKCF0ZW1wKQorCQkJYnJlYWs7CisJCWlmICghKHJlZ2V4ID0gZ2V0X25l
eHRfc3RyaW5nKCZ0ZW1wLCBzcGxpdF9jaGFyKSkpCisJCQlicmVhazsKKwkJaWYgKCEocHJpbyA9
IGdldF9uZXh0X3N0cmluZygmdGVtcCwgc3BsaXRfY2hhcikpKQorCQkJYnJlYWs7CisKKwkJaWYg
KCFyZWdjb21wKCZwYXRoZSwgcmVnZXgsIFJFR19FWFRFTkRFRHxSRUdfTk9TVUIpKSB7CisJCQlp
ZiAoIXJlZ2V4ZWMoJnBhdGhlLCBwYXRoLCAwLCBOVUxMLCAwKSkgeworCQkJCXBhdGhfZm91bmQg
PSAxOworCQkJCXByaW9yaXR5ID0gYXRvaShwcmlvKTsKKwkJCX0KKwkJCXJlZ2ZyZWUoJnBhdGhl
KTsKKwkJfQorCX0KKworCUZSRUUoYXJnKTsKKwlyZXR1cm4gcHJpb3JpdHk7Cit9CisKK2ludCBn
ZXRwcmlvKHN0cnVjdCBwYXRoICpwcCkKK3sKKwlyZXR1cm4gcHJpb19wYXRoX3dlaWdodChwcCk7
Cit9CisKZGlmZiAtcE51ciBtdWx0aXBhdGgtdG9vbHMtMC40Ljgub3JnL2xpYm11bHRpcGF0aC9w
cmlvcml0aXplcnMvd2VpZ2h0ZWRwYXRoLmggbXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRp
cGF0aC9wcmlvcml0aXplcnMvd2VpZ2h0ZWRwYXRoLmgKLS0tIG11bHRpcGF0aC10b29scy0wLjQu
OC5vcmcvbGlibXVsdGlwYXRoL3ByaW9yaXRpemVycy93ZWlnaHRlZHBhdGguaAkxOTcwLTAxLTAx
IDA1OjMwOjAwLjAwMDAwMDAwMCArMDUzMAorKysgbXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11
bHRpcGF0aC9wcmlvcml0aXplcnMvd2VpZ2h0ZWRwYXRoLmgJMjAwOC0xMS0xMyAxOTo1NjoxMC4w
MDAwMDAwMDAgKzA1MzAKQEAgLTAsMCArMSwxMSBAQAorI2lmbmRlZiBfV0VJR0hURURfUEFUSF9I
CisjZGVmaW5lIF9XRUlHSFRFRF9QQVRIX0gKKworI2RlZmluZSBQUklPX1dFSUdIVEVEX1BBVEgg
IndlaWdodGVkcGF0aCIKKyNkZWZpbmUgSEJUTCAiaGJ0bCIKKyNkZWZpbmUgREVWX05BTUUgImRl
dm5hbWUiCisjZGVmaW5lIERFRkFVTFRfUFJJT1JJVFkgMAorCitpbnQgcHJpb19wYXRoX3dlaWdo
dChzdHJ1Y3QgcGF0aCAqcHApOworCisjZW5kaWYKZGlmZiAtcE51ciBtdWx0aXBhdGgtdG9vbHMt
MC40Ljgub3JnL2xpYm11bHRpcGF0aC9wcm9wc2VsLmMgbXVsdGlwYXRoLXRvb2xzLTAuNC44L2xp
Ym11bHRpcGF0aC9wcm9wc2VsLmMKLS0tIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcvbGlibXVs
dGlwYXRoL3Byb3BzZWwuYwkyMDA4LTExLTExIDE4OjExOjU2LjAwMDAwMDAwMCArMDUzMAorKysg
bXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0aC9wcm9wc2VsLmMJMjAwOC0xMS0xMyAx
OTo1ODo1OC4wMDAwMDAwMDAgKzA1MzAKQEAgLTI1OCwxNCArMjU4LDI4IEBAIHNlbGVjdF9nZXR1
aWQgKHN0cnVjdCBwYXRoICogcHApCiBleHRlcm4gaW50CiBzZWxlY3RfcHJpbyAoc3RydWN0IHBh
dGggKiBwcCkKIHsKKwlzdHJ1Y3QgbXBlbnRyeSAqIG1wZTsKKworCWlmICgobXBlID0gZmluZF9t
cGUocHAtPnd3aWQpKSkgeworCQlpZiAobXBlLT5wcmlvX25hbWUpIHsKKwkJCXBwLT5wcmlvID0g
cHJpb19sb29rdXAobXBlLT5wcmlvX25hbWUpOworCQkJcHAtPnByaW9fYXJnID0gbXBlLT5wcmlv
X2FyZzsKKwkJCWNvbmRsb2coMywgIiVzOiBwcmlvID0gJXMgKExVTiBzZXR0aW5nKSIsCisJCQkJ
cHAtPmRldiwgcHAtPnByaW8tPm5hbWUpOworCQkJcmV0dXJuIDA7CisJCX0KKwl9CisKIAlpZiAo
cHAtPmh3ZSAmJiBwcC0+aHdlLT5wcmlvX25hbWUpIHsKIAkJcHAtPnByaW8gPSBwcmlvX2xvb2t1
cChwcC0+aHdlLT5wcmlvX25hbWUpOworCQlwcC0+cHJpb19hcmcgPSBwcC0+aHdlLT5wcmlvX2Fy
ZzsKIAkJY29uZGxvZygzLCAiJXM6IHByaW8gPSAlcyAoY29udHJvbGxlciBzZXR0aW5nKSIsCiAJ
CQlwcC0+ZGV2LCBwcC0+aHdlLT5wcmlvX25hbWUpOwogCQlyZXR1cm4gMDsKIAl9CiAJaWYgKGNv
bmYtPnByaW9fbmFtZSkgewogCQlwcC0+cHJpbyA9IHByaW9fbG9va3VwKGNvbmYtPnByaW9fbmFt
ZSk7CisJCXBwLT5wcmlvX2FyZyA9IGNvbmYtPnByaW9fYXJnOwogCQljb25kbG9nKDMsICIlczog
cHJpbyA9ICVzIChjb25maWcgZmlsZSBkZWZhdWx0KSIsCiAJCQlwcC0+ZGV2LCBjb25mLT5wcmlv
X25hbWUpOwogCQlyZXR1cm4gMDsKZGlmZiAtcE51ciBtdWx0aXBhdGgtdG9vbHMtMC40Ljgub3Jn
L2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmggbXVsdGlwYXRoLXRvb2xzLTAuNC44L2xpYm11bHRpcGF0
aC9zdHJ1Y3RzLmgKLS0tIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcvbGlibXVsdGlwYXRoL3N0
cnVjdHMuaAkyMDA4LTExLTExIDE4OjExOjU2LjAwMDAwMDAwMCArMDUzMAorKysgbXVsdGlwYXRo
LXRvb2xzLTAuNC44L2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmgJMjAwOC0xMS0xMSAxODoxMTowNy4w
MDAwMDAwMDAgKzA1MzAKQEAgLTEyMSw2ICsxMjEsNyBAQCBzdHJ1Y3QgcGF0aCB7CiAJaW50IHBn
aW5kZXg7CiAJY2hhciAqIGdldHVpZDsKIAlzdHJ1Y3QgcHJpbyAqIHByaW87CisJY2hhciAqIHBy
aW9fYXJnOwogCXN0cnVjdCBjaGVja2VyIGNoZWNrZXI7CiAJc3RydWN0IG11bHRpcGF0aCAqIG1w
cDsKIAlpbnQgZmQ7CmRpZmYgLXBOdXIgbXVsdGlwYXRoLXRvb2xzLTAuNC44Lm9yZy9tdWx0aXBh
dGgvbXVsdGlwYXRoLmNvbmYuNSBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbXVsdGlwYXRoL211bHRp
cGF0aC5jb25mLjUKLS0tIG11bHRpcGF0aC10b29scy0wLjQuOC5vcmcvbXVsdGlwYXRoL211bHRp
cGF0aC5jb25mLjUJMjAwOC0xMS0xMSAxODoxMTo1Ni4wMDAwMDAwMDAgKzA1MzAKKysrIG11bHRp
cGF0aC10b29scy0wLjQuOC9tdWx0aXBhdGgvbXVsdGlwYXRoLmNvbmYuNQkyMDA4LTExLTEzIDIy
OjM2OjA1LjAwMDAwMDAwMCArMDUzMApAQCAtMTQ2LDYgKzE0NiwyNCBAQCBHZW5lcmF0ZSB0aGUg
cGF0aCBwcmlvcml0eSBmb3IgSGl0YWNoaSBICiBEZWZhdWx0IHZhbHVlIGlzIFxmQm5vbmVcZlIu
CiAuUkUKIC5UUAorLkIgcHJpbworVGhlIGRlZmF1bHQgcHJvZ3JhbSBhbmQgYXJncyB0byBwYXRo
IHByaW9yaXR5IHJvdXRpbmUuIFRoZSBzcGVjaWZpZWQgCityb3V0aW5lIHNob3VsZCByZXR1cm4g
YSBudW1lcmljIHZhbHVlIHNwZWNpZnlpbmcgdGhlIHJlbGF0aXZlIHByaW9yaXR5IAorb2YgdGhp
cyBwYXRoLiBIaWdoZXIgbnVtYmVyIGhhdmUgYSBoaWdoZXIgcHJpb3JpdHkuIAorLlJTCisuVFAg
MTIKKy5CIGFsdWEKK0dlbmVyYXRlIHRoZSBwYXRoIHByaW9yaXR5IGJhc2VkIG9uIEFMVUEgc3Rh
dHVzIG9mIHRoZSBwYXRoLgorLlRQIDEyCisuQiB3ZWlnaHRlZHBhdGggPGhidGx8ZGV2bmFtZT4g
PHJlZ2V4MT4gPHByaW8xPiA8cmVnZXgyPiA8cHJpbzI+IC4uLgorLkkgaGJ0bCAKK3JlZ2V4IGNh
biBiZSBvZiBTQ1NJIEg6QjpUOkwgZm9ybWF0ICBFeDogMTowOi46LiAsICo6MDowOi4KKy5JIGRl
dm5hbWUgCityZWdleCBjYW4gYmUgb2YgZGV2aWNlIG5hbWUgZm9ybWF0ICBFeDogc2RhICwgc2Qu
ZQorR2VuZXJhdGUgdGhlIHBhdGggcHJpb3JpdHkgYmFzZWQgb24gdGhlIHJlZ3VsYXIgZXhwcmVz
c2lvbiBhbmQgdGhlIAorcHJpb3JpdHkgcHJvdmlkZWQgYXMgYXJndW1lbnQuCisuUkUKKy5UUAog
LkIgZmVhdHVyZXMKIFNwZWNpZnkgYW55IGRldmljZS1tYXBwZXIgZmVhdHVyZXMgdG8gYmUgdXNl
ZC4gU3ludGF4IGlzCiAuSSBudW0gbGlzdApAQCAtMzIyLDYgKzM0MCw4IEBAIHNlY3Rpb246CiAu
VFAKIC5CIHBhdGhfc2VsZWN0b3IKIC5UUAorLkIgcHJpbworLlRQCiAuQiBmYWlsYmFjawogLlRQ
CiAuQiBub19wYXRoX3JldHJ5CkBAIC0zNzUsNiArMzk1LDggQEAgc2VjdGlvbjoKIC5UUAogLkIg
cGF0aF9jaGVja2VyCiAuVFAKKy5CIHByaW8KKy5UUAogLkIgZmVhdHVyZXMKIC5UUAogLkIgcHJp
b19jYWxsb3V0CmRpZmYgLXBOdXIgbXVsdGlwYXRoLXRvb2xzLTAuNC44Lm9yZy9tdWx0aXBhdGgu
Y29uZi5hbm5vdGF0ZWQgbXVsdGlwYXRoLXRvb2xzLTAuNC44L211bHRpcGF0aC5jb25mLmFubm90
YXRlZAotLS0gbXVsdGlwYXRoLXRvb2xzLTAuNC44Lm9yZy9tdWx0aXBhdGguY29uZi5hbm5vdGF0
ZWQJMjAwOC0xMS0xMSAxODoxMTo1Ni4wMDAwMDAwMDAgKzA1MzAKKysrIG11bHRpcGF0aC10b29s
cy0wLjQuOC9tdWx0aXBhdGguY29uZi5hbm5vdGF0ZWQJMjAwOC0xMS0xMiAxODoyOTowMS4wMDAw
MDAwMDAgKzA1MzAKQEAgLTI2MSw2ICsyNjEsMTggQEAKICMJCSMgZGVmYXVsdCA6IDEwMDAKICMJ
CSMKICMJCXJyX21pbl9pbwkxMDAKKyMJCQorIwkJIworIwkJI25hbWUJICA6IHByaW8KKyMJCSNz
Y29wZSAgICA6IG11bHRpcGF0aAorIwkJI2Rlc2MgICAgIDogdGhlIGZ1bmN0aW9uIHRvIGNhbGwg
dG8gb2J0YWluIGEgcGF0aCB3ZWlnaHQuCisjCQkjICAgICAgICAgICBXZWlnaHRzIGFyZSBzdW1t
ZWQgZm9yIGVhY2ggcGF0aCBncm91cCB0bworIwkJIyAgICAgICAgICAgZGV0ZXJtaW5lIHRoZSBu
ZXh0IFBHIHRvIHVzZSBjYXNlIG9mIGZhaWx1cmUuICAKKyMJCSNkZWZhdWx0IDogbm8gY2FsbG91
dCwgYWxsIHBhdGhzIGVxdWFscworIwkJIyBFeDoKKyMJCSMgcHJpbwlhbHVhCisjCQkjIHByaW8J
IndlaWdodGVkcGF0aCBkZXZuYW1lIHNkYSA1MCBzZGUgMTAgc2RjIDUwIHNkZiAxMCIKKyMJCXBy
aW8gICAgICAgICAgIndlaWdodGVkcGF0aCBoYnRsIDE6LjouOi4gMiA0Oi46LjouIDQiCiAjCX0K
ICMJbXVsdGlwYXRoIHsKICMJCXd3aWQJMURFQ19fX19fMzIxODE2NzU4NDc0Cg==

--_002_2118D41AB77C214BBF7D2330CD977BCF1BB3958036GVW1162EXBame_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_2118D41AB77C214BBF7D2330CD977BCF1BB3958036GVW1162EXBame_--
