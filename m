Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8B2C6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663773194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wW7b2uYWFg3YoltK40JL5nJMnP/nHoqO0o2vv2jddNY=;
	b=e4sdsKYwFiVoGxhJvoZAIX/rYfH9RzRyQG/jCCgOM3yMNUjlpm+c47bdL7JoPE0icL0GYh
	YqysipI1m9tEyP0tIcNKz722Qfqj5KD3w8PkmV2lcEuHkwWitRCkFXuDjWV2UN2An8l4Ix
	nx7rnam+XIhFLTLAMYgMqDIL54y6R2o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-AfdR9moaO-O-gRG1PxS-5Q-1; Wed, 21 Sep 2022 11:13:10 -0400
X-MC-Unique: AfdR9moaO-O-gRG1PxS-5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4B2C882826;
	Wed, 21 Sep 2022 15:13:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6746B2166B37;
	Wed, 21 Sep 2022 15:13:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5562D19465B1;
	Wed, 21 Sep 2022 15:13:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1ECCE19465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 15:08:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DC8A2166B2D; Wed, 21 Sep 2022 15:08:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 071702166B29
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 15:08:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 881DD384C6C5
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 15:08:46 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-hNvWOK3zMnmNLmUZzYwv_Q-1; Wed, 21 Sep 2022 11:08:45 -0400
X-MC-Unique: hNvWOK3zMnmNLmUZzYwv_Q-1
Received: by mail-qv1-f70.google.com with SMTP id
 ok32-20020a0562143ca000b004a10b5f97e6so4454693qvb.12
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 08:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Ptp1oLSt177eSTGNW8YxvUlUM4rs67KrLKfl9pj1Lys=;
 b=7DbEbkDVHs6idZ7GwQTqLXV9COVtS0jqs6sCDXo9eb0bwP8BVGUbz3HnoNsK71rUqg
 aUCDJOYHdycQCPyIPwIcPY2QSoyOeCdu/eE9mM9RAw/pBHpgKOIL8JW0W6P7lS7C79AD
 I3eB1OEnQlV0DAopOoQsZcTZ2LWJSnOXNE2VPMLXsSQJTsvJj6tOCPiis32I5yFDYTSA
 ficBnv4IW3sKCcJ46U9v/wlPZvPNxTGKjHOU5qy6GB2RKi7mQ0ezSkmu/Fi13R2FSCG0
 PwaobO3GSGg/9HQo/7pzZlUbKPEAuj8SZDPXIaPPXSmr4QTo45Py5AAE5BSeTT7sCMeR
 UOoQ==
X-Gm-Message-State: ACrzQf0vgRuTWJvvDjYoPc2tia4RwEhwX1oPIdTg5PgiMAtsXp3SdkDh
 Xh7vyIVo9wD5L6nems1fH8T7Ukut+GlypUUoPGECmFIyc5rr1DZo6oONRjc1IbRN4pIRzzAe9ze
 TS5lXQj1pzgQ7bg==
X-Received: by 2002:ac8:7d85:0:b0:35b:f5b1:63df with SMTP id
 c5-20020ac87d85000000b0035bf5b163dfmr23884640qtd.113.1663772924832; 
 Wed, 21 Sep 2022 08:08:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4EexL7l8DWx+8oreUyHWUiCWf8NA2huyVubxlwg6z5TXJwF+130R2NsOA173MiJm0z6yEZRA==
X-Received: by 2002:ac8:7d85:0:b0:35b:f5b1:63df with SMTP id
 c5-20020ac87d85000000b0035bf5b163dfmr23884597qtd.113.1663772924537; 
 Wed, 21 Sep 2022 08:08:44 -0700 (PDT)
Received: from localhost ([217.138.198.196]) by smtp.gmail.com with ESMTPSA id
 w7-20020ac857c7000000b0035bbb6268e2sm2041812qta.67.2022.09.21.08.08.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Sep 2022 08:08:44 -0700 (PDT)
Date: Wed, 21 Sep 2022 11:08:43 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Daniil Lunev <dlunev@google.com>
Message-ID: <Yyso+9ChDJQUf9B1@redhat.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
 <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
 <Yylvvm3zVgqpqDrm@infradead.org>
 <CAAKderPF5Z5QLxyEb80Y+90+eR0sfRmL-WfgXLp=eL=HxWSZ9g@mail.gmail.com>
 <YymkSDsFVVg1nbDP@infradead.org>
 <CAAKderNcHpbBqWqqd5-WuKLRCQQUt7a_4D4ti4gy15+fKGK0vQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAKderNcHpbBqWqqd5-WuKLRCQQUt7a_4D4ti4gy15+fKGK0vQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@google.com>,
 virtualization@lists.linux-foundation.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 20 2022 at  5:48P -0400,
Daniil Lunev <dlunev@google.com> wrote:

> > There is no such thing as WRITE UNAVAILABLE in NVMe.
> Apologize, that is WRITE UNCORRECTABLE. Chapter 3.2.7 of
> NVM Express NVM Command Set Specification 1.0b
> 
> > That being siad you still haven't actually explained what problem
> > you're even trying to solve.
> 
> The specific problem is the following:
> * There is an thinpool over a physical device
> * There are multiple logical volumes over the thin pool
> * Each logical volume has an independent file system and an
>   independent application running over it
> * Each application is potentially allowed to consume the entirety
>   of the disk space - there is no strict size limit for application
> * Applications need to pre-allocate space sometime, for which
>   they use fallocate. Once the operation succeeded, the application
>   assumed the space is guaranteed to be there for it.
> * Since filesystems on the volumes are independent, filesystem
>   level enforcement of size constraints is impossible and the only
>   common level is the thin pool, thus, each fallocate has to find its
>   representation in thin pool one way or another - otherwise you
>   may end up in the situation, where FS thinks it has allocated space
>   but when it tries to actually write it, the thin pool is already
>   exhausted.
> * Hole-Punching fallocate will not reach the thin pool, so the only
>   solution presently is zero-writing pre-allocate.
> * Not all storage devices support zero-writing efficiently - apart
>   from NVMe being or not being capable of doing efficient write
>   zero - changing which is easier said than done, and would take
>   years - there are also other types of storage devices that do not
>   have WRITE ZERO capability in the first place or have it in a
>   peculiar way. And adding custom WRITE ZERO to LVM would be
>   arguably a much bigger hack.
> * Thus, a provisioning block operation allows an interface specific
>   operation that guarantees the presence of the block in the
>   mapped space. LVM Thin-pool itself is the primary target for our
>   use case but the argument is that this operation maps well to
>   other interfaces which allow thinly provisioned units.

Thanks for this overview. Should help level-set others.

Adding fallocate support has been a long-standing dm-thin TODO item
for me. I just never got around to it. So thanks to Sarthak, you and
anyone else who had a hand in developing this.

I had a look at the DM thin implementation and it looks pretty simple
(doesn't require a thin-metadata change, etc).  I'll look closer at
the broader implementation (block, etc) but I'm encouraged by what I'm
seeing.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

