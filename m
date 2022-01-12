Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 679B7C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 08:09:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-iSIR3CQ5NfKx3b9InqE0mQ-1; Thu, 13 Jan 2022 03:09:14 -0500
X-MC-Unique: iSIR3CQ5NfKx3b9InqE0mQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63D151083F68;
	Thu, 13 Jan 2022 08:09:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 493D35F91A;
	Thu, 13 Jan 2022 08:09:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BBC51806D2C;
	Thu, 13 Jan 2022 08:09:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CLKjPI016079 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 16:20:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E63714047281; Wed, 12 Jan 2022 21:20:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E1EF34047272
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB2A9185A7B4
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:44 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-82-wc27O7jwOpi2cegZOG7gHw-6; Wed, 12 Jan 2022 16:20:43 -0500
X-MC-Unique: wc27O7jwOpi2cegZOG7gHw-6
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="244060326"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="244060326"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	12 Jan 2022 13:20:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="529378272"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
	by orsmga008.jf.intel.com with ESMTP; 12 Jan 2022 13:20:41 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, ebiggers@kernel.org, ardb@kernel.org,
	x86@kernel.org, luto@kernel.org, tglx@linutronix.de, bp@suse.de,
	dave.hansen@linux.intel.com, mingo@kernel.org
Date: Wed, 12 Jan 2022 13:12:55 -0800
Message-Id: <20220112211258.21115-10-chang.seok.bae@intel.com>
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
Cc: ravi.v.shankar@intel.com, linux-doc@vger.kernel.org,
	chang.seok.bae@intel.com, linux-kernel@vger.kernel.org,
	kumar.n.dwarakanath@intel.com, dan.j.williams@intel.com,
	charishma1.gairuboyina@intel.com
Subject: [dm-devel] [PATCH v5 09/12] x86/cpu: Add a configuration and
	command line option for Key Locker
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add CONFIG_X86_KEYLOCKER to gate whether Key Locker is initialized at boot.
The option is selected by the Key Locker cipher module CRYPTO_AES_KL (to be
added in a later patch).

Add a new command line option "nokeylocker" to optionally override the
default CONFIG_X86_KEYLOCKER=y behavior.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v2:
* Make the option selected by CRYPTO_AES_KL. (Dan Williams)
* Massage the changelog and the config option description.
---
 Documentation/admin-guide/kernel-parameters.txt |  2 ++
 arch/x86/Kconfig                                |  3 +++
 arch/x86/kernel/cpu/common.c                    | 16 ++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2fba82431efb..30ed18fbdea3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3405,6 +3405,8 @@
 
 	nohugevmalloc	[PPC] Disable kernel huge vmalloc mappings.
 
+	nokeylocker	[X86] Disable Key Locker hardware feature.
+
 	nosmt		[KNL,S390] Disable symmetric multithreading (SMT).
 			Equivalent to smt=1.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5c2ccb85f2ef..191bd4a941eb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1864,6 +1864,9 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_KEYLOCKER
+	bool
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 23b4aa437c1e..db1fc9ff0fe3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -364,6 +364,22 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 /* These bits should not change their value after CPU init is finished. */
 static const unsigned long cr4_pinned_mask =
 	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP | X86_CR4_FSGSBASE;
+
+static __init int x86_nokeylocker_setup(char *arg)
+{
+	/* Expect an exact match without trailing characters. */
+	if (strlen(arg))
+		return 0;
+
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
+		return 1;
+
+	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
+	pr_info("x86/keylocker: Disabled by kernel command line.\n");
+	return 1;
+}
+__setup("nokeylocker", x86_nokeylocker_setup);
+
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

