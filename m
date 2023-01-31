Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA68C64EC4
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238645;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7XvDL7CAPfXheW/yvbvE4CrUTcYrZkK9TbXqs5hel54=;
	b=Diby7ASoFbTmJ9Cn8Z778hWdJbyl7vRnkwFx0lVR3HAxOnnYCQ4I2KfJa/AuxoxKB7GQxU
	NvUJYtnRycLqZ1yFHbW875erw7OOmUwdw/iwK1mv9slwnmklwHWbWzeNnp8pSg0MkkwTAa
	WjC4grnrOoRb5bMDQh0D3fd+SPJ39nI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-G4kBnvZdMt6hKkoMQ0DWXg-1; Wed, 01 Feb 2023 03:04:01 -0500
X-MC-Unique: G4kBnvZdMt6hKkoMQ0DWXg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83D29882827;
	Wed,  1 Feb 2023 08:03:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F574140EBF6;
	Wed,  1 Feb 2023 08:03:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6576D1946595;
	Wed,  1 Feb 2023 08:03:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 069C01946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 12:17:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CBA60112132C; Tue, 31 Jan 2023 12:17:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C46D1112132D
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 12:17:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1FB11C051A6
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 12:17:44 +0000 (UTC)
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-vIw_4QWxN2uTTp4Y7a18fw-1; Tue, 31 Jan 2023 07:17:43 -0500
X-MC-Unique: vIw_4QWxN2uTTp4Y7a18fw-1
Received: by mail-vs1-f70.google.com with SMTP id
 m2-20020a67bb02000000b003f6900b055eso1363492vsn.17
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 04:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=0xKlxpkUZRo2mPicdjcp1VlQPa8+dcAbG4ZeEJrymiQ=;
 b=receiYdrlc0nI060n12rD17b7aMoXig1m2EJH/ksne+zFKbb+hLQXNz+mld0uT0aNl
 abwP61c6OwkNBB1jAzXND5p4tq9/qOC7uJJoBwhK//2/7pM0xkv503hRDmw1cLBFuyNy
 TJGHtZ81OSulcsHHQyQXBbZI2HJnl0kjf6aEWKbaJaeTKhC/mBBE/WXDK+PJpfFYRY6+
 5lVnIL7ZtVv1EVmNMxsdV3q9w4v1/NYEcLXpyJFxd4A0s78jktgbNNUF0/y921HXb4GS
 HX3VNmfi0Eqoh1MHn/QmhX3mE7xHmgePEdK01N5XPL3pQUX/1wq2fqyNgrRlTX2jjLyg
 uibA==
X-Gm-Message-State: AO0yUKVevnIvZHHoQ64LAXghlnlWbEGu8Yz/JeL2Z7FtKs3hDhEHIWXe
 FRL8jVt6FwNfLZeavLLhWn+uyHLjwFGygpXab8x9A4Q7fgiuJs8te0IeifzOyuk/i5aYNykbR1D
 fUHQsXgNk1ZDAMyc=
X-Received: by 2002:a67:c119:0:b0:3ea:99cb:c3e with SMTP id
 d25-20020a67c119000000b003ea99cb0c3emr2996479vsj.2.1675167462885; 
 Tue, 31 Jan 2023 04:17:42 -0800 (PST)
X-Google-Smtp-Source: AK7set/3cWf1zFQSzSaXyTvYZFmhtrofj2WcZS5Lru0KQCl9i0U0TOY96Lm9fQ3ijteXPFUn2WOINw==
X-Received: by 2002:a67:c119:0:b0:3ea:99cb:c3e with SMTP id
 d25-20020a67c119000000b003ea99cb0c3emr2996457vsj.2.1675167462612; 
 Tue, 31 Jan 2023 04:17:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it.
 [146.241.113.28]) by smtp.gmail.com with ESMTPSA id
 10-20020a370b0a000000b007203bbbbb31sm3325683qkl.47.2023.01.31.04.17.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 31 Jan 2023 04:17:42 -0800 (PST)
Message-ID: <865b04949b69c3470ecb3fa5f93005e4c5a9e86e.camel@redhat.com>
From: Paolo Abeni <pabeni@redhat.com>
To: patchwork-bot+netdevbpf@kernel.org, Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 31 Jan 2023 13:17:35 +0100
In-Reply-To: <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 01 Feb 2023 08:03:52 +0000
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, netdev@vger.kernel.org, lizefan.x@bytedance.com,
 sparclinux@vger.kernel.org, quic_neeraju@quicinc.com, agk@redhat.com,
 dave.jiang@intel.com, linux-scsi@vger.kernel.org, corbet@lwn.net,
 vishal.l.verma@intel.com, kuba@kernel.org, jejb@linux.ibm.com,
 linux@roeck-us.net, linux-media@vger.kernel.org, jdelvare@suse.com,
 paulmck@kernel.org, frederic@kernel.org, snitzer@kernel.org,
 josh@joshtriplett.org, linux-raid@vger.kernel.org, tj@kernel.org,
 jiri@nvidia.com, cgroups@vger.kernel.org, dan.j.williams@intel.com,
 mchehab@kernel.org, linux-hwmon@vger.kernel.org, rcu@vger.kernel.org,
 martin.petersen@oracle.com, edumazet@google.com, linux-mm@kvack.org,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 linux-kernel@vger.kernel.org, vkoul@kernel.org, hannes@cmpxchg.org,
 dmaengine@vger.kernel.org, davem@davemloft.net
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-01-31 at 12:10 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (master)
> by Paolo Abeni <pabeni@redhat.com>:
> 
> On Sun, 29 Jan 2023 15:10:44 -0800 you wrote:
> > Maintainers of specific kernel subsystems are only Cc-ed on their
> > respective patches, not the entire series. [if all goes well]
> > 
> > These patches are based on linux-next-20230127.
> > 
> > 
> >  [PATCH 1/9] Documentation: admin-guide: correct spelling
> >  [PATCH 2/9] Documentation: driver-api: correct spelling
> >  [PATCH 3/9] Documentation: hwmon: correct spelling
> >  [PATCH 4/9] Documentation: networking: correct spelling
> >  [PATCH 5/9] Documentation: RCU: correct spelling
> >  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
> >  [PATCH 7/9] Documentation: scsi: correct spelling
> >  [PATCH 8/9] Documentation: sparc: correct spelling
> >  [PATCH 9/9] Documentation: userspace-api: correct spelling
> > 
> > [...]
> 
> Here is the summary with links:
>   - [4/9] Documentation: networking: correct spelling
>     https://git.kernel.org/netdev/net-next/c/a266ef69b890
> 
> You are awesome, thank you!

That is just a bot glitch. I actually applied only patch 4/9 to the
net-next tree. I hope this is not too much scarying/confusing.

Thanks,

Paolo

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

