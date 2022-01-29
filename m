Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846BEC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 08:31:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-C0qpwPP_PEijv_1shTGYhA-1; Mon, 31 Jan 2022 03:31:20 -0500
X-MC-Unique: C0qpwPP_PEijv_1shTGYhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A7531927807;
	Mon, 31 Jan 2022 08:31:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4830F1F2F8;
	Mon, 31 Jan 2022 08:31:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BF034A7CA;
	Mon, 31 Jan 2022 08:31:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20THdgE4028265 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 29 Jan 2022 12:39:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8F82340CFD17; Sat, 29 Jan 2022 17:39:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ACDB40CFD0A
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 17:39:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E436101A54C
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 17:39:42 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-608-N4KZleiMPUugKiKqR5EHuQ-1; Sat, 29 Jan 2022 12:39:40 -0500
X-MC-Unique: N4KZleiMPUugKiKqR5EHuQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10242"; a="247507158"
X-IronPort-AV: E=Sophos;i="5.88,327,1635231600"; d="scan'208";a="247507158"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	29 Jan 2022 09:39:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,327,1635231600"; d="scan'208";a="536545334"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
	by orsmga008.jf.intel.com with ESMTP; 29 Jan 2022 09:39:38 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, ebiggers@kernel.org, ardb@kernel.org,
	x86@kernel.org, luto@kernel.org, tglx@linutronix.de, bp@suse.de,
	dave.hansen@linux.intel.com, mingo@kernel.org
Date: Sat, 29 Jan 2022 09:31:53 -0800
Message-Id: <20220129173153.27899-1-chang.seok.bae@intel.com>
In-Reply-To: <20220112211258.21115-9-chang.seok.bae@intel.com>
References: <20220112211258.21115-9-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 31 Jan 2022 03:30:51 -0500
Cc: ravi.v.shankar@intel.com, marvin.hsu@intel.com, linux-pm@vger.kernel.org,
	chang.seok.bae@intel.com, linux-kernel@vger.kernel.org,
	kumar.n.dwarakanath@intel.com, dan.j.williams@intel.com,
	charishma1.gairuboyina@intel.com
Subject: [dm-devel] [PATCH v5-fix 08/12] x86/PM/keylocker: Restore internal
	wrapping key on resume from ACPI S3/4
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When the system enters the ACPI S3 or S4 sleep states, the internal
wrapping key is discarded.

The primary use case for the feature is bare metal dm-crypt. The key needs
to be restored properly on wakeup, as dm-crypt does not prompt for the key
on resume from suspend. Even the prompt it does perform for unlocking
the volume where the hibernation image is stored, it still expects to reuse
the key handles within the hibernation image once it is loaded. So it is
motivated to meet dm-crypt's expectation that the key handles in the
suspend-image remain valid after resume from an S-state.

Key Locker provides a mechanism to back up the internal wrapping key in
non-volatile storage. The kernel requests a backup right after the key is
loaded at boot time. It is copied back to each CPU upon wakeup.

While the backup may be maintained in NVM across S5 and G3 "off"
states it is not architecturally guaranteed, nor is it expected by dm-crypt
which expects to prompt for the key each time the volume is started.

The entirety of Key Locker needs to be disabled if the backup mechanism is
not available unless CONFIG_SUSPEND=n, otherwise dm-crypt requires the
backup to be available.

In the event of a key restore failure the kernel proceeds with an
initialized IWKey state. This has the effect of invalidating any key
handles that might be present in a suspend-image. When this happens
dm-crypt will see I/O errors resulting from error returns from
crypto_skcipher_{en,de}crypt(). While this will disrupt operations in the
current boot, data is not at risk and access is restored at the next reboot
to create new handles relative to the current IWKey.

Manage a feature-specific flag to communicate with the crypto
implementation. This ensures to stop using the AES instructions upon the
key restore failure while not turning off the feature.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
---
Changes from v5:
* Fix the valid_kl flag setting when the feature is disabled.
  (Reported by Marvin Hsu <marvin.hsu@intel.com>)

Changes from v4:
* Update the changelog and title. (Rafael Wysocki)

Changes from v3:
* Fix the build issue with !X86_KEYLOCKER. (Eric Biggers)

Changes from RFC v2:
* Change the backup key failure handling. (Dan Williams)

Changes from RFC v1:
* Folded the warning message into the if condition check. (Rafael
Wysocki)
* Rebased on the changes of the previous patches.
* Added error code for key restoration failures.
* Moved the restore helper.
* Added function descriptions.
---
 arch/x86/include/asm/keylocker.h |   4 +
 arch/x86/kernel/keylocker.c      | 128 ++++++++++++++++++++++++++++++-
 arch/x86/power/cpu.c             |   2 +
 3 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 820ac29c06d9..c1d27fb5a1c3 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -32,9 +32,13 @@ struct iwkey {
 #ifdef CONFIG_X86_KEYLOCKER
 void setup_keylocker(struct cpuinfo_x86 *c);
 void destroy_keylocker_data(void);
+void restore_keylocker(void);
+extern bool valid_keylocker(void);
 #else
 #define setup_keylocker(c) do { } while (0)
 #define destroy_keylocker_data() do { } while (0)
+#define restore_keylocker() do { } while (0)
+static inline bool valid_keylocker(void) { return false; }
 #endif
 
 #endif /*__ASSEMBLY__ */
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index 87d775a65716..981c1f5517e7 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -11,11 +11,26 @@
 #include <asm/fpu/api.h>
 #include <asm/keylocker.h>
 #include <asm/tlbflush.h>
+#include <asm/msr.h>
 
 static __initdata struct keylocker_setup_data {
+	bool initialized;
 	struct iwkey key;
 } kl_setup;
 
+/*
+ * This flag is set with IWKey load. When the key restore fails, it is
+ * reset. This restore state is exported to the crypto library, then AES-KL
+ * will not be used there. So, the feature is soft-disabled with this flag.
+ */
+static bool valid_kl;
+
+bool valid_keylocker(void)
+{
+	return valid_kl;
+}
+EXPORT_SYMBOL_GPL(valid_keylocker);
+
 static void __init generate_keylocker_data(void)
 {
 	get_random_bytes(&kl_setup.key.integrity_key,  sizeof(kl_setup.key.integrity_key));
@@ -24,7 +39,13 @@ static void __init generate_keylocker_data(void)
 
 void __init destroy_keylocker_data(void)
 {
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER) ||
+	    cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return;
+
 	memset(&kl_setup.key, KEY_DESTROY, sizeof(kl_setup.key));
+	kl_setup.initialized = true;
+	valid_kl = true;
 }
 
 static void __init load_keylocker(void)
@@ -34,6 +55,27 @@ static void __init load_keylocker(void)
 	kernel_fpu_end();
 }
 
+/**
+ * copy_keylocker - Copy the internal wrapping key from the backup.
+ *
+ * Request hardware to copy the key in non-volatile storage to the CPU
+ * state.
+ *
+ * Returns:	-EBUSY if the copy fails, 0 if successful.
+ */
+static int copy_keylocker(void)
+{
+	u64 status;
+
+	wrmsrl(MSR_IA32_COPY_IWKEY_TO_LOCAL, 1);
+
+	rdmsrl(MSR_IA32_IWKEY_COPY_STATUS, status);
+	if (status & BIT(0))
+		return 0;
+	else
+		return -EBUSY;
+}
+
 /**
  * setup_keylocker - Enable the feature.
  * @c:		A pointer to struct cpuinfo_x86
@@ -49,6 +91,7 @@ void __ref setup_keylocker(struct cpuinfo_x86 *c)
 
 	if (c == &boot_cpu_data) {
 		u32 eax, ebx, ecx, edx;
+		bool backup_available;
 
 		cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
 		/*
@@ -62,10 +105,49 @@ void __ref setup_keylocker(struct cpuinfo_x86 *c)
 			goto disable;
 		}
 
+		backup_available = !!(ebx & KEYLOCKER_CPUID_EBX_BACKUP);
+		/*
+		 * The internal wrapping key in CPU state is volatile in
+		 * S3/4 states. So ensure the backup capability along with
+		 * S-states.
+		 */
+		if (!backup_available && IS_ENABLED(CONFIG_SUSPEND)) {
+			pr_debug("x86/keylocker: No key backup support with possible S3/4.\n");
+			goto disable;
+		}
+
 		generate_keylocker_data();
-	}
+		load_keylocker();
+
+		/* Backup an internal wrapping key in non-volatile media. */
+		if (backup_available)
+			wrmsrl(MSR_IA32_BACKUP_IWKEY_TO_PLATFORM, 1);
+	} else {
+		int rc;
 
-	load_keylocker();
+		/*
+		 * Load the internal wrapping key directly when available
+		 * in memory, which is only possible at boot-time.
+		 *
+		 * NB: When system wakes up, this path also recovers the
+		 * internal wrapping key.
+		 */
+		if (!kl_setup.initialized) {
+			load_keylocker();
+		} else if (valid_kl) {
+			rc = copy_keylocker();
+			/*
+			 * The boot CPU was successful but the key copy
+			 * fails here. Then, the subsequent feature use
+			 * will have inconsistent keys and failures. So,
+			 * invalidate the feature via the flag.
+			 */
+			if (rc) {
+				valid_kl = false;
+				pr_err_once("x86/keylocker: Invalid copy status (rc: %d).\n", rc);
+			}
+		}
+	}
 
 	pr_info_once("x86/keylocker: Enabled.\n");
 	return;
@@ -77,3 +159,45 @@ void __ref setup_keylocker(struct cpuinfo_x86 *c)
 	/* Make sure the feature disabled for kexec-reboot. */
 	cr4_clear_bits(X86_CR4_KEYLOCKER);
 }
+
+/**
+ * restore_keylocker - Restore the internal wrapping key.
+ *
+ * The boot CPU executes this while other CPUs restore it through the setup
+ * function.
+ */
+void restore_keylocker(void)
+{
+	u64 backup_status;
+	int rc;
+
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER) || !valid_kl)
+		return;
+
+	/*
+	 * The IA32_IWKEYBACKUP_STATUS MSR contains a bitmap that indicates
+	 * an invalid backup if bit 0 is set and a read (or write) error if
+	 * bit 2 is set.
+	 */
+	rdmsrl(MSR_IA32_IWKEY_BACKUP_STATUS, backup_status);
+	if (backup_status & BIT(0)) {
+		rc = copy_keylocker();
+		if (rc)
+			pr_err("x86/keylocker: Invalid copy state (rc: %d).\n", rc);
+		else
+			return;
+	} else {
+		pr_err("x86/keylocker: The key backup access failed with %s.\n",
+		       (backup_status & BIT(2)) ? "read error" : "invalid status");
+	}
+
+	/*
+	 * Now the backup key is not available. Invalidate the feature via
+	 * the flag to avoid any subsequent use. But keep the feature with
+	 * zero IWKeys instead of disabling it. The current users will see
+	 * key handle integrity failure but that's because of the internal
+	 * key change.
+	 */
+	pr_err("x86/keylocker: Failed to restore internal wrapping key.\n");
+	valid_kl = false;
+}
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 9f2b251e83c5..1a290f529c73 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,6 +25,7 @@
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
+#include <asm/keylocker.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -262,6 +263,7 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	mtrr_bp_restore();
 	perf_restore_debug_store();
 	msr_restore_context(ctxt);
+	restore_keylocker();
 
 	c = &cpu_data(smp_processor_id());
 	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

