Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A48C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 15:40:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-QlwIQjoyOqOq4LSv1RHgGw-1; Thu, 03 Feb 2022 10:40:26 -0500
X-MC-Unique: QlwIQjoyOqOq4LSv1RHgGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B92F0876E3C;
	Thu,  3 Feb 2022 15:40:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC0F8798CF;
	Thu,  3 Feb 2022 15:40:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54A4B1809CB8;
	Thu,  3 Feb 2022 15:40:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213FeFCB014702 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 10:40:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37A0E40F9D6F; Thu,  3 Feb 2022 15:40:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33A6740F9D6D
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 15:40:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BDB61C05EAA
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 15:40:15 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
	[209.85.215.170]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-48-jbFBgJ4UOuaTCahcmRbeug-1; Thu, 03 Feb 2022 10:38:49 -0500
X-MC-Unique: jbFBgJ4UOuaTCahcmRbeug-1
Received: by mail-pg1-f170.google.com with SMTP id z131so2536605pgz.12;
	Thu, 03 Feb 2022 07:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=hJc80QrxeNpdYK/bKJzdbQZVP7dPgDgH6+/SL6BaJLA=;
	b=yc5X+9e6W+CAo4Wj+r+5HbM+kL/ibrPVN/Od5iXUMGLkFOFwfNWi9RH8L54GlcDQO4
	cNSt7wkUUMpbgyIYrDJFq2Sj+Pk5S5XS9zSIDIRwT9l+p4J/wCTttNfgMmXmL2PsmIyd
	96YhjiyjtobyxLyKuACOcwpFc1O76Zz03lGohJyrjnK9XwusDMe1q+UMIpB6CeKVzjYX
	0dbijSJSTNdvFZx5Rq9u6J14oSbBusRXqCmPhrAYRpYFW3b79C3dn/wXM7XGv7KSCNw5
	MPktihsDR3TtWOGLwaG6NgQ92o6IFDYrtYrGm9yKb0/bDkVXktcO1+TCKTD1xRJ+yH4G
	quZg==
X-Gm-Message-State: AOAM531c6ylVBssT6xG47sy61wgRDs8sf77OFRiNicV0UvD5C0WQq/3M
	jU4RoiqSSza1/ecR7srv4yw=
X-Google-Smtp-Source: ABdhPJyK53iWqvFX2Vqq2e4bGH4TKRnnEI6Nef430vI4MXHRwAQ64yyEJcJ63nBPtWhhnkJ6Y3aDlw==
X-Received: by 2002:a63:68c4:: with SMTP id
	d187mr15183399pgc.603.1643902727819; 
	Thu, 03 Feb 2022 07:38:47 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
	by smtp.gmail.com with ESMTPSA id
	b12sm12465462pfm.154.2022.02.03.07.38.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Feb 2022 07:38:46 -0800 (PST)
Date: Thu, 3 Feb 2022 07:38:43 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20220203153843.szbd4n65ru4fx5hx@garbanzo>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02, 2022 at 08:00:12AM +0000, Chaitanya Kulkarni wrote:
> Mikulas,
> 
> On 2/1/22 10:33 AM, Mikulas Patocka wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > This patch adds a new driver "nvme-debug". It uses memory as a backing
> > store and it is used to test the copy offload functionality.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> 
> 
> NVMe Controller specific memory backed features needs to go into
> QEMU which are targeted for testing and debugging, just like what
> we have done for NVMe ZNS QEMU support and not in kernel.
> 
> I don't see any special reason to make copy offload an exception.

One can instantiate scsi devices with qemu by using fake scsi devices,
but one can also just use scsi_debug to do the same. I see both efforts
as desirable, so long as someone mantains this.

For instance, blktests uses scsi_debug for simplicity.

In the end you decide what you want to use.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

