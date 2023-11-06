Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DB9171C8
	for <dm-devel@lists.linux.dev>; Mon,  6 Nov 2023 10:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cPQBY4ji"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699265064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tjqavlsdjSTCL3OatOtxm/8bNQn/kfn6t8DySBfAoiM=;
	b=cPQBY4jixedcars/1ODzyfacOe9ya1nLBgFBSJZYY/B+tfuRUnRVyIJe4w20+xHdvf0I9c
	JgCpvRZ5mZrrrlE4YDC99pDtUp7OJbJfNZ8mPmM8nUmAKOxubiyx7+s+VIaJImBKSYk9aV
	YpCICkUG00WELxrXe21anME1kDLA4v0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-mEXLX2FgMq6rkhUEsZzMmQ-1; Mon, 06 Nov 2023 05:04:20 -0500
X-MC-Unique: mEXLX2FgMq6rkhUEsZzMmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 970B2811E82;
	Mon,  6 Nov 2023 10:04:20 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B7392166B26;
	Mon,  6 Nov 2023 10:04:20 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 761A930C72AB; Mon,  6 Nov 2023 10:04:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 724AD3FD16;
	Mon,  6 Nov 2023 11:04:20 +0100 (CET)
Date: Mon, 6 Nov 2023 11:04:20 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>
cc: "agk@redhat.com" <agk@redhat.com>, 
    "snitzer@kernel.org" <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Akshay Rukmangad <arukmang@qti.qualcomm.com>
Subject: Re: Patch : drivers/md/dm-verity-target.c
In-Reply-To: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
Message-ID: <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="185210117-381424780-1699265060=:1437092"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-381424780-1699265060=:1437092
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT



On Mon, 6 Nov 2023, Aaditya Raj Barnwal (QUIC) wrote:

> Hi Developers, 
> 
> I have attached the patch for file : drivers/md/dm-verity-target.c
> 
> Race condition with some eMMC devices where the early_probe
> to dm-verity driver try to check access of data device
> fails. As this error is going to impact the bootup and mount
> of rootfs. As its impact bootup we make to wait for and
> then do a bail-out .
> adding the error which show the that dm-init already
> ack "all device available " but dm-verity returned
> error .
> device-mapper: init: all devices available
> device-mapper: table: 252:0: verity: Data device lookup failed
> device-mapper: ioctl: error adding target to table
> 
> This patch is going to wait based on module parm if not passed it
> will be 1sec max.
> 
> This patch is based on
> https://lore.kernel.org/lkml/7442e695-654a-59c2-e3dd-710946e6cddd@seco.com/T/
> which tries to do the same to dm-int level.
> 
> Thanks
> Aaditya

Hi

dm-init already has a parameter "dm-mod.waitfor" that waits for the listed 
devices. So, you can use "dm-mod.waitfor=/dev/mmcblk0" to wait for the 
emmc device that you need.

Mikulas
--185210117-381424780-1699265060=:1437092--

