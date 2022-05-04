Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899B2C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 20:10:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-ikASE5_tN8W3N2SaHqwbTw-1; Wed, 04 May 2022 16:10:28 -0400
X-MC-Unique: ikASE5_tN8W3N2SaHqwbTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 958D3803524;
	Wed,  4 May 2022 20:10:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38D67111DCF2;
	Wed,  4 May 2022 20:10:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E07A1947047;
	Wed,  4 May 2022 20:10:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E8051947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 20:10:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 65F9940E7F12; Wed,  4 May 2022 20:10:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 615B740E7F06
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:10:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 463321C05EA6
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:10:24 +0000 (UTC)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-q_SBMhIEOdqxkUWkfcJlSQ-1; Wed, 04 May 2022 16:10:22 -0400
X-MC-Unique: q_SBMhIEOdqxkUWkfcJlSQ-1
Received: by mail-lj1-f172.google.com with SMTP id v4so3061620ljd.10
 for <dm-devel@redhat.com>; Wed, 04 May 2022 13:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=O0/hKmkvb5BoU0+UFK3i+vBfCGj7h/+eV5+6M1+ExZM=;
 b=SJfOi0M7S/aYI1OiJZq/r4x5FsF9PqIfZwo7nBokmyin4jXfw8Qm33gn2XisIWcFo+
 oqFg7IbJOHRkHbTrHbj2jHY4VCgurvJNIbMiTfsHNuM4z463CTYfEwswjL3/eHvVukz8
 w94K7h1lfou45gzzE+k2a3R6GaIHVKGMCBkNSPFFtnhVjavP1Ug+ZnXaL+BjyNuUQ6gJ
 2Ic0GZ1HfTlx7uUriFvGu/PepUJwU3J79g7rkguPC/pzaaNcCkleFsIsHhbR2wUj7nek
 B2+FpcsPPqiNtwG4+7xwKrWuOlVv84bzTUHAEK1P26miO87SYbw49rb5DokMhaNDQpCq
 7oGQ==
X-Gm-Message-State: AOAM532nFsLId+yL1OSZNvaW9KcICDnQ4IpMR3N1d7BvoHBygNbttRYl
 uv7d5XOjK0sYI7lE+HHTxHD54U4SihyK5ZrySeA=
X-Google-Smtp-Source: ABdhPJzVS+1VzuWKkf1nZ/JwBm6ndGlVCE7dInB0IhZ95JHqBxnhZtXH/3J/2r2IKvxmUgFue8kClQ==
X-Received: by 2002:a2e:9197:0:b0:24f:2a75:f026 with SMTP id
 f23-20020a2e9197000000b0024f2a75f026mr13875371ljg.289.1651695020837; 
 Wed, 04 May 2022 13:10:20 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com.
 [209.85.208.180]) by smtp.gmail.com with ESMTPSA id
 t9-20020a2e8e69000000b0024f3d1dae9esm1766484ljk.38.2022.05.04.13.10.20
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 13:10:20 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id m23so3106019ljc.0
 for <dm-devel@redhat.com>; Wed, 04 May 2022 13:10:20 -0700 (PDT)
X-Received: by 2002:a2e:914d:0:b0:24f:6374:3eba with SMTP id
 q13-20020a2e914d000000b0024f63743ebamr10017408ljg.506.1651695019712; Wed, 04
 May 2022 13:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
In-Reply-To: <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 13:10:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
Message-ID: <CAHk-=wjLRo-6PbhbvMUDojbMo=L+2jc5VpCYTyF-LGxZPhUngA@mail.gmail.com>
To: Stafford Horne <shorne@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 4, 2022 at 12:58 PM Stafford Horne <shorne@gmail.com> wrote:
>
> I have uploaded a diff I created here:
>   https://gist.github.com/54334556f2907104cd12374872a0597c
>
> It shows the same output.

In hex_to_bin itself it seems to only be a difference due to some
register allocation (r19 and r3 switched around).

But then it gets inlined into hex2bin and there changes there seem to
be about instruction and basic block scheduling, so it's a lot harder
to see what's going on.

And a lot of constant changes, which honestly look just like code code
moved around by 16 bytes and offsets changed due to that.

So I doubt it's hex_to_bin() that is causing problems, I think it's
purely code movement. Which explains why adding a nop or a fake printk
fixes things.

Some alignment assumption that got broken?

               Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

