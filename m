Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A55DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 17:04:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-HvMfTpz9OSCSUtj7pZ8EQQ-1; Wed, 13 Apr 2022 13:04:35 -0400
X-MC-Unique: HvMfTpz9OSCSUtj7pZ8EQQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7305811E84;
	Wed, 13 Apr 2022 17:04:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94D2D416140;
	Wed, 13 Apr 2022 17:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5CBB71940347;
	Wed, 13 Apr 2022 17:04:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5FF31940345
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 17:04:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80A2A53CF; Wed, 13 Apr 2022 17:04:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C9F17C28
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 17:04:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 657EC1C06915
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 17:04:29 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-vJI5pJWIMJubkPeanjL8JQ-1; Wed, 13 Apr 2022 13:04:27 -0400
X-MC-Unique: vJI5pJWIMJubkPeanjL8JQ-1
Received: by mail-qt1-f174.google.com with SMTP id a11so1799191qtb.12
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 10:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1gkKYNxAVgG9gQQX5FWE9T2WbQK+aJhhHh5HXzZzRl0=;
 b=Kq+AJlxCBik7pp2k/HHX+1uz88PASmEXSoYknYDCatcm8QO+fzCyUpjcomq+idJuPK
 LHf+z5KOA/Zc8BRUbNfnIGiamFc+94crIrUP++q2Nzoqt4zy+Vc096KI0FWdQsnZLUco
 pwIatirr45wuodmm0VrOqcvFP5NssO++Q8KpxYzzSorw1S8NXqYx5PoDJX1QPIMLmMXz
 Re6DnZ1L+OBl4wfipUt+Hgqq6NoQqBXZUMvQtzezdtsAsz6fK3r7q58uhn2X7Us/I7i1
 ahfiAb2fjorA43B3n9Yw3JpAQFzsBMhJzRTVmoM0eipb4Th5HPCf+Addt5dn6WvQ4OCe
 9juw==
X-Gm-Message-State: AOAM5321Gl+Z3oj2YvRqO1blYZ/FQWMRHnCn2WtkMEp2ugRIIUkbLUPp
 dcYLVAbhVQ655ddILpmN6/TUiwJua9oVrWs=
X-Google-Smtp-Source: ABdhPJzk8Hsy6b4fFdojSz0Z/fwMjicI2vghSEfVW7+AE/QcDDdQw502GSidyJJNTGoVWuUmwvp37w==
X-Received: by 2002:ac8:5e4e:0:b0:2e2:2bad:47b1 with SMTP id
 i14-20020ac85e4e000000b002e22bad47b1mr7781053qtx.493.1649869467355; 
 Wed, 13 Apr 2022 10:04:27 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 a23-20020a05620a103700b00699d49c511dsm16089900qkk.104.2022.04.13.10.04.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Apr 2022 10:04:26 -0700 (PDT)
Date: Wed, 13 Apr 2022 13:04:25 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YlcCmW0CLAFXB8UQ@redhat.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220406061228.410163-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/5] block: turn bio_kmalloc into a simple
 kmalloc wrapper
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 06 2022 at  2:12P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Remove the magic autofree semantics and require the callers to explicitly
> call bio_init to initialize the bio.
> 
> This allows bio_free to catch accidental bio_put calls on bio_init()ed
> bios as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

