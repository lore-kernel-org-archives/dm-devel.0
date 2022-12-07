Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CD5C4167B
	for <dm-devel@archiver.kernel.org>; Thu,  8 Dec 2022 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670519694;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8/Ky+f6vl9DbIsrYfNeOmrRYVtJ6lSYbmqTAH15bLaA=;
	b=Ar4r+X97Q3vhBJszxubcDse9WR3BcRHWANG5YYJS0n67KVCuisldrlWldwSAXWVpCVgu3M
	a9R7RS8wqeIdI6SjqgjxBBr826JVQy8JKFjK/LgZa8BbEg5jkkVsspYo92cbQCb02eSOmd
	y6M89elfM4mgqgn8bCUE+SRN+8BWFLc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-iXr3bH6dOzKN9lML0hL7qA-1; Thu, 08 Dec 2022 12:14:50 -0500
X-MC-Unique: iXr3bH6dOzKN9lML0hL7qA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C4CB101A54E;
	Thu,  8 Dec 2022 17:14:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D16B51121333;
	Thu,  8 Dec 2022 17:14:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D2B91947048;
	Thu,  8 Dec 2022 17:14:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD33919465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 20:28:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9F1342222; Wed,  7 Dec 2022 20:28:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A269342220
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 20:28:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 829D32A59559
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 20:28:19 +0000 (UTC)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-l_dOGxngPFSZisSSNp5ehQ-1; Wed, 07 Dec 2022 15:28:18 -0500
X-MC-Unique: l_dOGxngPFSZisSSNp5ehQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 ay19-20020a05600c1e1300b003cf758f1617so1273323wmb.5
 for <dm-devel@redhat.com>; Wed, 07 Dec 2022 12:28:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ERzjyp7zk5Z5+YVLaxlhiooylxoMa/YnIAQSVI50Phc=;
 b=wsB0gcsA3cFNF6vD0/meX0pOT/hrX7xKg43GN7qjydytxaXEDDn8kngrpq5J/M24zR
 Xkyse1DtAPLZAYHmCUnBJs4A84NT4OH4o96Qg9ZTCjYAjLBe0ZN/FfoBTugttWjJAsR6
 G0jDTwRPVD3SYFzPaCRHfpZGQelTqfd7qOpGbLA4FRA23TaMxVv6H12gFS9TlbFkjYV7
 9w2SfpfZMICk/RJTEHQ11z7wBXZmSrIbHnK1j+Q/oobY5QtkZFPzbij6VdPJLy9SK/Xs
 7uJLPyc1JcPb20kvEjOa0aysv2G9af6hL5M7A3x6Zo0nCJ76POEYJ6AGUDsZC3heI7Yx
 3whg==
X-Gm-Message-State: ANoB5plZcZmvZA0p5r/LTzFaMzpVEC9+4Drke6Io8nDnKFAyn+OGfApo
 0WHctGeCMU7cEHl1SfPYHD/Q7hHWDO2Ki2bwhqcUITUDQQb1DMRK72p9i6N7e1GVHZ+AtZIzkdT
 xfCrZ90rBH5OafZc=
X-Received: by 2002:adf:f98e:0:b0:242:324:ff88 with SMTP id
 f14-20020adff98e000000b002420324ff88mr35473847wrr.81.1670444897080; 
 Wed, 07 Dec 2022 12:28:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4QOq0RAPymVdkyXnh7/V2ZIzFLtZtJ+dwe3UW02/93b8NTVphp6L78PZAaWRCEXF7iho9Mtw==
X-Received: by 2002:adf:f98e:0:b0:242:324:ff88 with SMTP id
 f14-20020adff98e000000b002420324ff88mr35473829wrr.81.1670444896831; 
 Wed, 07 Dec 2022 12:28:16 -0800 (PST)
Received: from redhat.com ([2a02:14f:17a:1a4f:ce60:357c:370b:cc7e])
 by smtp.gmail.com with ESMTPSA id
 b12-20020a5d634c000000b00241e8d00b79sm25007953wrw.54.2022.12.07.12.28.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Dec 2022 12:28:16 -0800 (PST)
Date: Wed, 7 Dec 2022 15:28:10 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20221207152116-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
MIME-Version: 1.0
In-Reply-To: <Y5C/4H7Ettg/DcRz@infradead.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 08 Dec 2022 17:14:29 +0000
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 Alvaro Karsz <alvaro.karsz@solid-run.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 07, 2022 at 08:31:28AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 05:21:48AM -0500, Michael S. Tsirkin wrote:
> > Christoph you acked the spec patch adding this to virtio blk:
> > 
> > 	Still not a fan of the encoding, but at least it is properly documented
> > 	now:
> > 
> > 	Acked-by: Christoph Hellwig <hch@lst.de>
> > 
> > Did you change your mind then? Or do you prefer a different encoding for
> > the ioctl then? could you help sugesting what kind?
> 
> Well, it is good enough documented for a spec.  I don't think it is
> a useful feature for Linux where virtio-blk is our minimum viable
> paravirtualized block driver.

No idea what this means, sorry.  Now that's in the spec I expect (some)
devices to implement it and if they do I see no reason not to expose the
data to userspace.

Alvaro could you pls explain the use-case? Christoph has doubts that
it's useful. Do you have a device implementing this?

-- 
MST

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

