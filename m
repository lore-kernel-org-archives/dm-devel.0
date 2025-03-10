Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8B7221DAB
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 23:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741650174; cv=none; b=jXzN+zSeeOOT8KQsJWN4jKk/OGycAnsUJF2PKgSbZK0wM3vJVLYqGhzsNeyvU0q4dbWoidz3tdXy7F+kxCvQUsb2lTFUAgCuVjmhHRg4GXe9p1aSjZ58D4Ejdm/bfMF4h7ooM1UCxOObUF483efCj54oEtct2hCbGEWNQkSZa9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741650174; c=relaxed/simple;
	bh=bEHb/XuKFvYwvTUlClFzRfHDWBIjRYrLFyegwd5yCLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orv5aWt5QGqrtsPY6OFTQZ2HB1d40RWW6hkzmisbYU2+dNaO8B/hhndQeSjKeJeqS+nj0UXxrSIwf+NcZ+ZYhioxOhDdJGrV+FGIvQ7fodaNIWv5YoSRTu3GA2R2x8HFFuU6oxoKbhbh+LCZFbCKv/rGeAbEV3mco5MBJfnY6bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XLXPgRyC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XLXPgRyC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741650171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HD+QO/wcq7UDXBHOW5cqJpCGmrmPyKM6LVw7Evp6oR8=;
	b=XLXPgRyCsxg64oBeWnFTMPksXClUu56xpsaKPFqOuCvyT7Iu5mb7RTMeZHkBDK/Pa5+Q//
	SL1Z+Ktnfjm/barXzYYKMN90ly4NiNBZ/NtK5cBvr1muoZhlkr9vaRMQGScDkPsktcTWqT
	75HcOAr+YhngUBEXNbzmUAq53nE9WZk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-ZH71itX7MAKio7QB_Gn9BA-1; Mon,
 10 Mar 2025 19:42:48 -0400
X-MC-Unique: ZH71itX7MAKio7QB_Gn9BA-1
X-Mimecast-MFC-AGG-ID: ZH71itX7MAKio7QB_Gn9BA_1741650167
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB75F19560BB;
	Mon, 10 Mar 2025 23:42:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 981811800944;
	Mon, 10 Mar 2025 23:42:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52ANgiit491406
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Mar 2025 19:42:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52ANgh2D491405;
	Mon, 10 Mar 2025 19:42:43 -0400
Date: Mon, 10 Mar 2025 19:42:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 7/7] dm: allow devices to revalidate existing zones
Message-ID: <Z8948_PSARorliqn@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-8-bmarzins@redhat.com>
 <7e0a1b47-3c96-4864-80b0-813f357845ad@kernel.org>
 <Z88k2RD6s5KpuxOD@redhat.com>
 <ab56c408-c98d-4333-b4f1-c3f380008e12@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab56c408-c98d-4333-b4f1-c3f380008e12@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 11, 2025 at 08:19:29AM +0900, Damien Le Moal wrote:
> On 3/11/25 02:43, Benjamin Marzinski wrote:
> > On Mon, Mar 10, 2025 at 08:59:26AM +0900, Damien Le Moal wrote:
> >> On 3/10/25 07:29, Benjamin Marzinski wrote:
> >>> dm_revalidate_zones() only allowed devices that had no zone resources
> >>> set up to call blk_revalidate_disk_zones(). If the device already had
> >>> zone resources, disk->nr_zones would always equal md->nr_zones so
> >>> dm_revalidate_zones() returned without doing any work. Instead, always
> >>> call blk_revalidate_disk_zones() if you are loading a new zoned table.
> >>>
> >>> However, if the device emulates zone append operations and already has
> >>> zone append emulation resources, the table size cannot change when
> >>> loading a new table. Otherwise, all those resources will be garbage.
> >>>
> >>> If emulated zone append operations are needed and the zone write pointer
> >>> offsets of the new table do not match those of the old table, writes to
> >>> the device will still fail. This patch allows users to safely grow and
> >>> shrink zone devices. But swapping arbitrary zoned tables will still not
> >>> work.
> >>
> >> I do not think that this patch correctly address the shrinking of dm zoned
> >> device: blk_revalidate_disk_zones() will look at a smaller set of zones, which
> >> will leave already hashed zone write plugs outside of that new zone range in the
> >> disk zwplug hash table. disk_revalidate_zone_resources() does not cleanup and
> >> reallocate the hash table if the number of zones shrinks.
> > 
> > This is necessary for DM. There could be plugged bios that are on on
> > these no longer in-range zones.  They will obviously fail when they get
> > reissued, but we need to keep the plugs around so that they *do* get
> > reissued. A cleaner alternative would be to add code to immediately
> > error out all the plugged bios on shrinks, but I was trying to avoid
> > adding a bunch of code to deal with these cases (of course simply
> > disallowing them adds even less code).
> 
> I am confused now :)
> Under the assumption that we do not allow switching to a new table that changes
> the zone configuration (in particualr, there is no grow/shrink of the device),
> then I do not think we have to do anything special for DM.

If we don't allow switching between zoned tables, then we obviously
don't need to make DM call blk_revalidate_disk_zones() on a zoned table
switch. I was just saying that I know that this patch would leave
out-of-range zone plugs behind on a shrink, but that is necessary to
allow shrinking while there could still be outstanding plugged bios
attached to those plugs.

So, if we wanted to allow shrinking, then I think this patch is correct
(although erroring out all the out-of-range bios would be a cleaner
solution). But assuming we don't allow shrinking, then you are correct.
We don't need to do anything special for DM.

-Ben

> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

