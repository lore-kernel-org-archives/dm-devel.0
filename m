Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F8E283FE5
	for <dm-devel@lists.linux.dev>; Mon,  2 Mar 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472847; cv=none; b=sK6mljIeZ5QJfvNdiI2Y5kA1C/yRjOv1OmZ8h1h6rOoUV1SDz2RCZ2TA49yVLS1WA9gYAxyowO/hpy97gZdhaxalEwgMZZV69DJ3O+EjFF6Y4iLX2/ggNmfc7s4AgCJYt7YMNx4Z9GAyglZW9yulrZAmJfb6VWtGU1OkD4/iN4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472847; c=relaxed/simple;
	bh=+/O9CpH8nLgnuEpAL2aF30BNzMF5BMZf9hDMuNpU2Ss=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iP1PcPMFuRCcg5kytUNP1HR1R5hzNHnbmhXCpn0NnVDMByIyzSg65GXtTCDFjcAGpubxq9vDvcgWuhsYMkoZOO0R3c433MxpkMxB3RTeoLrixRPIFua2gxrpKwNhJrjKMvR/qUfBfXIIqur6cyfvy+GpEPb/jyKegSC2UMNfiQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aKeWZJYZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aKeWZJYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772472844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aR7wBC+ansRdnpr2xRHWq+wiTXZewXFu6CEriISZqzI=;
	b=aKeWZJYZJPQw7agFCUuXWPmnnw5r2S6y8/rSC0ekZkb50IfIRlZZv1IYkJL/134Wl6Cr9t
	vLtOwSyLRJH+pqcTdTwDZjzaL10ZnNx3tDlBeX9u/MxDH32OlmcVyRuOoPt2lQTQ34QHot
	OPwpehRQBmlNuiAcRSlY4JtbvPoN2qI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-paCPR8LDPzGitr8yBq-Dwg-1; Mon,
 02 Mar 2026 12:34:01 -0500
X-MC-Unique: paCPR8LDPzGitr8yBq-Dwg-1
X-Mimecast-MFC-AGG-ID: paCPR8LDPzGitr8yBq-Dwg_1772472840
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E942019560A7;
	Mon,  2 Mar 2026 17:33:59 +0000 (UTC)
Received: from [10.45.224.173] (unknown [10.45.224.173])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8672D1800666;
	Mon,  2 Mar 2026 17:33:56 +0000 (UTC)
Date: Mon, 2 Mar 2026 18:33:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    Uladzislau Rezki <urezki@gmail.com>, 
    "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
    SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    zkabelac@redhat.com, Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
In-Reply-To: <aZ2zPzyoFUUNWdJ7@linux.dev>
Message-ID: <5382696e-25e0-cd41-0a63-a79f019cb6ae@redhat.com>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com> <aZykWyxLy34o7PKr@fedora> <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com> <aZzPwsBp-Z4XM58U@tiehlicka> <aZ2N9a4XgxnurOhz@pc636> <aZ2YDD_l5JN78DJC@tiehlicka> <aZ2voRA5VJytcfLp@infradead.org>
 <aZ2zPzyoFUUNWdJ7@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: chzDxWaegwfoTEbjs36smfIEdHb4gacGg8gylNEgNZY_1772472840
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 24 Feb 2026, Shakeel Butt wrote:

> On Tue, Feb 24, 2026 at 06:03:13AM -0800, Christoph Hellwig wrote:
> > On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > > allocations as those could be achieved by scoped allocation context.
> > > This could cause pre-mature failure after the whole bunch of memory has
> > > already been allocated for the backing pages but considering that page
> > > table allocations should be more and more rare over system runtime it
> > > might be just a reasonable workaround. WDYT?
> > 
> > Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> > too hard to allocate PTEs is not breaking the overall concept.
> > 
> 
> One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
> oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
> use __GFP_RETRY_MAYFAIL to avoid oom-killer.
> 
> Mikulas, is that the reason you are using __GFP_RETRY_MAYFAIL in your use-case?

The VDO is deduplication storage driver - it needs to allocate large 
amounts of memory - for each disk block, it needs to store hash of the 
data in memory to be able to detect blocks with duplicate data.

If the VDO driver attempts to allocate more memory than what is available, 
we want the allocation to fail; we don't want to kill user processes.

Mikulas

