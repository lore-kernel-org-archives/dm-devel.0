Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E15C32771
	for <dm-devel@archiver.kernel.org>; Wed, 28 Sep 2022 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664391709;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mn9BfbNxqHRraYI4y2bMHYIaKLuO1L7nE/hDlzt6vb4=;
	b=LXFB3MdlDWxm5AHVcZOX3r/2EgSewPgDqgCIA6cfartwap4gX1rUfCHaCXf8QmvFFJhsUH
	KzM7GK1owMUrkxk+MuIW1BuGRkEdt535mXx5HRqj+p8I4453bQ/zCxZr8/Sul9GDb7LoLd
	KLa6A0twWsFjITMOdi/rrbTRnUqOc9o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-_LV1i5KHOweovsLBHS6kbQ-1; Wed, 28 Sep 2022 15:01:47 -0400
X-MC-Unique: _LV1i5KHOweovsLBHS6kbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D416F3815D23;
	Wed, 28 Sep 2022 19:01:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 566C44099B55;
	Wed, 28 Sep 2022 19:01:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3AD7119465B5;
	Wed, 28 Sep 2022 19:01:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 433C2194658F
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Sep 2022 18:13:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FB672027062; Wed, 28 Sep 2022 18:13:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 28C8F2027061
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 18:13:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D375F882827
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 18:13:35 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-BepI7bMbODKnLXRkZQWiIg-1; Wed, 28 Sep 2022 14:13:33 -0400
X-MC-Unique: BepI7bMbODKnLXRkZQWiIg-1
Received: by mail-pj1-f47.google.com with SMTP id
 r8-20020a17090a560800b00205eaaba073so2382396pjf.1; 
 Wed, 28 Sep 2022 11:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=SrqLT0kXpAlJD8TZzx8ujBa5nxZPe+zl7PnVUm+RbhE=;
 b=6enkas/OxJzM9VflNXvkib3ofBI1A/T+LPiFIUXecr//t5MKy3lyN11NhOHCxAdgR6
 ts0NHikvqsS5oCFiGTQx1/Qtjt72zRaIKx5HnjgOLLhomlZMRzgM6meZ5ee6NAxv/Yva
 QbFvFaBalVWm73bKNpyVkpNSTT8WRh8yoKeTcGKfY/BsMBIrJTvavGL2atK9CVc51KZB
 KMkQnZHR+3mQUFVrz2AnEwBU7DtRDVSajt+U2ju8Xz2EsPhwJlkqPvgGK/Ugbr6zNuY4
 P60l5XVVjcmgRLT2o8R8lqy63mvuTpM0L4nM4NAp97ehoY9FYRn5ruio197hn14cILqT
 jnQQ==
X-Gm-Message-State: ACrzQf3fWSJ4tkmdYk1RRSyEQtV6fJswbDJwQizUqzt2RQpuZe9L58Xu
 713m21KgIUqca+5JQx8AqVU=
X-Google-Smtp-Source: AMsMyM5phyXRHDoV48KwWkEssjx6POVAM7KislIcpIimObHNjJBChVYQkrXS8krHgOsN/67JiWvhEA==
X-Received: by 2002:a17:90a:4607:b0:202:e22d:4892 with SMTP id
 w7-20020a17090a460700b00202e22d4892mr11629503pjg.220.1664388811703; 
 Wed, 28 Sep 2022 11:13:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4cba:f1a9:6ef8:3759?
 ([2620:15c:211:201:4cba:f1a9:6ef8:3759])
 by smtp.gmail.com with ESMTPSA id
 p15-20020a1709027ecf00b0016f8e8032c4sm4014341plb.129.2022.09.28.11.13.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 28 Sep 2022 11:13:31 -0700 (PDT)
Message-ID: <d7004ae9-ad68-cb61-9ca8-0bf61efa0c21@acm.org>
Date: Wed, 28 Sep 2022 11:13:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Pankaj Raghav <p.raghav@samsung.com>, snitzer@kernel.org,
 axboe@kernel.dk, agk@redhat.com, hch@lst.de, damien.lemoal@opensource.wdc.com
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173631eucas1p23cceb8438d6b8b9c3460192c0ad2472d@eucas1p2.samsung.com>
 <20220923173618.6899-12-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220923173618.6899-12-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v15 11/13] dm: call dm_zone_endio after the
 target endio callback for zoned devices
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
Cc: pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/23/22 10:36, Pankaj Raghav wrote:
> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
> uses either native append or append emulation, and it is called before the
> endio of the target. But target endio can still update the clone bio
> after dm_zone_endio is called, thereby, the orig bio does not contain
> the updated information anymore.
> 
> Currently, this is not a problem as the targets that support zoned devices
> such as dm-zoned, dm-linear, and dm-crypt do not have an endio function,
> and even if they do (such as dm-flakey), they don't modify the
> bio->bi_iter.bi_sector of the cloned bio that is used to update the
> orig_bio's bi_sector in dm_zone_endio function.
> 
> This is a prep patch for the new dm-po2zoned target as it modifies
> bi_sector in the endio callback.
> 
> Call dm_zone_endio for zoned devices after calling the target's endio
> function.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

