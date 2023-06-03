Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5B2C77B7A
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685806566;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kS/LdkOlPScm8InUd+KfBElcQkf+2cFb2wwOQJM4qXY=;
	b=Ossl2x7RFh6ywl5yW/qLkVvHjSBq6ibrPzZts/t4fzck4nwW1qQVp2OspbkNCZH3DbTUyj
	8t8ZqCrDJsuGfOUXsp76SO4fFb1jjU5eYvrCI5wOA0hlKXoSKFYWCVhaP282021d7UZGAt
	Z8W3u+nBfIWeSMS0dLgv2/6V1S5GCCI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-IngfFgcBORG3Efv-TSI_Hw-1; Sat, 03 Jun 2023 11:35:15 -0400
X-MC-Unique: IngfFgcBORG3Efv-TSI_Hw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6630101A59E;
	Sat,  3 Jun 2023 15:35:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18FB81410F25;
	Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D920019465A0;
	Sat,  3 Jun 2023 15:35:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFC091946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 15:35:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B00C22166B27; Sat,  3 Jun 2023 15:35:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A7BE32166B25
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75B7F3806623
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:05 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-GZTX6T5uM4uzhfnGS5k6ow-1; Sat, 03 Jun 2023 11:35:03 -0400
X-MC-Unique: GZTX6T5uM4uzhfnGS5k6ow-1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="356097299"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="356097299"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jun 2023 08:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="702274222"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="702274222"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga007.jf.intel.com with ESMTP; 03 Jun 2023 08:35:00 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 08:22:15 -0700
Message-Id: <20230603152227.12335-1-chang.seok.bae@intel.com>
In-Reply-To: <20230524165717.14062-1-chang.seok.bae@intel.com>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v8 00/12] x86: Support Key Locker
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

Posting V8 here, a brief status of this enabling:

The last two revisions trend to update the crypto code mainly. The
existing AEX-XTS code was improved further before being shared with
the new code. Then, the new implementation was tuned for the AES-XTS
mode which aligns with the claimed use case -- dm-crypt.

But, I'd say some additional change might be still needed.

The overall changes in charge of the last review:

  * PATCH12:
    - Clarify some documentation (Eric Biggers)
    - Simplify (Eric Biggers) and cleanup code

  * PATCH11:
    - Remove dead code.

  * PATCH10:
    - Deduplicate the alignment code (Eric Biggers)

The series can be found in this repo:
    git://github.com/intel-staging/keylocker.git kl-v8

The overall diff was populated in:
    https://raw.githubusercontent.com/intel-staging/keylocker/diff/kl-v8-vs-v7.diff

The feature is already available on recent Intel client systems. The
V3 cover letter covered the usage, the threat model and other details:
    https://lore.kernel.org/lkml/20211124200700.15888-1-chang.seok.bae@intel.com/

And the V6 cover followed up with updating the performance data:
    https://lore.kernel.org/lkml/20230410225936.8940-1-chang.seok.bae@intel.com/

V7 posting:
    https://lore.kernel.org/lkml/20230524165717.14062-1-chang.seok.bae@intel.com/

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
  crypto: x86/aes - Prepare for a new AES-XTS implementation
  crypto: x86/aes-kl - Implement the AES-XTS algorithm

 .../admin-guide/kernel-parameters.txt         |   2 +
 Documentation/arch/x86/index.rst              |   1 +
 Documentation/arch/x86/keylocker.rst          |  97 +++
 arch/x86/Kconfig                              |   3 +
 arch/x86/crypto/Kconfig                       |  22 +
 arch/x86/crypto/Makefile                      |   3 +
 arch/x86/crypto/aes-helper_asm.S              |  22 +
 arch/x86/crypto/aes-helper_glue.h             | 161 +++++
 arch/x86/crypto/aeskl-intel_asm.S             | 552 ++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c            | 188 ++++++
 arch/x86/crypto/aesni-intel_asm.S             |  55 +-
 arch/x86/crypto/aesni-intel_glue.c            | 241 +++-----
 arch/x86/crypto/aesni-intel_glue.h            |  16 +
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
 27 files changed, 1507 insertions(+), 211 deletions(-)
 create mode 100644 Documentation/arch/x86/keylocker.rst
 create mode 100644 arch/x86/crypto/aes-helper_asm.S
 create mode 100644 arch/x86/crypto/aes-helper_glue.h
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c
 create mode 100644 arch/x86/crypto/aesni-intel_glue.h
 create mode 100644 arch/x86/include/asm/keylocker.h
 create mode 100644 arch/x86/kernel/keylocker.c


base-commit: 054377e4774eee812b7930933d7a354ed5a7ddd6
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

