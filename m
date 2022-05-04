Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59EEC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-zLVknC1ON--lcrftFgOiFg-1; Thu, 05 May 2022 03:13:16 -0400
X-MC-Unique: zLVknC1ON--lcrftFgOiFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 988468BDEE1;
	Thu,  5 May 2022 07:13:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE8BA2167D61;
	Thu,  5 May 2022 07:13:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 58C7619451F1;
	Thu,  5 May 2022 07:13:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE0851947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 20:39:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE587156CF2A; Wed,  4 May 2022 20:39:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA468156CF27
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:39:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A25A8801E80
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:39:14 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-m-yRlBl0M-K9kEBvwggt2A-1; Wed, 04 May 2022 16:39:04 -0400
X-MC-Unique: m-yRlBl0M-K9kEBvwggt2A-1
Received: by mail-pg1-f173.google.com with SMTP id 15so2066994pgf.4;
 Wed, 04 May 2022 13:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=iPsQSqw38DosWcjT864uHfOF3XMxzmipGYiJZY97a+Y=;
 b=QW3XPJeuc7roSMO3Zd5Sz3f5h68w1KyQ9rV3f23ZGtZxCawNksBXY365Yg267hqx0E
 3+2vyUojFfZKRfV8Umdd4ty3m4g3SHyEij8qAdCM8cb+ollareLx/Tg+X58EZ6AmUQPj
 Woyk3uSPM9oDvUIsmMFrBzhWz/uSSVxVwo42Ri4AjKDItlzo+U4BQn3tcd7ooQb3K1em
 tKVgllH00sI7hNK+KcAQnmioOBpIGKlbFyRc04XfEJ9TGwuk85OzYU6SvJdtO84Wca8X
 rz1owydxcnkA1VmHWq6ieMedBjdbMkB2lrDa4hqV/WJk7KFAQ7HdevgrntASlOAufRpn
 mBzg==
X-Gm-Message-State: AOAM5325dOupl4Fc64DFjovEQckDBymPg+v3VeinJB0jnJIYiQ5nBRiZ
 E0zDiZDKESKF6pr6v+dCzto=
X-Google-Smtp-Source: ABdhPJyT72f6GCu/Hi0foCbtIUf3rGveJmsZaXeGY5CnNpUoYWUQwAfMmEBdDiFZ9ilZNTjq67JcTg==
X-Received: by 2002:a63:7c4e:0:b0:380:8ae9:c975 with SMTP id
 l14-20020a637c4e000000b003808ae9c975mr19713757pgn.25.1651696741592; 
 Wed, 04 May 2022 13:39:01 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
 by smtp.gmail.com with ESMTPSA id
 y11-20020a62b50b000000b0050e0a43712esm3644774pfe.63.2022.05.04.13.39.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 May 2022 13:39:00 -0700 (PDT)
Date: Thu, 5 May 2022 05:38:58 +0900
From: Stafford Horne <shorne@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YnLkYjOF2vEOdjOo@antec>
References: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com> <YnJQXr3igEMTqY3+@smile.fi.intel.com>
 <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
 <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 04, 2022 at 01:10:03PM -0700, Linus Torvalds wrote:
> On Wed, May 4, 2022 at 12:58 PM Stafford Horne <shorne@gmail.com> wrote:
> >
> > I have uploaded a diff I created here:
> >   https://gist.github.com/54334556f2907104cd12374872a0597c
> >
> > It shows the same output.
> 
> In hex_to_bin itself it seems to only be a difference due to some
> register allocation (r19 and r3 switched around).
> 
> But then it gets inlined into hex2bin and there changes there seem to
> be about instruction and basic block scheduling, so it's a lot harder
> to see what's going on.
> 
> And a lot of constant changes, which honestly look just like code code
> moved around by 16 bytes and offsets changed due to that.
> 
> So I doubt it's hex_to_bin() that is causing problems, I think it's
> purely code movement. Which explains why adding a nop or a fake printk
> fixes things.
> 
> Some alignment assumption that got broken?

This is what it looks like to me too.  I will have to do a deep dive on what is
going on with this particular build combination as I can't figure out what it is
off the top of my head.

This test is using a gcc 11 compiler, I tried with my gcc 12 toolchain and the
issue cannot be reproduced.

  - musl gcc 11 - https://musl.cc/or1k-linux-musl-cross.tgz
  - openrisc gcc 12 - https://github.com/openrisc/or1k-gcc/releases/tag/or1k-12.0.1-20220210-20220304

But again the difference between the two compiler outputs is a lot of register
allocation and offsets changes.  Its not easy to see anything that stands out.
I checked the change log for the openrisc specific changes from gcc 11 to gcc
12.  Nothing seems to stand out, mcount profiler fix for PIC, a new large binary
link flag.

-Stafford

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

