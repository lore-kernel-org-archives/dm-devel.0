Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8332770C
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711110754; cv=none; b=js9CO1Rk1TCXp8UeTR6Sxa4NcKtQwCtBjFeDKXcmARfKZJ6NSXZ3FuW8zWtqtKo/u3rJXXyGZLddhIHvybSiLVSnSg82oGWUhEUHwpG9TwcGPInpdifZvo5KxAJ2jx+9fseT/81DSi4XkV2Azvo+R3Ecqq3MWfPaDpOS+SMgMA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711110754; c=relaxed/simple;
	bh=gwphgHjZlfiNiJhvyyM8SZd86ONf9JZAT9wgRCkP83U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hGpQI1BIGxK+PlniU9ArFt5J24vnivCAgKhDnyJAQQPv2B6vrpeMkHfW2swAnFoSwk+h9APihMLl7IIy+e8zkMtkKSLBqMySFNLF/9ooi7CHMvP5ltGr0U/TBC/NYl4vy8FalJF1guTEpuLfBmmlEqu2Wgrw+jx53IGS1AR9Nrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eNNNs0oP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNNNs0oP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711110752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wkuXJbKYgenxL4UcNt4iV9Jday36DGpbf4sCh/JIqA=;
	b=eNNNs0oPAozU5KqcWAlEVHS6YWTvA2GWW5TSSA/rqOZaIDtKhv6eDSvpVp2cNAkquoqBmY
	MZsdKdGDHyWGEM9w4EVkubGcJZXRQ3yMpgc/nHeDAhEj6quGr/C97lFavW4CSCmObB2WiB
	ffrTWCIvzzryOe/gdbQuqvE3qEOnxsA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-7ylbzfNBPnCX5Xvk7qhg8A-1; Fri, 22 Mar 2024 08:32:30 -0400
X-MC-Unique: 7ylbzfNBPnCX5Xvk7qhg8A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F8858007A4
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:32:30 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31BAE492BDD;
	Fri, 22 Mar 2024 12:32:30 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 1D60F30BFECA; Fri, 22 Mar 2024 12:32:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 19FBB3FB4B;
	Fri, 22 Mar 2024 13:32:30 +0100 (CET)
Date: Fri, 22 Mar 2024 13:32:30 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
cc: Mike Snitzer <msnitzer@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-integrity: align the outgoing bio in
 integrity_recheck
In-Reply-To: <Zf1zfjuzb9be0Uwz@fedora>
Message-ID: <f4149577-ac28-b4f2-1a89-37845c197677@redhat.com>
References: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com> <ZfzhzMgdJJaOZwGA@fedora> <2ca5a02-de66-a4bb-b42f-45ea54f79de@redhat.com> <Zf1zfjuzb9be0Uwz@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 22 Mar 2024, Ming Lei wrote:

> If logical block becomes mismatched by reconfiguration, the whole DM stack can't work:
> 
> - at the beginning, DM is over NVMe(512 bs), DM & NVMe lbs is 512
> - later, nvme is reconfigured and its lbs becomes 4k, but DM's lbs can't
> be updated
> - then unaligned IO is submitted to NVMe
> 
> So DM _never_ works with mis-matched logical block size because of
> reconfigure, and same with MD.

It can work. If a filesystem has 4k block size and it is used on a block 
device with misconfigured with 512-byte sector size, it will work.

The buffer cache also prefers using page-sized blocks rather than logical 
block size, so it will work too.

> > But yes, it works with 64K PAGE_SIZE.
> 
> Fine, but I still think PAGE_SIZE is hard to follow than logical block
> size.
> 
> Thanks,
> Ming

The temporary buffer has one page, so I restricted the alignment to 
PAGE_SIZE. logical block size is always <= PAGE_SIZE.

Mikulas

