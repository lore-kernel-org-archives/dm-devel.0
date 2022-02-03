Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7179C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 16:07:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-HI2ctO6hOYOp9S60fv4QRA-1; Thu, 03 Feb 2022 11:06:55 -0500
X-MC-Unique: HI2ctO6hOYOp9S60fv4QRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAA951966322;
	Thu,  3 Feb 2022 16:06:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F2823779;
	Thu,  3 Feb 2022 16:06:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD8614BB7C;
	Thu,  3 Feb 2022 16:06:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213G6jZL016076 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 11:06:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 39346C23DC4; Thu,  3 Feb 2022 16:06:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34DCBC23DC3
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 16:06:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A6DE804181
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 16:06:45 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
	[209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-553--MWfaNzRPBKySPND4fRHxg-1; Thu, 03 Feb 2022 11:06:41 -0500
X-MC-Unique: -MWfaNzRPBKySPND4fRHxg-1
Received: by mail-pj1-f49.google.com with SMTP id h12so2824052pjq.3;
	Thu, 03 Feb 2022 08:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=CQl5z9carncWUpCNFDhmSPdjShzBxxx7Om9xnHB+4lM=;
	b=A5v+XGg/Nd7Oub8/tssN8+DD/G32yWz6IIaTwvegEQAY8o8e32uDZR5+13WGUlel9r
	UHaSjFaCh8CU1NjuhG4MAcOf3Q5Dg1IYfrWnwIRlRtqDI3Ajont/fRM/oEk3ActiuQfa
	NLmv8JZamzBAbXx1c/jrdfoumNveAPaxV8FFQLJE0uhrjSf+YRUqkN89rh2QqBE9OG/g
	LfivJqnS3d9pIA36BZQyxxXAHbvOhw3D0grwTXjtkG0AyOCwmANQsGww7sJOfBlXlCK1
	CmgBZ5NKTylTVM3ClTIoEdm7z1upV4p7gBnALfCLGkpE24PWpGlTbfjMWPflpFdX/Yev
	/HRg==
X-Gm-Message-State: AOAM530ZF3sZeq87v/wQ3+IZcy63sQYYZsaqyOlYzRRStnABA8dal6mx
	o/Gq8gUiRRh5SZ93znrlOzs=
X-Google-Smtp-Source: ABdhPJzhK8+95Srk1qUADNs99c7AM9hHsV465MsjDTT3FGN90VtQxc49I1xXzkBKwhRQs7yApS+AYA==
X-Received: by 2002:a17:903:2305:: with SMTP id
	d5mr35376153plh.122.1643904399872; 
	Thu, 03 Feb 2022 08:06:39 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
	by smtp.gmail.com with ESMTPSA id
	t7sm28321189pfj.138.2022.02.03.08.06.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Feb 2022 08:06:37 -0800 (PST)
Date: Thu, 3 Feb 2022 08:06:33 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Adam Manzanares <a.manzanares@samsung.com>
Message-ID: <20220203160633.rdwovqoxlbr3nu5u@garbanzo>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd@uscas1p2.samsung.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<20220202060154.GA120951@bgt-140510-bm01>
MIME-Version: 1.0
In-Reply-To: <20220202060154.GA120951@bgt-140510-bm01>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
> BTW I think having the target code be able to implement simple copy without 
> moving data over the fabric would be a great way of showing off the command.

Do you mean this should be implemented instead as a fabrics backend
instead because fabrics already instantiates and creates a virtual
nvme device? And so this would mean less code?

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

