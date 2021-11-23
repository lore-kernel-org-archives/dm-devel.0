Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AFAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 04:03:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-yhkGesXCOn6e4Tq7g0iJnA-1; Mon, 22 Nov 2021 23:03:02 -0500
X-MC-Unique: yhkGesXCOn6e4Tq7g0iJnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 467EC102CB2A;
	Tue, 23 Nov 2021 04:02:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2912D29403;
	Tue, 23 Nov 2021 04:02:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 012E91832E7F;
	Tue, 23 Nov 2021 04:02:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN42u4C013608 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 23:02:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 47F7340CFD15; Tue, 23 Nov 2021 04:02:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4353540CFD04
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 04:02:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AE4F185A7BA
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 04:02:56 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
	[209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-412-vw4uvpTmNZ-WXBRAtYaxnQ-1; Mon, 22 Nov 2021 23:02:54 -0500
X-MC-Unique: vw4uvpTmNZ-WXBRAtYaxnQ-1
Received: by mail-pl1-f180.google.com with SMTP id b13so15952553plg.2
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 20:02:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
	b=Sc90uTFSF24AoKdbNj5e1TFWKegqn8KW64nMq/kmHtGMV8LcMDHszZP2zUULIAyH6k
	IcQm9/dYmuAcb3z6E7SijjX0p+a218qyVWT4nL6MK6XoMMvrFJjQxDmVSK+3K7z9chN3
	/SNgWplo5zBtRWRUE1uNFGoIT+o7nrdJtVxaHjpVuOAxRTa1OvyTOPiK2ToSy47800sH
	loQsTfvexjArLS5cSQbGuwCTtBoiQ7NhwzwpOKZiYtK9jnQLVU1CuuDxpiiuz/wj9Q5v
	GRgW2SVRuXgwtdNdnycgr+ihZAa4VN5SJFIvzCJZ+Fz6YARO9RUXypXJY85YZ0+MQhLi
	P4Pg==
X-Gm-Message-State: AOAM533qgMpFb0JDxhqSYCdXDdNSFGchQzWNFfXAA9f0ttGcM/8KVBBi
	13isyU4cD/IMb/jTmr1LH6oQhKKyw2vcyF0c2s3/Og==
X-Google-Smtp-Source: ABdhPJxvSLmX3xye88c668D00uWDdnnCeZiY99i/tpK8E6hWm4PH0+Kg/6cCj46QhqqZS8+/hIjz2nKulq2NhEFbIuM=
X-Received: by 2002:a17:90b:1e07:: with SMTP id
	pg7mr2663610pjb.93.1637640173575; 
	Mon, 22 Nov 2021 20:02:53 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-11-hch@lst.de>
In-Reply-To: <20211109083309.584081-11-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 20:02:42 -0800
Message-ID: <CAPcyv4hUSRSVBP_G6z7fPUwvb=3F2q4mrGhmD9A4nez=DrEdWQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 10/29] dm-log-writes: add a
	log_writes_dax_pgoff helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

