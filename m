Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E09EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 08:09:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-MBnBHPXyNU6wFeS-w3Ch_Q-1; Thu, 13 Jan 2022 03:09:12 -0500
X-MC-Unique: MBnBHPXyNU6wFeS-w3Ch_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5867683DD27;
	Thu, 13 Jan 2022 08:09:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 371A11F2F9;
	Thu, 13 Jan 2022 08:09:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07CDF4A700;
	Thu, 13 Jan 2022 08:09:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CLKitM016066 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 16:20:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0A5854047281; Wed, 12 Jan 2022 21:20:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 069B44047272
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2C8B80A0AF
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:43 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-82-A4A36MIwOJiMjWYqwWBosQ-5; Wed, 12 Jan 2022 16:20:42 -0500
X-MC-Unique: A4A36MIwOJiMjWYqwWBosQ-5
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="244060320"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="244060320"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	12 Jan 2022 13:20:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="529378259"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
	by orsmga008.jf.intel.com with ESMTP; 12 Jan 2022 13:20:40 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, ebiggers@kernel.org, ardb@kernel.org,
	x86@kernel.org, luto@kernel.org, tglx@linutronix.de, bp@suse.de,
	dave.hansen@linux.intel.com, mingo@kernel.org
Date: Wed, 12 Jan 2022 13:12:53 -0800
Message-Id: <20220112211258.21115-8-chang.seok.bae@intel.com>
In-Reply-To: <20220112211258.21115-1-chang.seok.bae@intel.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 13 Jan 2022 03:08:37 -0500
Cc: ravi.v.shankar@intel.com, chang.seok.bae@intel.com,
	linux-kernel@vger.kernel.org, kumar.n.dwarakanath@intel.com,
	dan.j.williams@intel.com, charishma1.gairuboyina@intel.com
Subject: [dm-devel] [PATCH v5 07/12] x86/cpu/keylocker: Load an internal
	wrapping key at boot-time
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

The Internal Wrapping Key (IWKey) is an entity of Key Locker to encode a
clear text key into a key handle. This key is a pivot in protecting user
keys. So the value has to be randomized before being loaded in the
software-invisible CPU state.

IWKey needs to be established before the first user. Given that the only
proposed Linux use case for Key Locker is dm-crypt, the feature could be
lazily enabled when the first dm-crypt user arrives, but there is no
precedent for late enabling of CPU features and it adds maintenance burden
without demonstrative benefit outside of minimizing the visibility of
Key Locker to userspace.

The kernel generates random bytes and load them at boot time. These bytes
are flushed out immediately.

Setting the CR4.KL bit does not always enable the feature so ensure the
dynamic CPU bit (CPUID.AESKLE) is set before loading the key.

Given that the Linux Key Locker support is only intended for bare metal
dm-crypt consumption, and that switching IWKey per VM is untenable,
explicitly skip Key Locker setup in the X86_FEATURE_HYPERVISOR case.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v2:
* Make bare metal only.
* Clean up the code (e.g. dynamically allocate the key cache).
  (Dan Williams)
* Massage the changelog.
* Move out the LOADIWKEY wrapper and the Key Locker CPUID defines.

Note, Dan wonders that given that the only proposed Linux use case for
Key Locker is dm-crypt, the feature could be lazily enabled when the
first dm-crypt user arrives, but as Dave notes there is no precedent
for late enabling of CPU features and it adds maintenance burden
without demonstrative benefit outside of minimizing the visibility of
Key Locker to userspace.
---
 arch/x86/include/asm/keylocker.h |  9 ++++
 arch/x86/kernel/Makefile         |  1 +
 arch/x86/kernel/cpu/common.c     |  5 +-
 arch/x86/kernel/keylocker.c      | 79 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c        |  2 +
 5 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/keylocker.c

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index e85dfb6c1524..820ac29c06d9 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -5,6 +5,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/processor.h>
 #include <linux/bits.h>
 #include <asm/fpu/types.h>
 
@@ -28,5 +29,13 @@ struct iwkey {
 #define KEYLOCKER_CPUID_EBX_WIDE	BIT(2)
 #define KEYLOCKER_CPUID_EBX_BACKUP	BIT(4)
 
+#ifdef CONFIG_X86_KEYLOCKER
+void setup_keylocker(struct cpuinfo_x86 *c);
+void destroy_keylocker_data(void);
+#else
+#define setup_keylocker(c) do { } while (0)
+#define destroy_keylocker_data() do { } while (0)
+#endif
+
 #endif /*__ASSEMBLY__ */
 #endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2ff3e600f426..e15efa238497 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -144,6 +144,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_SCHED_MC_PRIO)		+= itmt.o
 obj-$(CONFIG_X86_UMIP)			+= umip.o
+obj-$(CONFIG_X86_KEYLOCKER)		+= keylocker.o
 
 obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0083464de5e3..23b4aa437c1e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -57,6 +57,8 @@
 #include <asm/microcode_intel.h>
 #include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
+#include <asm/keylocker.h>
+
 #include <asm/uv/uv.h>
 #include <asm/sigframe.h>
 
@@ -1595,10 +1597,11 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
 
-	/* Set up SMEP/SMAP/UMIP */
+	/* Setup various Intel-specific CPU security features */
 	setup_smep(c);
 	setup_smap(c);
 	setup_umip(c);
+	setup_keylocker(c);
 
 	/* Enable FSGSBASE instructions if available. */
 	if (cpu_has(c, X86_FEATURE_FSGSBASE)) {
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
new file mode 100644
index 000000000000..87d775a65716
--- /dev/null
+++ b/arch/x86/kernel/keylocker.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Setup Key Locker feature and support internal wrapping key
+ * management.
+ */
+
+#include <linux/random.h>
+#include <linux/poison.h>
+
+#include <asm/fpu/api.h>
+#include <asm/keylocker.h>
+#include <asm/tlbflush.h>
+
+static __initdata struct keylocker_setup_data {
+	struct iwkey key;
+} kl_setup;
+
+static void __init generate_keylocker_data(void)
+{
+	get_random_bytes(&kl_setup.key.integrity_key,  sizeof(kl_setup.key.integrity_key));
+	get_random_bytes(&kl_setup.key.encryption_key, sizeof(kl_setup.key.encryption_key));
+}
+
+void __init destroy_keylocker_data(void)
+{
+	memset(&kl_setup.key, KEY_DESTROY, sizeof(kl_setup.key));
+}
+
+static void __init load_keylocker(void)
+{
+	kernel_fpu_begin();
+	load_xmm_iwkey(&kl_setup.key);
+	kernel_fpu_end();
+}
+
+/**
+ * setup_keylocker - Enable the feature.
+ * @c:		A pointer to struct cpuinfo_x86
+ */
+void __ref setup_keylocker(struct cpuinfo_x86 *c)
+{
+	/* This feature is not compatible with a hypervisor. */
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER) ||
+	    cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		goto out;
+
+	cr4_set_bits(X86_CR4_KEYLOCKER);
+
+	if (c == &boot_cpu_data) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+		/*
+		 * Check the feature readiness via CPUID. Note that the
+		 * CPUID AESKLE bit is conditionally set only when CR4.KL
+		 * is set.
+		 */
+		if (!(ebx & KEYLOCKER_CPUID_EBX_AESKLE) ||
+		    !(eax & KEYLOCKER_CPUID_EAX_SUPERVISOR)) {
+			pr_debug("x86/keylocker: Not fully supported.\n");
+			goto disable;
+		}
+
+		generate_keylocker_data();
+	}
+
+	load_keylocker();
+
+	pr_info_once("x86/keylocker: Enabled.\n");
+	return;
+
+disable:
+	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
+	pr_info_once("x86/keylocker: Disabled.\n");
+out:
+	/* Make sure the feature disabled for kexec-reboot. */
+	cr4_clear_bits(X86_CR4_KEYLOCKER);
+}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 617012f4619f..00cfa64948f5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -82,6 +82,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/hw_irq.h>
 #include <asm/stackprotector.h>
+#include <asm/keylocker.h>
 
 #ifdef CONFIG_ACPI_CPPC_LIB
 #include <acpi/cppc_acpi.h>
@@ -1489,6 +1490,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	nmi_selftest();
 	impress_friends();
 	mtrr_aps_init();
+	destroy_keylocker_data();
 }
 
 static int __initdata setup_possible_cpus = -1;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

