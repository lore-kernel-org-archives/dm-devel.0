Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F57C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 22:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668639128;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xsuKyAsvrkeR4X62sWa5tVU4iTz2LDaiZjVuvCCiZBo=;
	b=Al+fgvOV+yWTSvjvza0gRz081QuixBovz+Dz60h0JOREj1+L+d6fnWf5ao+Uh+oh6s0Zf1
	sWj5CSwjb0t0POQOa4HFozCp3F8bjlQGdTLYB60HAkqnpdJhFqXMgqCY8qPPvvC4VR9RBh
	DKM2sZZE2LkmAfzFiAkO6+fm0pmKqiY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-b1SHHKFxODStkRjTEBfzfw-1; Wed, 16 Nov 2022 17:52:03 -0500
X-MC-Unique: b1SHHKFxODStkRjTEBfzfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C7AD38164CE;
	Wed, 16 Nov 2022 22:52:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8AE440C6EC3;
	Wed, 16 Nov 2022 22:52:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B56FD19465A3;
	Wed, 16 Nov 2022 22:52:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB52C19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 22:10:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D799249BB62; Wed, 16 Nov 2022 22:10:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D0A0649BB60
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 22:10:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B541B185A792
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 22:10:57 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-Y7lDeCTzOw6rfeUJ9hU54g-1; Wed, 16 Nov 2022 17:10:54 -0500
X-MC-Unique: Y7lDeCTzOw6rfeUJ9hU54g-1
Received: by mail-qk1-f197.google.com with SMTP id
 de43-20020a05620a372b00b006fae7e5117fso40138qkb.6
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 14:10:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=7vamPlcLskGy2JvIhU266turZK2l7Sx2cyKxaPLx7j8=;
 b=ZPnkGHIQjpBUVywi0M7hDqB7M5z4mDsOsn8JPffd8l1hBrGaluvqi4Smo3ac+WLZAF
 99VTIIKUT1cWtaQ42chGTtN4UntZIxr/vWKbY7dPXDTE/hJXoPGiVV1sF3Vsn0Nvh+1L
 XIbn7s9I2FT2MkWI/mC9Wi1n7aeErAQm8Q7gvif3ynv4iuk7d/Jyr4Cj8TEvoQd2HQ0R
 XwC/kDm1jynu0Sk1xTum13XTanwh4dE/kS7o6xsy7swNUPeQoFxZt8SChI03uHy/ADtQ
 YEKWO35SLLWFrk+wynZLmIBRncS2CmN8lfCQGBr2GJS3kyNrLNOviu++CmkzrjSwM0mb
 X6sg==
X-Gm-Message-State: ANoB5plD1gnto9Wyfb+HxdrnNbLK0/5kpO6DcMlUAFKvQ/iJDmXWj1s4
 4qu+W5S+jjmXx9Zzou6BwTiX5tyy1G6hTZkAV2Nbqkpctha5mqSoL+JVp0LPDYVcpLIDKLkFOyf
 H5uWOwcgyGGqFrA==
X-Received: by 2002:a0c:f4cd:0:b0:4b1:8ec4:4464 with SMTP id
 o13-20020a0cf4cd000000b004b18ec44464mr173726qvm.16.1668636654008; 
 Wed, 16 Nov 2022 14:10:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4znPzbOMmRcBIPotkDkuJjcA84kJF/jJYUJhZDK9rm9yXJQWV/5W2Fydvh5O0bt2+81eunGg==
X-Received: by 2002:a0c:f4cd:0:b0:4b1:8ec4:4464 with SMTP id
 o13-20020a0cf4cd000000b004b18ec44464mr173707qvm.16.1668636653766; 
 Wed, 16 Nov 2022 14:10:53 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bq40-20020a05620a46a800b006f7ee901674sm10691245qkb.2.2022.11.16.14.10.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 14:10:53 -0800 (PST)
Date: Wed, 16 Nov 2022 17:10:52 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y3Vf7LYexIXiUeOE@redhat.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
 <20221115141054.1051801-2-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221115141054.1051801-2-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3 01/10] block: clear ->slave_dir when
 dropping the main slave_dir reference
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
> Zero out the pointer to ->slave_dir so that the holder code doesn't
> incorrectly treat the object as alive when add_disk failed or after
> del_gendisk was called.
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

