Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ACE200CC
	for <dm-devel@lists.linux.dev>; Fri,  5 Jan 2024 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFHMnjcs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704491536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7HOuPBnrpa2tkKKFOqmPfGBQfbtjbn15Z9/huWFh0bg=;
	b=ZFHMnjcsXGxtUjFPTbeAfONraibCZBp2GAOU7gGr4MnaRDbnbRifT86++b7ylkNE6+0A07
	m3fDD7E8bmkTPbf2uPPbiS8VkX1kPB3LJwWtYUqxm3N4+gF35uxmytCzUF+g1EvwZ05VMp
	pXoIrIyPhG/2fqQiCKTcgJFVQ4PvsHc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-VoLVkETYNyC2PSJ7kI7mUQ-1; Fri,
 05 Jan 2024 16:52:11 -0500
X-MC-Unique: VoLVkETYNyC2PSJ7kI7mUQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A33103C000A5;
	Fri,  5 Jan 2024 21:52:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B5AB492BC7;
	Fri,  5 Jan 2024 21:52:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 405LqAIA048359
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 5 Jan 2024 16:52:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 405LqAoR048358;
	Fri, 5 Jan 2024 16:52:10 -0500
Date: Fri, 5 Jan 2024 16:52:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/3] multipath-tools: coverity defect fixes
Message-ID: <ZZh6ChsMlph1lE6d@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240105184037.16518-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240105184037.16518-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 05, 2024 at 07:40:33PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Fixes for defects reported by coverity (new defects in old code).
> So far I haven't had time to test them thoroughly.

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Martin Wilck (3):
>   multipathd: init_unwinder: protect pthread_cond_wait() call with a
>     loop
>   libmultipath: is_uevent_busy(): check servicing_uev under lock
>   libmultipath: tur: protect pthread_cond_timedwait with a loop
> 
>  libmultipath/checkers/tur.c | 9 ++++++---
>  libmultipath/uevent.c       | 5 +++--
>  multipathd/init_unwinder.c  | 6 +++++-
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> -- 
> 2.43.0

