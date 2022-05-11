Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E922C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 05:54:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-SYEzj_4hO9iGUqFEp_m8Dw-1; Thu, 12 May 2022 01:54:40 -0400
X-MC-Unique: SYEzj_4hO9iGUqFEp_m8Dw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB5551011637;
	Thu, 12 May 2022 05:54:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CD1315341C3;
	Thu, 12 May 2022 05:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C9741947B87;
	Thu, 12 May 2022 05:54:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C18B1947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 May 2022 12:17:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42AB7400E43D; Wed, 11 May 2022 12:17:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3ED8D40C1421
 for <dm-devel@redhat.com>; Wed, 11 May 2022 12:17:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26F6D3C1902F
 for <dm-devel@redhat.com>; Wed, 11 May 2022 12:17:46 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-MtcdC64FNHSZMU00Nm5p3w-1; Wed, 11 May 2022 08:17:42 -0400
X-MC-Unique: MtcdC64FNHSZMU00Nm5p3w-1
Received: by mail-pj1-f41.google.com with SMTP id
 t11-20020a17090ad50b00b001d95bf21996so4782022pju.2; 
 Wed, 11 May 2022 05:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6jloxkDrIBx1FQXB3WO3Zmzcd3Q83JGcMWSxebzbF80=;
 b=m2jjfujv+aPalWMSxR24EI9FklzZJFSYyrVNQdKgn+jUXxs8mT1i+TIACpVHy2mF/5
 eVfJobyJY9bvaJbIcrWRy6AlbfFr17e2U5Q1E12YQsTYMyse+vUbUf+B0n+vPjCHNCNQ
 PsE+UTYxvKsIrraVnhGSA9hAmWkU8XCsPB7I9MBS2/G9uXQXa0UYLhxkuaBPsqn5J8fm
 HlFrQaV7BbPY1YoSzxomz2lvuC7xOabwbrDFxdngxsv/5WIeAtUU2sxHyLVakr1o6WrP
 W6i92T+9CDhMe++xNvtMy+iXvLhImdghqno24KDfVM5TuCVZWYXJbFFJx/4+HzJbhUAQ
 QCLw==
X-Gm-Message-State: AOAM531q4WzVd7FHASYvbonMEbOLYHe3Ww0R7fdwxo+ct+5FkJVW9KCU
 al7PBTn9isPBU/hAWJtPVb0=
X-Google-Smtp-Source: ABdhPJxPUIzteam2t9wDpHP6nr06rCewsN5+gC9SkiHTFRp8pdZVPv3cYpJfFGaF/VpS85E2BKIFXA==
X-Received: by 2002:a17:902:9349:b0:158:a6f7:e280 with SMTP id
 g9-20020a170902934900b00158a6f7e280mr24853463plp.155.1652271461237; 
 Wed, 11 May 2022 05:17:41 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
 by smtp.gmail.com with ESMTPSA id
 v24-20020a170902e8d800b0015e8d4eb272sm1676730plg.188.2022.05.11.05.17.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 May 2022 05:17:40 -0700 (PDT)
Date: Wed, 11 May 2022 21:17:38 +0900
From: Stafford Horne <shorne@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YnupYin9knBu6c91@antec>
References: <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
 <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
 <YnLkYjOF2vEOdjOo@antec> <YncQxl1shpH5TpbK@antec>
MIME-Version: 1.0
In-Reply-To: <YncQxl1shpH5TpbK@antec>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 12 May 2022 05:54:34 +0000
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

On Sun, May 08, 2022 at 09:37:26AM +0900, Stafford Horne wrote:
> On Thu, May 05, 2022 at 05:38:58AM +0900, Stafford Horne wrote:
> > On Wed, May 04, 2022 at 01:10:03PM -0700, Linus Torvalds wrote:
> > > On Wed, May 4, 2022 at 12:58 PM Stafford Horne <shorne@gmail.com> wrote:
> > > >
> > > > I have uploaded a diff I created here:
> > > >   https://gist.github.com/54334556f2907104cd12374872a0597c
> > > >
> > > > It shows the same output.
> > > 
> > > In hex_to_bin itself it seems to only be a difference due to some
> > > register allocation (r19 and r3 switched around).
> > > 
> > > But then it gets inlined into hex2bin and there changes there seem to
> > > be about instruction and basic block scheduling, so it's a lot harder
> > > to see what's going on.
> > > 
> > > And a lot of constant changes, which honestly look just like code code
> > > moved around by 16 bytes and offsets changed due to that.
> > > 
> > > So I doubt it's hex_to_bin() that is causing problems, I think it's
> > > purely code movement. Which explains why adding a nop or a fake printk
> > > fixes things.
> > > 
> > > Some alignment assumption that got broken?
> > 
> > This is what it looks like to me too.  I will have to do a deep dive on what is
> > going on with this particular build combination as I can't figure out what it is
> > off the top of my head.
> > 
> > This test is using a gcc 11 compiler, I tried with my gcc 12 toolchain and the
> > issue cannot be reproduced.
> > 
> >   - musl gcc 11 - https://musl.cc/or1k-linux-musl-cross.tgz
> >   - openrisc gcc 12 - https://github.com/openrisc/or1k-gcc/releases/tag/or1k-12.0.1-20220210-20220304
> > 
> > But again the difference between the two compiler outputs is a lot of register
> > allocation and offsets changes.  Its not easy to see anything that stands out.
> > I checked the change log for the openrisc specific changes from gcc 11 to gcc
> > 12.  Nothing seems to stand out, mcount profiler fix for PIC, a new large binary
> > link flag.
> 
> Hello,
> 
> Just an update on this.  The issue so far has been traced to the alignment of
> the crypto multiplication function fe_mul_impl in lib/crypto/curve25519-fiat32.c.
> 
> This patch e5be15767e7e ("hex2bin: make the function hex_to_bin constant-time")
> allowed for the alignment to be just right to cause the failure.  Without
> this patch and forcing the alignment we can reproduce the issue.  So though the
> bisect is correct, this patch is not the root cause of the issue.
> 
> Using some l.nop sliding techniques and some strategically placed .align
> statements I have been able to reproduce the issue on:
> 
>   - gcc 11 and gcc 12
>   - preempt and non-preempt kernels
> 
> I have not been able to reproduce this on my FPGA, so far only QEMU.  My
> hunch now is that since the fe_mul_impl function contains some rather long basic
> blocks it appears that timer interrupts that interrupt qemu mid basic block
> execution somehow is causing this.  The hypothesis is it may be basic block
> resuming behavior in qemu that causes incosistent behavior.
> 
> It will take a bit more time to trace this.  Since I maintain OpenRISC QEMU the
> issue is on me.
> 
> Again, It's safe to say that patch e5be15767e7e ("hex2bin: make the function
> hex_to_bin constant-time") is not an issue.

This issue has been fixed.  I sent a patch to QEMU for it:

 - https://lore.kernel.org/qemu-devel/20220511120541.2242797-1-shorne@gmail.com/T/#u

The issue was a bug in the OpenRISC emulation in QEMU which was triggered when
receiving a TICK TIMER interrupt, in a delay slot, on a page boundary.

The fix was simple enough, but investigation took quite some work.

Thanks,

-Stafford

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

