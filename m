Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD30C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Nov 2022 19:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668109729;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Luvig2TTsSDWwZQJXUNuIOyGVhdnc8intki7LhSctWo=;
	b=g9XwLtwN946s8Oo7GGFzHTZoQYnFBygwnAUX70EtKHmbKJM36wl45aoAdhi5ZLA+qs5p8w
	W/40K3e0gOGaunXKnLtTpAbMFEGRI7e/XkEWk4/xI/SR25sAzUT7ZykzWCtmsSPx8iUKeG
	Tgt8xwOJ025e36jhv3PQWSjYF4hCq+c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-G2J_qU3COu-U89L17Lekcw-1; Thu, 10 Nov 2022 14:48:46 -0500
X-MC-Unique: G2J_qU3COu-U89L17Lekcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B69C805B72;
	Thu, 10 Nov 2022 19:48:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 345B639D6A;
	Thu, 10 Nov 2022 19:48:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14B551946589;
	Thu, 10 Nov 2022 19:48:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D0F911946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Nov 2022 19:48:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6FB840C83F2; Thu, 10 Nov 2022 19:48:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B07D540C83F0
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 19:48:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92724101A528
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 19:48:41 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-Ab9KlePXPJm6AIJeAWKbZw-1; Thu, 10 Nov 2022 14:48:40 -0500
X-MC-Unique: Ab9KlePXPJm6AIJeAWKbZw-1
Received: by mail-qk1-f197.google.com with SMTP id
 o13-20020a05620a2a0d00b006cf9085682dso2930165qkp.7
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 11:48:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=gfbxZFxEhlWZYZh8MUln7gbj8wqnN8AA2+XD0JKtltQ=;
 b=rrl/hBJNf63NKmnKA5qIYiY8o3I14sd7u9q6cJYgIpFPtN9HAvSzQeVxoZ1/Gtv3+t
 RhuohBLhwxyDF8gFHrKqnBPPgn9y+Jk8mYvHbe8i5alcsFHSqw7Mf+TKgD6lJaeLQPze
 HgnFTIBoJ6wo7fOacti6CjN6tyTz9pNuVNVD13PvOqdxdAN5qUcx4LyTFG8JqNRA/+Vr
 lZdoklHibVAWxcHCoYZB9xuAEzjWVqp7dQjaXYy7lf1vaIcPf4vQIWIp/gvHrc2TFL3T
 5Q98CZSOk++8eX8BbTeDEG+1xgBlcJ6vDzmHkSUqQhAnI/hMnSjdUktD1JfoRMUKwoDn
 Aqag==
X-Gm-Message-State: ANoB5pnHzK8v33ggTsPR3ycaagnP/+Hh+LSBR8XS58i8tvoSHGzTbK8s
 DKnsUh75jSYaTmk0Wy34m4kSa2m0IeppBx1qGJtSe7yTcyiUaMULUL6RlTufQJEjvcaBe1QJfnP
 NQ5JReztlZmF7AQ==
X-Received: by 2002:ac8:5fc3:0:b0:3a5:9826:a3f2 with SMTP id
 k3-20020ac85fc3000000b003a59826a3f2mr14873016qta.243.1668109719597; 
 Thu, 10 Nov 2022 11:48:39 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5th/wRJIR+zYpR6tRSP50/PBnDastQ7kzagzJ66Q1qmplYe0gU3MBfTSFabdkB4nsYC/JiLw==
X-Received: by 2002:ac8:5fc3:0:b0:3a5:9826:a3f2 with SMTP id
 k3-20020ac85fc3000000b003a59826a3f2mr14873007qta.243.1668109719403; 
 Thu, 10 Nov 2022 11:48:39 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 l11-20020a37f90b000000b006fa9d101775sm142266qkj.33.2022.11.10.11.48.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 11:48:38 -0800 (PST)
Date: Thu, 10 Nov 2022 14:48:37 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y21VlVHSisUaHJC5@redhat.com>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-6-hch@lst.de>
 <9b5b4c2a-6566-2fb4-d3ae-4904f0889ea0@huaweicloud.com>
 <20221109082645.GA14093@lst.de> <Y20+UNI0KV2VjUSi@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y20+UNI0KV2VjUSi@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 5/7] dm: track per-add_disk holder relations
 in DM
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 10 2022 at  1:09P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> The concern for race aside:
> I am concerned that your redundant bd_link_disk_holder() (first in
> open_table_device and later in dm_setup_md_queue) will result in
> dangling refcount (e.g. increase of 2 when it should only be by 1) --
> given bd_link_disk_holder will gladly just bump its holder->refcnt if
> bd_find_holder_disk() returns an existing holder. This would occur if
> a DM table is already loaded (and DM device's gendisk exists) and a
> new DM table is being loaded.

Nevermind, dm_setup_md_queue should only ever be called once.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

