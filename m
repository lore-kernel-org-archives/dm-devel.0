Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE5C405F3
	for <dm-devel@lists.linux.dev>; Tue, 14 Nov 2023 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xr9oRZDw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699973571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b2qNZoUS9dxFRejNY2cBl+GB3LEizeFzlT+R5s5zZkk=;
	b=Xr9oRZDw2w6yk1xNLnL+wuqtyeT5PMUHzSUlrF12Rkqu3EWhWTFi7etPKI2AnV5T3rvkB4
	ya03l9aaV7Ti6triZyn77jm4itQ2gRSkBhAgrbj2mKmF1tufNu0SlXG/JKuu4DZuZM4ju+
	Dz21iioDfq0UsBPP2gL8BvnnB7Tzvp4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-vup7eP7RPA27g3iZ8WUlDw-1; Tue,
 14 Nov 2023 09:52:48 -0500
X-MC-Unique: vup7eP7RPA27g3iZ8WUlDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06D623C40B54;
	Tue, 14 Nov 2023 14:52:48 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1BDE36EE;
	Tue, 14 Nov 2023 14:52:47 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id DD1B130C1A8C; Tue, 14 Nov 2023 14:52:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id D91C53FB77;
	Tue, 14 Nov 2023 15:52:47 +0100 (CET)
Date: Tue, 14 Nov 2023 15:52:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>
cc: "agk@redhat.com" <agk@redhat.com>, 
    "snitzer@kernel.org" <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Ravi Kumar Siddojigari <rsiddoji@qti.qualcomm.com>
Subject: RE: Patch : drivers/md/dm-verity-target.c
In-Reply-To: <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
Message-ID: <b5956421-f371-3535-6538-b189b16ec73e@redhat.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com> <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com> <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com> <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
 <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com> <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="185210117-1830619339-1699973567=:3377441"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-1830619339-1699973567=:3377441
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT



On Tue, 14 Nov 2023, Mikulas Patocka wrote:

> 
> 
> On Fri, 10 Nov 2023, Aaditya Raj Barnwal (QUIC) wrote:
> 
> > Hi @Mikulas
> > Sorry for my late reply
> > I was not clear on the ask assuming it to be device configuration , please see below points for your query.
> >  
> >  *  Only eMMC chip  Micron product name (S0J35A)  PNM 48(width) CID  value 8GB: 53304A333541h
> >  *  Linux version 5.15.104 compiled for  Arm64 (armv8+ )
> 
> I did these commands:
> 
> $ git checkout v5.15.104
> $ grep -r 'exiting after' * 
> 
> and grep didn't find anything. But your log shows an 'exiting after' 
> message. So, where does this message 'device-mapper: init:  exiting after' 
> come from? Are you using clean v5.15.104 or did you patch the kernel with 
> some external patch?
> 
> Mikulas

BTW. I see that the "dm-mod.waitfor" mechanism was introduced in 6.2, and 
it is not available in 5.15.104.

So I suggest that you upgrade the kernel to at least 6.2, or backport the 
upstream patch 035641b01e72af4f6c6cf22a4bdb5d7dfc4e8e8e to your kernel 
5.15.104.

Mikulas
--185210117-1830619339-1699973567=:3377441--

