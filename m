Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E58C43219
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668635422;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bMGPMwmyv4wQkaBAHZah1DjuxANDn2JFmyIS+Pjfm6s=;
	b=EcNN6z7ChQKzG+AdXbucphCwAReCEMqpWOCHAsZMyUuATqsFHP6Bjqywy/mKJSjvOgcGBh
	woSdpb4ZEwExUEavGu7asBjTwJRJZ2Xh9h/0We7ARTs4uO5/3a0vJ1YNNJGVQzwd7cvPwt
	H6/xTQSgo3CkLBs+i3EgnCTX+as9P9s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-1_Ej_KdoNf-UhbQ0mbe9Tg-1; Wed, 16 Nov 2022 16:50:19 -0500
X-MC-Unique: 1_Ej_KdoNf-UhbQ0mbe9Tg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F38938035AF;
	Wed, 16 Nov 2022 21:50:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26CEF40C98ED;
	Wed, 16 Nov 2022 21:50:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7AD019465A3;
	Wed, 16 Nov 2022 21:50:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C4F319465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 21:50:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0BEF2166BDD; Wed, 16 Nov 2022 21:50:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 876412166B4C
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:50:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED8D2A2AD7C
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:50:07 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-49Bzw2eANZOOu0xVSMbHkw-1; Wed, 16 Nov 2022 16:50:05 -0500
X-MC-Unique: 49Bzw2eANZOOu0xVSMbHkw-1
Received: by mail-qk1-f200.google.com with SMTP id
 q14-20020a05620a0d8e00b006ef0350dae1so18719142qkl.12
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 13:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3w8sc6ccmIuZ5y2kueBPTj95unxJJNUHkbfTdAl9rzY=;
 b=YmnvXg61ypUV5lfaNc2q2gTEC8+oHqsZw1Ll82IjFEtjJuEk/6nl8sGbrEMDLW2ZFA
 LL6fJ4qby2bFwjgJq4hXfJxwyzucCzT/u5eszqvzP27qHicMnqnbqKfOzcKQLrQTHtY7
 k6X4DA9mlcVSHky/+QbZF+ivqeQVr9iosWNT5QwOLBVg+V1o5LwI9lnPCSrSNs/CZwsx
 WFaT1d28FUiIhlj3y/CATJ7sU0FIAj1OxqE6f+bVrQ8H+vItFNtDIsut8OW59044q1MH
 jBSRnYMAeVDvKwUYwHejIIhdI634xlsZOCmscurOEcyPmpa0SAQILjh+4YPAyAJMtavb
 aaLA==
X-Gm-Message-State: ANoB5pnIxi/oX4oOqc7KAZ4OQt+mHGXz3Gwd18MqdWuGy+x3RehHaqx6
 pT+ES6Nozae/oCwe1IIYm5wFL9bUyhE8mrpIboRRr0LqsootIujZUybLGhaxuF9NCbmnH7SBYGz
 O/KYvU/RNDjiTOg==
X-Received: by 2002:ad4:40c1:0:b0:4bb:84ba:a413 with SMTP id
 x1-20020ad440c1000000b004bb84baa413mr4742qvp.100.1668635398947; 
 Wed, 16 Nov 2022 13:49:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4BnT2ggUvkeRYRo5Emt1G4E8xePLqRg/4lNDVcvpLW30ftub/O923iYrtX29gcyNWbOz9JeA==
X-Received: by 2002:ad4:40c1:0:b0:4bb:84ba:a413 with SMTP id
 x1-20020ad440c1000000b004bb84baa413mr4725qvp.100.1668635398766; 
 Wed, 16 Nov 2022 13:49:58 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 o26-20020ac8699a000000b003a50b9f099esm9307666qtq.12.2022.11.16.13.49.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 13:49:58 -0800 (PST)
Date: Wed, 16 Nov 2022 16:49:57 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y3VbBeuQvOLKH81a@redhat.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
 <20221115141054.1051801-7-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221115141054.1051801-7-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3 06/10] dm: track per-add_disk holder
 relations in DM
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 15 2022 at  9:10P -0500,
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> dm is a bit special in that it opens the underlying devices.  Commit
> 89f871af1b26 ("dm: delay registering the gendisk") tried to accommodate
> that by allowing to add the holder to the list before add_gendisk and
> then just add them to sysfs once add_disk is called.  But that leads to
> really odd lifetime problems and error handling problems as we can't
> know the state of the kobjects and don't unwind properly.  To fix this
> switch to just registering all existing table_devices with the holder
> code right after add_disk, and remove them before calling del_gendisk.
> 
> Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
> Reported-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

