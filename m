Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60ED1B0123
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720105588; cv=none; b=Y0lXhzzp0erlPfRW3+VUSU2WvhpEKHbfNFQ5Nh6XzRRNvc9HCdO3tbPKbQAdtdLGhBu8JOJLqLw5OrH6Cax/qBp7tKnrsII1MRcO9R0jULJC+GRtsY3xQ7QdTRySVddhMGvrzVE+FOQTak0BOffGIdNfBCleyCz8RL7U2+yEh+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720105588; c=relaxed/simple;
	bh=86Gm5Is8mkPJBC1aXyNs0DKmxSaeY/KIbMV8xYZbvdY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bWFQ2/qFS8Z6zql41UllVFKyFO84vVgv/pba64C6xG6N9q/ybp0LoXOfFRlDb5EnrPj0AlSKssxkBBjFD0Dc5Oq5skqZB3z1+elwEhrIVY37pc5dbEHu+JJm/LHd3q6TGR1EW50VqXWVle2hYjxukzb5aOWvP3MlW5fgqGdSsww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aM0UUMW6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aM0UUMW6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720105585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dtE8aD6qVsajP0FmvCYMq8naOyw7sWRkPDwBD4QiAlw=;
	b=aM0UUMW6Q1fotsTX7Pi4uhpwlHXSNLF2tNKvL2pMfYzqk6iD3ylTNq29M16dyT8m0HW2RT
	zx/GXCrI/gCN4mecsKlZH8ZbUSxAtTokExF/i8FJ3PRpUY7RiLAnbIauXvFUgBRMsvw2CA
	RxjD+PU91M3u1DPlugddfEuYW0bo+I8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-nV9naJy3NkWOml5eBGwT1Q-1; Thu,
 04 Jul 2024 11:06:22 -0400
X-MC-Unique: nV9naJy3NkWOml5eBGwT1Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89F3119560B0;
	Thu,  4 Jul 2024 15:06:21 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0456A195605A;
	Thu,  4 Jul 2024 15:06:21 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id E832030C1C14; Thu,  4 Jul 2024 15:06:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id E77D63FB52;
	Thu,  4 Jul 2024 17:06:19 +0200 (CEST)
Date: Thu, 4 Jul 2024 17:06:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/2] dm: mpath dm_get_device fix
In-Reply-To: <ZmdCAlEPN8Lmd5XQ@redhat.com>
Message-ID: <29d56ec7-87c5-cbcf-a75c-fb2fcea91978@redhat.com>
References: <20240517004129.139615-1-bmarzins@redhat.com> <ZmdCAlEPN8Lmd5XQ@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 10 Jun 2024, Benjamin Marzinski wrote:

> On Thu, May 16, 2024 at 08:41:27PM -0400, Benjamin Marzinski wrote:
> 
> ping.

I staged these patches for 6.11.

Mikulas

> > dm-mpath shouldn't be calling dm_get_device() in multipath_message().
> > If you run:
> > 
> > # dmsetup message <mpath_dev> 0 "fail_path <device_not_in_multipath>"
> > 
> > the dm_get_device() call in multipath_message() will add that incorrect
> > device to the devices list, fail to find a matching pgpath, and then
> > remove it.  multipath shouldn't be messing with the devices table
> > outside of its constructor and destructor.
> > 
> > To fix it, this patchset factors out a helper function from
> > dm_get_device() to turn the device path string into a dev_t.
> > multipath_message() calls that helper function and uses the dev_t to
> > find the correct pgpath instead.
> > 
> > Benjamin Marzinski (2):
> >   dm: factor out helper function from dm_get_device
> >   dm mpath: don't call dm_get_device in multipath_message
> > 
> >  drivers/md/dm-mpath.c         | 11 ++++-------
> >  drivers/md/dm-table.c         | 33 ++++++++++++++++++++++++---------
> >  include/linux/device-mapper.h |  5 +++++
> >  3 files changed, 33 insertions(+), 16 deletions(-)
> > 
> > -- 
> > 2.45.0
> > 
> 

