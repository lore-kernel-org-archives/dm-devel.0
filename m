Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6451E41749
	for <dm-devel@lists.linux.dev>; Tue, 14 Nov 2023 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YjDcTE8J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699972643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nDT1He7K1Eqk5nl1MwdWeO49mluztorjJOgWpnw4r4U=;
	b=YjDcTE8JIpjU8aAr3+jOhZqA4Cc8+6vuvu1stKu3efOWOV7p2srJoAnwenqTiH8nVY1UJT
	7mIKMEnf33wRXZbeNY4FmslBOgxip1pvsFznInKhyKmDPmI/oZafGBAg8bnhBnzQjYLmPL
	XFFe0C2LzDv9Imaat/lRDgKVOgavOBs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-TsRme4gdOo--k6AdIBd-eA-1; Tue,
 14 Nov 2023 09:37:21 -0500
X-MC-Unique: TsRme4gdOo--k6AdIBd-eA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEA523C025CD;
	Tue, 14 Nov 2023 14:37:18 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6B671C060AE;
	Tue, 14 Nov 2023 14:37:18 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 9011A30C1A8C; Tue, 14 Nov 2023 14:37:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8B8593FB77;
	Tue, 14 Nov 2023 15:37:18 +0100 (CET)
Date: Tue, 14 Nov 2023 15:37:18 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>
cc: "agk@redhat.com" <agk@redhat.com>, 
    "snitzer@kernel.org" <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Ravi Kumar Siddojigari <rsiddoji@qti.qualcomm.com>
Subject: RE: Patch : drivers/md/dm-verity-target.c
In-Reply-To: <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com>
Message-ID: <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com> <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com> <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com> <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
 <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="185210117-52514160-1699972638=:3375278"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-52514160-1699972638=:3375278
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT



On Fri, 10 Nov 2023, Aaditya Raj Barnwal (QUIC) wrote:

> Hi @Mikulas
> Sorry for my late reply
> I was not clear on the ask assuming it to be device configuration , please see below points for your query.
>  
>  *  Only eMMC chip  Micron product name (S0J35A)  PNM 48(width) CID  value 8GB: 53304A333541h
>  *  Linux version 5.15.104 compiled for  Arm64 (armv8+ )

I did these commands:

$ git checkout v5.15.104
$ grep -r 'exiting after' * 

and grep didn't find anything. But your log shows an 'exiting after' 
message. So, where does this message 'device-mapper: init:  exiting after' 
come from? Are you using clean v5.15.104 or did you patch the kernel with 
some external patch?

Mikulas


>  *  with sdhci enabled and sdcard support for auto detect
>  
> Please let me know if you have any concerns.
>  
> Thanks
> Aaditya
>  
> -----Original Message-----
> From: Mikulas Patocka <mpatocka@redhat.com>
> Sent: Monday, November 6, 2023 5:25 PM
> To: Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com>
> Cc: Aaditya Raj Barnwal (QUIC) <quic_abarnwal@quicinc.com>; agk@redhat.com; snitzer@kernel.org; dm-devel@lists.linux.dev; Akshay Rukmangad <arukmang@qti.qualcomm.com>
> Subject: Re: Patch : drivers/md/dm-verity-target.c
>  
> WARNING: This email originated from outside of Qualcomm. Please be wary of any links or attachments, and do not enable macros.
>  
> On Mon, 6 Nov 2023, Aaditya Raj Barnwal wrote:
>  
> > thanks for  reply ,
> >
> > yes we already have
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com
> > mit/?id=035641b01e72af4f6c6cf22a4bdb5d7dfc4e8e8e
> > and kernel cmdline is with wait for /dev/dm-0 where i could make out
> > from the logs it was able to get /dev/dm-0 but still failed to get the
> > data-devices adding the logs below
> >
> >    9.785204][    T9] mmc0: CQHCI version 5.10 [    9.826746][    T9]
> > mmc0: SDHCI controller on 8804000.sdhci [8804000.sdhci] using ADMA
> > 64-bit [    9.835559][    T9] sdhci_msm 8804000.sdhci: mmc0: CQE init:
> > success [    9.842578][    T1] device-mapper: init: waiting for device /dev/dm-0 ...
>  
> You should wait for /dev/mmcblk0 here, not for /dev/dm-0.
>  
> > [    9.849605][    T1] device-mapper: init:  exiting after  /dev/dm-0 
> > <<<<<got  dev/dm-0
>  
> Where does this 'exiting after' message come from? I grepped the kernel for it and didn't find it.
>  
> > [    9.856689][    T1] device-mapper: init: all devices available [   
> > 9.863061][    T1] device-mapper: table: 252:0: verity: Data device
> > lookup failed [    9.870868][    T1] device-mapper: ioctl: error
> > adding target to table [    9.895539][   T37] platform regulatory.0:
> > Direct firmware load for regulatory.db failed with error -2 [   
> > 9.898825][    T1] gcc-sdxpinn 80000.clock-controller: sync-state [   
> > 9.905125][   T37] cfg80211: failed to load regulatory.db [    9.911731][    T1] ALSA device list:
> > [    9.920911][    T1]   No soundcards found.
> > [    9.925133][    T1] TAP version 14
> > [    9.928642][    T1] 1..0
> > [    9.931645][    T1] md: Waiting for all devices to be available
> > before autodetect [    9.931829][   T85] mmc0: Command Queue Engine
> > enabled [    9.939343][    T1] md: If you don't use raid, use
> > raid=noautodetect [    9.944631][   T85] mmc0: new HS400 MMC card at
> > address 0001 [    9.951158][    T1] md: Autodetecting RAID arrays.
> > [    9.957520][   T85] mmcblk0: mmc0:0001 S0J35A 7.28 GiB [   
> > 9.961908][    T1] md: autorun ...
> > [    9.961912][    T1] md: ... autorun DONE.
> > [    9.970173][   T85]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
> > p12 p13 p14 p15 p16 p17 p18 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28
> > p29 p30 p31 p32 p33 p34 p35 p36
> > p37 p38 p39 p40 p41 p42 p43 p44 p45 p46 [    9.971004][    T1] Waiting
> > for root device /dev/dm-0...
> > [    9.979384][   T85] mmcblk0boot0: mmc0:0001 S0J35A 31.5 MiB [  
> > 10.005842][   T85] mmcblk0boot1: mmc0:0001 S0J35A 31.5 MiB [  
> > 10.012536][   T85] mmcblk0rpmb: mmc0:0001 S0J35A 4.00 MiB, chardev
> > (500:0) [   10.901495][   T85] msm-dwc3 a600000.ssusb: DWC3 in low
> > power mode << no rootfs and no further bootup  blocked at this point
> > same as the above path >>
>  
> I see that you also use md - please describe the full storage stack that you use.
>  
> Mikulas
>  
> 
> 
--185210117-52514160-1699972638=:3375278--

