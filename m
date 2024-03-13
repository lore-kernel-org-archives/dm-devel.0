Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A56225AD
	for <dm-devel@lists.linux.dev>; Wed, 13 Mar 2024 13:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710335487; cv=none; b=oSkLNU0dGA1/HXn0yD4iQBA0iYkUagf1mg3Juo3a0PF/PHDV6MQLg+qx9gg/okGlRzhphns/JHAckwGZd/IOVdiURZ3QMkFM6wAi74qXnQly4WcYAb/JZ3+SyBgWWHv3MiUzBOG2YoFY/LlphfG494yfQPWlYJcO2kMV1XO3ZNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710335487; c=relaxed/simple;
	bh=WJmxgj6Qmd9I66vJdLMoCeGyd9Ni4X1SwXJFbgbeDHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QG3bD9WYp35uj9oniYx6TF9RRyDd3Q9HGPybvrMiJBV04WPu7nkx29boo+TDrvy1RH20rDvReLpJrrnzbgqQcunPg35GNu1Bq+5QPUFkK2JH3kwCrTfkmWOvw0yVmWec9GnMabXtSO0DxgG+5jadyuiWJvmOWhcjwfrKDLVbhEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TZK6ZuX0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZK6ZuX0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710335485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VbKExkfuK6A1U00MuCFHA4JLsXlU55tMN2WgLDlOoZA=;
	b=TZK6ZuX02aYvu2t3fIiW4SvVbtxGki3bD156oRTAFOK9Kh5sllYgIJJTv6MvhO2JFG44vk
	5Au61rP2OUgD3EJ5SVyVWLXRDJceSnTvFLKBT4uQhV4CyTPERpN3uIZ5/glOnX5UnIMDOM
	vlH1tbFg5iT6kXpFtIRx8IfjHLYDTqc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-1XR3A94xOxWMKyCMirbtaQ-1; Wed,
 13 Mar 2024 09:11:21 -0400
X-MC-Unique: 1XR3A94xOxWMKyCMirbtaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C36E3C0253E;
	Wed, 13 Mar 2024 13:11:21 +0000 (UTC)
Received: from fedora (unknown [10.72.116.65])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 723762166AE9;
	Wed, 13 Mar 2024 13:11:16 +0000 (UTC)
Date: Wed, 13 Mar 2024 21:11:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev, ming.lei@redhat.com
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfGl8HzUpiOxCLm3@fedora>
References: <eaeec3b6-75c2-4b65-8c50-2d37450ccdd9@kernel.dk>
 <20240311235023.GA1205@cmpxchg.org>
 <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
 <ZfBzTWM7NBbGymsY@redhat.com>
 <ZfDEtchBNeFLG-GV@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfDEtchBNeFLG-GV@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Tue, Mar 12, 2024 at 02:10:13PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 12, 2024 at 11:22:53AM -0400, Mike Snitzer wrote:
> > blk_validate_limits() is currently very pedantic. I discussed with Jens
> > briefly and we're thinking it might make sense for blk_validate_limits()
> > to be more forgiving by _not_ imposing hard -EINVAL failure.  That in
> > the interim, during this transition to more curated and atomic limits, a
> > WARN_ON_ONCE() splat should serve as enough notice to developers (be it
> > lower level nvme or higher-level virtual devices like DM).
> 
> I guess.  And it more closely matches the status quo.  That being said
> I want to move to hard rejection eventually to catch all the issues.
> 
> > BUT for this specific max_segment_size case, the constraints of dm-crypt
> > are actually more conservative due to crypto requirements.
> 
> Honestly, to me the dm-crypt requirement actually doesn't make much
> sense: max_segment_size is for hardware drivers that have requirements
> for SGLs or equivalent hardware interfaces.  If dm-crypt never wants to
> see more than a single page per bio_vec it should just always iterate
> them using bio_for_each_segment.
> 
> > Yet nvme's
> > more general "don't care, but will care if non-nvme driver does" for
> > this particular max_segment_size limit is being imposed when validating
> > the combined limits that dm-crypt will impose at the top-level.
> 
> The real problem is that we combine the limits while we shouldn't.
> Every since we've supported immutable biovecs and do the splitting
> down in blk-mq there is no point to even inherit such limits in the
> upper drivers.

In theory, it is yes, DM even doesn't use the combined segment size
& virt boundary, but MD uses that(maybe unnecessarily), however
the two are often stacked.

There may be corner cases, and removing the two limits combination can
be one big change for DM/MD since this way has been used long time.

The warning & failure in blk_validate_limits() can fail any MD/DM
which is over scsi & nvme, so I'd suggest to remove the 'warning &
-EINVAL' first, otherwise more complaints may follow.


Thanks,
Ming

