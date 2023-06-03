Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EBCC7EE29
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685806520;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wzElLeKdMhRzl0XQqAH30NinA6T4RnFWN/UujMZ/8Hg=;
	b=P6SFL6uMqoPJmISxGZHjD+Zke0xahgHxFamTg5Z2meeobfM6g8yWfBcD1BOorXj8bRs6Mt
	A/gs84k5nlaj2pN6Ur7gVe73bmsaLkF2oeN4K0Sw+hSuFmxgA/mIsShfFVwZWWRg69ExUb
	Huv23FPwJzfsraZinc3sCjJNtT5dVCA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-EShTUrJsNb6v59ulSXiDHg-1; Sat, 03 Jun 2023 11:35:17 -0400
X-MC-Unique: EShTUrJsNb6v59ulSXiDHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08D2C800888;
	Sat,  3 Jun 2023 15:35:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA2A6407DEC0;
	Sat,  3 Jun 2023 15:35:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2AF991946F18;
	Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D5B7419466DF
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 15:35:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C291753BB; Sat,  3 Jun 2023 15:35:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BACFF7AE4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96E87802E58
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:09 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-KM-A9lADOd2dj-XtDUNPSQ-2; Sat, 03 Jun 2023 11:35:05 -0400
X-MC-Unique: KM-A9lADOd2dj-XtDUNPSQ-2
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="356097308"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="356097308"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jun 2023 08:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="702274230"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="702274230"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga007.jf.intel.com with ESMTP; 03 Jun 2023 08:35:01 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 08:22:16 -0700
Message-Id: <20230603152227.12335-2-chang.seok.bae@intel.com>
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
Subject: [dm-devel] [PATCH v8 01/12] Documentation/x86: Document Key Locker
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Document the overview of the feature along with relevant consideration
when provisioning dm-crypt volumes with AES-KL instead of AES-NI.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: x86@kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v6:
* Rebase on the upstream -- commit ff61f0791ce9 ("docs: move x86
  documentation into Documentation/arch/"). (Nathan Huckleberry)
* Remove a duplicated sentence -- 'But there is no AES-KL instruction
  to process a 192-bit key.'
* Update the text for clarity and readability:
  - Clarify the error code and exemplify the backup failure
  - Use 'wrapping key' instead of less readable 'IWKey'

Changes from v5:
* Fix a typo: 'feature feature' -> 'feature'

Changes from RFC v2:
* Add as a new patch.

The preview is available here:
  https://htmlpreview.github.io/?https://github.com/intel-staging/keylocker/kdoc/arch/x86/keylocker.html
---
 Documentation/arch/x86/index.rst     |  1 +
 Documentation/arch/x86/keylocker.rst | 97 ++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 Documentation/arch/x86/keylocker.rst

diff --git a/Documentation/arch/x86/index.rst b/Documentation/arch/x86/index.rst
index c73d133fd37c..256359c24669 100644
--- a/Documentation/arch/x86/index.rst
+++ b/Documentation/arch/x86/index.rst
@@ -42,3 +42,4 @@ x86-specific Documentation
    features
    elf_auxvec
    xstate
+   keylocker
diff --git a/Documentation/arch/x86/keylocker.rst b/Documentation/arch/x86/keylocker.rst
new file mode 100644
index 000000000000..5557b8d0659a
--- /dev/null
+++ b/Documentation/arch/x86/keylocker.rst
@@ -0,0 +1,97 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+x86 Key Locker
+==============
+
+Introduction
+============
+
+Key Locker is a CPU feature to reduce key exfiltration opportunities
+while maintaining a programming interface similar to AES-NI. It
+converts the AES key into an encoded form, called the 'key handle'.
+The key handle is a wrapped version of the clear-text key where the
+wrapping key has limited exposure. Once converted, all subsequent data
+encryption using new AES instructions (AES-KL) uses this key handle,
+reducing the exposure of private key material in memory.
+
+CPU-internal Wrapping Key
+=========================
+
+The CPU-internal wrapping key is an entity in a software-invisible CPU
+state. On every system boot, a new key is loaded. So the key handle that
+was encoded by the old wrapping key is no longer usable on system shutdown
+or reboot.
+
+And the key may be lost on the following exceptional situation upon wakeup:
+
+Wrapping Key Restore Failure
+----------------------------
+
+The CPU state is volatile with the ACPI S3/4 sleep states. When the system
+supports those states, the key has to be backed up so that it is restored
+on wake up. The kernel saves the key in non-volatile media.
+
+The event of a wrapping key restore failure upon resume from suspend, all
+established key handles become invalid. In flight dm-crypt operations
+receive error results from pending operations. In the likely scenario that
+dm-crypt is hosting the root filesystem the recovery is identical to if a
+storage controller failed to resume from suspend, reboot. If the volume
+impacted by a wrapping key restore failure is a data-volume then it is
+possible that I/O errors on that volume do not bring down the rest of the
+system. However, a reboot is still required because the kernel will have
+soft-disabled Key Locker. Upon the failure, the crypto library code will
+return -ENODEV on every AES-KL function call. The Key Locker implementation
+only loads a new wrapping key at initial boot, not any time after like
+resume from suspend.
+
+Use Case and Non-use Cases
+==========================
+
+Bare metal disk encryption is the only intended use case.
+
+Userspace usage is not supported because there is no ABI provided to
+communicate and coordinate wrapping-key restore failure to userspace. For
+now, key restore failures are only coordinated with kernel users. But the
+kernel can not prevent userspace from using the feature's AES instructions
+('AES-KL') when the feature has been enabled. So, the lack of userspace
+support is only documented, not actively enforced.
+
+Key Locker is not expected to be advertised to guest VMs and the kernel
+implementation ignores it even if the VMM enumerates the capability. The
+expectation is that a guest VM wants private wrapping key state, but the
+architecture does not provide that. An emulation of that capability, by
+caching per-VM wrapping keys in memory, defeats the purpose of Key Locker.
+The backup / restore facility is also not performant enough to be suitable
+for guest VM context switches.
+
+AES Instruction Set
+===================
+
+The feature accompanies a new AES instruction set. This instruction set is
+analogous to AES-NI. A set of AES-NI instructions can be mapped to an
+AES-KL instruction. For example, AESENC128KL is responsible for ten rounds
+of transformation, which is equivalent to nine times AESENC and one
+AESENCLAST in AES-NI.
+
+But they have some notable differences:
+
+* AES-KL provides a secure data transformation using an encrypted key.
+
+* If an invalid key handle is provided, e.g. a corrupted one or a handle
+  restriction failure, the instruction fails with setting RFLAGS.ZF. The
+  crypto library implementation includes the flag check to return -EINVAL.
+  Note that this flag is also set if the wrapping key is changed, e.g.,
+  because of the backup error.
+
+* AES-KL implements support for 128-bit and 256-bit keys, but there is no
+  AES-KL instruction to process an 192-bit key. The AES-KL cipher
+  implementation logs a warning message with a 192-bit key and then falls
+  back to AES-NI. So, this 192-bit key-size limitation is only documented,
+  not enforced. It means the key will remain in clear-text in memory. This
+  is to meet Linux crypto-cipher expectation that each implementation must
+  support all the AES-compliant key sizes.
+
+* Some AES-KL hardware implementation may have noticeable performance
+  overhead when compared with AES-NI instructions.
+
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

