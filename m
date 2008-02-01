From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath: Add compability 'command' prio handler
Date: Fri, 1 Feb 2008 16:08:05 +0100
Message-ID: <20080201150805.GK27779@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Transfer-Encoding: 7bit
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


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

with the move to the libprio framework we change the layout of the
configuration file. Without advance warning to the user.

Not good.

So here's a patch to implement a compatible 'command' prio handler,
which re-implements the old 'getprio' keyword handling on top of
the existing libprio framework.
And we print a nice fat warning to the user.

As usual, comments etc are welcome.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=EF=BF=BDrnberg
GF: Markus Rex, HRB 16746 (AG N=EF=BF=BDrnberg)

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=multipath-tools-implement-command-prio

tree d55d7fa57eb2e37a2963d58f3ffecc61a2dcfd19
parent 435a721afbb87e1921637538668441726ccc1d9e
author Hannes Reinecke <hare@suse.de> 1201878006 +0100
committer Hannes Reinecke <hare@suse.de> 1201878006 +0100

libprio: Add compability 'command' prio handler

The old 'getprio' callout functionality should be provided, as we
cannot guarantee that the config files will be up to date.
So re-implement the getprio callout and make sure the user is
notified on startup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
0a2def51de718fbbc3629a02e14870d9f8af4c69
 libmultipath/config.h  |    3 ++
 libmultipath/dict.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.c |   16 +++++++++++
 libmultipath/structs.h |    1 +
 libprio/Makefile       |    2 +-
 libprio/command.c      |   37 +++++++++++++++++++++++++
 libprio/command.h      |    7 +++++
 libprio/libprio.c      |    4 +++
 libprio/libprio.h      |    1 +
 9 files changed, 139 insertions(+), 1 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 7568d7b..d6403a8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -16,6 +16,7 @@ struct hwentry {
 	char * product;
 	char * revision;
 	char * getuid;
+	char * getprio;
 	char * features;
 	char * hwhandler;
 	char * selector;
@@ -37,6 +38,7 @@ struct mpentry {
 	char * wwid;
 	char * alias;
 	char * getuid;
+	char * getprio;
 	char * selector;
 
 	int pgpolicy;
@@ -73,6 +75,7 @@ struct config {
 	char * udev_dir;
 	char * selector;
 	char * getuid;
+	char * getprio;
 	char * features;
 	char * hwhandler;
 	char * bindings_file;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index fa37ee8..2e0e916 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -83,6 +83,23 @@ def_getuid_callout_handler(vector strvec)
 }
 
 static int
+def_prio_callout_handler(vector strvec)
+{
+	conf->getprio = set_value(strvec);
+
+	if (!conf->getprio)
+		return 1;
+
+	if (strlen(conf->getprio) == 4 &&
+	    !strcmp(conf->getprio, "none")) {
+		FREE(conf->getprio);
+		conf->getprio = NULL;
+	}
+
+	return 0;
+}
+
+static int
 def_prio_handler(vector strvec)
 {
 	char * buff;
@@ -589,6 +606,27 @@ hw_handler_handler(vector strvec)
 }
 
 static int
+prio_callout_handler(vector strvec)
+{
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	if (!hwe)
+	       return 1;
+
+	hwe->getprio = set_value(strvec);
+
+	if (!hwe->getprio)
+		return 1;
+
+	if (strlen(hwe->getprio) == 4 && !strcmp(hwe->getprio, "none")) {
+		FREE(hwe->getprio);
+		hwe->getprio = NULL;
+	}
+
+	return 0;
+}
+
+static int
 hw_prio_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
@@ -1130,6 +1168,26 @@ snprint_hw_getuid_callout (char * buff, int len, void * data)
 }
 
 static int
+snprint_hw_prio_callout (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (!conf->getprio && !hwe->getprio)
+		return 0;
+	if (!conf->getprio && hwe->getprio)
+		return snprintf(buff, len, "%s", hwe->getprio);
+	if (conf->getprio && !hwe->getprio)
+		return snprintf(buff, len, "none");
+
+	/* conf->getprio && hwe->getprio */
+	if (strlen(hwe->getprio) == strlen(conf->getprio) &&
+	    !strcmp(hwe->getprio, conf->getprio))
+		return 0;
+
+	return snprintf(buff, len, "%s", hwe->getprio);
+}
+
+static int
 snprint_hw_prio (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1372,6 +1430,15 @@ snprint_def_getuid_callout (char * buff, int len, void * data)
 }
 
 static int
+snprint_def_getprio_callout (char * buff, int len, void * data)
+{
+	if (!conf->getprio)
+		return 0;
+
+	return snprintf(buff, len, "%s", conf->getprio);
+}
+
+static int
 snprint_def_prio (char * buff, int len, void * data)
 {
 	if (!conf->prio)
@@ -1542,6 +1609,7 @@ init_keywords(void)
 	install_keyword("selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
 	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
+	install_keyword("prio_callout", &def_prio_callout_handler, &snprint_def_getprio_callout);
 	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
 	install_keyword("features", &def_features_handler, &snprint_def_features);
 	install_keyword("path_checker", &def_path_checker_handler, &snprint_def_path_checker);
@@ -1598,6 +1666,7 @@ init_keywords(void)
 	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
 	install_keyword("features", &hw_features_handler, &snprint_hw_features);
 	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_hardware_handler);
+	install_keyword("prio_callout", &prio_callout_handler, &snprint_hw_prio_callout);
 	install_keyword("prio", &hw_prio_handler, &snprint_hw_prio);
 	install_keyword("failback", &hw_failback_handler, &snprint_hw_failback);
 	install_keyword("rr_weight", &hw_weight_handler, &snprint_hw_rr_weight);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index bb2b2b7..7bc7083 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -266,12 +266,28 @@ select_prio (struct path * pp)
 			pp->dev, prio_name(pp->prio));
 		return 0;
 	}
+	if (pp->hwe && pp->hwe->getprio) {
+		pp->getprio = pp->hwe->getprio;
+		pp->prio = prio_lookup(PRIO_COMMAND);
+		condlog(1, "%s: Using deprecated prio_callout '%s' (controller setting)\n"
+			"\tPlease fixup /etc/multipath.conf",
+			pp->dev, pp->hwe->getprio);
+		return 0;
+	}
 	if (conf->prio) {
 		pp->prio = conf->prio;
 		condlog(3, "%s: prio = %s (config file default)",
 			pp->dev, prio_name(pp->prio));
 		return 0;
 	}
+	if (conf->getprio) {
+		pp->getprio = conf->getprio;
+		pp->prio = prio_lookup(PRIO_COMMAND);
+		condlog(1, "%s: Using deprecated prio_callout '%s' (controller setting)\n"
+			"\tPlease fixup /etc/multipath.conf",
+			pp->dev, pp->hwe->getprio);
+		return 0;
+	}
 	pp->prio = prio_default();
 	condlog(3, "%s: prio = %s (internal default)",
 		pp->dev, prio_name(pp->prio));
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 2517782..6205f59 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -120,6 +120,7 @@ struct path {
 	int priority;
 	int pgindex;
 	char * getuid;
+	char * getprio;
 	struct prio * prio;
 	struct checker checker;
 	struct multipath * mpp;
diff --git a/libprio/Makefile b/libprio/Makefile
index 177a67b..127def6 100644
--- a/libprio/Makefile
+++ b/libprio/Makefile
@@ -6,7 +6,7 @@ BUILD = glibc
 
 include ../Makefile.inc
 
-OBJS = libprio.o random.o const.o hp_sw.o emc.o rdac.o alua.o alua_rtpg.o netapp.o hds.o
+OBJS = libprio.o random.o const.o hp_sw.o emc.o rdac.o alua.o alua_rtpg.o netapp.o hds.o command.o
 
 CFLAGS += -I$(multipathdir)
 
diff --git a/libprio/command.c b/libprio/command.c
new file mode 100644
index 0000000..1154c59
--- /dev/null
+++ b/libprio/command.c
@@ -0,0 +1,37 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "../libcheckers/checkers.h"
+
+#include <vector.h>
+#include <structs.h>
+#include <callout.h>
+#include <debug.h>
+#include "libprio.h"
+
+int prio_command(struct path * pp)
+{
+	char buff[CALLOUT_MAX_SIZE];
+	char prio[16], *ptr;
+	int priority;
+
+	if (!pp->getprio)
+		return PRIO_UNDEF;
+
+	if (apply_format(pp->getprio, &buff[0], pp)) {
+		condlog(0, "error formatting prio callout command");
+		return PRIO_UNDEF;
+	} else if (execute_program(buff, prio, 16)) {
+		condlog(0, "error calling out %s", buff);
+		return PRIO_UNDEF;
+	}
+
+	condlog(3, "%s: priority %s", pp->dev, prio);
+	priority = strtoul(prio, &ptr, 10);
+	if (prio == ptr)
+		return PRIO_UNDEF;
+
+	return priority;
+}
diff --git a/libprio/command.h b/libprio/command.h
new file mode 100644
index 0000000..a1af97e
--- /dev/null
+++ b/libprio/command.h
@@ -0,0 +1,7 @@
+#ifndef _COMMAND_H
+#define _COMMAND_H
+
+#define PRIO_COMMAND "command"
+int prio_command(struct path * pp);
+
+#endif
diff --git a/libprio/libprio.c b/libprio/libprio.c
index 2d7d479..bc79fa7 100644
--- a/libprio/libprio.c
+++ b/libprio/libprio.c
@@ -37,6 +37,10 @@ static struct prio prioritizers[] = {
 		.getprio = prio_hp_sw
 	},
 	{
+		.name    = PRIO_COMMAND,
+		.getprio = prio_command
+	},
+	{
 		.name    = "",
 		.getprio = NULL
 	},
diff --git a/libprio/libprio.h b/libprio/libprio.h
index 978e14e..36d1eff 100644
--- a/libprio/libprio.h
+++ b/libprio/libprio.h
@@ -16,6 +16,7 @@
 #include "netapp.h"
 #include "hds.h"
 #include "rdac.h"
+#include "command.h"
 
 #define DEFAULT_PRIO PRIO_CONST
 

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--82I3+IH0IqGh5yIs--
