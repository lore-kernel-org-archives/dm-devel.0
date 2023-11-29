Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1F8208CF
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCAzjryP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701284548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DsMUlyrWWahUnMy1mIdG5bl9+m+2G0jF1XT7kXxNQuE=;
	b=cCAzjryPVUfC2JLPvhsB3fQ/4tDzyU8iKYgiPiqj0UzIlJh/7rPrTZvhQXLMxG7jbJiT7S
	p8KFUi5cVKOjqFR3P7qe7/iek6VpHKztHTQWe6H17wfFbVzghvyc9/dVnoNy/jcNTFfHI+
	uW2acwwdc+/ozY52oGxBImO3a1G9htA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-alrj6Q-xP6e-OIpl-KE93g-1; Wed, 29 Nov 2023 14:02:24 -0500
X-MC-Unique: alrj6Q-xP6e-OIpl-KE93g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86F2F101A594;
	Wed, 29 Nov 2023 19:02:23 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E788502A;
	Wed, 29 Nov 2023 19:02:23 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 6339330C1A8C; Wed, 29 Nov 2023 19:02:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 5FF193FB76;
	Wed, 29 Nov 2023 20:02:23 +0100 (CET)
Date: Wed, 29 Nov 2023 20:02:23 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sasha Levin <sashal@kernel.org>
cc: Christian Loehle <christian.loehle@arm.com>, 
    stable-commits@vger.kernel.org, stable@vger.kernel.org, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: Patch "dm delay: for short delays, use kthread instead of timers
 and wq" has been added to the 6.6-stable tree
In-Reply-To: <ZWeIiCcZXwZkY1_J@sashalap>
Message-ID: <ef29ecb1-5853-88cc-16c0-98cf17c2519@redhat.com>
References: <20231129025441.892320-1-sashal@kernel.org> <cac7f5be-454c-5ae1-e025-9ad1d84999fc@redhat.com> <bdf739ae-5e45-4192-b682-81f05982c220@arm.com> <30e67bef-4aaf-31d6-483f-2ca6523099c3@redhat.com> <ZWd3HCVNTkZYREGo@sashalap> <b8d0fdf7-fca4-4a2d-3dd-94b2c97b7fb4@redhat.com>
 <ZWeIiCcZXwZkY1_J@sashalap>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5



On Wed, 29 Nov 2023, Sasha Levin wrote:

> On Wed, Nov 29, 2023 at 07:16:52PM +0100, Mikulas Patocka wrote:
> >
> >
> >On Wed, 29 Nov 2023, Sasha Levin wrote:
> >
> >> On Wed, Nov 29, 2023 at 06:28:16PM +0100, Mikulas Patocka wrote:
> >> >
> >> >
> >> >On Wed, 29 Nov 2023, Christian Loehle wrote:
> >> >
> >> >> Hi Mikulas,
> >> >> Agreed and thanks for fixing.
> >> >> Has this been selected for stable because of:
> >> >> 6fc45b6ed921 ("dm-delay: fix a race between delay_presuspend and
> >> >> delay_bio")
> >> >> If so, I would volunteer do the backports for that for you at least.
> >> >
> >> >I wouldn't backport this patch - it is an enhancement, not a bugfix, so it
> >> >doesn't qualify for the stable kernel backports.
> >>
> >> Right - this watch was selected as a dependency for 6fc45b6ed921
> >> ("dm-delay: fix a race between delay_presuspend and delay_bio").
> >>
> >> In general, unless it's impractical, we'd rather take a dependency chain
> >> rather than deal with a non-trivial backport as those tend to have
> >> issues longer term.
> >>
> >> --
> >> Thanks,
> >> Sasha
> >
> >The patch 70bbeb29fab0 ("dm delay: for short delays, use kthread instead
> >of timers and wq") changes behavior of dm-delay from using timers to
> >polling, so it may cause problems to people running legacy kernels - the
> >polling consumes more CPU time than the timers - so I think it shouldn't
> >go to the stable kernels where users expect that there will be no
> >functional change.
> >
> >Here I'm submitting the patch 6fc45b6ed921 backported for 6.6.3.
> 
> Is this okay for 6.1 too?

Yes, it is. It applies to kernels as old as 4.19.

Mikulas

