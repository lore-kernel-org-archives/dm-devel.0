Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A49B168C4
	for <dm-devel@lists.linux.dev>; Mon,  9 Oct 2023 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G1pmaSI6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696844594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nr7QSsB7wLyltuP0bHCsK/kkUnIFZPuS3VoXE+QxReY=;
	b=G1pmaSI6/69dovf4mqk8sAN2mC9KjJPrNEAXM9uaK8FVis3aJ6Yv71bM8hVBABZCer1mub
	IOJpamOcHqZwRaZfj0HHSarzq9VypL7Vc3wYmV1Z9ltla9CLJy3/gInGuYtOzGA12IKK7z
	TLvb+8ac9OveqsDddluxunOl8REpZF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287--rvbNJH1Nb2ngrRzSVPlWA-1; Mon, 09 Oct 2023 05:43:00 -0400
X-MC-Unique: -rvbNJH1Nb2ngrRzSVPlWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B28D28060EA;
	Mon,  9 Oct 2023 09:42:59 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC0D8C47873;
	Mon,  9 Oct 2023 09:42:59 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 974AE30C1C0A; Mon,  9 Oct 2023 09:42:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 93FF33FD54;
	Mon,  9 Oct 2023 11:42:59 +0200 (CEST)
Date: Mon, 9 Oct 2023 11:42:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Hannes Reinecke <hare@suse.de>
cc: charlesfdotz@tutanota.com, Dm Devel <dm-devel@lists.linux.dev>
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
In-Reply-To: <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
Message-ID: <12c1c045-7b52-8c7c-161c-599ceaadf48@redhat.com>
References: <NgGvkdW--3-9@tutanota.com> <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 9 Oct 2023, Hannes Reinecke wrote:

> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
> > Hello,
> > 
> > I would like to request a new device manager layer be added that accepts
> > trim requests for sectors and instead
> > writes zeros to those sectors.
> > 
> > This would be useful to deal with SMR (shingled magnetic recording) drives
> > that do not support trim. Currently
> > after an SMR drive has had enough data written to it the performance drops
> > dramatically because the disk must
> > shuffle around data as if it were full and without trim support there is no
> > way to inform the disk which sectors
> > are no longer used. Currently there's no way to "fix" or reset this without
> > doing an ATA secure erase despite
> > many of these disk being sold without informing customers that they were SMR
> > drives (western digital was sued
> > for selling SMR drives as NAS drives).
> > 
> Gosh, no, please don't.
> SMR drives have a write pointer, and if the zone needs to be reset you just
> reset the write pointer. Writing zeroes will result in the opposite; the zone
> continues to be full, and no writes can happen there.
> 
> Which drive is this?
> 
> Cheers,
> 
> Hannes

BTW. what about converting trims to zone reset? If the trim spans a whole 
zone, the kernel could convert it to REQ_OP_ZONE_RESET on host-aware zoned 
devices.

Mikulas

