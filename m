Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3425C6FA82
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663351458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wVd5t4vWSKAv6SP0BD9HoLtVGJThfLhZavKwt5E7MTk=;
	b=bdQOKBN+lAFO3k+hGVoMNEv9G6IHZoLe/n11e7OmhHmwTEJXTp/VZnP6JGBY0pJMO/RYbU
	U/UzFOzRFmdhbwadl38/6EqHswShho/7eMFGKEwCKL2cDuWeCN6UCnXF03DSQNuQo6Qah4
	7QUy0/FQZu29WAyo0VjNHMRGLaP2uhs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-fTethhTZNL-Ypb1_4XoKRA-1; Fri, 16 Sep 2022 14:04:16 -0400
X-MC-Unique: fTethhTZNL-Ypb1_4XoKRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50AD880D08E;
	Fri, 16 Sep 2022 18:04:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0EF3C15BA4;
	Fri, 16 Sep 2022 18:04:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB4F0194658F;
	Fri, 16 Sep 2022 18:04:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBF461946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 18:04:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C01D7C15BA5; Fri, 16 Sep 2022 18:04:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B838AC15BA4
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 18:04:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AD6A101AA5D
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 18:04:12 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-T5kfWMBDMu2sG5Req7V74g-1; Fri, 16 Sep 2022 14:04:11 -0400
X-MC-Unique: T5kfWMBDMu2sG5Req7V74g-1
Received: by mail-qk1-f198.google.com with SMTP id
 n15-20020a05620a294f00b006b5768a0ed0so18855821qkp.7
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 11:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=+1Y0WCFyP/xwaopES4fLdWeNPtgD6wFT9927YdVHjxA=;
 b=zMwCmy7Cq/EPIA6qaJ+YCTJ8zQggdfDRFe5ayofwHZ5XVf4c+X+UDPCopGTToqT4/n
 ZYWOW6Xr7IJ8E4mfSgLm3VUhA79e5x0O+5JUMj4GVmWnPc8s4G4omOEZIhxcy6Wt7L4s
 lSQVD52Nm9QFY9cWcMEtGof/EYuD5cg+2x45Nv68+ChvXUzmrMEyo6YfEqjVmjY+wvn7
 nFFNlSRtDoMf8bt5rBrtiQB9krm/4xkvu9yuUcLVMlmUzWBcZhh8xYo0O2SQJyrC3esb
 G+5xGVUat3lZRURsjzXKu+E/uCh3ml1o6bxPqJQvhirOfvHRy4mO1LZsWBIF2LGxmy7i
 A/QA==
X-Gm-Message-State: ACrzQf1nnn2xbGucriZbEWDiXkEqR2UDhIihl5+ezBdau97mcLJoM8Up
 dyqA+WktSD03n0rY/9OOfZMe12B9Sk8tsAUvedC0BGwY+gEaFNhsMjuSy1d4pALsFaudLSlesvA
 YY+N+6KDpORmJaQ==
X-Received: by 2002:a05:622a:310:b0:344:89e4:cf8a with SMTP id
 q16-20020a05622a031000b0034489e4cf8amr5512044qtw.206.1663351450853; 
 Fri, 16 Sep 2022 11:04:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4avfW/4YAwR1npdBqO0O8h7AEDzFTbb8jsyKyqwPyhkUAoMtuvNzFwbiGDh+VRZqHyNgc5tQ==
X-Received: by 2002:a05:622a:310:b0:344:89e4:cf8a with SMTP id
 q16-20020a05622a031000b0034489e4cf8amr5512014qtw.206.1663351450637; 
 Fri, 16 Sep 2022 11:04:10 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 j15-20020a05620a410f00b006b5df4d2c81sm7417854qko.94.2022.09.16.11.04.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 16 Sep 2022 11:04:10 -0700 (PDT)
Date: Fri, 16 Sep 2022 14:04:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YyS6mUzqjq9P0+OG@redhat.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082220eucas1p24605fdcf22aedc4c40d5303da8f17ad5@eucas1p2.samsung.com>
 <20220912082204.51189-14-p.raghav@samsung.com>
 <YyIG3i++QriS9Gyy@redhat.com>
 <e42a0579-61b2-7b77-08cb-6723278490cc@samsung.com>
 <622ae86d-39ad-c45e-ec48-42abf4b257d2@samsung.com>
MIME-Version: 1.0
In-Reply-To: <622ae86d-39ad-c45e-ec48-42abf4b257d2@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v13 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 16 2022 at  1:57P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> >>
> >> Are you certain you shouldn't at least be exposing a different
> >> logical_block_size to upper layers?
> >>
> > To be honest, I tested my patches in QEMU with 4k Logical block size and on
> > a device with 4k LBA size.
> > 
> > I did a quick test with 512B LBA size in QEMU, and I didn't see any
> > failures when I ran my normal test suite.
> > 
> > Do you see any problem with exposing the same LBA as the underlying device?
> > 
> 
> Do you see any issues here? If not, I can send the next version with the
> other two changes you suggested.

That's fine, I just thought there might be special considerations
needed.  But if yo've tested it and upper layers work as expected then
obviously my concern wasn't applicable.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

