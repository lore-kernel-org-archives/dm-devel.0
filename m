Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0145AC7EE2E
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 06:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686033912;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zy9rPQBEJJgruzx87YZZLk0nLxie6WSFxAsMAkcEGkY=;
	b=SeDwj8LKW2DoZpDPYd7VwmDciqxSFUTgYW2t1BPTtbeLXFVHMF5TMeU6km1ivVrcZ0WYk3
	NPxScRbpv7gF6muVdRcwb7n/GfpKk8OpooEt7tmM8dwY9q03IFhXOv9tHDBxutMCiqkVbY
	Mh24lss3Gl0hvGdlrX1ArrDdXCSNeaY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-KYvLNogFPbGSlqCbLbb2lQ-1; Tue, 06 Jun 2023 02:45:09 -0400
X-MC-Unique: KYvLNogFPbGSlqCbLbb2lQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB522101A52C;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C50A7140E954;
	Tue,  6 Jun 2023 06:45:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD51819465B9;
	Tue,  6 Jun 2023 06:45:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7F0201946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 10:54:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 642FF40D1B61; Mon,  5 Jun 2023 10:54:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CD0740D1B60
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 10:54:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41C463C01DE5
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 10:54:53 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-ius0CtIeOXGDcBtj4mNS9Q-1; Mon, 05 Jun 2023 06:54:51 -0400
X-MC-Unique: ius0CtIeOXGDcBtj4mNS9Q-1
Received: by mail-pf1-f169.google.com with SMTP id
 d2e1a72fcca58-652328c18d5so1940415b3a.1; 
 Mon, 05 Jun 2023 03:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685962490; x=1688554490;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=xgcgjvcFqJ16hUvgLs2bTi5nsSAAxgHJ3nGSH16Iezs=;
 b=OmlY+7YWS37Ur1S5UUPN+BUSTTaaVDamj65UcEFJjG2+lHaFr0pnjkMQhBCb+QBBf9
 b6+kdfHTz1eWA6H1gFlwhA0lVhRYfhU1gmS8uPsnMy6zvZetnAdxb24ALa8dpBHp45lE
 YN/hjrnzkw8SpfcTGUJbrNWQ6lC5ts+adeBdxhunPpgBDEVf1Bn1zncYGlXZ6/xkGEdD
 cyRLPrLMzPBk78PP4m8QkKmSHAhOqWJhtXDMlQ2FAGGU4yEp1ypf395gwrth60TBIG4S
 pJ0nNRiM6Bm3OnjBL7O92F9xBYlzUO9v0fHavE/vMIEKJ9CqBE1ur4vrJQ4kwqTr7Fds
 Umzw==
X-Gm-Message-State: AC+VfDwXECkxXKR0o2dWSUb+YVc/Hy5POBVGmppaWWl7VVwouG662xHH
 q0KkJVZhU0r6EBwNGN/XW3E=
X-Google-Smtp-Source: ACHHUZ7bI67fM9JC8fBlc4gJJbjHk34ajtFWisoCdHmD6arrU7/k9D1h4qusPKrbNSe+CBmqSlJmdA==
X-Received: by 2002:a05:6a20:1451:b0:101:282c:2b with SMTP id
 a17-20020a056a20145100b00101282c002bmr1857364pzi.32.1685962490313; 
 Mon, 05 Jun 2023 03:54:50 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-71.three.co.id.
 [180.214.233.71]) by smtp.gmail.com with ESMTPSA id
 jf12-20020a170903268c00b001b176d96da0sm6345746plb.78.2023.06.05.03.54.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Jun 2023 03:54:49 -0700 (PDT)
Message-ID: <91fc8d61-1a34-bc37-41c1-1528ff93c654@gmail.com>
Date: Mon, 5 Jun 2023 17:54:43 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: "Chang S. Bae" <chang.seok.bae@intel.com>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dm-devel@redhat.com
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-2-chang.seok.bae@intel.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230603152227.12335-2-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 06 Jun 2023 06:45:04 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/3/23 22:22, Chang S. Bae wrote:
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
> +established key handles become invalid. In flight dm-crypt operations
> +receive error results from pending operations. In the likely scenario that
> +dm-crypt is hosting the root filesystem the recovery is identical to if a
> +storage controller failed to resume from suspend, reboot. If the volume
"... resume from suspend or reboot."
> +impacted by a wrapping key restore failure is a data-volume then it is
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
> +  not enforced. It means the key will remain in clear-text in memory. This
> +  is to meet Linux crypto-cipher expectation that each implementation must
> +  support all the AES-compliant key sizes.
> +
> +* Some AES-KL hardware implementation may have noticeable performance
> +  overhead when compared with AES-NI instructions.
> +

The rest is LGTM, thanks!

Anyway,

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

