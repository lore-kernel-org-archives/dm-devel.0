Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2855AC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:18:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B53D5610FD
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:18:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B53D5610FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-DKpD_Z6ePPmvdnT_ArhvOg-1; Fri, 05 Nov 2021 09:18:23 -0400
X-MC-Unique: DKpD_Z6ePPmvdnT_ArhvOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAB6518A0744;
	Fri,  5 Nov 2021 13:18:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91D855BAFB;
	Fri,  5 Nov 2021 13:18:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6C2BB1806D04;
	Fri,  5 Nov 2021 13:18:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A58P7W5020066 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 04:25:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4315440D1B9F; Fri,  5 Nov 2021 08:25:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F41A40D1B9E
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 08:25:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 119F7899EC3
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 08:25:07 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
	[209.85.128.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-273-2mX3gUsQNv2_vL3O2QQ-bw-1; Fri, 05 Nov 2021 04:25:05 -0400
X-MC-Unique: 2mX3gUsQNv2_vL3O2QQ-bw-1
Received: by mail-wm1-f45.google.com with SMTP id
	77-20020a1c0450000000b0033123de3425so9029087wme.0
	for <dm-devel@redhat.com>; Fri, 05 Nov 2021 01:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=EFUXh461CIiXVx1x45I6hR/O2ueRgYCwIDIidW8J+Tw=;
	b=jFB9SaAGnx2nB5WayodlcTlngbN6FIijiPHarvENnBoiG+DkTaFWc5RZg2o+tJ3LA+
	kg2clV1TAAZCqbbeKq9HHOJ3Z6yk2HYiYBSFUixwjLOqJFWKWPj5DJI3dXFdXSnx9TfK
	H7Infz+mSHilyEc/ghW7EGDXrTQCoMyhgxjsqJfMN/u+PTDVWThnXcYNoYh+Wxdd6lLF
	XAuG1+oOVxLBMKVh5ig8KsoQNpMD41XyZWYmxHGNMYKcoKtDROb+PIG0FDeVK3+9Y2ur
	4r5CWQZs4n6bJh5yRo/BVnnqZExURl1AiO7atWdtyweMADY/C6Swa4mXGjj1Bwp8Fd82
	y4hA==
X-Gm-Message-State: AOAM533ZeI/hdQE+oB1vBx+dejWi8Hm1rbAknzom+FoDduSxEYXdM191
	yd0eoVKcp5Kp8F48wlN25XWVDh4X/n6y20aFibk=
X-Google-Smtp-Source: ABdhPJx8UdeUgoUtHGGn9mgxXZu5qrGkFYtzQTF9umijJZfwGuuTFS/MsOT6GwSa2FPyLrvx70gJsw==
X-Received: by 2002:a1c:1b08:: with SMTP id b8mr27658572wmb.28.1636100703566; 
	Fri, 05 Nov 2021 01:25:03 -0700 (PDT)
Received: from localhost (5.186.126.13.cgn.fibianet.dk. [5.186.126.13])
	by smtp.gmail.com with ESMTPSA id r17sm3448703wmq.5.2021.11.05.01.25.02
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 05 Nov 2021 01:25:02 -0700 (PDT)
Date: Fri, 5 Nov 2021 09:25:01 +0100
From: "javier@javigon.com" <javier@javigon.com>
To: Keith Busch <kbusch@kernel.org>
Message-ID: <20211105082501.ltdfepz6inrffiux@mpHalley-2>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104071439.GA21927@lst.de>
	<661bcadd-a030-4a72-81ae-ef15080f0241@nvidia.com>
	<20211104173235.GI2237511@magnolia> <20211104173431.GA31740@lst.de>
	<20211104223736.GA2655721@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
In-Reply-To: <20211104223736.GA2655721@dhcp-10-100-145-180.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 05 Nov 2021 09:15:20 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Christoph Hellwig <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"clm@fb.com" <clm@fb.com>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 04.11.2021 15:37, Keith Busch wrote:
>On Thu, Nov 04, 2021 at 06:34:31PM +0100, Christoph Hellwig wrote:
>> On Thu, Nov 04, 2021 at 10:32:35AM -0700, Darrick J. Wong wrote:
>> > I also wonder if it would be useful (since we're already having a
>> > discussion elsewhere about data integrity syscalls for pmem) to be able
>> > to call this sort of thing against files?  In which case we'd want
>> > another preadv2 flag or something, and then plumb all that through the
>> > vfs/iomap as needed?
>>
>> IFF we do this (can't answer if there is a need) we should not
>> overload read with it.  It is an operation that does not return
>> data but just a status, so let's not get into that mess.
>
>If there is a need for this, a new io_uring opcode seems like the
>appropirate user facing interface for it.

+1 to this. I was looking at the patchset yesterday and this was one of
the questions I had. Any reasons to not do it this way Chaitanya?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

