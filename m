From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 13/18] multipath: add exclusive_pref_bit for
	alua prio
Date: Thu,  7 Apr 2016 18:20:07 -0500
Message-ID: <1460071212-21018-14-git-send-email-bmarzins@redhat.com>
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

The SCSI spec is pretty vague on exactly what the tpgs pref bit should
guarantee. In the past, the alua prioritizer has put paths with the pref
bit set in their own priority group, and some users complained.
Currently, the alua prioritizer puts paths with the tpgs pref bit set in
the highest priority path group. However, if the path with the pref bit
set is active/optimized, it will be grouped with other active/optimized
paths. Other users complained about this. The only good solution is to
allow users to configure what setting the pref bit does.

This patch allows user to set

prio_args "exclusive_pref_bit"

for the alua prioritizer.  If this is set, a paths with the pref bit set
will never get grouped with paths that don't have it set. If this is
not set, multipath will continue to work as it currently does, where
they may be grouped when all paths are active/optimized.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/alua.c | 20 +++++++++++++++++++-
 multipath/multipath.conf.5       | 19 ++++++++++++++++---
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 0bd374f..cd4aafc 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -75,15 +75,33 @@ get_alua_info(struct path * pp)
 	return rc;
 }
 
+int get_exclusive_perf_arg(char *args)
+{
+	char *ptr;
+
+	if (args == NULL)
+		return 0;
+	ptr = strstr(args, "exclusive_pref_bit");
+	if (!ptr)
+		return 0;
+	if (ptr[18] != '\0' && ptr[18] != ' ' && ptr[18] != '\t')
+		return 0;
+	if (ptr != args && ptr[-1] != ' ' && ptr[-1] != '\t')
+		return 0;
+	return 1;
+}
+
 int getprio (struct path * pp, char * args)
 {
 	int rc;
 	int aas;
 	int priopath;
+	int exclusive_perf;
 
 	if (pp->fd < 0)
 		return -ALUA_PRIO_NO_INFORMATION;
 
+	exclusive_perf = get_exclusive_perf_arg(args);
 	rc = get_alua_info(pp);
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
@@ -104,7 +122,7 @@ int getprio (struct path * pp, char * args)
 			default:
 				rc = 0;
 		}
-		if (priopath && aas != AAS_OPTIMIZED)
+		if (priopath && (aas != AAS_OPTIMIZED || exclusive_perf))
 			rc += 80;
 	} else {
 		switch(-rc) {
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 31c0eb8..7a4c452 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -193,7 +193,9 @@ Return a constant priority of \fI1\fR.
 Generate the path priority for EMC arrays.
 .TP
 .B alua
-Generate the path priority based on the SCSI-3 ALUA settings.
+Generate the path priority based on the SCSI-3 ALUA settings. This prioritizer
+accepts the optional prio_arg
+.I exclusive_pref_bit
 .TP
 .B ontap
 Generate the path priority for NetApp arrays.
@@ -219,14 +221,25 @@ Default value is \fBnone\fR.
 .RE
 .TP
 .B prio_args
-Arguments to pass to to the prio function.  Currently only used with
-.I weighted, which needs a value of the form
+Arguments to pass to to the prio function. This only applies to certain
+prioritizers
+.RS
+.TP 12
+.B weighted
+Needs a value of the form
 .I "<hbtl|devname> <regex1> <prio1> <regex2> <prio2> ..."
 .I hbtl
 regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
 .I devname
 regex can be of device name format  Ex: sda , sd.e
 .TP
+.B alua
+If
+.I exclusive_pref_bit
+is set, paths with the TPGS pref bit set will always be in their own path
+group.
+.RE
+.TP
 .B features
 Specify any device-mapper features to be used. Syntax is
 .I num list
-- 
1.8.3.1
