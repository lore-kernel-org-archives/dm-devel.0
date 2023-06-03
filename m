Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7558FC7EE2F
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685806521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K75DHYI/3nDB60DKK27Xn2K4f6ELKjCP6//nxK9K9jc=;
	b=VODH/L50gom2DqfoXZGrTX61lCL5wUzBM6sEFCwFYJkFJL8pY2OAZ4ORz1KlbZbfSYUNVb
	kMl9nss8N2NgdmJNdlUVURrAPveT/RVgDgi7YNbYP4e2QxSCfq4oZSIHdQnsE13w4x9fPw
	Jr7hfQK6kRdeOO1AIk/doAavFnS/g+g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-AsihTFhCMqOA-raqnANILA-1; Sat, 03 Jun 2023 11:35:17 -0400
X-MC-Unique: AsihTFhCMqOA-raqnANILA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91CA129A9D3D;
	Sat,  3 Jun 2023 15:35:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80790C154D7;
	Sat,  3 Jun 2023 15:35:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7098C19465B9;
	Sat,  3 Jun 2023 15:35:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E5391946F1D
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED91340C6CCC; Sat,  3 Jun 2023 15:35:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E632A40C6EC4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:11 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCDB53806623
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:11 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-1_y59uEEOhCsmU8m4H_PvQ-1; Sat, 03 Jun 2023 11:35:09 -0400
X-MC-Unique: 1_y59uEEOhCsmU8m4H_PvQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="356097497"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="356097497"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jun 2023 08:35:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="702274274"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="702274274"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga007.jf.intel.com with ESMTP; 03 Jun 2023 08:35:07 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 08:22:24 -0700
Message-Id: <20230603152227.12335-10-chang.seok.bae@intel.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v8 09/12] x86/cpu: Add a configuration and
 command line option for Key Locker
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, ardb@kernel.org, chang.seok.bae@intel.com,
 dave.hansen@linux.intel.com, dan.j.williams@intel.com, mingo@kernel.org,
 ebiggers@kernel.org, lalithambika.krishnakumar@intel.com,
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, charishma1.gairuboyina@intel.com,
 luto@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com,
 tglx@linutronix.de, nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add CONFIG_X86_KEYLOCKER to gate whether Key Locker is initialized at
boot. The option is selected by the Key Locker cipher module
CRYPTO_AES_KL (to be added in a later patch).

Add a new command line option "nokeylocker" to optionally override the
default CONFIG_X86_KEYLOCKER=y behavior.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v6:
* Rebase on the upstream: commit a894a8a56b57 ("Documentation:
  kernel-parameters: sort all "no..." parameters")

Changes from RFC v2:
* Make the option selected by CRYPTO_AES_KL. (Dan Williams)
* Massage the changelog and the config option description.
---
 Documentation/admin-guide/kernel-parameters.txt |  2 ++
 arch/x86/Kconfig                                |  3 +++
 arch/x86/kernel/cpu/common.c                    | 16 ++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c1247ec4589a..b42fc53cbcf9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3749,6 +3749,8 @@
 			kernel and module base offset ASLR (Address Space
 			Layout Randomization).
 
+	nokeylocker     [X86] Disable Key Locker hardware feature.
+
 	no-kvmapf	[X86,KVM] Disable paravirtualized asynchronous page
 			fault handling.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a98c5f82be48..f9788b477db1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1879,6 +1879,9 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_KEYLOCKER
+	bool
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5882ff6e3c6b..718ff1b1d6dd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -402,6 +402,22 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 static const unsigned long cr4_pinned_mask =
 	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
 	X86_CR4_FSGSBASE | X86_CR4_CET;
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

