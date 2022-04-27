Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09279C4167B
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-v80XTyKCPt-x5UiFv494Jw-1; Fri, 29 Apr 2022 04:23:45 -0400
X-MC-Unique: v80XTyKCPt-x5UiFv494Jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DFE583396C;
	Fri, 29 Apr 2022 08:23:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B614340869CB;
	Fri, 29 Apr 2022 08:23:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7443C194704B;
	Fri, 29 Apr 2022 08:23:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EEC3E1947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 14:50:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1A0C40CFD0A; Wed, 27 Apr 2022 14:50:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD8B340CFD05
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:50:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B34263C15886
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:50:39 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
 [209.85.218.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-mWmiEFSmNQWRJX-t40VQTQ-1; Wed, 27 Apr 2022 10:50:37 -0400
X-MC-Unique: mWmiEFSmNQWRJX-t40VQTQ-1
Received: by mail-ej1-f51.google.com with SMTP id gh6so3988236ejb.0;
 Wed, 27 Apr 2022 07:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=TopemPKnePhFBvdQyVlRU2YsgkU6mC/ZFyaLpAEWb+8=;
 b=2zly4q0FcIncH8YHTmiqbTunB4FhL91Np8kp5zTzW//EmOPAq9RnURNY7SBlbS0hh1
 dBHARjynBKG8o9JH/ZFos2OYo2JDGLBv6wmiCzmHJtilvfvo5ZMRIRLTwSORXmJwsIAG
 gtuE/KZ6d9lMdJ63TA59PPjo4UC9930w1+VfVHuU24tvc1/Xf0IqBsH+75XGhPPvI4LG
 rIyNJGzJX0k7FGCB4z9yTNKzDvz2dNfzbqmTB+kx9nJsQVN1+kHkklfxfG1XRd8pquW6
 SU6METhULsgiU7uzCZCgs48odmO/BkZWqQdedqfGT24QllQG8bz7fpq5ZkEzOzqMC0zJ
 xsoQ==
X-Gm-Message-State: AOAM532XqxjmA2GdpwHJweBvSVMDJ8ZnnIljZIZf1C+NA8lcgv9+IRRi
 wKea1yciMvwIiEh4gDZf1nPo9PPbvQNU9cJ/arbEamhHqhwitkbD
X-Google-Smtp-Source: ABdhPJze0rrE09zpTtnC3kY/fQaGWUjOnEIxVfQjERch64qFczOtwWFYXf/NmUkjW0AubSZi4EJKq9liLxcZi/rCYqU=
X-Received: by 2002:a17:907:6d22:b0:6f3:a9e5:d074 with SMTP id
 sa34-20020a1709076d2200b006f3a9e5d074mr9978050ejc.639.1651071035761; Wed, 27
 Apr 2022 07:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241643030.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHp75VdHnvv6FH1BKcs8WgGF3nJpj77TsrmsQGBSpsAQU_S-bw@mail.gmail.com>
 <alpine.LRH.2.02.2204260759540.2737@file01.intranet.prod.int.rdu2.redhat.com>
 <YmfxaB1j65p8dOyj@smile.fi.intel.com>
 <alpine.LRH.2.02.2204261128220.5129@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHp75Vc8kb+dpT_i93No+0_==tLuYKxu9t1Nnv1KRomRc+Ke1w@mail.gmail.com>
 <alpine.LRH.2.02.2204271000020.1114@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204271000020.1114@file01.intranet.prod.int.rdu2.redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 27 Apr 2022 16:49:59 +0200
Message-ID: <CAHp75Vf=sEeoHwzb2RdVFsmZ_mWAyg2zdMKgtW9RQFM_bTMHPw@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 27, 2022 at 4:10 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> On Wed, 27 Apr 2022, Andy Shevchenko wrote:
> > On Tue, Apr 26, 2022 at 5:29 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > On Tue, 26 Apr 2022, Andy Shevchenko wrote:
> > > > On Tue, Apr 26, 2022 at 08:07:44AM -0400, Mikulas Patocka wrote:
> > > > > On Tue, 26 Apr 2022, Andy Shevchenko wrote:
> > > > > > On Sun, Apr 24, 2022 at 10:48 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > ...
> >
> > > > Still shadows error codes.
> > > >
> > > > > +                   return -EINVAL;
> > > >
> > > > >                     return -EINVAL;
> > >
> > > What do you mean? What's wrong with "return -EINVAL"?
> >
> > The actual error code is returned by hex_to_bin(). What is the point
> > of shadowing it with the explicit value?
>
> hex_to_bin returns -1 on error, hex2bin returns -EINVAL on error.
>
> This is inconsistent and it may be fixed (after verifying all the
> hex_to_bin callers - a quick grep over the source shows that there is "if
> ((k = hex_to_bin(in_str[j--])) != -1)").
>
> But for the purpose of fixing this bug, we should preserve the behavior
> and return -1 and -EINVAL just like it was before.

This is clear now to me. So, by improving a commit message you may
make it clear to everybody who reads your change.

With the updated commit message,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

-- 
With Best Regards,
Andy Shevchenko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

