Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C4BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643303353;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/HZfiVgy97EL619sL58vpcuyHfpD77KKgc3mBkC/GX4=;
	b=TBHwtYx4Rc1b7oQCgl/JZ/IsOA5WrbdQHSbf8nHncLtcuNFzHTxBNeunblQYE6jGb1/T1B
	xmSx5Mtq38Xfqj6JSUbo9x2hZv86CjBqXsWvumtaKT0r3l3VK7dB1+YUgCn6qtAf3K06UP
	7E4M82M9mxPKDqgp0qqeaGTNeRVxcrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-lthpDR1QOl6Cin5NUZLowQ-1; Thu, 27 Jan 2022 12:09:09 -0500
X-MC-Unique: lthpDR1QOl6Cin5NUZLowQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DC238519E0;
	Thu, 27 Jan 2022 17:09:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95C5F753E4;
	Thu, 27 Jan 2022 17:09:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B43B1806D1D;
	Thu, 27 Jan 2022 17:09:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RH9068019945 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 12:09:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C582C27FA3; Thu, 27 Jan 2022 17:09:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78EC5C27FA0
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 17:09:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DAA5185A79C
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 17:09:00 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-473-LCA4qQvDP0aG7rGNV18VVw-1; Thu, 27 Jan 2022 12:08:59 -0500
X-MC-Unique: LCA4qQvDP0aG7rGNV18VVw-1
Received: by mail-qk1-f200.google.com with SMTP id
	d11-20020a37680b000000b0047d87e46f4aso2820882qkc.11
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 09:08:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=kAV23rTMcuty4CJFZ8o8ysOxnvRFj2DI1yB1mT746og=;
	b=b7BiZM7lFqTcZ6lbTsFFXdQfmrMt6ITt0FHJcLuduX9buf42/YHjFajE6JpwBrG8DX
	l6OnsFS3xMvxse4Ow1R1dzeLLiZHYa0XzDuQI3wd+qvGcrQWcBa+5B3VN/tELJ56hFhN
	De+c7NucuLmyrf+kfMBJb+C0N6cPy0PFN6ylGbQvSCKsz7qR8+5+z4NGOKd2KHoKvf0U
	Cbw+hk8JrRwqDnBjKno3wRe7EVmpfSOR7uNAnE72mSDbyUnQXG6YDnq3JJ8SuFQhN9jo
	RceY96kGXuI+r63ROiM0XQM+6IKxW89Hql4WjnbiY7mC3gzvheBeqWgMtdmfZim1TcBq
	J0RA==
X-Gm-Message-State: AOAM531ifXvDTvlff5YOz0c9kc5Cm1qn8ekRuLFOWeyVXojN6R5MkV0M
	CWtwK00lUZ94g3LQyYVvze7NaO+0YOWdVKQMKLRcTpa0pfNLhniJHktByoyGUu6BDdZ8i2XUE/h
	7s2Y460yJ7X7sdg==
X-Received: by 2002:ac8:44c9:: with SMTP id b9mr3555321qto.524.1643303338469; 
	Thu, 27 Jan 2022 09:08:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDu0k2yM0Z7B8jNmnNXJFkDazruS7TZzFMNaHKbWmY0JBs9tIC0IfQuLij5Gmty6LtXXG+Yw==
X-Received: by 2002:ac8:44c9:: with SMTP id b9mr3555294qto.524.1643303338263; 
	Thu, 27 Jan 2022 09:08:58 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	a141sm1694826qkc.73.2022.01.27.09.08.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 09:08:57 -0800 (PST)
Date: Thu, 27 Jan 2022 12:08:56 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YfLRqCMAhLH8xhDD@redhat.com>
References: <20220124091107.642561-1-hch@lst.de>
	<20220124091107.642561-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220124091107.642561-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Subject: Re: [dm-devel] [PATCH 05/19] dm: bio_alloc can't fail if it is
	allowed to sleep
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24 2022 at  4:10P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Remove handling of NULL returns from sleeping bio_alloc calls given that
> those can't fail.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

