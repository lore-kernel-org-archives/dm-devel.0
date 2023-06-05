Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F231FC7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 06:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686033912;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HpzZw/+DMnIcoBA3uUKbaco71+j+u2Y7TpOGZdYicgs=;
	b=VOHi4bXSIC3GnlgEo6u6zClLgYzN4KulIrEJkfqmvrrEN9Op7UrjDuGBsOjNOfGHGKkwtp
	ZLAl2spdo3KKMMM/PktjliOqSOlA7DaCSvYFDxICNGZ9KZMfC3MItFKECQCwlqxv7G5xrD
	AMZEaO4MwLgU+LiuE8UdvrvOpqNAssE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-abLmHxQHNkOyiTMaC_vq3w-1; Tue, 06 Jun 2023 02:45:09 -0400
X-MC-Unique: abLmHxQHNkOyiTMaC_vq3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9C5B1C06ED3;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4FC240CFD47;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C77519465BB;
	Tue,  6 Jun 2023 06:45:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BBC01946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 10:52:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0978449BB98; Mon,  5 Jun 2023 10:52:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 026C1403174
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 10:52:24 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBDE3381D4C0
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 10:52:24 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-Vt-vp-jbPmCB_dvCRFCXFg-1; Mon, 05 Jun 2023 06:52:23 -0400
X-MC-Unique: Vt-vp-jbPmCB_dvCRFCXFg-1
Received: by mail-pf1-f180.google.com with SMTP id
 d2e1a72fcca58-6537d2a8c20so1643541b3a.2
 for <dm-devel@redhat.com>; Mon, 05 Jun 2023 03:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685962342; x=1688554342;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VyziPcXjx042xRWB/UShxNbnJkgS86WOF1g0CAJiPcU=;
 b=GKZIaWUZNKpsLuPOwNeDPIG6fIDT5F3t452Pf+DmSJFDTq6zoCMCqKfxgJQDfx+mGT
 ojAMctebEjr8cUZ3gmepKSTQZq8o9DjAMmBa3lUyPXAV5FludXwqqpmKXQnFLA0DRuHh
 xP5ylrCYDhqfe6fMPSjq/LYywDCSHRktULjqKvnfqDiatBxgGJ6dLll5AX0AhnxwO/Dj
 gEtkBJtdgwz/Jwlnz5deAMSjmEPGscUO+Fsl1EXJ35UVHhSEPbF/sMbXtXLH634ZPNlQ
 YNwWp2mJIM0kEQScSdu0F4VzbvMj27jp3HMimCAVmAvVv97TI/KddFMVs7lttRAa6L8r
 nFWQ==
X-Gm-Message-State: AC+VfDwfechXK1f40BeGzOzUxY/Zmx0nUDdqk9toHUKAHSI0JAYPLW4l
 gYjFoqP2gjR8LeV3lJXjCjo=
X-Google-Smtp-Source: ACHHUZ4O5fsEe/UQksnA3+kVyPz7RFRKjUTKy+Vj+pQfbgdpSVTpwwXym6nU1m9pZGQVbwII+Lvrbg==
X-Received: by 2002:a05:6a20:8f0b:b0:10d:bc30:b9ea with SMTP id
 b11-20020a056a208f0b00b0010dbc30b9eamr3156392pzk.39.1685962342096; 
 Mon, 05 Jun 2023 03:52:22 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-71.three.co.id.
 [180.214.233.71]) by smtp.gmail.com with ESMTPSA id
 iy3-20020a170903130300b001ab061e352bsm6287237plb.195.2023.06.05.03.52.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Jun 2023 03:52:21 -0700 (PDT)
Message-ID: <15f5c6da-869c-cee4-3922-23873a077789@gmail.com>
Date: Mon, 5 Jun 2023 17:52:13 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: "Chang S. Bae" <chang.seok.bae@intel.com>, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com, herbert@gondor.apana.org.au, ebiggers@kernel.org,
 ardb@kernel.org, x86@kernel.org, luto@kernel.org, tglx@linutronix.de,
 bp@suse.de, dave.hansen@linux.intel.com, mingo@kernel.org
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-2-chang.seok.bae@intel.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220112211258.21115-2-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 06 Jun 2023 06:45:03 +0000
Subject: Re: [dm-devel] [PATCH v5 01/12] Documentation/x86: Document Key
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
Cc: ravi.v.shankar@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kumar.n.dwarakanath@intel.com,
 dan.j.williams@intel.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/13/22 04:12, Chang S. Bae wrote:
> +==============
> +x86 Key Locker
> +==============
> +
> +Introduction
> +============
> +
> +Key Locker is a CPU feature feature to reduce key exfiltration
> +opportunities while maintaining a programming interface similar to AES-NI.
> +It converts the AES key into an encoded form, called the 'key handle'. The
> +key handle is a wrapped version of the clear-text key where the wrapping
> +key has limited exposure. Once converted, all subsequent data encryption
> +using new AES instructions (AES-KL) uses this key handle, reducing the
> +exposure of private key material in memory.
> +
> +Internal Wrapping Key (IWKey)
> +=============================
> +
> +The CPU-internal wrapping key is an entity in a software-invisible CPU
> +state. On every system boot, a new key is loaded. So the key handle that
> +was encoded by the old wrapping key is no longer usable on system shutdown
> +or reboot.
> +
> +And the key may be lost on the following exceptional situation upon wakeup:
> +
> +IWKey Restore Failure
> +---------------------
> +
> +The CPU state is volatile with the ACPI S3/4 sleep states. When the system
> +supports those states, the key has to be backed up so that it is restored
> +on wake up. The kernel saves the key in non-volatile media.
> +
> +The event of an IWKey restore failure upon resume from suspend, all
> +established key handles become invalid. In flight dm-crypt operations
> +receive error results from pending operations. In the likely scenario that
> +dm-crypt is hosting the root filesystem the recovery is identical to if a
> +storage controller failed to resume from suspend, reboot. If the volume
                                            "suspend and reboot"?
> +impacted by an IWKey restore failure is a data-volume then it is possible
> +that I/O errors on that volume do not bring down the rest of the system.
> +However, a reboot is still required because the kernel will have
> +soft-disabled Key Locker. Upon the failure, the crypto library code will
> +return -ENODEV on every AES-KL function call. The Key Locker implementation
> +only loads a new IWKey at initial boot, not any time after like resume from
> +suspend.
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
> +expectation is that a guest VM wants private IWKey state, but the
> +architecture does not provide that. An emulation of that capability, by
> +caching per VM IWKeys in memory, defeats the purpose of Key Locker. The
> +backup / restore facility is also not performant enough to be suitable for
> +guest VM context switches.
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
> +  crypto library implementation includes the flag check to return an error
> +  code. Note that the flag is also set when the internal wrapping key is
> +  changed because of missing backup.
> +
> +* AES-KL implements support for 128-bit and 256-bit keys, but there is no
> +  AES-KL instruction to process an 192-bit key. But there is no AES-KL
> +  instruction to process a 192-bit key. The AES-KL cipher implementation
> +  logs a warning message with a 192-bit key and then falls back to AES-NI.
> +  So, this 192-bit key-size limitation is only documented, not enforced. It
> +  means the key will remain in clear-text in memory. This is to meet Linux
> +  crypto-cipher expectation that each implementation must support all the
> +  AES-compliant key sizes.
> +
> +* Some AES-KL hardware implementation may have noticeable performance
> +  overhead when compared with AES-NI instructions.
> +

The rest is LGTM.

-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

