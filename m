Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE7FEC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643303500;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mbaZkrkGLhu1+ACCbpxvQHNdhaGDb/2oFSe2iWxyLS0=;
	b=HySM8ZySaGd4I+u0NSWURGgWvJXmKra5NwAejJduACjb16u/MuvZG6ntaYAcE0rvFSLWYq
	7I4LdMBf+jamvSBVih/iwZXwoVtZfTv4B9sSjgfJsWAx3H0Tc6DwM/RsU2vadSPfJnH/7k
	m5n/EHkOjF+sizG9QrUtE/KmoommM2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-CSVxA_GPNcCv784DQM1tiQ-1; Thu, 27 Jan 2022 12:11:37 -0500
X-MC-Unique: CSVxA_GPNcCv784DQM1tiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66F2A1923B80;
	Thu, 27 Jan 2022 17:11:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4857E7A3FA;
	Thu, 27 Jan 2022 17:11:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 018271806D2B;
	Thu, 27 Jan 2022 17:11:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RH9jWe019989 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 12:09:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B59E1120ABB; Thu, 27 Jan 2022 17:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 876FC1121319
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 17:09:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6496A800B21
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 17:09:39 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-594-WZjBnXAZMp6Y84-euU1h2A-1; Thu, 27 Jan 2022 12:09:38 -0500
X-MC-Unique: WZjBnXAZMp6Y84-euU1h2A-1
Received: by mail-qt1-f200.google.com with SMTP id
	b7-20020ac85bc7000000b002b65aee118bso2674746qtb.13
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 09:09:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=+dhUoO5mtU5C6v7W8MZ+6HMQJZitoVQcF/qB+IF1Jr0=;
	b=LxdCSZqMbKraEefvP6md0nvUZoRLfhwoQxhzLQvu/5kXV9k9t8UQdkgfWcn/ehv5fu
	z7zuCn5eyD4zSUHfCyN3b9MhpL83v6cmJZgArXfm7u8dDiANc+ET9VoAiZTBCL1/UhkG
	nHRys6gxlidyvDFR3uan/E9p/EmetDjhQv/PoWBYyVJxYv3jwFeXF7nSZdIjTyaOODvs
	vMnWh5T9SJaoqJqCWbZ2R7rBE20LGmJpgni/6tWEDzfgloVmuV3adxNwTBCK67SCDhMt
	mvxnyopJOGdqev+u7mBsKWJQConhRYuTBDH7cSamBpERNz5UYNhE13yWR8IYbMqSXL0H
	Yc6A==
X-Gm-Message-State: AOAM5300q8ODK5EhwxVgrmm53QDQDbG9VdqV5rnQqo5qFaC4qJ2MKIJw
	QWlbLbPk/HmCqOKzSYAIXfcWtdyQT9CM9a+QzcX/P1iw7mHbR3CN8QN/sC+ZImT+yxfP9hDRf7w
	2BV9m1EsG+O25sw==
X-Received: by 2002:a05:620a:1671:: with SMTP id
	d17mr3422674qko.683.1643303377468; 
	Thu, 27 Jan 2022 09:09:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyie4bqi26jfgNY8Cjw+Pn5xYBOKV6NvnkIoBYF0/ZaizWWrCUD9ZTrfOlIA4zvFGF0i2/RFw==
X-Received: by 2002:a05:620a:1671:: with SMTP id
	d17mr3422658qko.683.1643303377286; 
	Thu, 27 Jan 2022 09:09:37 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id i8sm1628636qti.52.2022.01.27.09.09.36
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 09:09:36 -0800 (PST)
Date: Thu, 27 Jan 2022 12:09:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YfLR0DPcDOYO65Hp@redhat.com>
References: <20220124091107.642561-1-hch@lst.de>
	<20220124091107.642561-7-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220124091107.642561-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 06/19] dm-crypt: remove clone_init
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24 2022 at  4:10P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Just open code it next to the bio allocations, which saves a few lines
> of code, prepares for future changes and allows to remove the duplicate
> bi_opf assignment for the bio_clone_fast case in kcryptd_io_read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

