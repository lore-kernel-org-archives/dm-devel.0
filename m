Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702F0ECAAD5
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662144216;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eygLMGsQSE0wbkQUTE9O0CNt32y8z6iuvxWiJBUEFqM=;
	b=Rohn0Tq+LOBNAr4QCCo0yMyyEXt0mLAVDKDhbPuS2jS9hwrtF7+ba57psIy4772+iL/sjb
	eRe2Zpws3X9odZ0GUZP06zZLOf+dJL3B2hp1g/JEQMkrcyWO2PvH6TL4GQBI/4FFyir+XL
	9ZbWXMSeXkgzExDHLDmc+7g6BlM3zPc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-12KiklIlP1axVwrrZzlJeg-1; Fri, 02 Sep 2022 14:43:33 -0400
X-MC-Unique: 12KiklIlP1axVwrrZzlJeg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BC29803917;
	Fri,  2 Sep 2022 18:43:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1212492CA2;
	Fri,  2 Sep 2022 18:43:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1F5B1946A44;
	Fri,  2 Sep 2022 18:43:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B7141946A42
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 18:43:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57FEF1415137; Fri,  2 Sep 2022 18:43:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 544E81415125
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 18:43:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BAEC2919ECA
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 18:43:26 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-495-rhRSzd0bP6SKx45-ZYkpsA-1; Fri, 02 Sep 2022 14:43:25 -0400
X-MC-Unique: rhRSzd0bP6SKx45-ZYkpsA-1
Received: by mail-qt1-f199.google.com with SMTP id
 h13-20020ac87d4d000000b00342f6c363afso2152549qtb.9
 for <dm-devel@redhat.com>; Fri, 02 Sep 2022 11:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=7Ygx506LgmFK7L1KUAyuf5pe5qs+tRV+yvCiaInsACw=;
 b=BTv1MD+dZhKiQMpBY0DjDnsKOfogXJyvSWBYlOK5BkvjUjWrJ9v6t3lTIRrDmf6V2K
 HTruTeWbRWYoyIxMbiVvB+AImpAl5aOmehg9uVBLR8QSNp4NE47F0IutElqjJP+55TYl
 Brryatlqr2xSpHZdV9dc2vLvkxXRGrJud414adfUX/xVT5gqx9xXlvKo6CD2zCDxto7H
 JCX7CVRNgvzjajghp4rueTVp0+A93aS8OoxCd5evfDikfH97HC5a+EpF6J+gmMN30nd/
 20eGupCXTkdJ8Usj3MS/+zTSrj+ZNNCyqkG2Qqg6xdLtYUKib/thWEwUThpjGsHs/ULm
 VekA==
X-Gm-Message-State: ACgBeo2d/+/VwC/gUi4AuLMohtoXHEefbYYqQuo0x4kfe61ejB502GYw
 a7LrRHx2+3rPM0kUEUmEMgb1SjAZ5Pl/0zdN1hHaxmt/j003/IJAC/gIngbKXOD4udVRYd/v9Tc
 qi+dvOF3iCErlWw==
X-Received: by 2002:a05:6214:c8f:b0:499:21eb:ba3b with SMTP id
 r15-20020a0562140c8f00b0049921ebba3bmr11683314qvr.97.1662144204578; 
 Fri, 02 Sep 2022 11:43:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7K6nBjFNlybScTP7Kemi+J2G3yUcqV9Mva+4TXiBdaw+VSNZOrU4SppDL6kJQ3vHr68+qN5A==
X-Received: by 2002:a05:6214:c8f:b0:499:21eb:ba3b with SMTP id
 r15-20020a0562140c8f00b0049921ebba3bmr11683298qvr.97.1662144204338; 
 Fri, 02 Sep 2022 11:43:24 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 c4-20020ac84e04000000b00344f936bfc0sm1406919qtw.33.2022.09.02.11.43.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Sep 2022 11:43:23 -0700 (PDT)
Date: Fri, 2 Sep 2022 14:43:22 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YxJOyq8Pf2vIExFf@redhat.com>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121914eucas1p2f4445066c23cdae4fca80f7b0268815b@eucas1p2.samsung.com>
 <20220823121859.163903-13-p.raghav@samsung.com>
 <YxFOS8fq8AeE5mkf@redhat.com>
 <96f90e1d-aa0f-1c76-bfc9-a87e978ad655@samsung.com>
MIME-Version: 1.0
In-Reply-To: <96f90e1d-aa0f-1c76-bfc9-a87e978ad655@samsung.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v12 12/13] dm: introduce DM_EMULATED_ZONES
 target type
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
Cc: axboe@kernel.dk, bvanassche@acm.org, pankydev8@gmail.com,
 matias.bjorling@wdc.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 02 2022 at  8:02P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> On 2022-09-02 02:28, Mike Snitzer wrote:
> > On Tue, Aug 23 2022 at  8:18P -0400,
> > Pankaj Raghav <p.raghav@samsung.com> wrote:
> > 
> >> Introduce a new target type DM_EMULATED_ZONES for targets with
> >> a different number of sectors per zone (aka zone size) than the underlying
> >> device zone size.
> >>
> >> This target type is introduced as the existing zoned targets assume
> >> that the target and the underlying device have the same zone size.
> >> The new target: dm-po2zone will use this new target
> >> type as it emulates the zone boundary that is different from the
> >> underlying zoned device.
> >>
> >> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> >> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > 
> > This patch's use of "target type" jargon isn't valid. 
> > 
> > Please say "target feature flag" and rename DM_EMULATED_ZONES to
> > DM_TARGET_EMULATED_ZONES in the subject and header.
> > Good catch. I will fix it up for the next version.
> > But, with those fixed:
> > 
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > 
> You mean <Reviewed-By> ? :)

Ah, yes Reviewed-By, force of habit ;)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

