Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90157C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i9vHukNc2v1aokC70p7P2FyE3JbjS+M62y3x+pWj5Nc=;
	b=GfaTOYJawB8uCqCb+VoDIN+kYu9EOs5igZORxQ8oWBQEfbHzjkxg5ZpVjvirjD7hLDG9kD
	yId4Ch2jWxc7LOm4Xi412YTipoE73CNunLj05ZM53UQs6a2Is1wGMrUOQeqGn49Id87I9q
	6wDIMon8A0+zgrWXyqrs245IMKxeqOI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-TME7jXErNhirjVGTjefbCg-1; Thu, 07 Jul 2022 03:28:07 -0400
X-MC-Unique: TME7jXErNhirjVGTjefbCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 096DC3C0E22D;
	Thu,  7 Jul 2022 07:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC78DC3598C;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B9241947075;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A3221947040
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Jul 2022 19:13:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C6517416362; Sun,  3 Jul 2022 19:13:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C255D40336E
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 19:13:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA80C811E75
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 19:13:13 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-Fn_kkqn5Pk6HwhgpvO7zzA-1; Sun, 03 Jul 2022 15:13:10 -0400
X-MC-Unique: Fn_kkqn5Pk6HwhgpvO7zzA-1
Received: by mail-qk1-f169.google.com with SMTP id p11so5477238qkg.12;
 Sun, 03 Jul 2022 12:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=GxZU3SzyJ8upRz6LCjkJN5ZVBWMWHWnQxWf8ULlGcLQ=;
 b=fHRok1G4hLbA7SFmCDBOFLAT0Qm5J4tTAbjNSMR4iLQx47zpC09TXHFsq7HVLBx3sT
 h8s2ACYwcF6BB+4bvP0U5lKcBzO9xZL2+P5XN7W8kqqouJVkhINXJoQm4CsOmgTUPn5j
 l7s9PLUaqIPh6o7iKPpVPrlbG8c/hy6K9GfiY8SuIFdEvXZCrq4uX93pc80/Sh76URxw
 oSes35EXHn5jh0vAaQnBq4xUZxmkJI2xp1OqtOockqBRcSE2TxoryTZxmrynY71sDyFH
 0lmLEzJDqVUVbGzAvIUApaE0M7NzsAAY8seToQQEltAPyh4eQXwYUEgRe/Vj4owbZYgB
 /xvQ==
X-Gm-Message-State: AJIora/7euMav7+Gbs+hQF0l/UE+SUWBIZBXkDC+VJh2QHLh0czg2Us2
 92hFc8wRuHoLfoBK/7vDUJo=
X-Google-Smtp-Source: AGRyM1suCUiGNj2AtGv9qXHAknI0rdQV6COTvbJxhRt90ZLtR45vYIX+UMWLgN5XKi7Wvu+pjWrLOg==
X-Received: by 2002:a37:9447:0:b0:6af:944:8050 with SMTP id
 w68-20020a379447000000b006af09448050mr18208081qkd.732.1656875589665; 
 Sun, 03 Jul 2022 12:13:09 -0700 (PDT)
Received: from localhost (c-69-254-185-160.hsd1.fl.comcast.net.
 [69.254.185.160]) by smtp.gmail.com with ESMTPSA id
 v26-20020ac873da000000b00304dec6452csm18782228qtp.78.2022.07.03.12.13.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 03 Jul 2022 12:13:08 -0700 (PDT)
Date: Sun, 3 Jul 2022 12:13:08 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-ID: <YsHqRDfCQVwyA2m1@yury-laptop>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <98f5d3d855a9c687ccc035edf62016b02a6876b7.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsC0GpltMVaCPhkJ@yury-laptop>
 <4dc5d50a-2291-1d3a-efac-3f6378a15d69@wanadoo.fr>
 <YsGz1Xp0RDM5ZhVY@smile.fi.intel.com>
MIME-Version: 1.0
In-Reply-To: <YsGz1Xp0RDM5ZhVY@smile.fi.intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 3/4] bitmap: Introduce bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, gor@linux.ibm.com, linux@rasmusvillemoes.dk,
 hca@linux.ibm.com, snitzer@kernel.org, oberpar@linux.ibm.com,
 linux-kernel@vger.kernel.org, almaz.alexandrovich@paragon-software.com,
 dm-devel@redhat.com, Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 03, 2022 at 06:20:53PM +0300, Andy Shevchenko wrote:
> On Sun, Jul 03, 2022 at 08:50:19AM +0200, Christophe JAILLET wrote:
> > Le 02/07/2022 =E0 23:09, Yury Norov a =E9crit=A0:
> > > On Sat, Jul 02, 2022 at 08:29:36PM +0200, Christophe JAILLET wrote:
>=20
> ...
>=20
> > > This should be dropped, for sure, and kmalloc() at line 128 should be
> > > replaced with bitmap_alloc().
> >=20
> > This kmalloc() is for a structure and a flexible array.
> >=20
> > You mean re-arranging the code to allocate the structure alone at first=
,
> > then the bitmap?

We can change struct primes to:
        struct primes {
                struct rcu_head rcu;
                unsigned long last, sz;
                unsigned long *primes;
        };

And then either allocate twice:
        new =3D kmalloc(sizeof(struct primes);
        new->primes =3D bitmap_alloc(sz);

Or keep the same struct primes for all expansions, and just allocate
new bitmap for ->primes when needed. This is what I meant.

This a bit deeper rework, but it addresses Andy's concern about excessive
fragmentation. (Did anyone before complain? Is it measurable?)

> It's one way, but it will increase fragmentation of memory. The other one
> as it seems to me is to name a new API properly, i.e. bitmap_size_to_byte=
s().
>
> In such case you won't need renames to begin with. And then would be able
> to convert driver-by-driver in cases of duplicated code.
>=20
> I think that's what confused Yuri and I kinda agree that bitmap_size() sh=
ould
> return bits, and not bytes. Also argument for pure bitmap_size() would be
> bitmap itself, but we have no way to detect the length of bitmap because =
we
> are using POD and not a specific data structure for it.

bitmap_size_to_bytes() sounds better. How many places in the kernel
do we have where we can't simply use bitmap_alloc(), and need this
machinery? If this is the only one, I'd prefer to switch it to
bitmap_alloc() instead.

Thanks,
Yury

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

