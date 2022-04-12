Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38714C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 07:52:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-Ydh9hh2HNw6on6kohH6uXg-1; Tue, 12 Apr 2022 03:52:32 -0400
X-MC-Unique: Ydh9hh2HNw6on6kohH6uXg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA7E01066543;
	Tue, 12 Apr 2022 07:52:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7568A111E3FD;
	Tue, 12 Apr 2022 07:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C9271949762;
	Tue, 12 Apr 2022 07:52:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 890391947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 07:52:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64B6E2166BDD; Tue, 12 Apr 2022 07:52:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 600712166BDC
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 07:52:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6161B1C04B47
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 07:52:19 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-EdxxPFZ0Ob66jPyQG5_NaQ-1; Tue, 12 Apr 2022 03:52:17 -0400
X-MC-Unique: EdxxPFZ0Ob66jPyQG5_NaQ-1
Received: by mail-pj1-f46.google.com with SMTP id
 s14-20020a17090a880e00b001caaf6d3dd1so1922647pjn.3
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 00:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PdNJO9jKeiU6aIag2xubkGaXQwXjChJyaN34FakShGY=;
 b=hJihVKTGCDeAPdcwY2b0KbeF3sK+ed1fIhGq31vv2TcQSto5uY+Jqhk0MIi99llxzG
 KYvgZrVOEuSdPP89cUuYL5GAy5K4h2iQzQlNZ1dUN8zpkBcGDC49niieK2uEWZNWKwDc
 5zsFy1fWQJHwE6EcbtLdRih4IDEAZam9fvXJnQ5/Xl30AG+wLnThpb+I+Nm/QGinU+kj
 Hl0G0FqY2bLYHUyzGnSc4CXgAW8Yos1PJCImOAMy/IVwdK0RALyTtetljwm4qn+Hzxbm
 kgNCervXjmr96HvrEAWNxoNFELlI/+h1R/E08lhpmpMGzGM1GgslfMdYPeIs5CzRKF/k
 Xvng==
X-Gm-Message-State: AOAM533ndXDoJrUyzBXOko0miucMPCX/6/TkuqunWiPRW/WQEGSF8Gyp
 u/XoqKT/4J+j9EQk6CTeJpU=
X-Google-Smtp-Source: ABdhPJw3kPhCuAbQ5kwytznaF5rAWDrtwt4O2z2AZ5FETVqH+AjSQrIjZkQ9M2KwrcrdOTXs8Khxlw==
X-Received: by 2002:a17:902:7247:b0:156:9d3d:756d with SMTP id
 c7-20020a170902724700b001569d3d756dmr36508813pll.6.1649749935972; 
 Tue, 12 Apr 2022 00:52:15 -0700 (PDT)
Received: from fedora (136-24-99-118.cab.webpass.net. [136.24.99.118])
 by smtp.gmail.com with ESMTPSA id
 k187-20020a636fc4000000b003983a01b896sm1881676pgc.90.2022.04.12.00.52.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 00:52:15 -0700 (PDT)
Date: Tue, 12 Apr 2022 00:52:13 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YlUvrXX2M3VqsgCQ@fedora>
References: <YkRM7Iyp8m6A1BCl@fedora> <YkUwmyrIqnRGIOHm@infradead.org>
 <YkVBjUy9GeSMbh5Q@fedora> <YkVxLN9p0t6DI5ie@infradead.org>
 <YlBX+ytxxeSj2neQ@redhat.com> <YlEWfc39+H+esrQm@infradead.org>
 <YlReKjjWhvTZjfg/@redhat.com> <YlRiUVFK+a0DwQhu@redhat.com>
 <YlRmhlL8TtQow0W0@redhat.com> <YlUN2pVsIn1dbzHg@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YlUN2pVsIn1dbzHg@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] block: remove redundant blk-cgroup init from
 __bio_clone
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
Cc: linux-block@vger.kernel.org, tj@kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, axboe@kernel.dk
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

On Mon, Apr 11, 2022 at 10:27:54PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 01:33:58PM -0400, Mike Snitzer wrote:
> > When bio_{alloc,init}_clone are passed a bdev, bio_init() will call
> > bio_associate_blkg() so the __bio_clone() work to initialize blkcg
> > isn't needed.
> 
> No, unfortunately it isn't as simple as that.  There are bios that do
> not use the default cgroup and thus blkg, e.g. those that come from
> cgroup writeback.

Yeah I wasn't quite right earlier. But, the new api isn't in line with
the original semantics. Cloning the blkg preserves the original bios
request_queue which likely differs from the bdev passed into clone. This
means an IO might be charged to the wrong device.

So, the blkg combines the who, blkcg, and the where, the corresponding
request_queue. Before bios were inited in 2 phases:
    bio_alloc();
    bio_set_dev();

This meant at clone time, we didn't have the where, but the who was
encased in the blkg. So, after bio_clone_blkg_association() expected a
bio_set_dev() call which called bio_associate_blkg(). When the bio
already has a blkg, it attempts to reuse the blkcg while using the new
bdev to find the correct blkg.

The tricky part seems to be how to seamlessly expose the appropriate
blkcg without being intrusive to bio_alloc*() apis.

Regarding the NULL bdev, I think that works as long as we keep the
bio_clone_blkg_association() call to carry the correct blkcg to the
bio_set_dev() call.

Thanks,
Dennis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

