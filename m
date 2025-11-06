Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AD23093D3
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430824; cv=none; b=JibbjWgTgDTFljv+ZDthOQjZ5ZRDAUPTuBwvdHdQ7L3QipOIxRFIz8fjrOyIM32YjGrhfljsVgrf460YAOWBisgQNH3WcK8itbKTIN1EGd5aqafUuclla0KueGePqfHhnDe1l9sgcRdJLuFbvR2Z022v6X1Sp67FN8vg+YHUgM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430824; c=relaxed/simple;
	bh=Zvkj3QYGItg5e/tjbi30DBgTWFsFNqVt5wtpFeFGYPw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ux4TV+rqrmzZLEsSuQhORKte2ZwiG8Tksx/7cLO7kKkjuMmYymcnzInfdISCRYq6KED0pQsbyQE15YgYqH7qnFwOEH1boWe2AoI5UTa2QGNvwDGl4dw/NN6fhCOE0nXzhH9b+HHb98voOcErq3GCgHmsdaGztmpQs30twrzfQhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZkPcSncZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkPcSncZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762430821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vdYuhvG5GEendTlTnsmXxoyUf7AQfGijSW1IZX3Rkxw=;
	b=ZkPcSncZupXmGLHcj5XiqqXDEcLW+vcZrTA1ey3WmfEdnXbBf2RKSYgqO4v9LFeHd1+fWq
	fEb8gQkQySGgxEQGSiRqbsAkIqmXWTahgNhdQBbNcvlxqBx2H6qciAb2cMfXnKsPdR8IXd
	lzYCBqhxi75ixN1lkkaaUbr1rSqH9to=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-Q6JU9SFVPxyYKMcVAdHDAA-1; Thu,
 06 Nov 2025 07:06:58 -0500
X-MC-Unique: Q6JU9SFVPxyYKMcVAdHDAA-1
X-Mimecast-MFC-AGG-ID: Q6JU9SFVPxyYKMcVAdHDAA_1762430817
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CC411956067;
	Thu,  6 Nov 2025 12:06:57 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6735D180049F;
	Thu,  6 Nov 2025 12:06:55 +0000 (UTC)
Date: Thu, 6 Nov 2025 13:06:50 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org, 
    dm-devel@lists.linux.dev, michael.christie@oracle.com, 
    martin.petersen@oracle.com
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
In-Reply-To: <aQwCHqrdNMy1wy75@redhat.com>
Message-ID: <513ec9c1-a568-a98e-18ef-e42d9c73e3e1@redhat.com>
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com> <aQwCHqrdNMy1wy75@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kG2Ofvo5dRv3-HeHFepUq4bhhxFs2GqK3yeH7zZ7kXk_1762430817
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 5 Nov 2025, Benjamin Marzinski wrote:

> > @@ -3762,6 +3766,11 @@ static void crypt_io_hints(struct dm_tar
> >  	if (ti->emulate_zone_append)
> >  		limits->max_hw_sectors = min(limits->max_hw_sectors,
> >  					     BIO_MAX_VECS << PAGE_SECTORS_SHIFT);
> > +
> > +	limits->atomic_write_hw_unit_max = min(limits->atomic_write_hw_unit_max,
> > +					       BIO_MAX_VECS << PAGE_SHIFT);
> > +	limits->atomic_write_hw_max = min(limits->atomic_write_hw_max,
> > +					  BIO_MAX_VECS << PAGE_SHIFT);
> >  }
> 
> Do we need to cap these limits, instead of just accepting the underlying
> device limits?

BIO_MAX_VECS << PAGE_SHIFT is the hard limit for the size of any write 
(atomic or non-atomic) in dm-crypt. dm-crypt cannot support larger writes 
by design.

If non-atomic write is larger than BIO_MAX_VECS << PAGE_SHIFT, dm-crypt 
splits it using dm_accept_partial_bio. But atomic writes cannot be split, 
so we need to inform the upper layer to not sent larger bios.

> Neither of them are really used for IO.
> atomic_write_unit_max, which is used for IO, will already get a capped
> value from atomic_write_hw_unit_max in
> blk_atomic_writes_update_limits(). And capping atomic_write_hw_max seems
> wrong, since atomic_write_hw_max == UINT_MAX is used
> blk_validate_atomic_write_limits() to indicate that atomic writes were
> never set up, because no underlying device supported them. I don't think
> these caps will actually break things, but in my mind they make some
> already confusing limits even more confusing. 
> 
> Or am I missing some reason why this is needed?
> 
> -Ben

How do you think we should modify the limits, to make sure that atomic 
write size is capped at BIO_MAX_VECS << PAGE_SHIFT?

Mikulas

