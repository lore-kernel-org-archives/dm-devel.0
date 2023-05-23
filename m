Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B0EC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684861079;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bkbckHP8RpoQwMjYR/uxFyt2yy867iXx8npTzNJTuE8=;
	b=SR/GlxepRlgTReeX4MEq8puhAaN2QGyiON3ov71KZF3Q+7qTwOsIKtjfNiv2u+IcDCUIOE
	wupsujSXGoK5kNljugAkITdtwpRcyWsfSYAYhFu05cyPtzXBLivwhBtkjPc1+A8jKMu/q7
	cRbP8Gnp7evhFEWSzwYGzHfOjB87tv0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-A0FiDvvBPnipBE1kWAM8fw-1; Tue, 23 May 2023 12:57:56 -0400
X-MC-Unique: A0FiDvvBPnipBE1kWAM8fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1970D3C0C880;
	Tue, 23 May 2023 16:57:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04EAA2166B25;
	Tue, 23 May 2023 16:57:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD40319465A8;
	Tue, 23 May 2023 16:57:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EDC319465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 16:57:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 808A1112131B; Tue, 23 May 2023 16:57:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 792CD1121315
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:57:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 459A11C068C1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:57:29 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
 [209.85.222.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-hU0-ZrCtNqy-wEZCt3NcbA-1; Tue, 23 May 2023 12:57:26 -0400
X-MC-Unique: hU0-ZrCtNqy-wEZCt3NcbA-1
Received: by mail-qk1-f182.google.com with SMTP id
 af79cd13be357-75b1975ea18so5321885a.3
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684861046; x=1687453046;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6cIpc2hkpfcX9ytnNlNra4xHWCIbNM5n2UygyBIAgU8=;
 b=Vu7+GqqkStJjuADdy0LVqenktoRjN98VdPMfyy+st9aujdWBImb8tgT+rvBma75bdB
 ZnNd8DiYMxQ96xV0po3AK2XTs6IrveR4snkPnZ8NO3TO/i1WVCzi/YPVkeEfBU7xAnJz
 9XAFQXpGTIK8jGdFWYKMo4yvhgv6vdZTXFQUD8TRgQWxhzjSnQtWILv9Qezqgv71yCjw
 t22VgIN4M5XzVWBYnh5ovGncB30kFPnCro4jfSOlp71AxeGe1bfrv1yFafUm0upo5sDH
 D79eqzFSqfMxSZdRDx0gkpQtBnjgoyJhz4hqDpaye6rm1vcm9ApGUAi8om/mk9WC/6hr
 feaA==
X-Gm-Message-State: AC+VfDwBAQPgvC0INlX7whvVtMPBx156MbXmxzUHxwMF/uDGu+WAXizU
 zYlK0Pw9C3xwKAE4Z2o4PcVnIH4=
X-Google-Smtp-Source: ACHHUZ6FTUIWRZ17w4sgstUiGYRBur4Ios77FwtNmNA/oETp74y448b9irsL1KV98Bhgct8ETOyo4g==
X-Received: by 2002:a05:622a:112:b0:3f5:3a79:f863 with SMTP id
 u18-20020a05622a011200b003f53a79f863mr23323837qtw.25.1684861046295; 
 Tue, 23 May 2023 09:57:26 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 y14-20020a0ceace000000b0062120b054ebsm2930934qvp.19.2023.05.23.09.57.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 09:57:25 -0700 (PDT)
Date: Tue, 23 May 2023 12:57:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZGzwdLQz5IJUURCH@redhat.com>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-19-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230523074535.249802-19-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 18/24] dm: open code dm_get_dev_t in
 dm_init_init
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23 2023 at  3:45P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> dm_init_init is called from early boot code, and thus lookup_bdev
> will never succeed.  Just open code that call to early_lookup_bdev
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

