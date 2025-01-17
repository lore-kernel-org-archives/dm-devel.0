Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125801ACDE7
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 21:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737149264; cv=none; b=VdVRvTr3zHc5sx8NLj90bvbqUy0WEjCcV7HZfEUoY8otFcBQFEEUawn8JPY0ghuYiGqU8jtjFdZI78m6a81M5ORF4aRe3CuOwvqJ8BlOFe4K3UcGHsLt5DvSDXI7cp/KSQfADD0ZwdnwHJPHV3hm3SnbC/54eN37YIZoPuaJM1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737149264; c=relaxed/simple;
	bh=gHtROKOtw49TMpUTn1AbSc7CDbzBv0kMZ9gHKZs7a4M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Pnb6YoqP9WIuQEm2xi9UGuO1sfz+Gi4PjhX4udXl5ghbLsQhlsERTJr2fwwtFUCngJ3WAmqygCRg0J7L8HRUsTH0sJ/8Da7JmH05M/Qm4KAWF4cvBIKixlOk3jJOs60rsGzEzGTrPaosEsMgX4JoVRrac+/l0LCK0yllu4OXHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TWeebfAH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TWeebfAH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737149260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgV+zu79hN75oKX15LFXTDKwUbzMzhPDf2yqirzHSkk=;
	b=TWeebfAHO6+g24McDka7DLf4fCsTcNJPIe7YTgez++9Sxa8R4b4bucDgrGMwBZWt3eZJh0
	MP0PrbUKlWZyEWU1RcL6IM0zCanb4ecFEpI4LoQ0PWJGayBM9hwc6DSLa2epOt3WlUu6G1
	8tkrh/r8xBJR8zb4KYn/rVTF2iCS+ZI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-WwH0T1MENuyUjWdIi_lucQ-1; Fri,
 17 Jan 2025 16:27:36 -0500
X-MC-Unique: WwH0T1MENuyUjWdIi_lucQ-1
X-Mimecast-MFC-AGG-ID: WwH0T1MENuyUjWdIi_lucQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 635381956050;
	Fri, 17 Jan 2025 21:27:33 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A764019560A3;
	Fri, 17 Jan 2025 21:27:26 +0000 (UTC)
Date: Fri, 17 Jan 2025 22:27:22 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, agk@redhat.com, 
    hch@lst.de, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, 
    sagi@grimberg.me, James.Bottomley@hansenpartnership.com, 
    martin.petersen@oracle.com, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, 
    linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/8] device mapper atomic write support
In-Reply-To: <Z4q45sjEih8vIC-V@kernel.org>
Message-ID: <4c5d02d6-a798-a390-2743-088c31c8965f@redhat.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com> <Z4q45sjEih8vIC-V@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Fri, 17 Jan 2025, Mike Snitzer wrote:

> On Thu, Jan 16, 2025 at 05:02:53PM +0000, John Garry wrote:
> > This series introduces initial device mapper atomic write support.
> > 
> > Since we already support stacking atomic writes limits, it's quite
> > straightforward to support.
> > 
> > Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
> > more personalities could be supported in future.
> > 
> > This is still an RFC as I would like to test further.
> > 
> > Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
> > sectors to (LLONG_MAX >> 9)
> > 
> > Changes to v1:
> > - Generic block layer atomic writes enable flag and dm-table rework
> > - Add dm-stripe and dm-raid1 support
> > - Add bio_trim() patch
> 
> This all looks good.
> 
> Mikulas, we need Jens to pick up patches 1 and 2.  I wouldn't be
> opposed to him taking the entire set but I did notice the DM core
> (ioctl) version and the 3 DM targets that have had atomic support
> added need their version numbers bumped.  Given that, likely best for
> you (Mikulas) to pick up patches 3-8 after rebasing on Jens' latest
> for-6.14/block branch (once Jens picks up patches 1 and 2).
> 
> Jens, you cool with picking up patches 1+2 for 6.14?  Or too late and
> we circle back to this for 6.15?
> 
> Either way, for the series:
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Hi

I rebased on Jens' block tree, applied the patches 3-8, increased 
DM_VERSION_MINOR, DM_VERSION_EXTRA, increased version numbers in 
dm-linear, dm-stripe, dm-raid1 and uploaded it to git.kernel.org.

You can check it if it's correct.

Mikulas

