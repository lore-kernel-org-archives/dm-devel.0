Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF0930EF9F
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762437618; cv=none; b=e3m10oQFXf0vUSlmKz5/K0vH1nNPM1bZ2yLplsi/1dHSaftmmv9e4PMdTmXpHrK0mqhoYw8BFW9WNkoOPulPrNRtQ/3T3jfTmYdkIOtbZgMY60z0SUB/kmVrD0il5vIpl6SNQjV8NURE276m5Vd6LS1IwgXM+HOs4phsbPmCxmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762437618; c=relaxed/simple;
	bh=9OIsSl9H/nQV3MYuMUaqmANdMH86U4pwgH62q2PsKBc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ByRhn+H7J/r1nR0F9nOkfb4yr1xum/eUlCd7SWoGiJdl5E5EwSPCqHo9fldqlB+ffCO2UwtuQdaGc9LqNmU5981rXPPhWKxeE6SDBue7RZWZMuhd6tvdHLwmgIK8HMMUo/bs31XbgTCKqBW++MJlMt7KLQJ5NSGqsQVtFO7BKWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KPsXfBxo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KPsXfBxo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762437616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kQsVWDXfKhryMEDa8lN1vC0ws+ItB1D6hyIe5fKGCfU=;
	b=KPsXfBxoy5r2mmGyM5UvzegIbM9XCpixe211gS74FOlUtI5kstfx1gd05CQexhBEi+5hyY
	/fhqr8Werj8llni2NGe7SEAxDeehF/l8yNWOHJHpbsW/FCoga0d/XKFy1qfjzXbI88JGUs
	HD2b9Ic5ecJTDT25R1yGKB/BBYZtlrY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-1ADr0n1WNeCHgspYbM0WWg-1; Thu,
 06 Nov 2025 09:00:11 -0500
X-MC-Unique: 1ADr0n1WNeCHgspYbM0WWg-1
X-Mimecast-MFC-AGG-ID: 1ADr0n1WNeCHgspYbM0WWg_1762437610
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8484618002CF;
	Thu,  6 Nov 2025 14:00:10 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6016E19560B2;
	Thu,  6 Nov 2025 14:00:08 +0000 (UTC)
Date: Thu, 6 Nov 2025 15:00:05 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: Benjamin Marzinski <bmarzins@redhat.com>, agk@redhat.com, 
    snitzer@kernel.org, dm-devel@lists.linux.dev, michael.christie@oracle.com, 
    martin.petersen@oracle.com
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
In-Reply-To: <16e9a3d8-8334-4164-a41a-4a2da0467c65@oracle.com>
Message-ID: <05ac7dff-bdb2-049c-e38b-319e81170234@redhat.com>
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com> <aQwCHqrdNMy1wy75@redhat.com> <513ec9c1-a568-a98e-18ef-e42d9c73e3e1@redhat.com> <16e9a3d8-8334-4164-a41a-4a2da0467c65@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gDBCwSr9hRJYXdo54jPKv-K8dWxjSttfKQ--Taz3ty0_1762437610
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 6 Nov 2025, John Garry wrote:

> On 06/11/2025 12:06, Mikulas Patocka wrote:
> > > Neither of them are really used for IO.
> > > atomic_write_unit_max, which is used for IO, will already get a capped
> > > value from atomic_write_hw_unit_max in
> > > blk_atomic_writes_update_limits(). And capping atomic_write_hw_max seems
> > > wrong, since atomic_write_hw_max == UINT_MAX is used
> > > blk_validate_atomic_write_limits() to indicate that atomic writes were
> > > never set up, because no underlying device supported them. I don't think
> > > these caps will actually break things, but in my mind they make some
> > > already confusing limits even more confusing.
> > > 
> > > Or am I missing some reason why this is needed?
> > > 
> > > -Ben
> > How do you think we should modify the limits, to make sure that atomic
> > write size is capped at BIO_MAX_VECS << PAGE_SHIFT?
> 
> The atomic write size is limited elsewhere, specifically
> blk_atomic_writes_update_limits() - the limit there is quite similar (to what
> is added in this updated patch). So I don't think that we need to do anything
> special in dm-crypt, as that block limit is already tighter.
> 
> I suppose that this code can be kept with a comment (saying that it is
> unnecessary, but safer to keep). Or we can just drop the code and add a
> comment (saying that we don't need to limit here, as it is done elsewhere).
> 
> Thanks,
> John

What if someone creates a hypothetical device that supports atomic writes 
larger than BIO_MAX_VECS << PAGE_SHIFT? I think, we should limit it.

Mikulas

