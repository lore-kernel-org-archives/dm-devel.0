Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270041537B9
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 09:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727255722; cv=none; b=Pf3777T/BQ11+8CNrvyeTBQadRvYZprf1R5z7bnDBdDdN76xjJROJ/d/xlcAE6KQm2vZf7DedQTVs4vSmFI0QhI2cnT9QFpAgqiWKwOSlYxGh6A9CDr5RspUTmDPxknxlFzAzze9XDqzrApykZoBR8AtBdkmooIwO717YdzGnUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727255722; c=relaxed/simple;
	bh=mfBB284wwfChSg7t0qFDugWT6M7vDw0FfnPt1nTGNnM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XNwjRnlCwZHO2st5MBBktvxcuFPo4SjsCpyYb6Ubw+4qHoWVfCIGXvllixm+WBzcP1Dt50N4d0CVUbCdv2tzcaQA7f/04nrbzrmuTqBM5eeQLYz4GEyXdMFLp8jcfKXiEIkYqCDOhqI8fKSZV1VSF15hqWqyQr8W7BV/ZLR9RFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gygTKlUE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gygTKlUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727255720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0a9nHEf0B2hLBriwSpx9p07Lvvvk2EihZ6nrwSco3YU=;
	b=gygTKlUE5a559gY2uFzaQ0Sz8i2ULPG36BhNaRBZoVjcDBNvVvi2hBZyr1evw2kCQysI2/
	dAuKcKp2/4b2a3w1YlhXFfB6lOpoUIKIvvXSqHQ4wi1Q6/K38Z/l4PfOekH1bK4pDG5zT7
	ZM8+CpNpEG++PfVw8tfxh5dOSUn5Ju0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-WnKxo2izN7Wm09HxgEzg7g-1; Wed,
 25 Sep 2024 05:15:18 -0400
X-MC-Unique: WnKxo2izN7Wm09HxgEzg7g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BAC819344E9;
	Wed, 25 Sep 2024 09:15:17 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D71A19560A3;
	Wed, 25 Sep 2024 09:15:15 +0000 (UTC)
Date: Wed, 25 Sep 2024 11:15:12 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Maxim Suhanov <dfirblog@gmail.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <20240924224950.GD1585@sol.localdomain>
Message-ID: <ca52b93d-e1da-5c29-4c4e-31a083538a7a@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <20240924224950.GD1585@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 24 Sep 2024, Eric Biggers wrote:

> On Tue, Sep 24, 2024 at 03:18:29PM +0200, Mikulas Patocka wrote:
> > Maxim Suhanov reported that dm-verity doesn't crash if an I/O error 
> > happens. In theory, this could be used to subvert security, because an 
> > attacker can create sectors that return error with the Write Uncorrectable 
> > command. Some programs may misbehave if they have to deal with EIO.
> > 
> > This commit fixes dm-verity, so that if "panic_on_corruption" or
> > "restart_on_corruption" was specified and an I/O error happens, the
> > machine will panic or restart.
> 
> How does this interact with FEC, which can correct for I/O errors on the
> underlying media by reconstructing the data?

It tries to do FEC, if it succeeds, it continues, if it doesn't succeed, 
it panics or restarts.

> > @@ -596,6 +596,19 @@ static void verity_finish_io(struct dm_v
> >  	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
> >  		verity_fec_finish_io(io);
> >  
> > +	if (unlikely(status != BLK_STS_OK) && unlikely(!(bio->bi_opf & REQ_RAHEAD))) {
> > +		if (v->mode == DM_VERITY_MODE_RESTART ||
> > +		    v->mode == DM_VERITY_MODE_PANIC)
> > +			DMERR_LIMIT("%s has error: %s", v->data_dev->name,
> > +					blk_status_to_str(status));
> > +
> > +		if (v->mode == DM_VERITY_MODE_RESTART)
> > +			emergency_restart();
> > +
> > +		if (v->mode == DM_VERITY_MODE_PANIC)
> > +			panic("dm-verity device has I/O error");
> 
> The blk_status_t code that is checked above is usually the one that
> verity_verify_io() produced, not the original one.  This could be an error from
> a cause other than an I/O error on the underlying media, like data corruption
> detected by dm-verity, or an error from the crypto API.
> 
> Maybe what you are trying to do is really "panic if an I/O error would be
> returned to the layer above", not "panic if an I/O error occurred on the
> underlying media"?  If so, this needs to be clearly explained.
> 
> - Eric

The function verity_finish_io is called when we are going to return the 
bio to the upper layer. So, the semantics is "panic if an I/O error would 
be returned to the layer above".

Mikulas

