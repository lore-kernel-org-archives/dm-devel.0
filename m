Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FB4266580
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 14:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860205; cv=none; b=qRaIdaYrbcuOCW406RehXfnqSuhdzoj5BPYg4IsitQBYQKrsRp+g3mfuZ3BR+48gsjJTV2h+3+tqJdeCgEpMdQE0ftJ4cDo3Y28p2C/dlTHnacadCgBaX+FjeLPgZ2tgeiAPXTM2VWoSZhOTUV1mOCXqogSrpGjWEB2LNJHU0Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860205; c=relaxed/simple;
	bh=EaFhp6R32Jc8lRhiKE1xYpI6RCk3iahyylmWstMF/jI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LoCdcaLFS5E2/tSsGP849BBjcS7wbBeg3BBmpuK36MgFOfRFzJhmLjXkUtDiOfRVrlo8tbEr7rAv8kWlbi8GztFohtzp6GTfrstBR6q0c7fGR3cwcXUnMKw1R2HbEMHYDCbSjieV9osXRlg9sPWL8J7viAWoiU8nwk1Jd1eFPGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ddfa3wLK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ddfa3wLK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750860203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2od9y3CugzjAAC7eCYpJrhMDJ9juTnwbD/Om22GZ6Ik=;
	b=Ddfa3wLKH0yx8l2pX7fa0mlcvlk+4rM4SsbY5J4nQeyuJVlil18PsmWJ1d0zbGQGStO3MO
	dXhobqSH+xL0BxpQBmJXZW1139elI5/cyOnDWb18PMo0hL2np7GDGgVo6WkOKb2KUvmY1n
	QhttZrBZCBFYGRUVyK6YuBp2i1aKNk8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-v0qaJX-ENq2oEn-3YNKcwQ-1; Wed,
 25 Jun 2025 10:03:17 -0400
X-MC-Unique: v0qaJX-ENq2oEn-3YNKcwQ-1
X-Mimecast-MFC-AGG-ID: v0qaJX-ENq2oEn-3YNKcwQ_1750860194
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0029D1955F56;
	Wed, 25 Jun 2025 14:03:14 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98AEA18003FC;
	Wed, 25 Jun 2025 14:03:11 +0000 (UTC)
Date: Wed, 25 Jun 2025 16:03:08 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
    dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 3/4] dm: dm-crypt: Do not split write operations with
 zoned targets
In-Reply-To: <07d71ad1-a6de-474b-bee4-a64180284802@kernel.org>
Message-ID: <5c9898e1-3fae-d271-b0b8-a23371d22cb0@redhat.com>
References: <20250625055908.456235-1-dlemoal@kernel.org> <20250625055908.456235-4-dlemoal@kernel.org> <96831fd8-da1e-771f-7d19-8087d29f2af1@redhat.com> <07d71ad1-a6de-474b-bee4-a64180284802@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Wed, 25 Jun 2025, Damien Le Moal wrote:

> On 6/25/25 19:19, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 25 Jun 2025, Damien Le Moal wrote:
> > 
> >> +	bool wrt = op_is_write(bio_op(bio));
> >> +
> >> +	if (wrt) {
> >> +		/*
> >> +		 * For zoned devices, splitting write operations creates the
> >> +		 * risk of deadlocking queue freeze operations with zone write
> >> +		 * plugging BIO work when the reminder of a split BIO is
> >> +		 * issued. So always allow the entire BIO to proceed.
> >> +		 */
> >> +		if (ti->emulate_zone_append)
> >> +			return bio_sectors(bio);
> > 
> > The overrun may still happen (if the user changes the dm table while some 
> > bio is in progress) and if it happens, you should terminate the bio with 
> > DM_MAPIO_KILL (like it was in my original patch).
> 
> I am confused... Overrun against what ? We are now completely ignoring the
> max_write_size limit so even if the user changes it, that will not affect the
> BIO processing. If you are referring to an overrun against the zoned device
> max_hw_sectors limit, it is not possible since changing limits is done with the
> DM device queue frozen, so we are guaranteed that there will be no BIO in-flight.
> 
> I am not sure about what kind of table change you are thinking of, but at the
> very least,  dm_table_supports_size_change() ensure that there cannot be any
> device size change for a zoned DM device. And given the above point about limits
> changes, I do not see how a table change can affect the BIO execution.
> 
> Do you have a specific example in mind ?

What happens if a bio that is larger than "BIO_MAX_VECS << PAGE_SHIFT" 
enters dm_split_and_process_bio? Where will the bio be split? I don't see 
it, but maybe I'm missing something.

Mikulas

