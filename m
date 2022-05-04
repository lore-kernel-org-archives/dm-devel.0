Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDD7C4167B
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-9t1Oj8GMP3GCpL4W4gnEdw-1; Thu, 05 May 2022 03:13:19 -0400
X-MC-Unique: 9t1Oj8GMP3GCpL4W4gnEdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12E5A3C0D1A3;
	Thu,  5 May 2022 07:13:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3D6640D2976;
	Thu,  5 May 2022 07:13:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 38EBF1947BAF;
	Thu,  5 May 2022 07:13:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3BD1D1947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 09:50:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 15CF740CFD32; Wed,  4 May 2022 09:50:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10DA840CF8F8
 for <dm-devel@redhat.com>; Wed,  4 May 2022 09:50:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECB7B1014A61
 for <dm-devel@redhat.com>; Wed,  4 May 2022 09:50:37 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-Q-NQi1u0M0-zIuLMcFEuPg-1; Wed, 04 May 2022 05:50:34 -0400
X-MC-Unique: Q-NQi1u0M0-zIuLMcFEuPg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CF989B817A7;
 Wed,  4 May 2022 09:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351B2C385A5;
 Wed,  4 May 2022 09:50:31 +0000 (UTC)
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4be900cb
 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO); 
 Wed, 4 May 2022 09:50:29 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id
 00721157ae682-2f7d19cac0bso9128787b3.13; 
 Wed, 04 May 2022 02:50:28 -0700 (PDT)
X-Gm-Message-State: AOAM532j1hnsIsUiqxWhirkESd1Kja+lVvT8CWdG68F+4agY8zd/LU2Q
 LIJfQXjD+1JwDT0t9i1Gmt2a4nsWhPlCXUqNA/U=
X-Google-Smtp-Source: ABdhPJzuMzs1bKkUTBLTJ00IJAbYgtTI+hqFcHguOCIXiEYbsg60S5jxhxQzD4lN6i9iMWN9Mzs+4DwAmgNgps7YOKU=
X-Received: by 2002:a81:cc3:0:b0:2f7:d52b:92bf with SMTP id
 186-20020a810cc3000000b002f7d52b92bfmr18719777ywm.231.1651657827651; Wed, 04
 May 2022 02:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec>
 <alpine.LRH.2.02.2205040453050.22937@file01.intranet.prod.int.rdu2.redhat.com>
 <YnJFViBFIgYOl7/2@smile.fi.intel.com>
 <24c9a856-be10-e9b3-b26d-e6ced9e13c63@gmail.com>
In-Reply-To: <24c9a856-be10-e9b3-b26d-e6ced9e13c63@gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 4 May 2022 11:50:16 +0200
X-Gmail-Original-Message-ID: <CAHmME9roTbjorBTzJGqJjmu7fgE_8w4RV8Pnwkqnoa1V+0kahg@mail.gmail.com>
Message-ID: <CAHmME9roTbjorBTzJGqJjmu7fgE_8w4RV8Pnwkqnoa1V+0kahg@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Stafford Horne <shorne@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 4, 2022 at 11:47 AM Milan Broz <gmazyland@gmail.com> wrote:
> BTW we use exactly the same code from Mikulas in cryptsetup now (actually the report
> was initiated from here :) and I added some tests for this code,
> you can probably adapt it (we just use generic wrapper around it):

I use something pretty similar in wireguard-tools:
https://git.zx2c4.com/wireguard-tools/tree/src/encoding.c#n74

The code is fine. This is looking like a different issue somewhere
else in the OpenRISC stack...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

