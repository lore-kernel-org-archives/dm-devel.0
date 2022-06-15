Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7254C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 07:33:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-HUJaVfk1PyS-Zek59j9JLA-1; Thu, 16 Jun 2022 03:33:32 -0400
X-MC-Unique: HUJaVfk1PyS-Zek59j9JLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D61A3C0E20C;
	Thu, 16 Jun 2022 07:33:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6FBBA1121314;
	Thu, 16 Jun 2022 07:33:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41A8B194705A;
	Thu, 16 Jun 2022 07:33:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 82FE419466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:32:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63DEB1400AFB; Wed, 15 Jun 2022 10:32:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FF471415106
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:32:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 496D81044564
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:32:11 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-zQHpTm7MMI-Y_0Dapf1WWw-1; Wed, 15 Jun 2022 06:32:09 -0400
X-MC-Unique: zQHpTm7MMI-Y_0Dapf1WWw-1
Received: by mail-pj1-f42.google.com with SMTP id
 gc3-20020a17090b310300b001e33092c737so1619407pjb.3
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 03:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MKCQ4Kven3aZ8G3GecuK409NOxVitL3Lqc8x7hcJkoU=;
 b=3xNrQtYZlvwoVaXUUzxlHcocVMfVe7p+zoCw8KTt53D3dNjQnEujFdSdg4mw7HNBdJ
 G8AiZyRHoKMtue4baCBfBFGMN8r9zRgYxaLlaVC8cB0qERfgp2xRonqpuohh8i3w8PNS
 j0xiUYSYj5PQCLZPAklzG7BQ2oo6p04oGzkXMOyHoslYrd0fr8n7r2EkUBLwHQ7KfP1x
 KOvDziSibJAXvpWQPsUn34m7i3r91JX6KYKI2efVOhhdxUkmTPOei+zU/+GCKQTEebPC
 myy97vO+852CNbS9I02HKzk/SwmM4aYVWbzpIPYRi4aLYNslAPOkAeYd99BVP/+NypED
 V37g==
X-Gm-Message-State: AJIora/wswt1OJcBXZx8BoHJMNBROj5gJADk1HgFNcs9iBbPtq0yon+R
 PLs31TbaV1ildOZYnniXqeIzAaIeyOgs+GBH
X-Google-Smtp-Source: AGRyM1uaXQV3dVsMinLRj83h6vlRejswI4fVrPUeCXkrCTf5O1ZXq5QnAxKVyEkUrwDC2AbAmOsWRQ==
X-Received: by 2002:a17:902:eb8d:b0:168:e324:f0a3 with SMTP id
 q13-20020a170902eb8d00b00168e324f0a3mr9025285plg.56.1655289128345; 
 Wed, 15 Jun 2022 03:32:08 -0700 (PDT)
Received: from localhost ([122.183.153.161]) by smtp.gmail.com with ESMTPSA id
 y15-20020a170902d64f00b00163cc9d6a04sm8919738plh.299.2022.06.15.03.32.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Jun 2022 03:32:07 -0700 (PDT)
Date: Wed, 15 Jun 2022 12:32:04 +0200
From: Pankaj Raghav <pankydev8@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20220615103204.qck26yl2svict7ah@quentin>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220614090934.570632-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 16 Jun 2022 07:33:27 +0000
Subject: Re: [dm-devel] [PATCH 1/6] block: factor out a chunk_size_left
 helper
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pankaj Raghav <p.raghav@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 14, 2022 at 11:09:29AM +0200, Christoph Hellwig wrote:
> Factor out a helper from blk_max_size_offset so that it can be reused
> independently.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

