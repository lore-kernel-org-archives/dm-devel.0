Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8FEC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 15:43:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A06CE611C1
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 15:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A06CE611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-f4hmBY8EP1-qhZwRylvrvg-1; Fri, 29 Oct 2021 11:42:59 -0400
X-MC-Unique: f4hmBY8EP1-qhZwRylvrvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13ED8806694;
	Fri, 29 Oct 2021 15:42:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C06760BD8;
	Fri, 29 Oct 2021 15:42:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5FD54E58F;
	Fri, 29 Oct 2021 15:42:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TFgltn023404 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 11:42:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E1E372166B26; Fri, 29 Oct 2021 15:42:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCA3A2166B25
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 15:42:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82831066686
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 15:42:43 +0000 (UTC)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
	[209.85.215.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-109-Cv_2_5AiPdCRJC5FwxuDeg-1; Fri, 29 Oct 2021 11:42:42 -0400
X-MC-Unique: Cv_2_5AiPdCRJC5FwxuDeg-1
Received: by mail-pg1-f177.google.com with SMTP id t7so10246492pgl.9
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 08:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=kkrK8/+uwUhU1+ibCc9sihgvRMe3oeCDEJlEEAsQMNY=;
	b=ZeLpUQFte6l3S/4vy09Z37c3hDOMGorhfMKA7IohYau/FPFwLmDOF3myJ0igJsCYfo
	ZlAt5TxdppUVL7g3NjZSGsNWlP6uGIe/CUQFWP00TuFto9YNfGqDj3HCErS93ZUoAqjb
	zamSfnXr00tN1Oge8akuzTW+HUxGbJgv8T2tQeC5LFtBl3QfT2qXnoEaALzVrg5SPO75
	nTObdFiunm3FIz/0aYprNZ07kaXlRhfW7nmHH+wPwFdJFKjsAk1Ngseg3Ao3jqYP0LG3
	ZolZoEJo96nlw2+a2xScZ1VKnxw1cV0k28iWnnNMFGq4VkL5f/W466OGGN6fBX2Ot3VN
	0bGA==
X-Gm-Message-State: AOAM532qvIFzGDYor6RvyWLcY4gxvVhTv8Qga7jWVvlvo6kO3t/5eQvc
	NkdC7jyuTjZebkiooUUj/TT7oMfgns6ptTSR5jG2AQ==
X-Google-Smtp-Source: ABdhPJwscYMJBcsf4QuT7rFuYsL/BYYBLAhJeu/07ZB2t6F9Qexmb3kIziq0UAiLr3A7UbGhuhxXArjTEfzlR4kAptU=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
	l14-20020a056a00140e00b00444b07751efmr11616698pfu.61.1635522160977;
	Fri, 29 Oct 2021 08:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
	<CAPcyv4iEt78-XSsKjTWcpy71zaduXyyigTro6f3fmRqqFOG98Q@mail.gmail.com>
	<20211029105139.1194bb7f@canb.auug.org.au>
In-Reply-To: <20211029105139.1194bb7f@canb.auug.org.au>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Oct 2021 08:42:29 -0700
Message-ID: <CAPcyv4g8iEyN5UN1w1xBqQDYSb3HCh7_smsmjt-PiHORRK+X9Q@mail.gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] futher decouple DAX from block devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 28, 2021 at 4:52 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Dan,
>
> On Wed, 27 Oct 2021 13:46:31 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > My merge resolution is here [1]. Christoph, please have a look. The
> > rebase and the merge result are both passing my test and I'm now going
> > to review the individual patches. However, while I do that and collect
> > acks from DM and EROFS folks, I want to give Stephen a heads up that
> > this is coming. Primarily I want to see if someone sees a better
> > strategy to merge this, please let me know, but if not I plan to walk
> > Stephen and Linus through the resolution.
>
> It doesn't look to bad to me (however it is a bit late in the cycle :-(
> ).  Once you are happy, just put it in your tree (some of the conflicts
> are against the current -rc3 based version of your tree anyway) and I
> will cope with it on Monday.

Christoph, Darrick, Shiyang,

I'm losing my nerve to try to jam this into v5.16 this late in the
cycle. I do want to get dax+reflink squared away as soon as possible,
but that looks like something that needs to build on top of a
v5.16-rc1 at this point. If Linus does a -rc8 then maybe it would have
enough soak time, but otherwise I want to take the time to collect the
acks and queue up some more follow-on cleanups to prepare for
block-less-dax.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

