Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740521C17D
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606348; cv=none; b=bOnkgSqPqQprWAyUDJTScVbCOwOYNKHJ8pORemrwzCk/UNkCEL3hRdz2EbW0OC4as9jPykUCdMAO5mAg2We6CmArBUs5oNo81NeaV/Ug/qiQD90bMHtWc0Wqrsh+iAOjytWK8ecOZTJlYpvdmZmdc6u2QJoBcnyv8i84jlA6CdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606348; c=relaxed/simple;
	bh=6Kg+71dLCVeAUKU0tZocjty6bCKBW7KCfbWacoa136g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iLzv/xd+d30wgZfhuRSzB7gKC7/C7aQMeKk32XSp3/TKN7eIo4YM1EF+ezX+LfMLlgMTJOzr0VCnb9Y9KI8wZnGuVr1OJT3P88s80Tg93CLgw9ozz3L9bkUbh5fx6/s4aNFvST4u5f+CRRCkAgDl2JPq6AS9NsWPQTG7P4runKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JEQqFQa9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEQqFQa9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757606345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a0PX3u9Sk5E5C8gIcja/OV0TSOTM+bceGBMMPf84/a4=;
	b=JEQqFQa9FlYy9X9sJUoBKqjbHfnHDxxOUlLHZiFlckoU0XDOpfBxsO71BiwcxjBgtAiSGU
	sfdpVjOsgUREgznfZXbDl1fgTX3wrgnFvhmUOd6C7aReUYd8thpSfCJPZ3LJNDLLK8HFqU
	iji81uWM4TswkAM/n5jl4h4EMfNWBo4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-Bt89rya_MV-wZK3WqpPM6g-1; Thu,
 11 Sep 2025 11:59:03 -0400
X-MC-Unique: Bt89rya_MV-wZK3WqpPM6g-1
X-Mimecast-MFC-AGG-ID: Bt89rya_MV-wZK3WqpPM6g_1757606342
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CBBE180034A;
	Thu, 11 Sep 2025 15:59:01 +0000 (UTC)
Received: from [10.44.32.12] (unknown [10.44.32.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63BFB1944CEB;
	Thu, 11 Sep 2025 15:58:58 +0000 (UTC)
Date: Thu, 11 Sep 2025 17:58:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ingo Franzki <ifranzki@linux.ibm.com>
cc: Harald Freudenberger <freude@linux.ibm.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com, 
    snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
In-Reply-To: <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
Message-ID: <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
References: <20250908131642.385445532@debian4.vm> <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com> <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com> <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Thu, 11 Sep 2025, Ingo Franzki wrote:

> >> So, it looks like a dm-crypt bug.
> >>
> >> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just 
> >> to verify that the patches do not introduce the bug.
> > 
> > With your patches reverted the combined mode fails the same way as with your patches.
> > So they did not introduce the bug.
> 
> Mikulas, do you have any idea what could be causing this errors? 
> Is it that dm-crypt is not properly dealing with async-only HMAC ciphers? 
> Async-only encryption ciphers seem to work fine in dm-crypt, since LUKS with PAES (but no integrity) works fine, and PAES is an async-onky cipher.
> LUKS with sync-HMAC ciphers (e.g. clear key HMAC) also works fine, even in combination with PAES.

Yes, I think that it's a problem with async HMAC. The bug is probably 
either in dm-crypt or in the crypto library.

Do you have some other (non-dm-crypt-related) workload that uses the 
async authentication, so that we can determine whether the bug is in 
dm-crypt or crypto?

Otherwise, would it be possible to give us a virtual machine on the 
mainframe to debug this issue?

Mikulas

