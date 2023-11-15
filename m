Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED903DB84
	for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HohaC4Tm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700071199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J9PMlVU0wSw4hP4CQngCFOOQNSVpU2hCl+cgV/hzWjQ=;
	b=HohaC4TmUQooX5gTgpLOsZc6zDJIy3NPT59qawAbEyXOh5BYyYGiJUXLiJu1rbxPrznw2K
	p8KZWYqVZ1g39Bu4Qf2smjEg9TEZeGVHsCc+RJ0PkYHHCzLrvzlbHPvo6XH36yrbdTmdxG
	yheQnTjHQ9DzncD9agAJHmGm95JdgmE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-bo5BNe70OcuJRuVPB8walg-1; Wed, 15 Nov 2023 12:59:55 -0500
X-MC-Unique: bo5BNe70OcuJRuVPB8walg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D75928C7EC1;
	Wed, 15 Nov 2023 17:59:54 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAE691121306;
	Wed, 15 Nov 2023 17:59:54 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id B087D30C1A8C; Wed, 15 Nov 2023 17:59:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id AC29E3FB76;
	Wed, 15 Nov 2023 18:59:54 +0100 (CET)
Date: Wed, 15 Nov 2023 18:59:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com>, 
    "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>, 
    "agk@redhat.com" <agk@redhat.com>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    "Ravi Kumar Siddojigari (QUIC)" <quic_rsiddoji@quicinc.com>
Subject: Re: Patch : drivers/md/dm-verity-target.c
In-Reply-To: <ZVUADgxZPOtcSYTE@redhat.com>
Message-ID: <5ff365e7-1d8b-b214-1c52-956dce62286@redhat.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com> <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com> <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com> <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
 <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com> <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com> <b5956421-f371-3535-6538-b189b16ec73e@redhat.com> <SJ0PR02MB8593C7351FBA28D4B213E105F6B1A@SJ0PR02MB8593.namprd02.prod.outlook.com>
 <ZVUADgxZPOtcSYTE@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 15 Nov 2023, Mike Snitzer wrote:

> On Wed, Nov 15 2023 at  2:01P -0500,
> Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com> wrote:
> 
> > Sorry if that statement confused you ,  It was debugging print 
> > that was added to check if the  tight while loop has ended or not
> >  
> > Code : dm-init.c 
> > dm_init_init()
> >  
> > 	wait_for_device_probe();
> > 	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
> > 		if (waitfor[i]) {
> > 			dev_t dev;
> >  
> > 			DMERR("waiting for device %s ...", waitfor[i]);
> > 			while ((dev=  name_to_dev_t(waitfor[i]) !=0))
> > 				fsleep(5000);
> > 		}
> >  
> > 	DMERR("exiting after %s ",waitfor[i]);  <<<<<<<<<<<here it was added 
> > 	}
> >  
> > 	if (waitfor[0])
> > 		DMINFO("all devices available");
> >  
> > 	list_for_each_entry(dev, &devices, list) {
> > 		if (dm_early_create(&dev->dmi, dev->table,
> > 				    dev->target_args_array))
> > 			break;
> > 	}
> > 
> 
> 
> Mikulas wasn't confused.  He was pointing out that you have made
> changes to your kernel without sharing what they are.
> 
> But your issue is that you configured the dm-mod.waitfor device
> incorrectly. You must wait for the underlying physical device(s) that
> the virtual DM device depends on.

Yes, that's the problem.

> Mike

[    9.785204][    T9] mmc0: CQHCI version 5.10
[    9.826746][    T9] mmc0: SDHCI controller on 8804000.sdhci [8804000.sdhci] using ADMA 64-bit
[    9.835559][    T9] sdhci_msm 8804000.sdhci: mmc0: CQE init: success
[    9.842578][    T1] device-mapper: init: waiting for device /dev/dm-0 ...
[    9.849605][    T1] device-mapper: init:  exiting after  /dev/dm-0 <<<<<got  dev/dm-0
[    9.856689][    T1] device-mapper: init: all devices available
[    9.863061][    T1] device-mapper: table: 252:0: verity: Data device lookup failed
[    9.870868][    T1] device-mapper: ioctl: error adding target to table
[    9.895539][   T37]

I'm wondering about another thing - here it succeeds finding /dev/dm-0 and 
immediatelly after that fails loading /dev/dm-0 table with the dm-verity 
target.

So, how could we succeed finding /dev/dm-0 before it was created?

I think that you backported that patch incorrectly - instead of

	while ((dev=  name_to_dev_t(waitfor[i]) !=0)) fsleep(5000);

there should be

	while ((dev=  name_to_dev_t(waitfor[i]) ==0)) fsleep(5000);

There was a change in the return value of devt_from_devname - in 6.7-rc1, 
it returns 0 on success and -ERROR on error. In 5.15.104, it returns 0 on 
error and a device nubmer on success.

Mikulas

