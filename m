Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9F7C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 15:01:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 89A1B610EA
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 15:01:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89A1B610EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-HxV12pIiPsazw5oU7pt7dw-1; Thu, 21 Oct 2021 11:01:51 -0400
X-MC-Unique: HxV12pIiPsazw5oU7pt7dw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFD1C100F973;
	Thu, 21 Oct 2021 15:01:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CBA55F4E9;
	Thu, 21 Oct 2021 15:01:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 375194A703;
	Thu, 21 Oct 2021 15:01:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LF1HYp031690 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 11:01:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A979A2026D64; Thu, 21 Oct 2021 15:01:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3E6C2026D46
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 15:01:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08DBC899ED5
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 15:01:12 +0000 (UTC)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
	[209.85.167.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-8-k-3oAb3aNlqUR2Ri96Ao8w-1; Thu, 21 Oct 2021 11:01:10 -0400
X-MC-Unique: k-3oAb3aNlqUR2Ri96Ao8w-1
Received: by mail-oi1-f177.google.com with SMTP id r6so1219897oiw.2
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 08:01:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=6jnVZbBkLbnw6pFZpxUldRg4FuFfEZElhVVQao3Uy20=;
	b=gqLg78TwoibCGRKPKjnrmkSunlONWkL2BfvwTZqzsF7gCzk42PYLnWX1qL0CEzilYR
	vDNbGPWPZAjsta543ghMXYNwmW8b/wTkZx41r2kXad5IdmcAvpB+5s7y8soAhXSldZB7
	WUM9M+b97Ui+T38sPfTkNhy1Y+w4Wu3JofmWwD6wJoKddGMKu8MHSDvKkZewVM6Uezsy
	6J/TUGlIqAI540aq2ZulDq4qKVelCb3Yf0GXk687IFNq1LPsJimFtKHM4w94XR1L++iB
	s9esQFIgaBBbh+t6Eoq0zQ+FVl6ZgwBJy0mjpPsYWIWG6J7lhRlusNj7y/wk10HEK6vP
	KXeg==
X-Gm-Message-State: AOAM530EA0n2vGzo3R9Nw9xM8Ine3dNWT4gHec+rvZjmo9T9EHswzo5R
	9sKS1meHzq5M+GYLwecoY1Fq4Q==
X-Google-Smtp-Source: ABdhPJxcqYzZpw8hjWvx8wtyMAFaG+Ip962yojdp/B4kEz2Pn9lx52Qn4eX8lgw7zW26Sgpyf8s+nQ==
X-Received: by 2002:a05:6808:3c9:: with SMTP id
	o9mr4905862oie.20.1634828468846; 
	Thu, 21 Oct 2021 08:01:08 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:783a:c43c:af64:c142:4db7:63ac])
	by smtp.gmail.com with ESMTPSA id
	w18sm1173833ott.29.2021.10.21.08.01.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 21 Oct 2021 08:01:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
	johannes.berg@intel.com, roger.pau@citrix.com,
	miquel.raynal@bootlin.com, jdike@addtoit.com,
	anton.ivanov@cambridgegreys.com, geert@linux-m68k.org,
	krisman@collabora.com, vigneshr@ti.com, richard@nod.at, hare@suse.de,
	jinpu.wang@ionos.com, jgross@suse.com, sstabellini@kernel.org,
	ulf.hansson@linaro.org, agk@redhat.com, linux-mtd@lists.infradead.org, 
	Luis Chamberlain <mcgrof@kernel.org>, tj@kernel.org, colyli@suse.de,
	jejb@linux.ibm.com, chris.obbard@collabora.com, snitzer@redhat.com,
	boris.ostrovsky@oracle.com, kent.overstreet@gmail.com,
	martin.petersen@oracle.com
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
Message-Id: <163482846658.50565.12530170761457767964.b4-ty@kernel.dk>
Date: Thu, 21 Oct 2021 09:01:06 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, xen-devel@lists.xenproject.org
Subject: Re: [dm-devel] (subset) [PATCH 0/9] block: reviewed add_disk()
	error handling set
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Oct 2021 16:30:19 -0700, Luis Chamberlain wrote:
> Jens,
> 
> I had last split up patches into 7 groups, but at this point now
> most changes are merged except a few more drivers. Instead of creating
> a new patch set for each of the 7 groups I'm creating 3 new groups of
> patches now:
> 
> [...]

Applied, thanks!

[3/9] dm: add add_disk() error handling
      commit: e7089f65dd51afeda5eb760506b5950d95f9ec29
[4/9] bcache: add error handling support for add_disk()
      commit: 2961c3bbcaec0ed7fb7b9a465b3796f37f2294e5
[5/9] xen-blkfront: add error handling support for add_disk()
      commit: 293a7c528803321479593d42d0898bb5a9769db1
[6/9] m68k/emu/nfblock: add error handling support for add_disk()
      commit: 21fd880d3da7564bab68979417cab7408e4f9642
[7/9] um/drivers/ubd_kern: add error handling support for add_disk()
      commit: 66638f163a2b5c5b462ca38525129b14a20117eb
[8/9] rnbd: add error handling support for add_disk()
      commit: 2e9e31bea01997450397d64da43b6675e0adb9e3
[9/9] mtd: add add_disk() error handling
      commit: 83b863f4a3f0de4ece7802d9121fed0c3e64145f

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

