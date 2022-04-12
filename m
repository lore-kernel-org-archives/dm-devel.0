Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E6AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 20:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649796769;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i4gtSWLuoCc7Sv1Q8lkDcbHgjoGqfp8FX2jHnkJRc4s=;
	b=RziyOYDcVoufS8e4nz6B2Se2raZfCj1tKLvbdbvRZqUBwxhlXQH09Qxl1nzKbBhoEwULcm
	DkrIMmD+58Nvh5PB4+4BTR8o4suIXy3PtjfkNV6OQA4JgLyNsIOIOzIvBMUnW6+wE3dleF
	MJSPh+nQQ/QXbSB/7fyijElo6r1UEQ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-ikfb3HtTNniPCnTATe_QYQ-1; Tue, 12 Apr 2022 16:52:48 -0400
X-MC-Unique: ikfb3HtTNniPCnTATe_QYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B13880005D;
	Tue, 12 Apr 2022 20:52:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4987A7AC3;
	Tue, 12 Apr 2022 20:52:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15277194036A;
	Tue, 12 Apr 2022 20:52:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6831D1949763
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 20:52:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54147401E01; Tue, 12 Apr 2022 20:52:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F9CF401DEC
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 20:52:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0637E80346F
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 20:52:44 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-eLtSr5i4MW-noLXf2ruYFg-1; Tue, 12 Apr 2022 16:52:43 -0400
X-MC-Unique: eLtSr5i4MW-noLXf2ruYFg-1
Received: by mail-qv1-f70.google.com with SMTP id
 t12-20020a0cea2c000000b004443d7585f0so61893qvp.19
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 13:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oSGlSFmkV0dQpkxytbOFilmxcRdv/gtOoUcqeFDKH3U=;
 b=VIvcqxk8lVvAu6VEf/fmiydNtfZPMw9feQkBj3rklfAl74HJOqByxpc1W/TLqhZOiL
 OhV3369KmiRq/U+2+F0lb6Q8Ou/JFjzB5NoGPBgpLHf18SUEKRNACL8Z08WkTXiVQPF3
 I7DwX4iO8nrei4J9KzqUfyWxVV3iyMUJCGmufqEaDHkyRrDhtZ4ihyj51kwuG3joLuqp
 7czQMwFrNt59q+e2V85nHI2eJtPJ122DHyZapHGaKg3YoEIa8iU0iAhc2I9/5ew9O2Ad
 SDX8KDDmrr5zEgMN0Tzhv0myzid7geYLNEEj3oXDGcQXMkCljYzbrshOQnCYRMmiWAw5
 wTRg==
X-Gm-Message-State: AOAM532jtl39MOHlUgA+PZT8qA3a8iWSFOVKnkqZYdb7pGg66hijs8tq
 LB81p2NAUuAjS8dyPyDElo9Rwmznkh1gK6OaiHET2HSYkO83xZrdJwnumvNhYEuwII1iEMCLoIl
 EuWcgD4YmZQX1/Q==
X-Received: by 2002:a37:82c7:0:b0:69c:1612:53f9 with SMTP id
 e190-20020a3782c7000000b0069c161253f9mr4447734qkd.408.1649796762098; 
 Tue, 12 Apr 2022 13:52:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbRAr69KUXZHA1hFRyE0EoPeOfDydesoZY9+W/e1MtrwpsCB2KNNv+dCQFRLorPvnzr6Oeog==
X-Received: by 2002:a37:82c7:0:b0:69c:1612:53f9 with SMTP id
 e190-20020a3782c7000000b0069c161253f9mr4447723qkd.408.1649796761847; 
 Tue, 12 Apr 2022 13:52:41 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 a7-20020a05622a064700b002e238d6db02sm28512669qtb.54.2022.04.12.13.52.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 13:52:41 -0700 (PDT)
Date: Tue, 12 Apr 2022 16:52:40 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YlXmmB6IO7usz2c1@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220412085616.1409626-6-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
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
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12 2022 at  4:56P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> The current DM codes setup ->orig_bio after __map_bio() returns,
> and not only cause kernel panic for dm zone, but also a bit ugly
> and tricky, especially the waiting until ->orig_bio is set in
> dm_submit_bio_remap().
> 
> The reason is that one new bio is cloned from original FS bio to
> represent the mapped part, which just serves io accounting.
> 
> Now we have switched to bdev based io accounting interface, and we
> can retrieve sectors/bio_op from both the real original bio and the
> added fields of .sector_offset & .sectors easily, so the new cloned
> bio isn't necessary any more.
> 
> Not only fixes dm-zone's kernel panic, but also cleans up dm io
> accounting & split a bit.

You're conflating quite a few things here.  DM zone really has no
business accessing io->orig_bio (dm-zone.c can just as easily inspect
the tio->clone, because it hasn't been remapped yet it reflects the
io->origin_bio, so there is no need to look at io->orig_bio) -- but
yes I clearly broke things during the 5.18 merge and it needs fixing
ASAP.

But I'm (ab)using io->orig_bio assignment to indicate to completion
that it may proceed.  See these dm-5.19 commits to see it imposed even
further:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=311a8e6650601a79079000466db77386c5ec2abb
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=56219ebb5f5c84785aa821f755d545eae41bdb1a

And then leveraged here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=4aa7a368370c2a172d5a0b8927c6332c4b6a3514

Could be all these dm-5.19 changes suck.. but I do know dm-zone.c is
too tightly coupled to DM core.  So I'll focus on that first, fix
5.18, and then circle back to "what's next?".

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

