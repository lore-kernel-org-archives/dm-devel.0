Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E832FFF9C
	for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758896415; cv=none; b=TXhdqbB8VsqtNXaYuOqt4p8OSyBmHQoMZIp5KohqyDyzOZMGWyaiSDgaHmNhbrdCWzBsaZvEwb3s1KNAmXFKwzSKB/L2Kf1A8G/vgtStum/+zDMSjEPZqvYH55MGtnJvNeho7eNM1ZednLEXg+DAONsjNQ0EZ8vBwgKqAZIrhzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758896415; c=relaxed/simple;
	bh=0VqoJagHrKLIwyAGEtvqS8c+miGdVC4teNhV83UF4Ro=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bdY9Sp8MkvNTHAA9a3zUpBZAzmcsv5OInbnw/otYFdF2rce1rSDQv0ClSDUzQmK4vzmUIlerYRjCaD3nrYR6u2/Fy5c0TFHWJOrcANLLpjmaMOGUT88j2DnNDxQGd/ZiK8RMlx4ug3UeCkCZSimFhtii75OqM0s3JEEf7siD4TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5SsclCN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5SsclCN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758896413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eujfjsMNWh2LvBUHAs1tDGGYHgRVcuZcHOJDVCXjpzM=;
	b=S5SsclCN+nnd7Tfn3nqt6e75Oa5AgA7fAD52ChofF5GS7CI/KifJLjlI2EtEvvk0vsWNbK
	VTnWb7qhCRKrSLnisSGUVaABuFmQsob419snhHwd3LMayV6yCqzyDcTgVNto7Qg/tf/FCh
	kRzqoGmPeOAVAUgOW7BOHII3HDOWeTQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-qhDHJPvTOpuPiv45MGTaBA-1; Fri,
 26 Sep 2025 10:20:06 -0400
X-MC-Unique: qhDHJPvTOpuPiv45MGTaBA-1
X-Mimecast-MFC-AGG-ID: qhDHJPvTOpuPiv45MGTaBA_1758896405
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAADA180035C;
	Fri, 26 Sep 2025 14:20:04 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6B8719560A2;
	Fri, 26 Sep 2025 14:20:02 +0000 (UTC)
Date: Fri, 26 Sep 2025 16:19:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@kernel.org>
cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev, 
    snitzer@kernel.org, linux-block@vger.kernel.org, ebiggers@google.com
Subject: Re: [RFC PATCH] dm-crypt: allow unaligned bio_vecs for direct io
In-Reply-To: <aMxnzIavwnJmdAz1@kbusch-mbp>
Message-ID: <f3d06d99-638d-99a5-03e3-686b544d97ac@redhat.com>
References: <20250918161642.2867886-1-kbusch@meta.com> <aMxnzIavwnJmdAz1@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Thu, 18 Sep 2025, Keith Busch wrote:

> On Thu, Sep 18, 2025 at 09:16:42AM -0700, Keith Busch wrote:
> > +		bio_advance_iter_single(ctx->bio_in, &ctx->iter_in, len);
> > +		bytes -= len;
> > +	} while (bytes);
> > +
> > +	sg_mark_end(sg_in);
> > +	sg_in = dmreq->sg_in[0];
> 
> Err, there should be an '&' in there, "&dmreq->sg_in[0];"
> 
> By the way, I only tested plain64 for the ivmode. That appears to work
> fine, but I am aware this will not be successful with elephant, lmk, or
> tcw. So just an RFC for now to see if it's worth pursuing.

Hi

I'd like to ask - how much does it help performance? How many percent 
faster does your application run?

Another question - what if the user uses preadv or pwritev with direct I/O 
and uses more than 4 sg lists? Will this be rejected in the upper layers, 
or will it reach dm-crypt and return -EINVAL? Note that returning error 
from dm-crypt may be quite problematic, because it would kick the leg out 
of RAID, if there were RAID above dm-crypt. I think that we should return 
BLK_STS_NOTSUPP, because that would be ignored by RAID.

I am considering committing this for the kernel 6.19 (it's too late to add 
it to the 6.18 merge window).

Mikulas

