Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AC9C7EE37
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685806521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fTTmgNFp+CU5K1hiYpfbqBggiKgfmzim9DAe+06j8yo=;
	b=OwhoibgoUHD0tSUyuK95+GMtgLpbWTYAuxTGLzKMFCIlYcUl5UBLraCQ0HByXfb8NiRUyE
	Y5arXKcw/EhBt6WHMmNsz1wcYUVN8Nzb6GtLhPcSHRmg7fvHAhLk14KR6mjEFhzhU99nR+
	2WSTMptVFxfmOk0Xwb8mUDorfgmXy7Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-YvTHIsBLN2GC6RKUHlE0tA-1; Sat, 03 Jun 2023 11:35:18 -0400
X-MC-Unique: YvTHIsBLN2GC6RKUHlE0tA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 549BD1C041A7;
	Sat,  3 Jun 2023 15:35:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40D5B1401C51;
	Sat,  3 Jun 2023 15:35:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55A2319465A0;
	Sat,  3 Jun 2023 15:35:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A1E01946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 15:35:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2539B7AE4; Sat,  3 Jun 2023 15:35:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D8E79E71
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:13 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF55F3C0257D
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-cf9qDtpfMV2fOrpIJiDkLA-3; Sat, 03 Jun 2023 11:35:09 -0400
X-MC-Unique: cf9qDtpfMV2fOrpIJiDkLA-3
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="356097488"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="356097488"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jun 2023 08:35:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="702274269"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="702274269"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga007.jf.intel.com with ESMTP; 03 Jun 2023 08:35:07 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 08:22:23 -0700
Message-Id: <20230603152227.12335-9-chang.seok.bae@intel.com>
In-Reply-To: <20230603152227.12335-1-chang.seok.bae@intel.com>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v8 08/12] x86/PM/keylocker: Restore the wrapping
 key on the resume from ACPI S3/4
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: x86@kernel.org, herbert@gondor.apana.org.au,
 "Rafael J. Wysocki" <rafael@kernel.org>, ardb@kernel.org,
 chang.seok.bae@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, Ingo Molnar <mingo@redhat.com>,
 bp@alien8.de, charishma1.gairuboyina@intel.com, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
 bernie.keany@intel.com, tglx@linutronix.de, nhuck@google.com,
 gmazyland@gmail.com, elliott@hpe.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The primary use case for the feature is bare metal dm-crypt. The key
needs to be restored properly on wakeup, as dm-crypt does not prompt
for the key on resume from suspend. Even if the prompt performs for
unlocking the volume, where the hibernation image is stored, it still
expects to reuse the key handles within the hibernation image once it
is loaded.

== Wrapping-key Restore ==

So it is motivated to meet dm-crypt's expectation that the key handles
in the suspend-image remain valid after resume from an S-state. But,
when the system enters the ACPI S3 or S4 sleep states, the wrapping
key is discarded.

Key Locker provides a mechanism to back up the wrapping key in
non-volatile storage. So, request a backup right after the key is
loaded at boot time, and copy it back to each CPU upon wakeup. Then,
the entirety of Key Locker has to be disabled if the backup mechanism
is not available unless CONFIG_SUSPEND=n.

== Restore Failure ==

In the event of a key restore failure, the kernel proceeds with an
initialized wrapping key state. This has the effect of invalidating
any key handles that might be present in a suspend-image. When this
happens, dm-crypt will see I/O errors resulting from error returns
from crypto_skcipher_encrypt()/decrypt().

While this will disrupt operations in the current boot, data is not at
risk and access is restored with new handles created by the new
wrapping key at the next boot. Also, manage a feature-specific flag to
communicate with the crypto implementation. This ensures to stop using
the AES instructions upon the key restore failure while not turning
off the feature.

== Off-states ==

While the backup may be maintained in non-volatile media across S5 and
G3 "off" states, it is neither architecturally guaranteed nor it is
expected by dm-crypt as prompting for the key whenever the volume is
started. Then, a reboot can cover this case with a new wrapping key.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
---
Changes from v6:
* Limit the symbol export only when needed.
* Improve the coding style -- reduce an indent after
  'if() { ... return; }'. (Eric Biggers)
* Fix the coding style -- reduce an indent after if() {...return;}.
  (Eric Biggers) Tweak the comment along with that.
* Improve the function prototype, instead of using a macro. (Eric
  Biggers and Dave Hansen)
* Update the documentation:
  - Massage the changelog to clarify the problem-and-solution by
    sections
  - Clarify the comment about the key restore failure.

Changes from v5:
* Fix the 'valid_kl' flag not to be set when the feature is disabled.
  (Reported by Marvin Hsu marvin.hsu@intel.com) Add the function
  comment about this.
* Improve the error handling in setup_keylocker(). All the error cases
  fall through the end that disables the feature. Otherwise, all the
  successful cases return immediately.

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
 arch/x86/kernel/keylocker.c      | 136 ++++++++++++++++++++++++++++++-
 arch/x86/power/cpu.c             |   2 +
 3 files changed, 139 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 9040e10ab648..8621234c5897 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -32,9 +32,13 @@ struct iwkey {
 #ifdef CONFIG_X86_KEYLOCKER
 void setup_keylocker(struct cpuinfo_x86 *c);
 void destroy_keylocker_data(void);
+void restore_keylocker(void);
+extern bool valid_keylocker(void);
 #else
 static inline void setup_keylocker(struct cpuinfo_x86 *c) { }
 static inline void destroy_keylocker_data(void) { }
+static inline void restore_keylocker(void) { }
+static inline bool valid_keylocker(void) { return false; }
 #endif
 
 #endif /*__ASSEMBLY__ */
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index 038e5268e6b8..8f3acc34b6da 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -11,20 +11,48 @@
 #include <asm/fpu/api.h>
 #include <asm/keylocker.h>
 #include <asm/tlbflush.h>
+#include <asm/msr.h>
 
 static __initdata struct keylocker_setup_data {
+	bool initialized;
 	struct iwkey key;
 } kl_setup;
 
+/*
+ * This flag is set with wrapping key load. When the key restore
+ * fails, it is reset. This restore state is exported to the crypto
+ * library, then Key Locker will not be used there. So, the feature is
+ * soft-disabled with this flag.
+ */
+static bool valid_kl;
+
+bool valid_keylocker(void)
+{
+	return valid_kl;
+}
+#if IS_MODULE(CONFIG_CRYPTO_AES_KL)
+EXPORT_SYMBOL_GPL(valid_keylocker);
+#endif
+
 static void __init generate_keylocker_data(void)
 {
 	get_random_bytes(&kl_setup.key.integrity_key,  sizeof(kl_setup.key.integrity_key));
 	get_random_bytes(&kl_setup.key.encryption_key, sizeof(kl_setup.key.encryption_key));
 }
 
+/*
+ * This is invoked when the boot-up is finished, which means wrapping
+ * key is loaded. Then, the 'valid_kl' flag is set here as the feature
+ * is enabled.
+ */
 void __init destroy_keylocker_data(void)
 {
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
+		return;
+
 	memzero_explicit(&kl_setup.key, sizeof(kl_setup.key));
+	kl_setup.initialized = true;
+	valid_kl = true;
 }
 
 static void __init load_keylocker(void)
@@ -34,6 +62,27 @@ static void __init load_keylocker(void)
 	kernel_fpu_end();
 }
 
+/**
+ * copy_keylocker - Copy the wrapping key from the backup.
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
@@ -52,6 +101,7 @@ void __ref setup_keylocker(struct cpuinfo_x86 *c)
 
 	if (c == &boot_cpu_data) {
 		u32 eax, ebx, ecx, edx;
+		bool backup_available;
 
 		cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
 		/*
@@ -65,13 +115,53 @@ void __ref setup_keylocker(struct cpuinfo_x86 *c)
 			goto disable;
 		}
 
+		backup_available = !!(ebx & KEYLOCKER_CPUID_EBX_BACKUP);
+		/*
+		 * The wrapping key in CPU state is volatile in S3/4
+		 * states. So ensure the backup capability along with
+		 * S-states.
+		 */
+		if (!backup_available && IS_ENABLED(CONFIG_SUSPEND)) {
+			pr_debug("x86/keylocker: No key backup support with possible S3/4.\n");
+			goto disable;
+		}
+
 		generate_keylocker_data();
+		load_keylocker();
+
+		/* Backup a wrapping key in non-volatile media. */
+		if (backup_available)
+			wrmsrl(MSR_IA32_BACKUP_IWKEY_TO_PLATFORM, 1);
+
+		pr_info("x86/keylocker: Enabled.\n");
+		return;
 	}
 
-	load_keylocker();
+	/*
+	 * At boot time, the key is loaded directly from the memory.
+	 * Otherwise, this path performs the key recovery on each CPU
+	 * wake-up. Then, the backup in the platform-scoped state is
+	 * copied to the CPU state.
+	 */
+	if (!kl_setup.initialized) {
+		load_keylocker();
+		return;
+	} else if (valid_kl) {
+		int rc;
 
-	pr_info_once("x86/keylocker: Enabled.\n");
-	return;
+		rc = copy_keylocker();
+		if (!rc)
+			return;
+
+		/*
+		 * The key copy failed here. The subsequent feature
+		 * use will have inconsistent keys and failures. So,
+		 * invalidate the feature via the flag like with the
+		 * backup failure.
+		 */
+		valid_kl = false;
+		pr_err_once("x86/keylocker: Invalid copy status (rc: %d).\n", rc);
+	}
 
 disable:
 	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
@@ -80,3 +170,43 @@ void __ref setup_keylocker(struct cpuinfo_x86 *c)
 	/* Make sure the feature disabled for kexec-reboot. */
 	cr4_clear_bits(X86_CR4_KEYLOCKER);
 }
+
+/**
+ * restore_keylocker - Restore the wrapping key.
+ *
+ * The boot CPU executes this while other CPUs restore it through the
+ * setup function.
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
+	 * The IA32_IWKEYBACKUP_STATUS MSR contains a bitmap that
+	 * indicates an invalid backup if bit 0 is set and a read (or
+	 * write) error if bit 2 is set.
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
+	 * Now the backup key is not available. Invalidate the feature
+	 * via the flag to avoid any subsequent use. But keep the
+	 * feature with zeroed wrapping key instead of disabling it.
+	 */
+	pr_err("x86/keylocker: Failed to restore wrapping key.\n");
+	valid_kl = false;
+}
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 63230ff8cf4f..e99be45354cd 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -27,6 +27,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
 #include <asm/microcode.h>
+#include <asm/keylocker.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -264,6 +265,7 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	x86_platform.restore_sched_clock_state();
 	cache_bp_restore();
 	perf_restore_debug_store();
+	restore_keylocker();
 
 	c = &cpu_data(smp_processor_id());
 	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

