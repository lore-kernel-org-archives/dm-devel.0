Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED75C77B73
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 02:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686017871;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hdN0q2EEMt7JCY5Fr/JkKCJcfo/lQQEwMJY00/JKkag=;
	b=hvVypzRFFIZ3YAcIK5h4R6sImS6fc+VR8KAfrLJM4v+9/GJyirtq8UVy7hXx1bqeQPN7CB
	gCFDk1xHbgI/BIoEgEl4p78plCwFAQailu0bkbFQcZKu61HAJd2cF/VjXm/c7G8QLa3bl1
	pQSPkunMFPh5Qd8MkXCzS1lHV7En8Do=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-6VMFWlaqMOKNxfk7rXfjig-1; Mon, 05 Jun 2023 22:17:47 -0400
X-MC-Unique: 6VMFWlaqMOKNxfk7rXfjig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5FCB29A9CA6;
	Tue,  6 Jun 2023 02:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE10F9E90;
	Tue,  6 Jun 2023 02:17:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 903AA19465B5;
	Tue,  6 Jun 2023 02:17:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E7411946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 02:17:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C045C0448F; Tue,  6 Jun 2023 02:17:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2463CC084BB
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:17:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08AF58007D9
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 02:17:41 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-exCgk-HOPEuTHkNM1sl6HA-1; Mon, 05 Jun 2023 22:17:38 -0400
X-MC-Unique: exCgk-HOPEuTHkNM1sl6HA-1
Received: from [2601:1c2:980:9ec0::2764]
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q6MGN-00HQTW-0Y; Tue, 06 Jun 2023 02:17:35 +0000
Message-ID: <32ffb593-c39c-c741-7b6f-6f1cbcb1d558@infradead.org>
Date: Mon, 5 Jun 2023 19:17:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: "Chang S. Bae" <chang.seok.bae@intel.com>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dm-devel@redhat.com
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-2-chang.seok.bae@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230603152227.12335-2-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 01/12] Documentation/x86: Document Key
 Locker
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
 Jonathan Corbet <corbet@lwn.net>, ardb@kernel.org, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, Ingo Molnar <mingo@redhat.com>,
 bp@alien8.de, charishma1.gairuboyina@intel.com, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 6/3/23 08:22, Chang S. Bae wrote:
> Document the overview of the feature along with relevant consideration
> when provisioning dm-crypt volumes with AES-KL instead of AES-NI.
> 
> ---
> ---
>  Documentation/arch/x86/index.rst     |  1 +
>  Documentation/arch/x86/keylocker.rst | 97 ++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+)
>  create mode 100644 Documentation/arch/x86/keylocker.rst
> 

> diff --git a/Documentation/arch/x86/keylocker.rst b/Documentation/arch/x86/keylocker.rst
> new file mode 100644
> index 000000000000..5557b8d0659a
> --- /dev/null
> +++ b/Documentation/arch/x86/keylocker.rst
> @@ -0,0 +1,97 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +x86 Key Locker
> +==============
> +
> +Introduction
> +============
> +
> +Key Locker is a CPU feature to reduce key exfiltration opportunities
> +while maintaining a programming interface similar to AES-NI. It
> +converts the AES key into an encoded form, called the 'key handle'.
> +The key handle is a wrapped version of the clear-text key where the
> +wrapping key has limited exposure. Once converted, all subsequent data
> +encryption using new AES instructions (AES-KL) uses this key handle,
> +reducing the exposure of private key material in memory.
> +
> +CPU-internal Wrapping Key
> +=========================
> +
> +The CPU-internal wrapping key is an entity in a software-invisible CPU
> +state. On every system boot, a new key is loaded. So the key handle that
> +was encoded by the old wrapping key is no longer usable on system shutdown
> +or reboot.
> +
> +And the key may be lost on the following exceptional situation upon wakeup:
> +
> +Wrapping Key Restore Failure
> +----------------------------
> +
> +The CPU state is volatile with the ACPI S3/4 sleep states. When the system
> +supports those states, the key has to be backed up so that it is restored
> +on wake up. The kernel saves the key in non-volatile media.
> +
> +The event of a wrapping key restore failure upon resume from suspend, all

   Upon the event of a ...

> +established key handles become invalid. In flight dm-crypt operations
> +receive error results from pending operations. In the likely scenario that
> +dm-crypt is hosting the root filesystem the recovery is identical to if a
> +storage controller failed to resume from suspend, reboot. If the volume
> +impacted by a wrapping key restore failure is a data-volume then it is

                                                   data volume

> +possible that I/O errors on that volume do not bring down the rest of the
> +system. However, a reboot is still required because the kernel will have
> +soft-disabled Key Locker. Upon the failure, the crypto library code will
> +return -ENODEV on every AES-KL function call. The Key Locker implementation
> +only loads a new wrapping key at initial boot, not any time after like
> +resume from suspend.
> +
> +Use Case and Non-use Cases
> +==========================
> +
> +Bare metal disk encryption is the only intended use case.
> +
> +Userspace usage is not supported because there is no ABI provided to
> +communicate and coordinate wrapping-key restore failure to userspace. For
> +now, key restore failures are only coordinated with kernel users. But the
> +kernel can not prevent userspace from using the feature's AES instructions
> +('AES-KL') when the feature has been enabled. So, the lack of userspace
> +support is only documented, not actively enforced.
> +
> +Key Locker is not expected to be advertised to guest VMs and the kernel
> +implementation ignores it even if the VMM enumerates the capability. The
> +expectation is that a guest VM wants private wrapping key state, but the
> +architecture does not provide that. An emulation of that capability, by
> +caching per-VM wrapping keys in memory, defeats the purpose of Key Locker.
> +The backup / restore facility is also not performant enough to be suitable
> +for guest VM context switches.
> +
> +AES Instruction Set
> +===================
> +
> +The feature accompanies a new AES instruction set. This instruction set is
> +analogous to AES-NI. A set of AES-NI instructions can be mapped to an
> +AES-KL instruction. For example, AESENC128KL is responsible for ten rounds
> +of transformation, which is equivalent to nine times AESENC and one
> +AESENCLAST in AES-NI.
> +
> +But they have some notable differences:
> +
> +* AES-KL provides a secure data transformation using an encrypted key.
> +
> +* If an invalid key handle is provided, e.g. a corrupted one or a handle
> +  restriction failure, the instruction fails with setting RFLAGS.ZF. The
> +  crypto library implementation includes the flag check to return -EINVAL.
> +  Note that this flag is also set if the wrapping key is changed, e.g.,
> +  because of the backup error.
> +
> +* AES-KL implements support for 128-bit and 256-bit keys, but there is no
> +  AES-KL instruction to process an 192-bit key. The AES-KL cipher
> +  implementation logs a warning message with a 192-bit key and then falls
> +  back to AES-NI. So, this 192-bit key-size limitation is only documented,

Is it logged anywhere?  i.e., a kernel log message?

> +  not enforced. It means the key will remain in clear-text in memory. This
> +  is to meet Linux crypto-cipher expectation that each implementation must
> +  support all the AES-compliant key sizes.
> +
> +* Some AES-KL hardware implementation may have noticeable performance
> +  overhead when compared with AES-NI instructions.
> +

-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

