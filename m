Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89A5C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 14:49:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-SKQnp98mPVOXVkS8FcK_9w-1; Wed, 30 Mar 2022 10:49:50 -0400
X-MC-Unique: SKQnp98mPVOXVkS8FcK_9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65039811E75;
	Wed, 30 Mar 2022 14:49:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4678B2166B3F;
	Wed, 30 Mar 2022 14:49:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB7E01947BBB;
	Wed, 30 Mar 2022 14:49:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88FD819451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 14:49:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68112401E67; Wed, 30 Mar 2022 14:49:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64343401473
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 14:49:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44934185A7BA
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 14:49:44 +0000 (UTC)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com
 [209.85.166.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-kXH0u4xDPp6HwC0ZQ6PM7g-1; Wed, 30 Mar 2022 10:49:39 -0400
X-MC-Unique: kXH0u4xDPp6HwC0ZQ6PM7g-1
Received: by mail-il1-f177.google.com with SMTP id e18so14690270ilr.2
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 07:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=S7jHDD9H3A3SYC5lPe9ohlnX79nRebzt30Q3Ep3X12o=;
 b=A+gIFcoDyb/zFPzHMl44Vs21S//hru68JGo7/7ScIDydp0yFXGyqtkBKoqeu53mvoJ
 D0yNqXJughNjQJ63zqnxCkKlzDANENxeAx59fI0ITrcER85dwqfztTHjfbbuJ5ubGdLi
 Jk13jo1n2R4x1r+MHPdUXhoWkFUjIaIVD0ZSKv7xGQjbVpEK4zEWwKP0BNvt972cK6vB
 i9MDnaV5haRnycv0z3ZB6JiSqs8J02ID4N0iEu0HRW9wwVHkkUxUmZQA/pOTTsMClUmE
 OfwAo/ffdhyX3TgOVZ87dXywHWysg46ehgr5ULNe67t9CNyeJFwut2PInLQEisinMCfI
 2yOg==
X-Gm-Message-State: AOAM532DWWdb1P+Y0Kk/lgfllkIVvvzyJDqM0LiENmM223wwJzWuMFBa
 xjGlkLpAaCPYIVIthddcJh3rlg==
X-Google-Smtp-Source: ABdhPJz3EibI69DwP9lkcaYHyRWrAtLzvk4HhXkWXzgIOSW08I0BfaQQag5PmpjZEv83Snk+VZv0fA==
X-Received: by 2002:a05:6e02:1e0e:b0:2c6:18c3:9691 with SMTP id
 g14-20020a056e021e0e00b002c618c39691mr11475070ila.287.1648651778718; 
 Wed, 30 Mar 2022 07:49:38 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 r9-20020a6b6009000000b006412abddbbbsm11434439iog.24.2022.03.30.07.49.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 07:49:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
Message-Id: <164865177761.37391.13379579175408786139.b4-ty@kernel.dk>
Date: Wed, 30 Mar 2022 08:49:37 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] cleanup bio_kmalloc v2
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
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-bcache@vger.kernel.org,
 target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Phillip Lougher <phillip@squashfs.org.uk>, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 8 Mar 2022 07:15:46 +0100, Christoph Hellwig wrote:
> this series finishes off the bio allocation interface cleanups by dealing
> with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
> for the bio and bio_vecs with a hidden bio_init call and magic cleanup
> semantics.
> 
> This series moves a few callers away from bio_kmalloc and then turns
> bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
> inline biovecs.  The callers need to manually call bio_init instead with
> all that entails and the magic that turns bio_put into a kfree goes away
> as well, allowing for a proper debug check in bio_put that catches
> accidental use on a bio_init()ed bio.
> 
> [...]

Applied, thanks!

[1/5] btrfs: simplify ->flush_bio handling
      commit: 6978ffddd5bba44e6b7614d52868cf4954e0529b
[2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
      commit: 88a39feabf25efbaec775ffb48ea240af198994e
[3/5] target/pscsi: remove pscsi_get_bio
      commit: bbccc65bd7c1b22f050b65d8171fbdd8d72cf39c
[4/5] block: turn bio_kmalloc into a simple kmalloc wrapper
      commit: 57c47b42f4545b5f8fa288f190c0d68f96bc477f
[5/5] pktcdvd: stop using bio_reset
      commit: 1292fb59f283e76f55843d94f066c2f0b91dfb7e

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

