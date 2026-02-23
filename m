Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9038364E99
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 12:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771848809; cv=none; b=DQxNaiawrAL4P8IywostSgLTeoW2PvyHJxMQ1OcUsN6NAbp36PIISxmTIG9CTtiBA7u0kMlVXCGY6Y/ixYO6KrhUc11Ew1ViCd81ad0Cd2hpbrZ6f9BqcvY/wSwbynWCmj4cBKURp3m1YK8iQLVfzh5TZB3WJ0aWmZCWTjgwrX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771848809; c=relaxed/simple;
	bh=Mfc5og3dzWAAuJ7mus9itNcRMAYoQ/9PArv2YhznlNY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rB0k30wwn4k6aTRfwzltZJ7OZvpSMDdzmKaC0Yy1G1B5d8Q0Y/N4plxGYfXsfVHN3bC5iom+aK1T952yvZhf9N/fWtxv07oM6TZeOfPNABQq8AR/xhv9wmcmcTeb8kmmNrUBetHUp1eCGHsgSRctf7zC6qxEecNx46oEM1LhRpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=baouG8IQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="baouG8IQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771848806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=im1Uzk8Co+53q9O4bY1Id3plFSjM3v8WFdQaM0aRdZE=;
	b=baouG8IQcuMcsuPs7OqfG50Cjc+pXaMet4BwH3ltEiIQ5+5FIgfQzasYGgwyjM++iPVkSX
	6x/HYQGp5EK9uvpEbPLXr3xIybpUUIimMHIhtBohpyNTruE3XTsfIPutlOR4Oggjklf1CT
	5FionYh0rRZlbTbrc9ugGO5UCl30cG0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-XhbjdbRSPQObMHYV4dN1Og-1; Mon,
 23 Feb 2026 07:13:23 -0500
X-MC-Unique: XhbjdbRSPQObMHYV4dN1Og-1
X-Mimecast-MFC-AGG-ID: XhbjdbRSPQObMHYV4dN1Og_1771848801
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78B471956094;
	Mon, 23 Feb 2026 12:13:21 +0000 (UTC)
Received: from [10.44.34.95] (unknown [10.44.34.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B036119560A3;
	Mon, 23 Feb 2026 12:13:18 +0000 (UTC)
Date: Mon, 23 Feb 2026 13:13:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Marco Crivellari <marco.crivellari@suse.com>
cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
    Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
    Frederic Weisbecker <frederic@kernel.org>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Michal Hocko <mhocko@suse.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH] dm: add WQ_PERCPU to alloc_workqueue users
In-Reply-To: <CAAofZF7gneM02R9oHKS-=NmFs47Unk+rO9bjEiW5Gv694GLTvA@mail.gmail.com>
Message-ID: <391f5759-e85c-c6eb-d81a-ec0d82d57ab6@redhat.com>
References: <20260113110302.114843-1-marco.crivellari@suse.com> <CAAofZF7gneM02R9oHKS-=NmFs47Unk+rO9bjEiW5Gv694GLTvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: _ItRdKyzQOjuFUmnwDUJUbFb4bi-MLIBvKhTh8AF9xM_1771848801
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-111903147-1771848801=:23927"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-111903147-1771848801=:23927
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 23 Feb 2026, Marco Crivellari wrote:

> On Tue, Jan 13, 2026 at 12:03 PM Marco Crivellari
> <marco.crivellari@suse.com> wrote:
> >  drivers/md/dm-bufio.c              |  3 ++-
> >  drivers/md/dm-cache-target.c       |  3 ++-
> >  drivers/md/dm-clone-target.c       |  3 ++-
> >  drivers/md/dm-crypt.c              |  6 ++++--
> >  drivers/md/dm-delay.c              |  4 +++-
> >  drivers/md/dm-integrity.c          | 15 ++++++++++-----
> >  drivers/md/dm-kcopyd.c             |  3 ++-
> >  drivers/md/dm-log-userspace-base.c |  3 ++-
> >  drivers/md/dm-mpath.c              |  5 +++--
> >  drivers/md/dm-raid1.c              |  5 +++--
> >  drivers/md/dm-snap-persistent.c    |  3 ++-
> >  drivers/md/dm-stripe.c             |  2 +-
> >  drivers/md/dm-verity-target.c      |  4 +++-
> >  drivers/md/dm-writecache.c         |  3 ++-
> >  drivers/md/dm.c                    |  3 ++-
> >  drivers/md/md.c                    |  4 ++--
> >  16 files changed, 45 insertions(+), 24 deletions(-)
> 
> Gentle ping.
> 
> Thanks!

Hi

The patch was already committed to 7.0-rc1. See the commit 
d4880868670198df321627a949e7b7f2d76cf54e.

Mikulas
---1463811712-111903147-1771848801=:23927--

