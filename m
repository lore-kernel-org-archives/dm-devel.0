Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366EB3126C3
	for <dm-devel@lists.linux.dev>; Fri,  2 Jan 2026 13:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767361625; cv=none; b=jzXRnZJ9HojD47ts1Gp/t83/A3+bs/7aS+N1nXpPmjMCMRQ6v+xD4njkIsopARrImIgapMYELf7+JpHu4T2bdtZ1nT09OWPhWhw+I0glxY+DWaLvXfZEEQtsoL4CsJdN90YxhxOIDXW6cWOa5pE04ZQ+3UDrebHk49fkuCsRd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767361625; c=relaxed/simple;
	bh=L2GJNIzZGxj1iTrqoajisleJTyF/oA9RtQX2Rdfh/o4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=j6lsroSIF7oieDqhh5Qwcn8JI1evNgdASkRMkWP1CrZknxEMQO0JcOqDvLu9EIC4I5/tfMTrBwIqdepIvn7KypHoUgzqyBF3HRJcVX+yMiWm9UKQwxNykH9/+UioNSS+OztjQp44EXf+88W5XowNtq5/RtKsoySsH5Etc6gLnn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWTW6Tb7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWTW6Tb7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767361621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1i20b/Mjn1bqQD3Dx3TUmWUZ2VJRP6JCW5L9UDKlzFc=;
	b=eWTW6Tb7L4WmHzf+qzWQPEw7uUN8ch+xyx93zqq2fDKj1bWZkQpeqdX0V+OTgTLXMM6FBG
	CLXxmH1RCJFfb4Z9AZBzRY7b7jan+euI2B0oF/HyG4duv2IE6y1kZfjTf2ToVyzRx1Ko+G
	3Beit/op3VASG4HuOSrjpozKrdO5Euk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-62FfLU-aMZixtLHflc2r_Q-1; Fri,
 02 Jan 2026 08:46:52 -0500
X-MC-Unique: 62FfLU-aMZixtLHflc2r_Q-1
X-Mimecast-MFC-AGG-ID: 62FfLU-aMZixtLHflc2r_Q_1767361611
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BEB119560B2;
	Fri,  2 Jan 2026 13:46:50 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34A4A1800576;
	Fri,  2 Jan 2026 13:46:48 +0000 (UTC)
Date: Fri, 2 Jan 2026 14:46:44 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: adrelanos@whonix.org, arraybolt3@gmail.com, cryptsetup@lists.linux.dev, 
    dm-devel@lists.linux.dev, gmazyland@gmail.com, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <20251211182429.3300562-1-safinaskar@gmail.com>
Message-ID: <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com> <20251211182429.3300562-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Thu, 11 Dec 2025, Askar Safin wrote:

> Mikulas Patocka <mpatocka@redhat.com>:
> > So, this is what happened to you - the machine runs out of memory, it 
> > needs to swap out some pages, dm-crypt encrypts the pages and generates 
> > write bios, the write bios are directed to the loop device, the loop 
> > device directs them to the filesystem, the filesystem attempts to allocate 
> > more memory => deadlock.
> 
> Does similar thing happen in my case? I. e. swap on top of dm-integrity on
> top of partition? Is my use case supported? (I'm not talking about
> hibernation now, just about swap.)
> 
> -- 
> Askar Safin

Hi

Dm integrity doesn't need to allocate memory when processing I/O requests 
(it reserves some memory using mempools). So, dm-integrity on the top of a 
partition should be safe.

Mikulas

