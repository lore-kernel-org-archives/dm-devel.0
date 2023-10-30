Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956DF4E8
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 11:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HK/gXW3C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698665848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z5XvzHGoYibU00zP11b4K8Q9RWlvIImJ+SASs4zDQHE=;
	b=HK/gXW3C4S+Txb3Vk6kNNPCt1CzqesKa3L+Dkr1zw98xOFifeG0RJ2N9A356CxQ3GKA9l+
	owA22/63087Gj6E7ZBMaVw4kZfgntGEW2C9Qdo4wN0FUrFWoGF8mbSqqtlb45HQQWMgUWz
	Q/l8eQHtPC14TzX5afI8KYVX5bXRx5k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-QVylyo7IMXGgDQ4-NF2k5g-1; Mon, 30 Oct 2023 07:37:17 -0400
X-MC-Unique: QVylyo7IMXGgDQ4-NF2k5g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAED58870A1;
	Mon, 30 Oct 2023 11:37:16 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABF27492BE9;
	Mon, 30 Oct 2023 11:37:16 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 97BFD30C72AB; Mon, 30 Oct 2023 11:37:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 949AA3D99F;
	Mon, 30 Oct 2023 12:37:16 +0100 (CET)
Date: Mon, 30 Oct 2023 12:37:16 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
Message-ID: <1efb1dfc-785a-bf5f-390-b1d372e81c18@redhat.com>
References: <ZTNH0qtmint/zLJZ@mail-itl> <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl> <ZTiJ3CO8w0jauOzW@mail-itl> <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com> <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com> <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz> <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com> <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9



On Mon, 30 Oct 2023, Vlastimil Babka wrote:

> On 10/30/23 12:22, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 30 Oct 2023, Vlastimil Babka wrote:
> > 
> >> Ah, missed that. And the traces don't show that we would be waiting for
> >> that. I'm starting to think the allocation itself is really not the issue
> >> here. Also I don't think it deprives something else of large order pages, as
> >> per the sysrq listing they still existed.
> >> 
> >> What I rather suspect is what happens next to the allocated bio such that it
> >> works well with order-0 or up to costly_order pages, but there's some
> >> problem causing a deadlock if the bio contains larger pages than that?
> > 
> > Yes. There are many "if (order > PAGE_ALLOC_COSTLY_ORDER)" branches in the 
> > memory allocation code and I suppose that one of them does something bad 
> > and triggers this bug. But I don't know which one.
> 
> It's not what I meant. All the interesting branches for costly order in page
> allocator/compaction only apply with __GFP_DIRECT_RECLAIM, so we can't be
> hitting those here.
> The traces I've seen suggest the allocation of the bio suceeded, and
> problems arised only after it was submitted.
> 
> I wouldn't even be surprised if the threshold for hitting the bug was not
> exactly order > PAGE_ALLOC_COSTLY_ORDER but order > PAGE_ALLOC_COSTLY_ORDER
> + 1 or + 2 (has that been tested?) or rather that there's no exact
> threshold, but probability increases with order.

It has been tested - Marek tested it with intial order == 4 and he hit the 
bug. With 3 and less he didn't.

Mikulas

