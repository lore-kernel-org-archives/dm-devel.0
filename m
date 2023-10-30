Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B61D2E9
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFffjU37"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698666546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNWJb3Kj/1cIYg/Vg3MgPzg6XViSheol3KsOD/+icSA=;
	b=ZFffjU37n2s2lidQKUEc3FuTzR+0/utnVMhKsaGMUGLdyN2qEmy29ptG5pVaMe8g9yYUcV
	47VurCjDD7/6B8XwREjzDO6qDZKl8J3I3uXIwCS8lm+mckQsJm8GHqaA/IeLNqrR9WBnb2
	7ooN6qOdQJTV0wSdP8SHIC10GEvKezk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-imiWb702NZ2UiB9qt1FnAg-1; Mon,
 30 Oct 2023 07:49:02 -0400
X-MC-Unique: imiWb702NZ2UiB9qt1FnAg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D2863C000A2;
	Mon, 30 Oct 2023 11:49:01 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AFC2492BE0;
	Mon, 30 Oct 2023 11:49:01 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 5711B30C72AB; Mon, 30 Oct 2023 11:49:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 5467E3D99F;
	Mon, 30 Oct 2023 12:49:01 +0100 (CET)
Date: Mon, 30 Oct 2023 12:49:01 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <20231030112844.g7b76cm2xxpovt6e@quack3>
Message-ID: <7355fe90-5176-ea11-d6ed-a187c0146fdc@redhat.com>
References: <ZTNH0qtmint/zLJZ@mail-itl> <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl> <ZTiJ3CO8w0jauOzW@mail-itl> <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com> <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com> <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz> <20231030112844.g7b76cm2xxpovt6e@quack3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9



On Mon, 30 Oct 2023, Jan Kara wrote:

> > >> What if we end up in "goto retry" more than once? I don't see a matching
> > > 
> > > It is impossible. Before we jump to the retry label, we set 
> > > __GFP_DIRECT_RECLAIM. mempool_alloc can't ever fail if 
> > > __GFP_DIRECT_RECLAIM is present (it will just wait until some other task 
> > > frees some objects into the mempool).
> > 
> > Ah, missed that. And the traces don't show that we would be waiting for
> > that. I'm starting to think the allocation itself is really not the issue
> > here. Also I don't think it deprives something else of large order pages, as
> > per the sysrq listing they still existed.
> > 
> > What I rather suspect is what happens next to the allocated bio such that it
> > works well with order-0 or up to costly_order pages, but there's some
> > problem causing a deadlock if the bio contains larger pages than that?
> 
> Hum, so in all the backtraces presented we see that we are waiting for page
> writeback to complete but I don't see anything that would be preventing the
> bios from completing. Page writeback can submit quite large bios so it kind
> of makes sense that it trips up some odd behavior. Looking at the code
> I can see one possible problem in crypt_alloc_buffer() but it doesn't
> explain why reducing initial page order would help. Anyway: Are we
> guaranteed mempool has enough pages for arbitrarily large bio that can
> enter crypt_alloc_buffer()? I can see crypt_page_alloc() does limit the
> number of pages in the mempool to dm_crypt_pages_per_client plus I assume
> the percpu counter bias in cc->n_allocated_pages can limit the really
> available number of pages even further. So if a single bio is large enough
> to trip percpu_counter_read_positive(&cc->n_allocated_pages) >=
> dm_crypt_pages_per_client condition in crypt_page_alloc(), we can loop
> forever? But maybe this cannot happen for some reason...
> 
> If this is not it, I think we need to find out why the writeback bios are
> not completeting. Probably I'd start with checking what is kcryptd,
> presumably responsible for processing these bios, doing.
> 
> 								Honza

cc->page_pool is initialized to hold BIO_MAX_VECS pages. crypt_map will 
restrict the bio size to BIO_MAX_VECS (see dm_accept_partial_bio being 
called from crypt_map).

When we allocate a buffer in crypt_alloc_buffer, we try first allocation 
without waiting, then we grab the mutex and we try allocation with 
waiting.

The mutex should prevent a deadlock when two processes allocate 128 pages 
concurrently and wait for each other to free some pages.

The limit to dm_crypt_pages_per_client only applies to pages allocated 
from the kernel - when this limit is reached, we can still allocate from 
the mempool, so it shoudn't cause deadlocks.

Mikulas

