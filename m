From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH RFC 3/3] multipath-tools: coalesce heterogenous
	paths by referencing method
Date: Fri, 21 Jul 2017 13:07:32 +0800
Message-ID: <1500613652-9084-4-git-send-email-guanjunxiong@huawei.com>
References: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com
List-Id: dm-devel.ids

This patch supports migrating data for heterogenous arrays without
interrupting uplayer transaction.

The usage is as follows:

The new attribute named uid_reference provides a unique path identifier
for some paths by referencing another path's identifier. Therefor those
paths can be coalesced. This is useful to migrate data for heterogenous
arrays without interrupting uplayer transaction. If you are going to let
sda, sdb and sdc use the unique path identifier of the sdd, you can add
the uid_reference field as follows into the vendor specific _devices_
section, _override_ section or the _default_ section in the multipath.conf
file.

uid_reference  "sd[a-c]  sdd"

where the first parameter which can be regular expression specifies
the target devices to be assigned with the wwid of the source device.
The second parameter is the source device to be referenced by the target
devices. The source device only supports one device.

Here is another expamle I use:
uid_reference "nvme[1-9]*n[0-9]*  nvme0n1"

The implementation outline is as follows:

1. To let multipath configuation suppport the new attribute uid_reference
in the, we add a new attribute named uid_reference which can be added in
the _default_, _override_, and _devices_ section.

2. When the target path is going to get unique id, we fetch the source
path's unique id at first. To simplify logic and code, we use recurring
method where the recurring ending condition is speficied by the flags
in the path.

3. Copy the source path wwid to the target path's.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/config.c      |  13 +++++
 libmultipath/config.h      |   3 ++
 libmultipath/dict.c        |  11 ++++
 libmultipath/discovery.c   | 123 ++++++++++++++++++++++++++++++++++++++++++++-
 libmultipath/propsel.c     |  25 +++++++++
 libmultipath/structs.h     |   1 +
 libmultipath/structs_vec.c |   1 +
 multipath/multipath.conf.5 |  37 +++++++++++++-
 8 files changed, 211 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 6b236019..fa42dcd9 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -176,6 +176,9 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->uid_attribute)
 		FREE(hwe->uid_attribute);
 
+	if (hwe->uid_reference)
+		FREE(hwe->uid_reference);
+
 	if (hwe->features)
 		FREE(hwe->features);
 
@@ -236,6 +239,9 @@ free_mpe (struct mpentry * mpe)
 	if (mpe->uid_attribute)
 		FREE(mpe->uid_attribute);
 
+	if (mpe->uid_reference)
+		FREE(mpe->uid_reference);
+
 	if (mpe->alias)
 		FREE(mpe->alias);
 
@@ -323,6 +329,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_str(revision);
 	merge_str(getuid);
 	merge_str(uid_attribute);
+	merge_str(uid_reference);
 	merge_str(features);
 	merge_str(hwhandler);
 	merge_str(selector);
@@ -388,6 +395,9 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	if (dhwe->uid_attribute && !(hwe->uid_attribute = set_param_str(dhwe->uid_attribute)))
 		goto out;
 
+	if (dhwe->uid_reference && !(hwe->uid_reference = set_param_str(dhwe->uid_reference)))
+		goto out;
+
 	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
 		goto out;
 
@@ -500,6 +510,9 @@ free_config (struct config * conf)
 	if (conf->uid_attribute)
 		FREE(conf->uid_attribute);
 
+	if (conf->uid_reference)
+		FREE(conf->uid_reference);
+
 	if (conf->uid_attrs)
 		FREE(conf->uid_attrs);
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ffc69b5f..709e9f19 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -47,6 +47,7 @@ struct hwentry {
 	char * product;
 	char * revision;
 	char * uid_attribute;
+	char * uid_reference;
 	char * getuid;
 	char * features;
 	char * hwhandler;
@@ -84,6 +85,7 @@ struct mpentry {
 	char * wwid;
 	char * alias;
 	char * uid_attribute;
+	char * uid_reference;
 	char * getuid;
 	char * selector;
 	char * features;
@@ -172,6 +174,7 @@ struct config {
 	char * selector;
 	char * uid_attrs;
 	char * uid_attribute;
+	char * uid_reference;
 	char * getuid;
 	char * features;
 	char * hwhandler;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 82066f67..7a5514ad 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -258,6 +258,14 @@ declare_ovr_snprint(uid_attribute, print_str)
 declare_hw_handler(uid_attribute, set_str)
 declare_hw_snprint(uid_attribute, print_str)
 
+declare_def_handler(uid_reference, set_str)
+declare_def_snprint(uid_reference, print_str)
+declare_ovr_handler(uid_reference, set_str)
+declare_ovr_snprint(uid_reference, print_str)
+declare_hw_handler(uid_reference, set_str)
+declare_hw_snprint(uid_reference, print_str)
+
+
 declare_def_handler(getuid, set_str)
 declare_def_snprint(getuid, print_str)
 declare_ovr_handler(getuid, set_str)
@@ -1400,6 +1408,7 @@ init_keywords(vector keywords)
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_pgpolicy);
 	install_keyword("uid_attrs", &def_uid_attrs_handler, &snprint_def_uid_attrs);
 	install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_def_uid_attribute);
+	install_keyword("uid_reference", &def_uid_reference_handler, &snprint_def_uid_reference);
 	install_keyword("getuid_callout", &def_getuid_handler, &snprint_def_getuid);
 	install_keyword("prio", &def_prio_name_handler, &snprint_def_prio_name);
 	install_keyword("prio_args", &def_prio_args_handler, &snprint_def_prio_args);
@@ -1499,6 +1508,7 @@ init_keywords(vector keywords)
 	install_keyword("product_blacklist", &hw_bl_product_handler, &snprint_hw_bl_product);
 	install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_hw_pgpolicy);
 	install_keyword("uid_attribute", &hw_uid_attribute_handler, &snprint_hw_uid_attribute);
+	install_keyword("uid_reference", &hw_uid_reference_handler, &snprint_hw_uid_reference);
 	install_keyword("getuid_callout", &hw_getuid_handler, &snprint_hw_getuid);
 	install_keyword("path_selector", &hw_selector_handler, &snprint_hw_selector);
 	install_keyword("path_checker", &hw_checker_name_handler, &snprint_hw_checker_name);
@@ -1534,6 +1544,7 @@ init_keywords(vector keywords)
 	install_keyword_root("overrides", &overrides_handler);
 	install_keyword("path_grouping_policy", &ovr_pgpolicy_handler, &snprint_ovr_pgpolicy);
 	install_keyword("uid_attribute", &ovr_uid_attribute_handler, &snprint_ovr_uid_attribute);
+	install_keyword("uid_reference", &ovr_uid_reference_handler, &snprint_ovr_uid_reference);
 	install_keyword("getuid_callout", &ovr_getuid_handler, &snprint_ovr_getuid);
 	install_keyword("path_selector", &ovr_selector_handler, &snprint_ovr_selector);
 	install_keyword("path_checker", &ovr_checker_name_handler, &snprint_ovr_checker_name);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1d3f591e..ce2343cd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1768,6 +1768,118 @@ get_vpd_uid(struct path * pp)
 	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
+static int
+check_uid_reference(struct path * pp, char *uid_reference)
+{
+	const char *msg_id = "uid_reference";
+	const char *from_dev;
+	const char *to_dev_regex;
+	char *args, *temp;
+	char split_char[] = " \t";
+	regex_t path_regex;
+	int ret = -EINVAL;
+
+	if (!uid_reference)
+		return -EINVAL;
+
+	args = temp = STRDUP(uid_reference);
+	if (!args)
+		return -ENOMEM;
+
+	to_dev_regex = get_next_string(&temp, split_char);
+	if (!to_dev_regex) {
+		condlog(3, "%s: no target devices provided for %s",
+			pp->dev, msg_id);
+		goto out1;
+	}
+
+	if (!temp || !(from_dev = get_next_string(&temp, split_char))) {
+		condlog(3, "%s: no source device provided for %s",
+			pp->dev, msg_id);
+		goto out1;
+	}
+
+	if (regcomp(&path_regex, to_dev_regex, REG_EXTENDED|REG_NOSUB))
+		goto out2;
+
+	/*
+	 * to discard if the target device is in the source device list
+	 */
+	if (!regexec(&path_regex, from_dev, 0, NULL, 0)) {
+		condlog(3, "%s: invalid parameter for %s because the source \
+			devices include the target device", pp->dev, msg_id);
+		goto out2;
+	}
+
+	if (regexec(&path_regex, pp->dev, 0, NULL, 0)) {
+		goto out2;
+	}
+
+	ret = 0;
+out2:
+	regfree(&path_regex);
+out1:
+	FREE(args);
+
+	return ret;
+}
+
+static int
+get_uid_reference(struct path * pp, char *uid_reference)
+{
+	const char *msg_id = "uid_reference";
+	int ret;
+	ssize_t len = -1;
+
+	const char *from_dev = NULL;
+	char *args, *temp;
+	char split_char[] = " \t";
+	struct path *from_pp = NULL;
+	struct udev_device *from_udev;
+	struct config *conf;
+
+	args = temp = STRDUP(uid_reference);
+	if (!args)
+		return -ENOMEM;
+
+	/*
+	 * the uid_reference has been checked by check_uid_reference,
+	 * so discard handle the exceptions
+	 */
+	get_next_string(&temp, split_char);
+	from_dev = get_next_string(&temp, split_char);
+
+	from_udev = udev_device_new_from_subsystem_sysname(udev, "block",
+			from_dev);
+	if (!from_udev) {
+		condlog(3, "%s: (%s) failed to get udev_device for (%s)",
+			pp->dev, msg_id, from_dev);
+		goto out1;
+	}
+
+	conf = get_multipath_config();
+	ret = alloc_path_with_pathinfo(conf, from_udev, NULL,
+			DI_SYSFS | DI_WWID | DI_BLACKLIST,
+			&from_pp, PATHFLAG_UID_TO_BE_REFERENCED);
+	put_multipath_config(conf);
+
+	if (!from_pp || ret) {
+		condlog(3, "%s: (%s) failed to get source device (%s)\'s wwid",
+			pp->dev, msg_id, from_dev);
+		goto out2;
+	}
+
+	if (strlen(from_pp->wwid) != 0) {
+		len = strlcpy(pp->wwid, from_pp->wwid, WWID_SIZE);
+	}
+out2:
+	udev_device_unref(from_udev);
+out1:
+	FREE(args);
+
+	return len;
+}
+
 int
 get_uid (struct path * pp, int path_state, struct udev_device *udev)
 {
@@ -1775,8 +1887,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 	const char *origin = "unknown";
 	ssize_t len = 0;
 	struct config *conf;
+	int flag;
 
-	if (!pp->uid_attribute && !pp->getuid) {
+	if (!pp->uid_attribute && !pp->getuid && !pp->uid_reference) {
 		conf = get_multipath_config();
 		select_getuid(conf, pp);
 		put_multipath_config(conf);
@@ -1788,7 +1901,13 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 	}
 
 	memset(pp->wwid, 0, WWID_SIZE);
-	if (pp->getuid) {
+
+	flag = pp->flags & PATHFLAG_UID_TO_BE_REFERENCED;
+	if (!flag && check_uid_reference(pp, pp->uid_reference) == 0) {
+		len = get_uid_reference(pp, pp->uid_reference);
+		origin = "reference";
+	}
+	else if (pp->getuid) {
 		char buff[CALLOUT_MAX_SIZE];
 
 		/* Use 'getuid' callout, deprecated */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 27f39517..75c339c1 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -343,10 +343,35 @@ out:
 	return 0;
 }
 
+static int select_uid_reference(struct config *conf, struct path *pp)
+{
+	char *origin;
+	int flag = pp->flags & PATHFLAG_UID_TO_BE_REFERENCED;
+
+	if (!flag) {
+		pp_set_ovr(uid_reference);
+		pp_set_hwe(uid_reference);
+		pp_set_conf(uid_reference);
+	}
+
+out:
+	if (pp->uid_reference)
+		condlog(3, "%s: uid_reference = %s %s", pp->dev,
+			pp->uid_reference, origin);
+	return 0;
+
+}
+
 int select_getuid(struct config *conf, struct path *pp)
 {
 	char *origin;
 
+	/*
+	 * Here we use a wrapper to ensure uid_reference can be fetched
+	 * with either getuid or uid_atrribute.
+	 */
+	select_uid_reference(conf, pp);
+
 	pp->uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, pp->dev);
 	if (pp->uid_attribute) {
 		origin = "(setting: multipath.conf defaults section)";
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 0d2bc40d..e548059d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -222,6 +222,7 @@ struct path {
 	int wait_checks;
 	int tpgs;
 	char * uid_attribute;
+	char * uid_reference;
 	char * getuid;
 	struct prio prio;
 	char * prio_args;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 22be8e0d..ed5c94df 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -85,6 +85,7 @@ void orphan_path(struct path *pp, const char *reason)
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
+	pp->uid_reference = NULL;
 	pp->getuid = NULL;
 	prio_put(&pp->prio);
 	checker_put(&pp->checker);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0049cba7..e2916ac6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -238,6 +238,22 @@ The default is: for NVME devices \fBID_WWN\fR
 .
 .
 .TP
+.B uid_reference
+The user defined attribute providing a unique path identifier by referencing
+another path's identifier. Those paths can be coalesced. This is useful to
+migrate data for heterogenous arrays without interrupting uplayer transaction.
+If you are going to let sda, sdb and sdc use the unique path identifier of the sdd,
+you can set uid_reference as:
+.RS
+.TP
+\fBsd[a-c]  sdd\fR
+where the first parameter which can be regular expression is the target devices
+to be assigned. The second parameter is the source device whose identifier will be
+referenced by the target devices. The source device only support one device.
+.RE
+.
+.
+.TP
 .B getuid_callout
 (Superseded by \fIuid_attribute\fR) The default program and args to callout
 to obtain a unique path identifier. Should be specified with an absolute path.
@@ -1193,6 +1209,8 @@ section:
 .TP
 .B uid_attribute
 .TP
+.B uid_reference
+.TP
 .B path_selector
 .TP
 .B path_checker
@@ -1259,6 +1277,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B uid_attribute
 .TP
+.B uid_reference
+.TP
 .B getuid_callout
 .TP
 .B path_selector
@@ -1323,8 +1343,23 @@ Multipath uses a \fIWorld Wide Identification\fR (WWID) to determine
 which paths belong to the same device. Each path presenting the same
 WWID is assumed to point to the same device.
 .LP
-The WWID is generated by three methods (in the order of preference):
+The WWID is generated by four methods (in the order of preference):
 .TP 17
+.B uid_reference
+The user defined attribute providing a unique path identifier by referencing
+another path's identifier. Those paths can be coalesced. This is useful to
+migrate data for heterogenous arrays without interrupting uplayer transaction.
+If you are going to let sda, sdb and sdc use the unique path identifier of the sdd,
+you can set uid_reference as:
+.RS
+.TP
+\fBsd[a-c]  sdd\fR
+where the first parameter which can be regular expression is the target devices
+to be assigned. The second parameter is the source device whose identifier will be
+referenced by the target devices. The source device only support one device.
+.RE
+.
+.TP
 .B getuid_callout
 Use the specified external program; cf \fIgetuid_callout\fR above.
 Care should be taken when using this method; the external program
-- 
2.11.1
