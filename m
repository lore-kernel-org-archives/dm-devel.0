Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C153C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 21:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668635208;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rX7rPiwxVDEUt1/n0E4IQM0qc8+YVTLunkHSk3XicBk=;
	b=Y5dnSDPGi5Xbe4ILf/3IvD9LzHcMsofG7cCGCbXIgXdA8LvdNAa4iglyyogzRsbnvOiuOH
	13Y8E8WsD2vOKerdCH8Xs1V9aGQ2I/Q8KMocZDaJdbTcTYOE+bv7th/nUc71cIGxLj2w9r
	mH8iTfMdbzR0XYzg/0KbcHLtg58dB4c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-T0I41OMEPAGWtBeNqCHH_A-1; Wed, 16 Nov 2022 16:46:45 -0500
X-MC-Unique: T0I41OMEPAGWtBeNqCHH_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 904463C025BD;
	Wed, 16 Nov 2022 21:46:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DAB6492B04;
	Wed, 16 Nov 2022 21:46:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6A5419465A3;
	Wed, 16 Nov 2022 21:46:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2795319465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 21:46:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05ACC477F5C; Wed, 16 Nov 2022 21:46:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2FF1477F55
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:46:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7C2738123A0
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:46:40 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-F5uat_UPMnWd8O15miqsdA-1; Wed, 16 Nov 2022 16:46:37 -0500
X-MC-Unique: F5uat_UPMnWd8O15miqsdA-1
Received: by mail-qt1-f197.google.com with SMTP id
 u31-20020a05622a199f00b003a51fa90654so14190393qtc.19
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 13:46:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zqBOrG9rli2QJrkKNVbeBDdgpPeZ5Pcyt9IVG+ltwAM=;
 b=0u+U6QqYjf3NzSjOn0P+qQHlRCeEtZJwkbWza1QObE91o8cbVjdbBdFEbV1mJKnLDW
 Vu6fuQ6S5/x96jHZ6SUo2b37rJYUAuJ/w7tXOQmr0+IFX5hKNzH9j/Byk1PD5DWHH2zi
 5O9zTceOK3jaouLJ533jYrS5uO7V4kc5tu6TZe/zb7oU8SUk+MpNyhGa3Do+Gf7/5Ely
 nXL3PpbLtCsjw44Hpj80l9DaCdQhyqdExbrsGk+ZaxDvURnNQnVx//oWCnRsrk390zNV
 e9MY1I42YdcOcMgUrCyknggnnYcGt3UsyLShXA34gN2YtpBEl1oq0r+Z0l1TYDXZNoTu
 9KBA==
X-Gm-Message-State: ANoB5pkH+gYy6rbnQktXMgfw728QykiQsE7IaRq1koroqmoFxZmhVGob
 yEV5IyxXtdaRaFjEliIBGcAoudmKr6m7U54Sr5NCa6sY/E8gJtTASjoJ7yCf37TBFqLQfuvH1Eq
 vLhV0EX2yzyUTvQ==
X-Received: by 2002:a05:620a:439c:b0:6f9:9833:1e21 with SMTP id
 a28-20020a05620a439c00b006f998331e21mr20998697qkp.715.1668635197043; 
 Wed, 16 Nov 2022 13:46:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5CNustigt3HWzBTGO59Iu4TDYZJeRnveeOzDy21Xv1w6GMw4lyGw6Oe0HN/e1q0sFig+Vh+Q==
X-Received: by 2002:a05:620a:439c:b0:6f9:9833:1e21 with SMTP id
 a28-20020a05620a439c00b006f998331e21mr20998686qkp.715.1668635196850; 
 Wed, 16 Nov 2022 13:46:36 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 f16-20020a05620a409000b006bb78d095c5sm10888736qko.79.2022.11.16.13.46.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 13:46:36 -0800 (PST)
Date: Wed, 16 Nov 2022 16:46:35 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y3VaO4PQo4rRIRBR@redhat.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
 <20221115141054.1051801-5-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221115141054.1051801-5-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3 04/10] dm: cleanup close_table_device
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
Cc: axboe@kernel.dk, yi.zhang@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 yukuai3@huawei.com, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 15 2022 at  9:10P -0500,
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> Take the list unlink and free into close_table_device so that no half
> torn down table_devices exist.  Also remove the check for a NULL bdev
> as that can't happen - open_table_device never adds a table_device to
> the list that does not have a valid block_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

