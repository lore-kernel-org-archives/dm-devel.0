Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D051118A
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 11:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fYb3SyUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698664965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsoSqi0pr1x6sNVcc+kdDZ1hk5GZpJql/KSUpzO2HtQ=;
	b=fYb3SyUEFeqTBZSKlaJvT6aXJzhUJknVA2hZLntkzaoghss3Q+T0U+QRoO+uqRohewejMD
	WyKOKxql0c8bMyYNQ3DlcZVny1nC6dgg23EMxXmTd/4RIeCwy6SFM2HNcxlqsyAtshjg6r
	PcokDKLZD1prN/neRCaS+xVDIUrL34U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-sUZWnPKSONSu9s7Br8Ss7A-1; Mon, 30 Oct 2023 07:22:39 -0400
X-MC-Unique: sUZWnPKSONSu9s7Br8Ss7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18667802E65;
	Mon, 30 Oct 2023 11:22:39 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4E102026D66;
	Mon, 30 Oct 2023 11:22:38 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D085130C72AB; Mon, 30 Oct 2023 11:22:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id CCAA53D99F;
	Mon, 30 Oct 2023 12:22:38 +0100 (CET)
Date: Mon, 30 Oct 2023 12:22:38 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
Message-ID: <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
References: <ZTNH0qtmint/zLJZ@mail-itl> <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl> <ZTiJ3CO8w0jauOzW@mail-itl> <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com> <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com> <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4



On Mon, 30 Oct 2023, Vlastimil Babka wrote:

> Ah, missed that. And the traces don't show that we would be waiting for
> that. I'm starting to think the allocation itself is really not the issue
> here. Also I don't think it deprives something else of large order pages, as
> per the sysrq listing they still existed.
> 
> What I rather suspect is what happens next to the allocated bio such that it
> works well with order-0 or up to costly_order pages, but there's some
> problem causing a deadlock if the bio contains larger pages than that?

Yes. There are many "if (order > PAGE_ALLOC_COSTLY_ORDER)" branches in the 
memory allocation code and I suppose that one of them does something bad 
and triggers this bug. But I don't know which one.

> Cc Honza. The thread starts here:
> https://lore.kernel.org/all/ZTNH0qtmint%2FzLJZ@mail-itl/
> 
> The linked qubes reports has a number of blocked task listings that can be
> expanded:
> https://github.com/QubesOS/qubes-issues/issues/8575

Mikulas

