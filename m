Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605AC383BD
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715270854; cv=none; b=njfVpApY6nuLaBJZa0SeA64rjMLe3/MIOjleNi+BrGol6Z7ezsqOWa8JVZQFc86l6LFcAW7WK1ePHf58DpSqlCmPpdlTGLdxmApZIs2QJ6qVBybQ+qBJLKNClz95+9KqTz9iAi/wQ98nV0TGEFrrjo5hzBxfN256aBWTFCsUgZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715270854; c=relaxed/simple;
	bh=FgIbhRy7HSrWRViKpPVE8AV0cZ4sC3zgxZcgjDUi/vA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LFnEujw0HcMP/hVd2crjxILzKKaNzS0j4wq/R/JCnGBJWRMrKgOJsSFd2SK1g4bq3PDGb574cH63WFOMOUODdfWoaPSZ30aB4YY401MbppvvQQVALtmrHVwXdBpvo17masrRbvdptmn1c91d0hPVfhsuDPhbwclGlTbusxWZRd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxLQv6QN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxLQv6QN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715270851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=skcFIg+gE2cq8ItC18iUQ3bcCNr+kvWpwg62m7/g4e8=;
	b=OxLQv6QNc/RgH9mr1tGjYa9HXCGOWuLGnGtIFNl0MKEBhGb/79Svral5CBZzSfVlCmcChB
	Jl3tqKIzTCvaoxY6tYwH0sshGCiYBH16SLOJcr7rT2lHl5tKKL+8JnxtIwSNK3UqtQ+q34
	wh+15uhZi6ifiQ2hYdAn1xRvtEHMuHQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-3KXZ1f9aMyqmq66XheBQXw-1; Thu, 09 May 2024 12:07:27 -0400
X-MC-Unique: 3KXZ1f9aMyqmq66XheBQXw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CD5780027F;
	Thu,  9 May 2024 16:07:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3283243511F;
	Thu,  9 May 2024 16:07:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 449G7Re8048645
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 May 2024 12:07:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 449G7QMf048644;
	Thu, 9 May 2024 12:07:26 -0400
Date: Thu, 9 May 2024 12:07:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@lists.linux.dev,
        Joel Colledge <joel.colledge@linbit.com>
Subject: Re: [PATCH 0/3] dm-delay synchronization cleanup
Message-ID: <Zjz0vkYQSMPxHFqz@redhat.com>
References: <20240507211626.26706-1-bmarzins@redhat.com>
 <ZjzctGe27JkXsANR@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZjzctGe27JkXsANR@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2024 at 10:24:52AM -0400, Mike Snitzer wrote:
> On Tue, May 07, 2024 at 05:16:22PM -0400, Benjamin Marzinski wrote:
> > This patchset fixes a possible crash in delay_dtr() caused by the
> > delay_timer queueing work on a destroyed workqueue. It also cuts down
> > on the amount of locking and waiting the dm-delay does.
> > 
> > Benjamin Marzinski (3):
> >   dm-delay: fix workqueue delay_timer race
> >   dm-delay: change locking to avoid contention
> >   dm-delay: remove timer_lock
> > 
> >  drivers/md/dm-delay.c | 52 +++++++++++++++++++++++--------------------
> >  1 file changed, 28 insertions(+), 24 deletions(-)
> > 
> > -- 
> > 2.45.0
> > 
> > 
> 
> Hey Ben,
> 
> I just staged 5 dm-delay patches in dm-6.10. 1 from Joel and 4 from
> you.  Please confirm this is what you expected and looks good:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.10

Well, I was half expecting to be told that it's kinda pointless to
optimize a target whoses purpose is to slow things down, but yeah, this
matches my dev branch.

Thanks.
-Ben

> 
> Thanks,
> Mike

