Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A406C7EE2E
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684948229;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t9g0NdKzq5vOrsYgaUwLN9iYW2DtVuqyPLLVqd7tK2U=;
	b=Gj/OkXKaPSqf1T18VeFyTjtk2pwWxwOTrxsHCYeosG+s/S1h9+MqIDfTUgOFQFNV7EiFPp
	Ndm7eE2kN8PdXE5/50fJcN2LAO3/NLOK5Kh0kQ2/BQYcZIc3T7enuz9Q4IU9mBNyINlU3c
	j3Boa+4kQ45MjuFzjmlaVQd2AB2SuDo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-bmebiRGEMpmosuncVCNVsw-1; Wed, 24 May 2023 13:10:26 -0400
X-MC-Unique: bmebiRGEMpmosuncVCNVsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F37D6800159;
	Wed, 24 May 2023 17:10:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7EC07AF5;
	Wed, 24 May 2023 17:10:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A61CF19465A8;
	Wed, 24 May 2023 17:10:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7AE0019465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 17:10:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AD9C140E95D; Wed, 24 May 2023 17:10:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 629F8140E962
 for <dm-devel@redhat.com>; Wed, 24 May 2023 17:10:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46E303806703
 for <dm-devel@redhat.com>; Wed, 24 May 2023 17:10:22 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-jINXp5t3Me6W9KASh15_Lg-1; Wed, 24 May 2023 13:10:18 -0400
X-MC-Unique: jINXp5t3Me6W9KASh15_Lg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="338206642"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; d="scan'208";a="338206642"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 May 2023 10:09:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="704427331"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; d="scan'208";a="704427331"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga002.jf.intel.com with ESMTP; 24 May 2023 10:09:49 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Wed, 24 May 2023 09:57:05 -0700
Message-Id: <20230524165717.14062-1-chang.seok.bae@intel.com>
In-Reply-To: <20230410225936.8940-1-chang.seok.bae@intel.com>
References: <20230410225936.8940-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v7 00/12] x86: Support Key Locker
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, ardb@kernel.org,
 chang.seok.bae@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, bp@alien8.de,
 charishma1.gairuboyina@intel.com, luto@kernel.org, bernie.keany@intel.com,
 tglx@linutronix.de, nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

The previous posting [v6] was intended to deliver the hardware
performance update primarily by revamping the old series. Then,
multiple feedbacks were received. This revision thus incorporates the
changes to address them. So, the primary goal here is to meet those
reviewers' expectations at first.

The series has two parts of changes -- the x86 core and its crypto
library. In this revision, much more changes were made on the latter.
Also, overall changelogs were revisited to be more reviewable.

Here is the overview of those feedbacks/changes (skip some trivial):

Part 1. Crypto Library (PATCH10-12):

  PATCH12: AES-KL driver
  - Merge all the AES-KL patches. (Eric Biggers)
  - Make the driver for the 64-bit mode only. (Eric Biggers)
  - Rework the key-size check code (Eric Biggers)
  - Adjust the Kconfig change (Robert Elliott)
  - Update the changelog. (Eric Biggers)
  - Adjust the ASM code to return a proper error code. (Eric Biggers)

  PATCH11: AES-NI rework
  - Inline the helper code to avoid the indirect call. (Eric Biggers)
  - Rename the filename: aes-intel* -> aes-helper*. (Eric Biggers)
  - Don't export symbols yet here. Instead, do it when needed later.
  - Improve the coding style (Eric Biggers)

  PATCH10: the AESNI-XTS field type fix
  - Add as a new patch. (Eric Biggers)

Part 2. The X86 Core (PATCH1-9):

  PATCH09: a chicken bit and a Kconfig option
  - Rebase on the upstream: commit a894a8a56b57 ("Documentation:
    kernel-parameters: sort all "no..." parameters")

  PATCH08: the wrapping key recovery
  - Limit the symbol export only when needed.

  PATCH07: the wrapping key load at boot-time
  - Use memzero_explicit() instead of memset(). (Robert Elliott)
  - Improve the function prototype. (Eric Biggers and Dave Hansen)

  PATCH01: documentation
  - Rebase on the upstream -- commit ff61f0791ce9 ("docs: move x86
    documentation into Documentation/arch/"). (Nathan Huckleberry)

This version can be also found here:
    git://github.com/intel-staging/keylocker.git kl-v7

[v6] -- the last posting:
    https://lore.kernel.org/lkml/20230410225936.8940-1-chang.seok.bae@intel.com/

Thanks,
Chang

Chang S. Bae (12):
  Documentation/x86: Document Key Locker
  x86/cpufeature: Enumerate Key Locker feature
  x86/insn: Add Key Locker instructions to the opcode map
  x86/asm: Add a wrapper function for the LOADIWKEY instruction
  x86/msr-index: Add MSRs for Key Locker wrapping key
  x86/keylocker: Define Key Locker CPUID leaf
  x86/cpu/keylocker: Load a wrapping key at boot-time
  x86/PM/keylocker: Restore the wrapping key on the resume from ACPI
    S3/4
  x86/cpu: Add a configuration and command line option for Key Locker
  crypto: x86/aesni - Use the proper data type in struct aesni_xts_ctx
  crypto: x86/aes - Prepare for a new AES implementation
  crypto: x86/aes-kl - Implement the AES-XTS algorithm

 .../admin-guide/kernel-parameters.txt         |   2 +
 Documentation/arch/x86/index.rst              |   1 +
 Documentation/arch/x86/keylocker.rst          |  97 +++
 arch/x86/Kconfig                              |   3 +
 arch/x86/crypto/Kconfig                       |  22 +
 arch/x86/crypto/Makefile                      |   3 +
 arch/x86/crypto/aes-helper_asm.S              |  22 +
 arch/x86/crypto/aes-helper_glue.h             | 161 +++++
 arch/x86/crypto/aeskl-intel_asm.S             | 580 ++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c            | 216 +++++++
 arch/x86/crypto/aesni-intel_asm.S             |  55 +-
 arch/x86/crypto/aesni-intel_glue.c            | 242 +++-----
 arch/x86/crypto/aesni-intel_glue.h            |  17 +
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/keylocker.h              |  45 ++
 arch/x86/include/asm/msr-index.h              |   6 +
 arch/x86/include/asm/special_insns.h          |  32 +
 arch/x86/include/uapi/asm/processor-flags.h   |   2 +
 arch/x86/kernel/Makefile                      |   1 +
 arch/x86/kernel/cpu/common.c                  |  21 +-
 arch/x86/kernel/cpu/cpuid-deps.c              |   1 +
 arch/x86/kernel/keylocker.c                   | 212 +++++++
 arch/x86/kernel/smpboot.c                     |   2 +
 arch/x86/lib/x86-opcode-map.txt               |  11 +-
 arch/x86/power/cpu.c                          |   2 +
 tools/arch/x86/lib/x86-opcode-map.txt         |  11 +-
 27 files changed, 1573 insertions(+), 203 deletions(-)
 create mode 100644 Documentation/arch/x86/keylocker.rst
 create mode 100644 arch/x86/crypto/aes-helper_asm.S
 create mode 100644 arch/x86/crypto/aes-helper_glue.h
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c
 create mode 100644 arch/x86/crypto/aesni-intel_glue.h
 create mode 100644 arch/x86/include/asm/keylocker.h
 create mode 100644 arch/x86/kernel/keylocker.c


base-commit: 3a128547bd4425cdef27c606efc88e1eb03a2dba
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

