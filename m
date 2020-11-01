Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF13EC388F2
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 328C421D91
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 328C421D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-prKkjPXYPNucyLsE_QRDxA-1; Mon, 02 Nov 2020 02:58:42 -0500
X-MC-Unique: prKkjPXYPNucyLsE_QRDxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E422A186840C;
	Mon,  2 Nov 2020 07:58:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C5F035D9E4;
	Mon,  2 Nov 2020 07:58:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 99C38181A06C;
	Mon,  2 Nov 2020 07:58:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQjEW029379 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B54D31111C6F; Sun,  1 Nov 2020 22:26:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B16861111C6E
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8277080088F
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:45 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-284-wZuaCqddO8GcxZe1ab7rDg-3;
	Sun, 01 Nov 2020 17:26:40 -0500
X-MC-Unique: wZuaCqddO8GcxZe1ab7rDg-3
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3B1E6208A8F1;
	Sun,  1 Nov 2020 14:26:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3B1E6208A8F1
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:26 -0800
Message-Id: <20201101222626.6111-8-tusharsu@linux.microsoft.com>
In-Reply-To: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v5 7/7] selinux: measure state and hash of the
	policy using IMA
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

Critical data structures of security modules are currently not measured.
Therefore an attestation service, for instance, would not be able to
attest whether the security modules are always operating with the policies
and configurations that the system administrator had setup. The policies
and configurations for the security modules could be tampered by rogue
user mode agents or modified through some inadvertent actions on
the system. Measuring such critical data would enable an attestation
service to reliably assess the security configuration of the system.

SELinux configuration and policy are some of the critical data for this
security module that need to be measured. This measurement can be used
by an attestation service, for instance, to verify if the configurations
and policies have been setup correctly and that they haven't been
tampered at run-time.

Measure SELinux configurations, policy capabilities settings, and
the hash of the loaded policy by calling the IMA hook
ima_measure_critical_data(). Since the size of the loaded policy can
be large (several MB), measure the hash of the policy instead of
the entire policy to avoid bloating the IMA log entry.

Add "selinux" to the list of supported data sources maintained by IMA
to enable measuring SELinux data.

To enable SELinux data measurement, the following steps are required:

1, Add "ima_policy=critical_data" to the kernel command line arguments
   to enable measuring SELinux data at boot time.
For example,
  BOOT_IMAGE=/boot/vmlinuz-5.10.0-rc1+ root=UUID=fd643309-a5d2-4ed3-b10d-3c579a5fab2f ro nomodeset security=selinux ima_policy=critical_data

2, Add the following rule to /etc/ima/ima-policy
   measure func=CRITICAL_DATA data_sources=selinux template=ima-buf

Sample measurement of SELinux state and hash of the policy:

10 e32e...5ac3 ima-buf sha256:86e8...4594 selinux-state-1595389364:287899386 696e697469616c697a65643d313b656e61626c65643d313b656e666f7263696e673d303b636865636b72657170726f743d313b6e6574776f726b5f706565725f636f6e74726f6c733d313b6f70656e5f7065726d733d313b657874656e6465645f736f636b65745f636c6173733d313b616c776179735f636865636b5f6e6574776f726b3d303b6367726f75705f7365636c6162656c3d313b6e6e705f6e6f737569645f7472616e736974696f6e3d313b67656e66735f7365636c6162656c5f73796d6c696e6b733d303
10 9e81...0857 ima-buf sha256:4941...68fc selinux-policy-hash-1597335667:462051628 8d1d...1834

To verify the measurement check the following:

Execute the following command to extract the measured data
from the IMA log for SELinux configuration (selinux-state).

  grep "selinux-state" /sys/kernel/security/integrity/ima/ascii_runtime_measurements | tail -1 | cut -d' ' -f 6 | xxd -r -p

The output should be the list of key-value pairs. For example,
 initialized=1;enabled=1;enforcing=0;checkreqprot=1;network_peer_controls=1;open_perms=1;extended_socket_class=1;always_check_network=0;cgroup_seclabel=1;nnp_nosuid_transition=1;genfs_seclabel_symlinks=0;

To verify the measured data with the current SELinux state:

 => enabled should be set to 1 if /sys/fs/selinux folder exists,
    0 otherwise

For other entries, compare the integer value in the files
 => /sys/fs/selinux/enforce
 => /sys/fs/selinux/checkreqprot
And, each of the policy capabilities files under
 => /sys/fs/selinux/policy_capabilities

Note that the actual verification would be against an expected state
and done on a system other than the measured system, typically
requiring "initialized=1; enabled=1;enforcing=1;checkreqprot=0;" for
a secure state and then whatever policy capabilities are actually set
in the expected policy (which can be extracted from the policy itself
via seinfo, for example).

For selinux-policy-hash, the hash of SELinux policy is included
in the IMA log entry.

To verify the measured data with the current SELinux policy run
the following commands and verify the output hash values match.

  sha256sum /sys/fs/selinux/policy | cut -d' ' -f 1

  grep "selinux-policy-hash" /sys/kernel/security/integrity/ima/ascii_runtime_measurements | tail -1 | cut -d' ' -f 6

Note that the actual verification of SELinux policy would require loading
the expected policy into an identical kernel on a pristine/known-safe
system and run the sha256sum /sys/kernel/selinux/policy there to get
the expected hash.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
---
 Documentation/ABI/testing/ima_policy |   6 +-
 security/integrity/ima/ima.h         |   1 +
 security/selinux/Makefile            |   2 +
 security/selinux/hooks.c             |   3 +
 security/selinux/include/security.h  |  11 +-
 security/selinux/measure.c           | 157 +++++++++++++++++++++++++++
 security/selinux/selinuxfs.c         |   9 ++
 security/selinux/ss/services.c       |  71 ++++++++++--
 8 files changed, 249 insertions(+), 11 deletions(-)
 create mode 100644 security/selinux/measure.c

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 15be8b16f6f3..2eb06c53a326 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -48,7 +48,7 @@ Description:
 			template:= name of a defined IMA template type
 			(eg, ima-ng). Only valid when action is "measure".
 			pcr:= decimal value
-			data_sources:= list of kernel subsystems that contain
+			data_sources:= list of kernel subsystems (eg, SeLinux) that contain
 			kernel in-memory data critical to the integrity of the kernel.
 			Only valid when action is "measure" and func is
 			CRITICAL_DATA.
@@ -129,3 +129,7 @@ Description:
 		keys added to .builtin_trusted_keys or .ima keyring:
 
 			measure func=KEY_CHECK keyrings=.builtin_trusted_keys|.ima
+
+		Example of measure rule using CRITICAL_DATA to measure critical data
+
+			measure func=CRITICAL_DATA data_sources=selinux template=ima-buf
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 4a35db010d91..f10b9a368595 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -230,6 +230,7 @@ struct modsig;
 
 #define __ima_supported_kernel_data_sources(source)	\
 	source(MIN_SOURCE, min_source)			\
+	source(SELINUX, selinux)			\
 	source(MAX_SOURCE, max_source)
 
 #define __ima_enum_stringify(ENUM, str) (#str),
diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index 4d8e0e8adf0b..83d512116341 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -16,6 +16,8 @@ selinux-$(CONFIG_NETLABEL) += netlabel.o
 
 selinux-$(CONFIG_SECURITY_INFINIBAND) += ibpkey.o
 
+selinux-$(CONFIG_IMA) += measure.o
+
 ccflags-y := -I$(srctree)/security/selinux -I$(srctree)/security/selinux/include
 
 $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6b1826fc3658..8b9fde47ae28 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7398,6 +7398,9 @@ int selinux_disable(struct selinux_state *state)
 	}
 
 	selinux_mark_disabled(state);
+	mutex_lock(&state->policy_mutex);
+	selinux_measure_state(state);
+	mutex_unlock(&state->policy_mutex);
 
 	pr_info("SELinux:  Disabled at runtime.\n");
 
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 3cc8bab31ea8..18ee65c98446 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -229,7 +229,8 @@ void selinux_policy_cancel(struct selinux_state *state,
 			struct selinux_policy *policy);
 int security_read_policy(struct selinux_state *state,
 			 void **data, size_t *len);
-
+int security_read_policy_kernel(struct selinux_state *state,
+				void **data, size_t *len);
 int security_policycap_supported(struct selinux_state *state,
 				 unsigned int req_cap);
 
@@ -446,4 +447,12 @@ extern void ebitmap_cache_init(void);
 extern void hashtab_cache_init(void);
 extern int security_sidtab_hash_stats(struct selinux_state *state, char *page);
 
+#ifdef CONFIG_IMA
+extern void selinux_measure_state(struct selinux_state *selinux_state);
+#else
+static inline void selinux_measure_state(struct selinux_state *selinux_state)
+{
+}
+#endif
+
 #endif /* _SELINUX_SECURITY_H_ */
diff --git a/security/selinux/measure.c b/security/selinux/measure.c
new file mode 100644
index 000000000000..65d42059f588
--- /dev/null
+++ b/security/selinux/measure.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Measure SELinux state using IMA subsystem.
+ */
+#include <linux/vmalloc.h>
+#include <linux/ktime.h>
+#include <linux/ima.h>
+#include "security.h"
+
+/*
+ * This function creates a unique name by appending the timestamp to
+ * the given string. This string is passed as "event_name" to the IMA
+ * hook to measure the given SELinux data.
+ *
+ * The data provided by SELinux to the IMA subsystem for measuring may have
+ * already been measured (for instance the same state existed earlier).
+ * But for SELinux the current data represents a state change and hence
+ * needs to be measured again. To enable this, pass a unique "event_name"
+ * to the IMA hook so that IMA subsystem will always measure the given data.
+ *
+ * For example,
+ * At time T0 SELinux data to be measured is "foo". IMA measures it.
+ * At time T1 the data is changed to "bar". IMA measures it.
+ * At time T2 the data is changed to "foo" again. IMA will not measure it
+ * (since it was already measured) unless the event_name, for instance,
+ * is different in this call.
+ */
+static char *selinux_event_name(const char *name_prefix)
+{
+	char *event_name = NULL;
+	struct timespec64 cur_time;
+
+	ktime_get_real_ts64(&cur_time);
+	event_name = kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
+			       cur_time.tv_sec, cur_time.tv_nsec);
+	if (!event_name) {
+		pr_err("%s: event name not allocated.\n", __func__);
+		return NULL;
+	}
+
+	return event_name;
+}
+
+static int read_selinux_state(char **state_str, int *state_str_len,
+			      struct selinux_state *state)
+{
+	char *buf, *str_fmt = "%s=%d;";
+	int i, buf_len, curr;
+	bool initialized = selinux_initialized(state);
+	bool enabled = !selinux_disabled(state);
+	bool enforcing = enforcing_enabled(state);
+	bool checkreqprot = checkreqprot_get(state);
+
+	buf_len = snprintf(NULL, 0, str_fmt, "initialized", initialized);
+	buf_len += snprintf(NULL, 0, str_fmt, "enabled", enabled);
+	buf_len += snprintf(NULL, 0, str_fmt, "enforcing", enforcing);
+	buf_len += snprintf(NULL, 0, str_fmt, "checkreqprot", checkreqprot);
+
+	for (i = 0; i < __POLICYDB_CAPABILITY_MAX; i++) {
+		buf_len += snprintf(NULL, 0, str_fmt,
+				    selinux_policycap_names[i],
+				    state->policycap[i]);
+	}
+	++buf_len;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	curr = scnprintf(buf, buf_len, str_fmt,
+			 "initialized", initialized);
+	curr += scnprintf((buf + curr), (buf_len - curr), str_fmt,
+			  "enabled", enabled);
+	curr += scnprintf((buf + curr), (buf_len - curr), str_fmt,
+			  "enforcing", enforcing);
+	curr += scnprintf((buf + curr), (buf_len - curr), str_fmt,
+			  "checkreqprot", checkreqprot);
+
+	for (i = 0; i < __POLICYDB_CAPABILITY_MAX; i++) {
+		curr += scnprintf((buf + curr), (buf_len - curr), str_fmt,
+				  selinux_policycap_names[i],
+				  state->policycap[i]);
+	}
+
+	*state_str = buf;
+	*state_str_len = curr;
+
+	return 0;
+}
+
+/*
+ * selinux_measure_state - Measure SELinux state configuration and hash of
+ *			   the SELinux policy.
+ * @state: selinux state struct
+ *
+ * NOTE: This function must be called with policy_mutex held.
+ */
+void selinux_measure_state(struct selinux_state *state)
+{
+	void *policy = NULL;
+	char *state_event_name = NULL;
+	char *policy_event_name = NULL;
+	char *state_str = NULL;
+	size_t policy_len;
+	int state_str_len, rc = 0;
+	bool initialized = selinux_initialized(state);
+
+	/*
+	 * Get a unique string for measuring the current SELinux state.
+	 */
+	state_event_name = selinux_event_name("selinux-state");
+	if (!state_event_name) {
+		pr_err("%s: Event name for state not allocated.\n",
+		       __func__);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = read_selinux_state(&state_str, &state_str_len, state);
+	if (rc) {
+		pr_err("%s: Failed to read state %d.\n", __func__, rc);
+		goto out;
+	}
+
+	ima_measure_critical_data("selinux", state_event_name,
+				  state_str, state_str_len, false);
+
+	/*
+	 * Measure SELinux policy only after initialization is completed.
+	 */
+	if (!initialized)
+		goto out;
+
+	policy_event_name = selinux_event_name("selinux-policy-hash");
+	if (!policy_event_name) {
+		pr_err("%s: Event name for policy not allocated.\n",
+		       __func__);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = security_read_policy_kernel(state, &policy, &policy_len);
+	if (rc) {
+		pr_err("%s: Failed to read policy %d.\n", __func__, rc);
+		goto out;
+	}
+
+	ima_measure_critical_data("selinux", policy_event_name,
+				  policy, policy_len, true);
+
+	vfree(policy);
+
+out:
+	kfree(policy_event_name);
+	kfree(state_str);
+	kfree(state_event_name);
+}
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 4bde570d56a2..a4f1282f7178 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -182,6 +182,10 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
 		selinux_status_update_setenforce(state, new_value);
 		if (!new_value)
 			call_blocking_lsm_notifier(LSM_POLICY_CHANGE, NULL);
+
+		mutex_lock(&state->policy_mutex);
+		selinux_measure_state(state);
+		mutex_unlock(&state->policy_mutex);
 	}
 	length = count;
 out:
@@ -762,6 +766,11 @@ static ssize_t sel_write_checkreqprot(struct file *file, const char __user *buf,
 
 	checkreqprot_set(fsi->state, (new_value ? 1 : 0));
 	length = count;
+
+	mutex_lock(&fsi->state->policy_mutex);
+	selinux_measure_state(fsi->state);
+	mutex_unlock(&fsi->state->policy_mutex);
+
 out:
 	kfree(page);
 	return length;
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 9704c8a32303..dfa2e00894ae 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2180,6 +2180,7 @@ static void selinux_notify_policy_change(struct selinux_state *state,
 	selinux_status_update_policyload(state, seqno);
 	selinux_netlbl_cache_invalidate();
 	selinux_xfrm_notify_policyload();
+	selinux_measure_state(state);
 }
 
 void selinux_policy_commit(struct selinux_state *state,
@@ -3875,8 +3876,33 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
 }
 #endif /* CONFIG_NETLABEL */
 
+/**
+ * security_read_selinux_policy - read the policy.
+ * @policy: SELinux policy
+ * @data: binary policy data
+ * @len: length of data in bytes
+ *
+ */
+static int security_read_selinux_policy(struct selinux_policy *policy,
+					void *data, size_t *len)
+{
+	int rc;
+	struct policy_file fp;
+
+	fp.data = data;
+	fp.len = *len;
+
+	rc = policydb_write(&policy->policydb, &fp);
+	if (rc)
+		return rc;
+
+	*len = (unsigned long)fp.data - (unsigned long)data;
+	return 0;
+}
+
 /**
  * security_read_policy - read the policy.
+ * @state: selinux_state
  * @data: binary policy data
  * @len: length of data in bytes
  *
@@ -3885,8 +3911,6 @@ int security_read_policy(struct selinux_state *state,
 			 void **data, size_t *len)
 {
 	struct selinux_policy *policy;
-	int rc;
-	struct policy_file fp;
 
 	policy = rcu_dereference_protected(
 			state->policy, lockdep_is_held(&state->policy_mutex));
@@ -3898,14 +3922,43 @@ int security_read_policy(struct selinux_state *state,
 	if (!*data)
 		return -ENOMEM;
 
-	fp.data = *data;
-	fp.len = *len;
+	return security_read_selinux_policy(policy, *data, len);
+}
 
-	rc = policydb_write(&policy->policydb, &fp);
-	if (rc)
-		return rc;
+/**
+ * security_read_policy_kernel - read the policy.
+ * @state: selinux_state
+ * @data: binary policy data
+ * @len: length of data in bytes
+ *
+ * Allocates kernel memory for reading SELinux policy.
+ * This function is for internal use only and should not
+ * be used for returning data to user space.
+ *
+ * This function must be called with policy_mutex held.
+ */
+int security_read_policy_kernel(struct selinux_state *state,
+				void **data, size_t *len)
+{
+	struct selinux_policy *policy;
+	int rc = 0;
 
-	*len = (unsigned long)fp.data - (unsigned long)*data;
-	return 0;
+	policy = rcu_dereference_protected(
+			state->policy, lockdep_is_held(&state->policy_mutex));
+	if (!policy) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	*len = policy->policydb.len;
+	*data = vmalloc(*len);
+	if (!*data) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
+	rc = security_read_selinux_policy(policy, *data, len);
+
+out:
+	return rc;
 }
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

