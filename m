Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981B3C77B6F
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195468;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5qLeDSRPMFo8LED/9fWtTwWmsCMpGOHnZyBJkTnyy8I=;
	b=MsIbeJ1U+eUu4AzeCX3Y9iUYAQtQPXVSMW6M4hoEZG8VvpMaYxfnhptdEOkrYBcUs6xqdH
	b7L7TCnnvMc6VEWsgNubbcatE1ZzcqXSK5XoWRdqBP4FIA94LSOtgZPCiqLLkjjlLI6H3S
	i1QIUuoTr36llCofxxkPlqQEZHjMr/k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-5Id-g03CM4eef08GVPWkDQ-1; Tue, 11 Apr 2023 02:44:27 -0400
X-MC-Unique: 5Id-g03CM4eef08GVPWkDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A10B685C075;
	Tue, 11 Apr 2023 06:44:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8EF40C15BA0;
	Tue, 11 Apr 2023 06:44:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19B1219472C6;
	Tue, 11 Apr 2023 06:44:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A1C91946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Apr 2023 23:12:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58B73112132D; Mon, 10 Apr 2023 23:12:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51C2C1121320
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 23:12:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 330B3885620
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 23:12:44 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-3t8kpD9MMDOO3h91duOtOg-1; Mon, 10 Apr 2023 19:12:42 -0400
X-MC-Unique: 3t8kpD9MMDOO3h91duOtOg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="340962485"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; d="scan'208";a="340962485"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 Apr 2023 16:11:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="757607987"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; d="scan'208";a="757607987"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by fmsmga004.fm.intel.com with ESMTP; 10 Apr 2023 16:11:38 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Mon, 10 Apr 2023 15:59:24 -0700
Message-Id: <20230410225936.8940-1-chang.seok.bae@intel.com>
In-Reply-To: <20220112211258.21115-1-chang.seok.bae@intel.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 00/12] x86: Support Key Locker
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
 lalithambika.krishnakumar@intel.com, luto@kernel.org, bernie.keany@intel.com,
 tglx@linutronix.de, bp@suse.de, gmazyland@gmail.com,
 charishma1.gairuboyina@intel.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

This feature enabling has been stalled due to the decryption
performance issue which took a while to result in a solution. There
was also a question on the userspace utility -- cryptsetup [6].

As posting this version, I wanted to make sure the resolutions are
acknowledgeable with these updates, at first:

* People identified a gap between encryption and decryption speeds
  [1, 2]. Intel has identified the root cause and will make a fix
  available. The fix will ensure that the encryption and decryption
  speeds are comparable with each other.

  This fix requires a microcode update and will go through a formal
  process of release toward the end of the year. As of now, listed
  below are the expected numbers [10] when the issue is fixed. Intel
  will provide the latest information on the request.

  +---------------------------+---------------+-----------------+
  |       Cipher              |   Encryption  |   Decryption    |
  |      (AES-XTS)            |    (MiB/s)    |   (MiB/s)       |
  +===========================+===============+=================+
  | Microcode version (0xa4)  |     1726.5    |      776.3      |
  +---------------------------+---------------+-----------------+
  | With the potential fix    |     2308.7    |     2305.9      |
  +---------------------------+---------------+-----------------+

  The benchmark results came from:
    $ cryptsetup benchmark -c aes-xts -s 256
  which are approximate using memory only (no storage IO).

  The fix is specific to the CPU model [8] which was measured when
  posting v3 [4]. Here is another results from the latest CPU [9]:

  +--------------+---------------+-----------------+
  | Cipher       |   Encryption  |   Decryption    |
  | (AES-XTS)    |    (MiB/s)    |   (MiB/s)       |
  +==============+===============+=================+
  | AES-NI       |     6738.7    |     6851.7      |
  +--------------+---------------+-----------------+
  | AES-KL       |     3425.4    |     3431.7      |
  +--------------+---------------+-----------------+

* Andy questioned the cryptsetup readiness to edit the cipher mode,
  e.g. AES-KL to AES-NI, for decrypting a keylocker-encrypted volume
  on non-keylocker systems [3].

  The cryptsetup changes were prototyped as a proof-of-concept. The
  code and test details can be found in this repository:

    git://github.com/intel-staging/keylocker.git cryptsetup

  Once the enabling code is accepted in the mainline, I will follow-up
  with the DM-crypt [7] folks to add this ability.

The feature is already available on recent Intel client systems. Its
usage along with the threat model and other details can be found in
the v3 cover letter [4].

The code has some updates from the last posting [5]:

- Fix the 'valid_kl' flag not to be set when the feature is disabled.
  This was reported by Marvin Hsu <marvin.hsu@intel.com>. Add the
  function comment about this. (Patch8)
- Improve the error handling in setup_keylocker(). All the error
  cases fall through the end that disables the feature. Otherwise,
  all the successful cases return immediately. (Patch8)
- Call out when disabling the feature on virtual machines. (Patch7)
- Ensure kernel_fpu_end() for the possible error (Patch10)
- Rebased on the upstream -- use the RET macro (Patch11/12)
- Clean up dead code -- cbc_crypt_common() (Patch10)
- Fix a typo (Patch1)

This series is based on the tip tree. The code is also available in
this repository:

  git://github.com/intel-staging/keylocker.git kl

Thanks to Charishma Gairuboyina and Lalithambika Krishnakumar for the
help to update the performance results.

Thanks,
Chang

[1]  https://lore.kernel.org/lkml/YbqRseO+TtuGQk5x@sol.localdomain/
[2]  https://lore.kernel.org/lkml/120368dc-e337-9176-936c-4db2a8bf710e@gmail.com/
[3]  https://lore.kernel.org/lkml/75ec3ad1-6234-ae1f-1b83-482793e4fd23@kernel.org/
[4]  v3: https://lore.kernel.org/lkml/20211124200700.15888-1-chang.seok.bae@intel.com/
[5]  v5: https://lore.kernel.org/lkml/20220112211258.21115-1-chang.seok.bae@intel.com/
[6]  cryptsetup: https://gitlab.com/cryptsetup/cryptsetup
[7]  DM-crypt: https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/dm-crypt.html
[8]  Tiger Lake:
     https://www.intel.com/content/www/us/en/products/docs/processors/embedded/11th-gen-product-brief.html
[9]  Raptor Lake:
     https://www.intel.com/content/www/us/en/newsroom/resources/13th-gen-core.html
[10] Intel publishes information about product performance at
     https://www.Intel.com/PerformanceIndex

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
 arch/x86/crypto/aes-intel_glue.c              | 127 ++++
 arch/x86/crypto/aes-intel_glue.h              |  44 ++
 arch/x86/crypto/aeskl-intel_asm.S             | 633 ++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c            | 216 ++++++
 arch/x86/crypto/aesni-intel_asm.S             |  58 +-
 arch/x86/crypto/aesni-intel_glue.c            | 235 ++-----
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
 arch/x86/kernel/keylocker.c                   | 212 ++++++
 arch/x86/kernel/smpboot.c                     |   2 +
 arch/x86/lib/x86-opcode-map.txt               |  11 +-
 arch/x86/power/cpu.c                          |   2 +
 crypto/Kconfig                                |  36 +
 tools/arch/x86/lib/x86-opcode-map.txt         |  11 +-
 28 files changed, 1642 insertions(+), 214 deletions(-)
 create mode 100644 Documentation/x86/keylocker.rst
 create mode 100644 arch/x86/crypto/aes-intel_asm.S
 create mode 100644 arch/x86/crypto/aes-intel_glue.c
 create mode 100644 arch/x86/crypto/aes-intel_glue.h
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c
 create mode 100644 arch/x86/crypto/aesni-intel_glue.h
 create mode 100644 arch/x86/include/asm/keylocker.h
 create mode 100644 arch/x86/kernel/keylocker.c


base-commit: b2e7ae549d84c654744bf70d30a881bfa140a6e3
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

