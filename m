Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7355EC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633--I_kUAPAPQGrzU-HBcu1CA-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: -I_kUAPAPQGrzU-HBcu1CA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 607101884990;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A3D91468949;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9FDA9194705A;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A2291947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 12:25:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2318B5742D8; Wed, 27 Apr 2022 12:25:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F8565742D6
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 12:25:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0819B805F6B
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 12:25:34 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-p5uoKp1lO-m0tV71_al9QQ-1; Wed, 27 Apr 2022 08:25:28 -0400
X-MC-Unique: p5uoKp1lO-m0tV71_al9QQ-1
Received: by mail-ej1-f47.google.com with SMTP id i27so3038503ejd.9;
 Wed, 27 Apr 2022 05:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=umXYVD04U8kB6up3Hq3d8f7zqDE6PdNJnaxLabPQIXk=;
 b=2qhYUSBm8YwnlbK7HGiQ6psUtqRXuJyB5XhIYu0XtAVJIevTl0J7xPK+nwZJDz5Rey
 AGp38xxtkRHks+XumRCEPIdhBzTr6/WcOuOsTHIO7lmvgSiCxzcZ8XJz9yzr7Q0MimGW
 LT/vNb/ispnoHN0Rq+KqIj0pAx6+qxHGNUAiB8sJOILX0P1wXEHIXk8gH/5y2Spq1XuC
 qfiPFgfRy/zjfuoH3V65W9oVkHKG5CFbGLzn1g7+5vf2vrkcitdIoZNfz2Uv2wilhFwT
 viDJF0MwR5DRAoqr1Yy6Fy4o8gPr00Ey9G0V3+AmqRnh+OqF5HpQkkitnLUPQ2f1NSru
 m9Ug==
X-Gm-Message-State: AOAM533Tz8T6lTdNIoEX6OoQd/TC4dKO86r1JuDWl+Yr/17syLGOgnWs
 MvxvD9or97qwUxNmUxwDNpaYcNCNys7I1E+44mf7VqvoNw/b+yRp
X-Google-Smtp-Source: ABdhPJyGULnAQQCy4CkeSzY2AuWpgjImq9ua1w6pHhwayjgNZgiOZVA8967ZCRMYAJ2ie/iIcarByTRaXkPWb2GRcCg=
X-Received: by 2002:a17:906:3799:b0:6ec:d25:3afe with SMTP id
 n25-20020a170906379900b006ec0d253afemr26414725ejc.44.1651062326257; Wed, 27
 Apr 2022 05:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241643030.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHp75VdHnvv6FH1BKcs8WgGF3nJpj77TsrmsQGBSpsAQU_S-bw@mail.gmail.com>
 <alpine.LRH.2.02.2204260759540.2737@file01.intranet.prod.int.rdu2.redhat.com>
 <YmfxaB1j65p8dOyj@smile.fi.intel.com>
 <alpine.LRH.2.02.2204261128220.5129@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204261128220.5129@file01.intranet.prod.int.rdu2.redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 27 Apr 2022 14:24:50 +0200
Message-ID: <CAHp75Vc8kb+dpT_i93No+0_==tLuYKxu9t1Nnv1KRomRc+Ke1w@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH v2] hex2bin: fix access beyond string end
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
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 26, 2022 at 5:29 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> On Tue, 26 Apr 2022, Andy Shevchenko wrote:
> > On Tue, Apr 26, 2022 at 08:07:44AM -0400, Mikulas Patocka wrote:
> > > On Tue, 26 Apr 2022, Andy Shevchenko wrote:
> > > > On Sun, Apr 24, 2022 at 10:48 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

...

> > Still shadows error codes.
> >
> > > +                   return -EINVAL;
> >
> > >                     return -EINVAL;
>
> What do you mean? What's wrong with "return -EINVAL"?

The actual error code is returned by hex_to_bin(). What is the point
of shadowing it with the explicit value?

-- 
With Best Regards,
Andy Shevchenko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

