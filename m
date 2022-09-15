Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E18FECAAA1
	for <dm-devel@archiver.kernel.org>; Thu, 15 Sep 2022 06:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663223205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9yUx2krqm6V+BOohz/VoocY27OBRjW2YX0KuW9cIjpw=;
	b=P+9MD+4cIt24J4Ef8gVpt1FmvulqTGfKp13HDrXeiavAIFiS2gN3WFh4QfaVbKN4ADr3BV
	mw1XUgQauxM/1HRMbaZs9aE6L4Z5Ae+6NASLzpyZu/SmJb0F9TDO7GV8klEoVZL0Coygum
	idzSBcLDcm0IcP5CJoEHomx9aGT5O88=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-CqFHXBRFMIybeqXzURYVwA-1; Thu, 15 Sep 2022 02:26:42 -0400
X-MC-Unique: CqFHXBRFMIybeqXzURYVwA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26003101CC62;
	Thu, 15 Sep 2022 06:26:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B5FD492B04;
	Thu, 15 Sep 2022 06:26:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5EBC61946587;
	Thu, 15 Sep 2022 06:26:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FC0A1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 06:26:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED62F492CA4; Thu, 15 Sep 2022 06:26:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E96CD492CA2
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 06:26:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D049293248B
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 06:26:33 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-88-3RU_4uxgOmSepyH-e6zCmg-1; Thu, 15 Sep 2022 02:26:31 -0400
X-MC-Unique: 3RU_4uxgOmSepyH-e6zCmg-1
Received: by mail-wr1-f48.google.com with SMTP id cc5so19343937wrb.6
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 23:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=53azt2CEsZCggGAheq6TyF6iTOmbICnkxb2hCWHTNe4=;
 b=ifd/jZAOK2AnanRiGI2mnm4Sw70kLcuQX8ijkvAKxe1h3mO7oA1XePy7YFhSHrTCpI
 mo5kz0M6aChZ78WA8OlYvPnCakmtgiEQ4jD1qtg6Imr5rmGlIgKhqDl9E8CuAOjvnvqR
 qg1ZlnCKsZeSgMq9iqj+EWn26iWey/LMiBGdviugTHVqOGdo7912dz9HOM/Y336QmLLC
 BYbkaMPQDTYjobjeITSXrcGiJnY6MHiQiwzHY03bsc6RF88Sap/uN9Rzdvr4N054Dh/p
 h36Y356gFsh1buTMVmoAc9UTa3HExHQoMkza2/ZCySSFmbfc0jpUTMYi5gy/hh5wrc0G
 vy/g==
X-Gm-Message-State: ACgBeo2SjibBkdi8EGeN9EjLn3NlH/8Oh3XiR/4cOBon8/3/04Kd9Fes
 5awCYpNQW9rWM8hXHM2n8PwQPA==
X-Google-Smtp-Source: AA6agR5O6KCBYKVXODqzNESnvoRQ/SxDLu+VkMuLHccnWb1AGPucfcGiOPIRJxVCp13GZChM1mxA7Q==
X-Received: by 2002:a5d:5644:0:b0:22a:6b69:27f0 with SMTP id
 j4-20020a5d5644000000b0022a6b6927f0mr12746781wrw.650.1663223190095; 
 Wed, 14 Sep 2022 23:26:30 -0700 (PDT)
Received: from [127.0.0.1] ([185.122.133.20]) by smtp.gmail.com with ESMTPSA id
 m15-20020a05600c3b0f00b003b49ab8ff53sm1750543wms.8.2022.09.14.23.26.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 14 Sep 2022 23:26:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
In-Reply-To: <alpine.LRH.2.02.2209141549480.28100@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209141549480.28100@file01.intranet.prod.int.rdu2.redhat.com>
Message-Id: <166322318866.3079.9447693766159343280.b4-ty@kernel.dk>
Date: Thu, 15 Sep 2022 00:26:28 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] blk-lib: fix blkdev_issue_secure_erase
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Chao Yu <chao@kernel.org>,
 Coly Li <colyli@suse.de>,
 =?UTF-8?Q?_Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 14 Sep 2022 16:55:51 -0400 (EDT), Mikulas Patocka wrote:
> There's a bug in blkdev_issue_secure_erase. The statement
> "unsigned int len = min_t(sector_t, nr_sects, max_sectors);"
> sets the variable "len" to the length in sectors, but the statement
> "bio->bi_iter.bi_size = len" treats it as if it were in bytes.
> The statements "sector += len << SECTOR_SHIFT" and "nr_sects -= len <<
> SECTOR_SHIFT" are thinko.
> 
> [...]

Applied, thanks!

[1/1] blk-lib: fix blkdev_issue_secure_erase
      commit: c4fa368466cc1b60bb92f867741488930ddd6034

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

