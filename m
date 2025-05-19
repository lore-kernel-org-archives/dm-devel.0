Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA3727586E
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747656326; cv=none; b=AL/xG+Xyn2UrAtW24Nlal1oQC75mLqo34kAHZ7Sj/0VxWWCye909+szqqBmERBtuua3HPudsuJsUqJRbUT16w2LesiTpT5khxsiutwZ3d1gTUyooH4QarwaLek2v8f+UNXpdIbrz27h0wPFw7uBnQsIM3QjNriix0JKDLb7Kg6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747656326; c=relaxed/simple;
	bh=78Q12QYnJH4S2R2AB8yX78RKDi/GNQa4v9RMyjjgapI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZBu/wKKAJ1WCqnTCiI5sVSLqGdgLJYWKnwz4Y59DbXHoXqQ+a/Acby+UOnX07AN48NL8aLl5GOjlE46ILvVDR7V4H8fc72hZLlIudOR2J9bTPSt8ovI9arCxOi2tuIzBw4gThzIpM3keUk1XUznazSk/0gcb1+a0EbOgyaXEB4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SQXLSfX4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQXLSfX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747656323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=almO9GfCXjlb3pdQZNIkcKGUxWcRtmIfYk4o8OpiOFw=;
	b=SQXLSfX478oJwZoR93n+QPOzPW/BuN9QMJvMZ5jHjUK/TlSffRr+RyeYKfMCRW5ziG/Q73
	ZfNI9QD4lP9SFfRXcrB/6XBi/ZhYg68EmSG1ws4C3Qh4+PSgm2IUc1ieyOT8/N1kBNEjPR
	i/cQEYpxoppJwj/4vtk6EoG1ABQv0XU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-q5zx6HwmOyegI-Qj_vTNpQ-1; Mon,
 19 May 2025 08:05:20 -0400
X-MC-Unique: q5zx6HwmOyegI-Qj_vTNpQ-1
X-Mimecast-MFC-AGG-ID: q5zx6HwmOyegI-Qj_vTNpQ_1747656319
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C02918004A7;
	Mon, 19 May 2025 12:05:18 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A4D21956095;
	Mon, 19 May 2025 12:05:15 +0000 (UTC)
Date: Mon, 19 May 2025 14:05:11 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, zkabelac@redhat.com, 
    linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
In-Reply-To: <b560f87d-0072-91be-2a87-43f3510737d1@huaweicloud.com>
Message-ID: <617a9d67-9671-f2aa-5188-0755b5b87972@redhat.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com> <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com> <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com> <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com> <10db5f49-0662-49da-9535-75aded725950@huaweicloud.com>
 <b560f87d-0072-91be-2a87-43f3510737d1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-683348926-1747656318=:2642065"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-683348926-1747656318=:2642065
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8BIT



On Mon, 19 May 2025, Yu Kuai wrote:

> Hi,
> 
> ÔÚ 2025/05/19 19:19, Yu Kuai Ð´µÀ:
> > > The commit e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags") breaks
> > > the lvm2 test shell/lvcreate-large-raid.sh. The commit changes raid1 and
> > > raid10 to pass down all the flags from the incoming bio. The problem is
> > > when we pass down the REQ_RAHEAD flag - bios with this flag may fail
> > > anytime and md-raid is not prepared to handle this failure.
> > 
> > Can dm-raid handle this falg? At least from md-raid array, for read
> > ahead IO, it doesn't make sense to kill that flag.
> > 
> > If we want to fall back to old behavior, can we kill that flag from
> > dm-raid?
> 
> Please ignore the last reply, I misunderstand your commit message, I
> thought you said dm-raid, actually you said mdraid, and it's correct,
> if read_bio faild raid1/10 will set badblocks which is not expected.
> 
> Then for reada head IO, I still think don't kill REQ_RAHEAD for
> underlying disks is better, what do you think about skip handling IO
> error for ead ahead IO?

I presume that md-raid will report an error and kick the disk out of the 
array if a bio with REQ_RAHEAD fails - could this be the explanation of 
this bug?

Mikulas
---1463811712-683348926-1747656318=:2642065--

