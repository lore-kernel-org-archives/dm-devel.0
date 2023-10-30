Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5366015E8C
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayoKd+9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698674942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dOFRZkTKK9Z0bMd9xnhKPQO2WNoW7oCCTYa8Hwz84I8=;
	b=ayoKd+9c0u6JFKkPl2YgVO8B36twShJxlVlK5fFPneby38H55Tj6RMUnLUPFdifBm/UbeA
	vi9xRd2ZWMQD4PWaj09ymXkjlrKnX212RXaBfgdjIYcs9Bfqt84H2IzuVIVlK80yZ/CQtm
	Rrcy1aW5tBEIzFGNQm7rpEaDjH9+siQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-j40fAQMlM6aMhm1JptNM3g-1; Mon, 30 Oct 2023 10:08:57 -0400
X-MC-Unique: j40fAQMlM6aMhm1JptNM3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AC63185A781;
	Mon, 30 Oct 2023 14:08:56 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A2621C060AE;
	Mon, 30 Oct 2023 14:08:56 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 1763530C72AB; Mon, 30 Oct 2023 14:08:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 148423D99F;
	Mon, 30 Oct 2023 15:08:56 +0100 (CET)
Date: Mon, 30 Oct 2023 15:08:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>
cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <ZT+wDLwCBRB1O+vB@mail-itl>
Message-ID: <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
References: <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl> <ZTiJ3CO8w0jauOzW@mail-itl> <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com> <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz> <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz> <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com> <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz> <20231030122513.6gds75hxd65gu747@quack3> <ZT+wDLwCBRB1O+vB@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-1250732461-1698674809=:1161929"
Content-ID: <e31910e4-851f-f227-c7cd-1d99fb82696a@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1250732461-1698674809=:1161929
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <2e223827-e6b-47b8-d026-66c8d92466bd@redhat.com>



On Mon, 30 Oct 2023, Marek Marczykowski-Górecki wrote:

> > Well, it would be possible that larger pages in a bio would trip e.g. bio
> > splitting due to maximum segment size the disk supports (which can be e.g.
> > 0xffff) and that upsets something somewhere. But this is pure
> > speculation. We definitely need more debug data to be able to tell more.
> 
> I can collect more info, but I need some guidance how :) Some patch
> adding extra debug messages?
> Note I collect those via serial console (writing to disk doesn't work
> when it freezes), and that has some limits in the amount of data I can
> extract especially when printed quickly. For example sysrq-t is too much.
> Or maybe there is some trick to it, like increasing log_bug_len?

If you can do more tests, I would suggest this:

We already know that it works with order 3 and doesn't work with order 4.

So, in the file include/linux/mmzone.h, change PAGE_ALLOC_COSTLY_ORDER 
from 3 to 4 and in the file drivers/md/dm-crypt.c leave "unsigned int 
order = PAGE_ALLOC_COSTLY_ORDER" there.

Does it deadlock or not?

So, that we can see whether the deadlock depends on 
PAGE_ALLOC_COSTLY_ORDER or whether it is just a coincidence.

Mikulas
--185210117-1250732461-1698674809=:1161929--

