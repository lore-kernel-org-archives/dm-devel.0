Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF64EC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 01:55:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-6eqJVSZiMU-UplYOr8B95w-1; Mon, 31 Jan 2022 20:55:01 -0500
X-MC-Unique: 6eqJVSZiMU-UplYOr8B95w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C9F814246;
	Tue,  1 Feb 2022 01:54:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 106FE5E480;
	Tue,  1 Feb 2022 01:54:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72C851809CB8;
	Tue,  1 Feb 2022 01:54:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2111sjx2025894 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 20:54:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1256140885B1; Tue,  1 Feb 2022 01:54:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D39040885A7
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 01:54:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7CB41C05153
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 01:54:44 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
	[209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-669-655X-9HeN6CR7LAO4AU6qA-1; Mon, 31 Jan 2022 20:54:41 -0500
X-MC-Unique: 655X-9HeN6CR7LAO4AU6qA-1
Received: by mail-pf1-f177.google.com with SMTP id u130so14487276pfc.2;
	Mon, 31 Jan 2022 17:54:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=DEQ16urBvP0UlaY7sL7xRV/9fsqy0EWylw9ub26/KfQ=;
	b=Nxx7bafM5cIsRn24icGR4hiKxBfbIhaWqIsr+Z4rZYFzD1lLiivP3U9CcynU6UEyUn
	s5zKrIuEQ+37D737n4lxvzvjBu/q5c7baqH/20c46LN8EfAz6WVZZHO8caZmrWS7ZJor
	1aneQCEfUW4d4/X4ZpBQFpyTJJMHsIISXDW+EcmyuFH3g0pYm0hX1Jbictx0qkTU/YSa
	B1Fkh/+fdXE7ZFnnxymsktJDp15Wu1t9D8mCJiyvTBpDGZDC/ITfe3hC8G/jvRgKWPv0
	IB80RZ1b8Uspslgpsp3htNwXzclz3AzANdsBkbj4HRFJcR2S7Qf6gHMQ2fxWyhlufOH2
	cvJw==
X-Gm-Message-State: AOAM533KPT0WBP4lQARVFt9Rh/Wb81/fIe0v4++VRH9PjQfWsQLB5pck
	UcCcDxyK6WDvtJ6Cm4PAzxk=
X-Google-Smtp-Source: ABdhPJxwurPLwookDKYfdK759aK7v43l+AjycUMO4NhyGq1GqximIDE/k24pt0ls+ZyULuBGbLpUaw==
X-Received: by 2002:a63:1ca:: with SMTP id 193mr16567674pgb.20.1643680479518; 
	Mon, 31 Jan 2022 17:54:39 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
	by smtp.gmail.com with ESMTPSA id k9sm446369pfi.134.2022.01.31.17.54.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 31 Jan 2022 17:54:38 -0800 (PST)
Date: Mon, 31 Jan 2022 17:54:35 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20220201015435.okpgudxfrrtxwcd4@garbanzo>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
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
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbus >> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
> 
> I'd like to propose a session to go over this topic to understand :-
> 
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
> 
> * Required Participants :-
> -----------------------------------------------------------------------
> 
> I'd like to invite file system, block layer, and device drivers
> developers to:-
> 
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.

Consider me intersted in this topic.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

