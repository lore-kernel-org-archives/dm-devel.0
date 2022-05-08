Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D26C43219
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 07:53:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-R604Ft_XM1ykpIHh4zMHgg-1; Mon, 09 May 2022 03:53:32 -0400
X-MC-Unique: R604Ft_XM1ykpIHh4zMHgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30B2D38149CA;
	Mon,  9 May 2022 07:53:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19B561415628;
	Mon,  9 May 2022 07:53:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E45201947062;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 92812194704E
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 May 2022 00:37:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7D7B32166B48; Sun,  8 May 2022 00:37:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 78E322166B2F
 for <dm-devel@redhat.com>; Sun,  8 May 2022 00:37:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CF9A811E75
 for <dm-devel@redhat.com>; Sun,  8 May 2022 00:37:35 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-wpwuMW5jNa-IAiNpO_YHQw-1; Sat, 07 May 2022 20:37:30 -0400
X-MC-Unique: wpwuMW5jNa-IAiNpO_YHQw-1
Received: by mail-pl1-f170.google.com with SMTP id d22so10780223plr.9;
 Sat, 07 May 2022 17:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=arUH2MRVxEf8vhAeq3i8+iP+btufOwV/ehc3jq4WcgU=;
 b=Xj1biJQGpyM10rQW6td/T1D4VkE2yQtswOp4CQxuJFSF9L6ILINYNPg//U5QNYZ1EP
 O743A61CF1+D1jmQ2UvMQ2iSocA+wieZED70iQnFtQ2gi+c5WEW6yIwvzPtbZA47kjSG
 SaYy/mtRDGnlyKEw0iqTwXiuOCyaSpFuzUpugE3SM9Iojl7Ocp97OkWzIUhI27qni0gz
 Cqe+Y5VE07A5vm7g13A9Zh9Ru1wba01nFuxysAlaSdvHDFPYiSQrH8AUaEkNK/jDC3f+
 ElAfOUXcUyHkVsodXulxOJcoKGohGcRwkfmNF2mPUwXLR+OtDdtcroga0JioLAGJVI/F
 gN4Q==
X-Gm-Message-State: AOAM532ihs1xI28LfuK/wcMLX1M1ddTyt/Sn8TCwIFGGtTbOub1GwX9e
 G8AfFtHU9yBc2T35kvc82S0=
X-Google-Smtp-Source: ABdhPJwLlAmDIofQb7jE/g+VMSVHar3owskWZ/EMG0HUf496uiLDgk4O2m3XYmugmFA8Z827riK8VA==
X-Received: by 2002:a17:902:f68d:b0:15e:bd3c:43da with SMTP id
 l13-20020a170902f68d00b0015ebd3c43damr9894794plg.164.1651970248880; 
 Sat, 07 May 2022 17:37:28 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
 by smtp.gmail.com with ESMTPSA id
 a7-20020a1709027e4700b0015e8d4eb222sm3341599pln.108.2022.05.07.17.37.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 07 May 2022 17:37:27 -0700 (PDT)
Date: Sun, 8 May 2022 09:37:26 +0900
From: Stafford Horne <shorne@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YncQxl1shpH5TpbK@antec>
References: <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com> <YnJQXr3igEMTqY3+@smile.fi.intel.com>
 <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
 <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
 <YnLkYjOF2vEOdjOo@antec>
MIME-Version: 1.0
In-Reply-To: <YnLkYjOF2vEOdjOo@antec>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Mon, 09 May 2022 07:53:25 +0000
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
Cc: Andy Shevchenko <andy@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Mike Snitzer <msnitzer@redhat.com>,
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 05, 2022 at 05:38:58AM +0900, Stafford Horne wrote:
> On Wed, May 04, 2022 at 01:10:03PM -0700, Linus Torvalds wrote:
> > On Wed, May 4, 2022 at 12:58 PM Stafford Horne <shorne@gmail.com> wrote:
> > >
> > > I have uploaded a diff I created here:
> > >   https://gist.github.com/54334556f2907104cd12374872a0597c
> > >
> > > It shows the same output.
> > 
> > In hex_to_bin itself it seems to only be a difference due to some
> > register allocation (r19 and r3 switched around).
> > 
> > But then it gets inlined into hex2bin and there changes there seem to
> > be about instruction and basic block scheduling, so it's a lot harder
> > to see what's going on.
> > 
> > And a lot of constant changes, which honestly look just like code code
> > moved around by 16 bytes and offsets changed due to that.
> > 
> > So I doubt it's hex_to_bin() that is causing problems, I think it's
> > purely code movement. Which explains why adding a nop or a fake printk
> > fixes things.
> > 
> > Some alignment assumption that got broken?
> 
> This is what it looks like to me too.  I will have to do a deep dive on what is
> going on with this particular build combination as I can't figure out what it is
> off the top of my head.
> 
> This test is using a gcc 11 compiler, I tried with my gcc 12 toolchain and the
> issue cannot be reproduced.
> 
>   - musl gcc 11 - https://musl.cc/or1k-linux-musl-cross.tgz
>   - openrisc gcc 12 - https://github.com/openrisc/or1k-gcc/releases/tag/or1k-12.0.1-20220210-20220304
> 
> But again the difference between the two compiler outputs is a lot of register
> allocation and offsets changes.  Its not easy to see anything that stands out.
> I checked the change log for the openrisc specific changes from gcc 11 to gcc
> 12.  Nothing seems to stand out, mcount profiler fix for PIC, a new large binary
> link flag.

Hello,

Just an update on this.  The issue so far has been traced to the alignment of
the crypto multiplication function fe_mul_impl in lib/crypto/curve25519-fiat32.c.

This patch e5be15767e7e ("hex2bin: make the function hex_to_bin constant-time")
allowed for the alignment to be just right to cause the failure.  Without
this patch and forcing the alignment we can reproduce the issue.  So though the
bisect is correct, this patch is not the root cause of the issue.

Using some l.nop sliding techniques and some strategically placed .align
statements I have been able to reproduce the issue on:

  - gcc 11 and gcc 12
  - preempt and non-preempt kernels

I have not been able to reproduce this on my FPGA, so far only QEMU.  My
hunch now is that since the fe_mul_impl function contains some rather long basic
blocks it appears that timer interrupts that interrupt qemu mid basic block
execution somehow is causing this.  The hypothesis is it may be basic block
resuming behavior in qemu that causes incosistent behavior.

It will take a bit more time to trace this.  Since I maintain OpenRISC QEMU the
issue is on me.

Again, It's safe to say that patch e5be15767e7e ("hex2bin: make the function
hex_to_bin constant-time") is not an issue.

-Stafford

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

