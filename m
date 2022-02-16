Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FD46C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645037325;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=88Yf6asMrBrLRVKhTiC14mSqnBMvIp5qsGsFQJnmEEQ=;
	b=TJWtwdmqwYmIcuyA/tSI1Gu/vcDtksmEK0RBAeTVMXOEIrsr++7QxzZ1eSL890dECtUJLN
	O4ToZfPLE4XGi0kgSWO1FsmU5zgOsm1zNQ9nZT2ntJwvIpww6it7Cz4b4dcQUCQUjSmW91
	rBdP14AxVLrX5tJ+zgVes3JKX99jJ4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-44OMH51WMi2rZXYQFIo3pw-1; Wed, 16 Feb 2022 13:48:41 -0500
X-MC-Unique: 44OMH51WMi2rZXYQFIo3pw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7CDD8143EB;
	Wed, 16 Feb 2022 18:48:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F78584A1D;
	Wed, 16 Feb 2022 18:48:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 577C54CA93;
	Wed, 16 Feb 2022 18:48:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21GIjBeH014774 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 13:45:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DAC88492D51; Wed, 16 Feb 2022 18:45:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7375492D50
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 18:45:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE45F185AD01
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 18:45:11 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-584-OZ2isdsbPvu1YInaZhl6Gg-1; Wed, 16 Feb 2022 13:45:10 -0500
X-MC-Unique: OZ2isdsbPvu1YInaZhl6Gg-1
Received: by mail-qk1-f197.google.com with SMTP id
	bj2-20020a05620a190200b005084968bb24so1926400qkb.23
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 10:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=OOx+E3QllfryzTFmIymhQ3ST1693x2OfbOWkWxjfBfw=;
	b=fPsPqBjZyMMVskpmb3wrtp64X+cEkwVIkfyxMPwlg8s+KrySlzKlt2rqDfzNCOkbt5
	vP+jePSlzMGBErHxdlI0PTwVVLDDQiUk8vJLxR+I9OaCbnTjZhnp157kuDykQleUiIVz
	/hMBLSaeB7Zp4KMx2pvh3GGnblSyCvtv7Hj6Gnt38l2P6WGTlM6CZMY+r3t13B7RyRQL
	q9n2Oz8S2JFRua3uQe4DYp/NQxVEik/cbRjZqSN//DuN8MBSaFpI4YPH4yyeYWIlL7+t
	FmWXnwYGfVbRIg4dmoGeVM4unByqkYjh3O68cVy14RVxW3FrxOAwQW4s+Z9RJh48gxyI
	J0Ig==
X-Gm-Message-State: AOAM533KvPjrA0btRbpP45vrqh/9CPpgqEIOZHZUzH3WVNpX3Z4gA3Gb
	Q1TaCML0nSG+m8ye6EdsZ+0g/GOejdcbMpDsZrv+8jx5hzDOze/L1uTznG4gIMLe9zH45tSNRhP
	Hp69Pt2/SwmDy2g==
X-Received: by 2002:a05:6214:21ed:b0:42c:11d1:70cd with SMTP id
	p13-20020a05621421ed00b0042c11d170cdmr2797943qvj.115.1645037110076;
	Wed, 16 Feb 2022 10:45:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJgOjhzSS8RxxVMNtzc6xG6mkVlUt//oPzsjAQ7SdjdxSfis7RMELX8WfonQ2JnnKXjLlDqw==
X-Received: by 2002:a05:6214:21ed:b0:42c:11d1:70cd with SMTP id
	p13-20020a05621421ed00b0042c11d170cdmr2797925qvj.115.1645037109867;
	Wed, 16 Feb 2022 10:45:09 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	i4sm20421081qkn.13.2022.02.16.10.45.09
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Feb 2022 10:45:09 -0800 (PST)
Date: Wed, 16 Feb 2022 13:45:08 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Yg1GNMD6jIrKOxBE@redhat.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-7-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220209082828.2629273-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, jinpu.wang@ionos.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 6/7] dm: remove write same support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 09 2022 at  3:28P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> There are no more end-users of REQ_OP_WRITE_SAME left, so we can start
> deleting it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

