Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1E3C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 08:09:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-fEoa21vYNi2gTmZBVEe7aA-1; Thu, 13 Jan 2022 03:09:06 -0500
X-MC-Unique: fEoa21vYNi2gTmZBVEe7aA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E06A083DD22;
	Thu, 13 Jan 2022 08:09:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCB1A5E49A;
	Thu, 13 Jan 2022 08:09:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8C73F4CA9B;
	Thu, 13 Jan 2022 08:09:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CLKgKh016051 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 16:20:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B40D62166B4F; Wed, 12 Jan 2022 21:20:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF2FB2166B44
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68633805F4A
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:39 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-82-krkKhBE3Pq6KqbW8Ol2iGw-1; Wed, 12 Jan 2022 16:20:37 -0500
X-MC-Unique: krkKhBE3Pq6KqbW8Ol2iGw-1
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="244060306"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="244060306"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	12 Jan 2022 13:20:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="529378212"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
	by orsmga008.jf.intel.com with ESMTP; 12 Jan 2022 13:20:35 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, ebiggers@kernel.org, ardb@kernel.org,
	x86@kernel.org, luto@kernel.org, tglx@linutronix.de, bp@suse.de,
	dave.hansen@linux.intel.com, mingo@kernel.org
Date: Wed, 12 Jan 2022 13:12:46 -0800
Message-Id: <20220112211258.21115-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 13 Jan 2022 03:08:37 -0500
Cc: ravi.v.shankar@intel.com, chang.seok.bae@intel.com,
	linux-kernel@vger.kernel.org, kumar.n.dwarakanath@intel.com,
	dan.j.williams@intel.com, charishma1.gairuboyina@intel.com
Subject: [dm-devel] [PATCH v5 00/12] x86: Support Key Locker
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Changes from v4 [1]:
* Drop CBC mode support (PATCH10). (Eric Biggers)
* Update the changelog (PATCH8). (Rafael Wysocki)

A couple of other things outside of these patches are still in progress:
* Support DM-crypt/cryptsetup for Key Locker usage (Andy Lutomirski)
  [2].
* Understand decryption under-performance (Eric Biggers and Milan Broz)
  [3][4].

This feature's usage for the threat model can be found in the previous
cover letter [1]. This version is based on 5.16.

Thanks,
Chang

[1] V4: https://lore.kernel.org/lkml/20211214005212.20588-1-chang.seok.bae@intel.com/
[2] https://lore.kernel.org/lkml/75ec3ad1-6234-ae1f-1b83-482793e4fd23@kernel.org/
[3] https://lore.kernel.org/lkml/YbqRseO+TtuGQk5x@sol.localdomain/
[4] https://lore.kernel.org/lkml/120368dc-e337-9176-936c-4db2a8bf710e@gmail.com/

Chang S. Bae (12):
  Documentation/x86: Document Key Locker
  x86/cpufeature: Enumerate Key Locker feature
  x86/insn: Add Key Locker instructions to the opcode map
  x86/asm: Add a wrapper function for the LOADIWKEY instruction
  x86/msr-index: Add MSRs for Key Locker internal wrapping key
  x86/keylocker: Define Key Locker CPUID leaf
  x86/cpu/keylocker: Load an internal wrapping key at boot-time
  x86/PM/keylocker: Restore internal wrapping key on resume from ACPI
    S3/4
  x86/cpu: Add a configuration and command line option for Key Locker
  crypto: x86/aes - Prepare for a new AES implementation
  crypto: x86/aes-kl - Support AES algorithm using Key Locker
    instructions
  crypto: x86/aes-kl - Support XTS mode

 .../admin-guide/kernel-parameters.txt         |   2 +
 Documentation/x86/index.rst                   |   1 +
 Documentation/x86/keylocker.rst               |  98 +++
 arch/x86/Kconfig                              |   3 +
 arch/x86/crypto/Makefile                      |   5 +-
 arch/x86/crypto/aes-intel_asm.S               |  26 +
 arch/x86/crypto/aes-intel_glue.c              | 125 ++++
 arch/x86/crypto/aes-intel_glue.h              |  48 ++
 arch/x86/crypto/aeskl-intel_asm.S             | 633 ++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c            | 216 ++++++
 arch/x86/crypto/aesni-intel_asm.S             |  58 +-
 arch/x86/crypto/aesni-intel_glue.c            | 239 ++-----
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
 arch/x86/kernel/keylocker.c                   | 199 ++++++
 arch/x86/kernel/smpboot.c                     |   2 +
 arch/x86/lib/x86-opcode-map.txt               |  11 +-
 arch/x86/power/cpu.c                          |   2 +
 crypto/Kconfig                                |  36 +
 tools/arch/x86/lib/x86-opcode-map.txt         |  11 +-
 28 files changed, 1633 insertions(+), 216 deletions(-)
 create mode 100644 Documentation/x86/keylocker.rst
 create mode 100644 arch/x86/crypto/aes-intel_asm.S
 create mode 100644 arch/x86/crypto/aes-intel_glue.c
 create mode 100644 arch/x86/crypto/aes-intel_glue.h
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c
 create mode 100644 arch/x86/crypto/aesni-intel_glue.h
 create mode 100644 arch/x86/include/asm/keylocker.h
 create mode 100644 arch/x86/kernel/keylocker.c


base-commit: df0cc57e057f18e44dac8e6c18aba47ab53202f9
--
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

