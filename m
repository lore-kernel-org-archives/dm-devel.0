Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248A611CAF
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZ5mEXzx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698841003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a5UIfMBVdGIbdKNzRDMLvhiScyxGbvuh4NifZMx02eQ=;
	b=aZ5mEXzxW8/GXvcWV22XW6XEVVcUUYsiJy2VvSbnZE/m0hrDOahBJhGV8GLDIetUFI1vLy
	nD1tOHm1m5vekifavTUGz37hyayt5LE0nTFZyJ07ITCchI01okVR9jJJd0tim1tsZv7CN0
	xEacZrM0LPOEctKBBIDvzET2qIOjmbs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-rsj5tSE7PqiyMazlfvH37A-1; Wed,
 01 Nov 2023 08:16:40 -0400
X-MC-Unique: rsj5tSE7PqiyMazlfvH37A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C7E02803022;
	Wed,  1 Nov 2023 12:16:38 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA5C11121309;
	Wed,  1 Nov 2023 12:16:37 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D85C230C2A86; Wed,  1 Nov 2023 12:16:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id D3EFE3FB77;
	Wed,  1 Nov 2023 13:16:37 +0100 (CET)
Date: Wed, 1 Nov 2023 13:16:37 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Hannes Reinecke <hare@suse.de>
cc: Ming Lei <tom.leiming@gmail.com>, 
    =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>, 
    Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org, linux-block@vger.kernel.org, 
    linux-nvme@lists.infradead.org, ming.lei@redhat.com
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <ab02413f-4bf2-4d92-baf7-62fbd106f5df@suse.de>
Message-ID: <fd2e3ba-d681-4856-3d50-9f63a2fcb0a8@redhat.com>
References: <ZT+wDLwCBRB1O+vB@mail-itl> <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com> <20231030155603.k3kejytq2e4vnp7z@quack3> <ZT/e/EaBIkJEgevQ@mail-itl> <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com> <ZUB5HFeK3eHeI8UH@mail-itl> <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl> <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com> <ZUG0gcRhUlFm57qN@mail-itl> <ZUHE52SznRaZQxnG@fedora> <ab02413f-4bf2-4d92-baf7-62fbd106f5df@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3



On Wed, 1 Nov 2023, Hannes Reinecke wrote:

> And that is something I've been wondering (for quite some time now):
> What _is_ the appropriate error handling for -ENOMEM?
> At this time, we assume it to be a retryable error and re-run the queue
> in the hope that things will sort itself out.
> But if they don't we're stuck.
> Can we somehow figure out if we make progress during submission, and (at
> least) issue a warning once we detect a stall?

The appropriate way is to use mempools. mempool_alloc (with 
__GFP_DIRECT_RECLAIM) can't ever fail.

But some kernel code does GFP_NOIO allocations in the I/O path and the 
authors hope that they get away with it.

Mikulas

