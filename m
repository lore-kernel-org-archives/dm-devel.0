Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C631586C8
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 16:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314404; cv=none; b=PKJLZFIZN2jwW1/tWkecS/LIfK9u/hG/KB284KVkROjg+J9hb3l4BpCPnCGHRcGTPx18Iz6lO0l/CTKoqx0F/+lKCBfH7KEnUxy8c+gY3JH9eaIhgTkBDxaw7DCqpT6WTb/cU0Cl7J9mPlY89R2veOaymvYTGswu9ZKQvP83CHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314404; c=relaxed/simple;
	bh=DllG38BYOokA0Bi29339VZSQQG53Zbv+VmI1+g5+v3g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aVdtOe4l1xyO1hr4T+5YI6qA2vErYqZI9QAGTpW58eJwAvW06WH0ApS2gIz8Gt2DHM0ivge5UcCZ6HqEyZjxpfta7QYkUh1R9++bOeByXLBkHaTrIsJtZIwRhNsR6Wj89jZhW09tCU5hUeDdgIAC6maAxx+Vv1LW2PtKPFOTs3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWySfBG4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWySfBG4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742314396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fv4IGnzTLlWvEisT1ne8MCV/2g+mHPSVR+ca+3UZg84=;
	b=HWySfBG4Pxxr4NnhsnbDoospmzmWtzRLHQsFx7thfGg/N5f4AY9XoxNE7AH/6nLf5UQhXu
	hebzAcwX4+AMKM1I+AnPS3817bGPfeBNRTChG5HGFuoBwBUAPEO4EBU8LOGiPYgJMSV4w2
	NtRW7ieCl92WtxWAMNMLLfn4lsg+tGY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-UchRZJbxOKiaeEF8QIenJA-1; Tue,
 18 Mar 2025 12:13:11 -0400
X-MC-Unique: UchRZJbxOKiaeEF8QIenJA-1
X-Mimecast-MFC-AGG-ID: UchRZJbxOKiaeEF8QIenJA_1742314390
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9289919560B4;
	Tue, 18 Mar 2025 16:13:09 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 387D71828A92;
	Tue, 18 Mar 2025 16:13:07 +0000 (UTC)
Date: Tue, 18 Mar 2025 17:13:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, Ming Lei <ming.lei@redhat.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
In-Reply-To: <14dd4360-c846-43e3-86bc-b1e7448e5896@acm.org>
Message-ID: <bbc48d3c-e221-8429-0753-d9d48462b19c@redhat.com>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com> <14dd4360-c846-43e3-86bc-b1e7448e5896@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Tue, 18 Mar 2025, Bart Van Assche wrote:

> On 3/18/25 7:26 AM, Mikulas Patocka wrote:
> > The block limits may be read while they are being modified. The statement
> > "q->limits = *lim" is not really atomic. The compiler may turn it into
> > memcpy (clang does).
> 
> Which code reads block limits while these are being updated?

See my reply to Ming - 
https://lore.kernel.org/dm-devel/14dd4360-c846-43e3-86bc-b1e7448e5896@acm.org/T/#m7e4e49fed1cbcb56954b880e54a5155c4089c0e0

> This should be mentioned in the patch description.
> 
> Bart.

Yes, I can add it there.

Mikulas

