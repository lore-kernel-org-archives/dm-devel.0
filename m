Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A19218E91
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767821186; cv=none; b=j8S0xrMMF5vE2mD5e6eaQs9qL651r123FHdVxHJ8LwAjLaspGSyZmFXVLlGcUhBK2IJeGi9f5i1vA90N+dxIAndMOgeBu9Wpt1tq+sy4pIDXti/W3F4cLOwN4HUSKCtgzEs8DcDqjCp4WdcNQIVOxl7k8sfclQUzXwlrWJtimQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767821186; c=relaxed/simple;
	bh=1sPUffG1MmPqbjQpt6RY6MiUQnmjUSTv6HWL968pJCg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=m9B4m6MBl7P+pEzY2YRl8OVDsovgHopMfr2KdYpj1dC1QR1+h1ZYqzIEGuCxNps32EADyh6IAHYhQR/GrtFuK91s38BhaAHkqj/oNYgAyKpTpeDGkxvxciXzUM/+4KNYp0cbm83+e1292fQ5w+qY0E3OHIXDLrmXT4VN/BM8zfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d1zLCmDR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1zLCmDR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767821183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OiNHA8omZomKnpjg33JaxcId1oUgxtoBF0WaTwHIUro=;
	b=d1zLCmDRcGLQJm/yEXCsLP/3HJj0UF8OZFYwVvwtGgOygxr4yEvC9cmQ6E0C+k2zaZmDuY
	AciEN+AUEDPevQ3ziz/8w4BMVl9LHDtcnxZj2tpc/El6YBHyx4R0OeDqsdmrYQwBcz+85R
	v4RVdsf3fgRZ0lLIaJuACuuN9I2CDdM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-IuumeatSPt2AMRyVwqgmYw-1; Wed,
 07 Jan 2026 16:26:20 -0500
X-MC-Unique: IuumeatSPt2AMRyVwqgmYw-1
X-Mimecast-MFC-AGG-ID: IuumeatSPt2AMRyVwqgmYw_1767821179
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BDF91956094;
	Wed,  7 Jan 2026 21:26:19 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E432418001D5;
	Wed,  7 Jan 2026 21:26:16 +0000 (UTC)
Date: Wed, 7 Jan 2026 22:26:10 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Leo Samulis <anagon@gmail.com>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>, 
    Milan Broz <gmazyland@gmail.com>, "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [RFQ] dm-steg : a deniable encryption module
In-Reply-To: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
Message-ID: <c3e8ba98-2ac9-9424-f6ad-d279f22c2073@redhat.com>
References: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -9G0wM1-8Dc7ohAb3qtk2hUG79y2lFNm_qpMQO34UDE_1767821179
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 23 Dec 2025, Leo Samulis wrote:

> Hello,
> 
> I'm Leo, the author of dm-steg ( https://dmsteg.sourceforge.net/Steg.pdf ), a
> deniable encryption module for device mapper. It was working nicely in 2011
> but I got caught up in life and never updated it.
> 
> What would need to be done for it to be accepted into mainline device mapper?
> 
> Would I simply need to update the code, get it working reliably, and then
> submit a patch? Or would the specification and use of crypto primitives also
> need to pass a separate cryptography exam?
> 
> Thanks in advance,
> 
> - Leo

Hi

If it doesn't interfere with other kernel code (i.e. if it's just one or a 
few files with no changes elsewhere), it should be quite easy to get it 
in. There is no formal verification of cryptography required.

Milan Broz is developing the userspace cryptsetup package, so you can 
discuss with him how to integrate it with the existing tools.

I think that (if possible) it would be better to integrate it with 
cryptsetup.


Just one big warning - it doesn't work on SSDs!

If the attacker unsolders the flash chips from the SSD and reads them 
directly, he can read the mapping table for the blocks. From the mapping 
table, he can infer which blocks were written recently.

I.e. if you recently wrote to the hidden area that is supposed to contain 
random data, the attacker would know that you wrote there and know how 
much data did you write there - he just wouldn't be able to decrypt actual 
data.

So, I suggest to either disable it completely on SSDs or print a big 
warning that it is not as secure as it is supposed to be.

Mikulas

