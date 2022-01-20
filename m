Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66FAC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jan 2022 10:17:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-y3CHLj_KOtyoOjh2aYpdxA-1; Fri, 21 Jan 2022 05:17:18 -0500
X-MC-Unique: y3CHLj_KOtyoOjh2aYpdxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 803471091DA2;
	Fri, 21 Jan 2022 10:17:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3577D10595B9;
	Fri, 21 Jan 2022 10:17:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B89434BB7B;
	Fri, 21 Jan 2022 10:17:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20K8kbMT016436 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 Jan 2022 03:46:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9E5E740F9D74; Thu, 20 Jan 2022 08:46:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99E3B40F9D73
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 08:46:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FEF3101A52D
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 08:46:37 +0000 (UTC)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
	[209.85.208.50]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-215-79X4MbCtMrmaIlKA3CyigQ-1; Thu, 20 Jan 2022 03:46:35 -0500
X-MC-Unique: 79X4MbCtMrmaIlKA3CyigQ-1
Received: by mail-ed1-f50.google.com with SMTP id cx27so25685078edb.1
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 00:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=cgwK+h4TcKTuzoMVgpyjaT6hqJgZPgeFi9/82jcEytw=;
	b=BXqEXfYI/THtQSaKKq8gG4lmMIUQTgoASI2eEGVLinMmqrCNbxIgyn2Lk8kqqAWfvH
	CweKVsXvYa/EX+eaQQ/AYfloPDkhUvVBqrBUE/AM5E6fPARBH0rw9Msso1bnq3HQp2WH
	rof5+ezLkTd1uGI1pRxEBd5v3/DTtausL4hz7XG/OOCpVWK3e1qnOLEzBu4P4otfK82I
	RRyCXOPOlzSEgKJItRHQmzttiY/KYCUdOxBOTQu+e7Oy2NZomsS9SVuv1n1kqIoMQbjm
	lJXLNXu+BWvbUWa96tcBI6GzoLJ8NmYPBNBd7fs4bZbcDFHMqbtF/45BHfOdt10D52gd
	BIWw==
X-Gm-Message-State: AOAM530+rj2Im7ASn1jJ0HAucHscOivcLqX9jsgf4D0+JW01ZntcJXgI
	KbVXVk8KxLxxGMy7P8zDzKZBU+w7qT0NEREZcYJocA==
X-Google-Smtp-Source: ABdhPJxuyj+5hYqiz1QG79H/zXO6tZsV+Dq+Pw3BW6UC4M2lhhCbPthTcTo8B1M9EwB4FqJ6g90lXSpEfvPIb7w08Cw=
X-Received: by 2002:a05:6402:195:: with SMTP id
	r21mr34247351edv.174.1642668394471; 
	Thu, 20 Jan 2022 00:46:34 -0800 (PST)
MIME-Version: 1.0
References: <20220118071952.1243143-1-hch@lst.de>
	<20220118071952.1243143-11-hch@lst.de>
	<CAMGffEmFZB1PPE09bfxQjKw-tJhdprEkF-OWrVF4Kjsf1OwQ_g@mail.gmail.com>
	<20220120083746.GA5622@lst.de>
In-Reply-To: <20220120083746.GA5622@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 20 Jan 2022 09:46:23 +0100
Message-ID: <CAMGffE=+ENBdRfugG4k3yB_ca3rqwnaKFXC4+8=CZ=LGvggA6w@mail.gmail.com>
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
X-Mailman-Approved-At: Fri, 21 Jan 2022 05:16:34 -0500
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal" <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 10/19] rnbd-srv: simplify bio mapping in
	process_rdma
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 20, 2022 at 9:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Jan 19, 2022 at 01:20:54AM +0100, Jinpu Wang wrote:
> > this changes lead to IO error all the time, because bio_add_page return len.
> > We need  if (bio_add_page(bio, virt_to_page(data), datalen,
> >                      offset_in_page(data)) < datalen)
>
> Does this version look good to you?
>
> http://git.infradead.org/users/hch/block.git/commitdiff/62adb08e765b889dd8db4227cad33a710e36d631

Yes, lgtm, thank you!
Reviewed-by: Jack Wang <jinpu.wang@ionons.com>
Tested-by: Jack Wang <jinpu.wang@ionos.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

