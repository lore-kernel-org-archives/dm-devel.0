Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDBFC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-Zo7gK027MSKvKA1a8J7Daw-1; Thu, 05 May 2022 03:13:21 -0400
X-MC-Unique: Zo7gK027MSKvKA1a8J7Daw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B57CA85A5A8;
	Thu,  5 May 2022 07:13:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A02DF40D2971;
	Thu,  5 May 2022 07:13:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D73DE194704B;
	Thu,  5 May 2022 07:13:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4BC6119466DF
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 08:38:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F1121C28114; Wed,  4 May 2022 08:38:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED4FFC27EB9
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:38:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D29471014A66
 for <dm-devel@redhat.com>; Wed,  4 May 2022 08:38:34 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-JABiwTvvPbq7d6dg4dG6TA-1; Wed, 04 May 2022 04:38:33 -0400
X-MC-Unique: JABiwTvvPbq7d6dg4dG6TA-1
Received: by mail-pj1-f49.google.com with SMTP id p6so633771pjm.1;
 Wed, 04 May 2022 01:38:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=N8whqiXCDudhxPgHYW7myFUbj5FdlX84aTgM+lwpxQc=;
 b=K2xez9nkdlpV/tJMX+t9+I6ZAWVXxEAi6ecYcV6ywCyWWmbH6F/24wTOmjaDBBTYhU
 k4NcMCLAtM/CGDcLEG5hqy50kjGFq2Pjwb5azgTWlwuhhU+KJaj1KIWe+gElH5lIJYpz
 NNQtsG8bLm/Fd7odSlb25Rkb2Q3sdzT0s3ppa2atEp6x3MjD3yMjHxy6TQRt6cAooiyj
 mNZdYHtFSL5sHoB/NjWdM/bC29Dd1lE0DIXgVOK2Xquvbq3m2ZIhzm+OLROzIRYHc+5p
 oF8hAs3SRV8LP3OZpJR3fju85SA7Dt5tjQevNaWQIREClZ9msB1DOoep+YRlrqjS8mSZ
 qb1Q==
X-Gm-Message-State: AOAM5301JmZqptuw6WZu4bfOwl4UE83uP9rB37fmnrv4xwTWlc0iql0+
 sKzqe0ZPTRCpBjux7TLgEk6klyrbNAP7ZQ==
X-Google-Smtp-Source: ABdhPJxcFVjZohTgju6+Dy9Mq0QAz/vz1Hn0Yp88nR+3wQfP0tWVaB4N3OrnpG1Odvmj3pudVCCn8w==
X-Received: by 2002:a17:90a:ec02:b0:1dc:3b8d:38e5 with SMTP id
 l2-20020a17090aec0200b001dc3b8d38e5mr9340621pjy.134.1651653511278; 
 Wed, 04 May 2022 01:38:31 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
 by smtp.gmail.com with ESMTPSA id
 u18-20020a170902e21200b0015e8d4eb23esm7286998plb.136.2022.05.04.01.38.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 May 2022 01:38:30 -0700 (PDT)
Date: Wed, 4 May 2022 17:38:28 +0900
From: Stafford Horne <shorne@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YnI7hE4cIfjsdKSF@antec>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Thu, 05 May 2022 07:13:10 +0000
Subject: Re: [dm-devel] [PATCH v2] hex2bin: make the function hex_to_bin
 constant-time
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
Cc: Andy Shevchenko <andy@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Jason@zx2c4.com,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 25, 2022 at 08:07:48AM -0400, Mikulas Patocka wrote:
 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The function hex2bin is used to load cryptographic keys into device mapper
> targets dm-crypt and dm-integrity. It should take constant time
> independent on the processed data, so that concurrently running
> unprivileged code can't infer any information about the keys via
> microarchitectural convert channels.
> 
> This patch changes the function hex_to_bin so that it contains no branches
> and no memory accesses.
> 
> Note that this shouldn't cause performance degradation because the size of
> the new function is the same as the size of the old function (on x86-64) -
> and the new function causes no branch misprediction penalties.
> 
> I compile-tested this function with gcc on aarch64 alpha arm hppa hppa64
> i386 ia64 m68k mips32 mips64 powerpc powerpc64 riscv sh4 s390x sparc32
> sparc64 x86_64 and with clang on aarch64 arm hexagon i386 mips32 mips64
> powerpc powerpc64 s390x sparc32 sparc64 x86_64 to verify that there are no
> branches in the generated code.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  include/linux/kernel.h |    2 +-
>  lib/hexdump.c          |   32 +++++++++++++++++++++++++-------
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/lib/hexdump.c
> ===================================================================
> --- linux-2.6.orig/lib/hexdump.c	2022-04-24 18:51:20.000000000 +0200
> +++ linux-2.6/lib/hexdump.c	2022-04-25 13:15:26.000000000 +0200
> @@ -22,15 +22,33 @@ EXPORT_SYMBOL(hex_asc_upper);
>   *
>   * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
>   * input.
> + *
> + * This function is used to load cryptographic keys, so it is coded in such a
> + * way that there are no conditions or memory accesses that depend on data.
> + *
> + * Explanation of the logic:
> + * (ch - '9' - 1) is negative if ch <= '9'
> + * ('0' - 1 - ch) is negative if ch >= '0'
> + * we "and" these two values, so the result is negative if ch is in the range
> + *	'0' ... '9'
> + * we are only interested in the sign, so we do a shift ">> 8"; note that right
> + *	shift of a negative value is implementation-defined, so we cast the
> + *	value to (unsigned) before the shift --- we have 0xffffff if ch is in
> + *	the range '0' ... '9', 0 otherwise
> + * we "and" this value with (ch - '0' + 1) --- we have a value 1 ... 10 if ch is
> + *	in the range '0' ... '9', 0 otherwise
> + * we add this value to -1 --- we have a value 0 ... 9 if ch is in the range '0'
> + *	... '9', -1 otherwise
> + * the next line is similar to the previous one, but we need to decode both
> + *	uppercase and lowercase letters, so we use (ch & 0xdf), which converts
> + *	lowercase to uppercase
>   */
> -int hex_to_bin(char ch)
> +int hex_to_bin(unsigned char ch)
>  {
> -	if ((ch >= '0') && (ch <= '9'))
> -		return ch - '0';
> -	ch = tolower(ch);
> -	if ((ch >= 'a') && (ch <= 'f'))
> -		return ch - 'a' + 10;
> -	return -1;
> +	unsigned char cu = ch & 0xdf;
> +	return -1 +
> +		((ch - '0' +  1) & (unsigned)((ch - '9' - 1) & ('0' - 1 - ch)) >> 8) +
> +		((cu - 'A' + 11) & (unsigned)((cu - 'F' - 1) & ('A' - 1 - cu)) >> 8);
>  }
>  EXPORT_SYMBOL(hex_to_bin);

Hello,

Just a heads up it seems this patch is causing some instability with crypto self
tests on OpenRISC when using a PREEMPT kernel (no SMP).

This was reported by Jason A. Donenfeld as it came up in wireguard testing.

I am trying to figure out if this is an OpenRISC PREEMPT issue or something
else.

The warning I am seeing is a bit random but looks something like the
following:

    [    0.164000] Freeing initrd memory: 1696K
    [    0.188000] xor: measuring software checksum speed
    [    0.196000]    8regs           :  1343 MB/sec
    [    0.204000]    8regs_prefetch  :  1347 MB/sec
    [    0.212000]    32regs          :  1335 MB/sec
    [    0.220000]    32regs_prefetch :  1277 MB/sec
    [    0.220000] xor: using function: 8regs_prefetch (1347 MB/sec)
    [    0.252000] SARU running 25519 tests
    [    0.424000] curve25519 self-test 5: FAIL
    [    0.496000] curve25519 self-test 7: FAIL
    [    1.744000] curve25519 self-test 45: FAIL
    [    3.448000] ------------[ cut here ]------------
    [    3.448000] WARNING: CPU: 0 PID: 1 at lib/crypto/curve25519.c:19 curve25519_init+0x38/0x50
    [    3.448000] CPU: 0 PID: 1 Comm: swapper Not tainted 5.18.0-rc4+ #758
    [    3.448000] Call trace:
    [    3.448000] [<(ptrval)>] ? __warn+0xe0/0x114
    [    3.448000] [<(ptrval)>] ? curve25519_init+0x38/0x50
    [    3.448000] [<(ptrval)>] ? warn_slowpath_fmt+0x5c/0x94
    [    3.448000] [<(ptrval)>] ? curve25519_init+0x0/0x50
    [    3.452000] [<(ptrval)>] ? curve25519_init+0x38/0x50
    [    3.452000] [<(ptrval)>] ? do_one_initcall+0x98/0x328
    [    3.452000] [<(ptrval)>] ? proc_register+0x4c/0x284
    [    3.452000] [<(ptrval)>] ? ignore_unknown_bootoption+0x0/0x8
    [    3.452000] [<(ptrval)>] ? kernel_init_freeable+0x1fc/0x2a8
    [    3.452000] [<(ptrval)>] ? ignore_unknown_bootoption+0x0/0x8
    [    3.452000] [<(ptrval)>] ? kernel_init+0x0/0x164
    [    3.452000] [<(ptrval)>] ? kernel_init+0x28/0x164
    [    3.452000] [<(ptrval)>] ? schedule_tail+0x18/0xac
    [    3.452000] [<(ptrval)>] ? ret_from_fork+0x1c/0x9c
    [    3.452000] ---[ end trace 0000000000000000 ]---
    [    3.452000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
    [    3.464000] printk: console [ttyS0] disabled
    [    3.464000] 90000000.serial: ttyS0 at MMIO 0x90000000 (irq = 2, base_baud = 1250000) is a 16550A

Example config: https://xn--4db.cc/cCRlQ1AE

The self-test iteration number that fails is always a bit different.  I am
still in progress of investigating this and will not have a lot of time new the
next few days.  If anything ring's a bell let me know.

-Stafford

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

