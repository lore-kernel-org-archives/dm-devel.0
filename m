Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA4B433BC
	for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715796928; cv=none; b=lSmfU1Eho/5i+luThPuB+maHOUosCcuHtAt3FAIBHQuurRi966u81alE9Fs53MbyKMFZ7d8ist0UxQV07JgZ8OCwuoYYZz7jCqNJDbqhoF4AWdzP7Gwj5sSRzAC4Fm3WiDihiJ3i4ZqQqkpE5WUvbesBknEObOkIRs/j99MKzD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715796928; c=relaxed/simple;
	bh=SU/RDVkpPTpp5QYAfDm+EZqMp5LVlExxE1dd6L0JSXQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=dWVqEaOddFA2nZ/clu5r4wNSYyz1QR0Kv3HHKxISqh0EWd884TceUMA4ZyketpFIav1/MgjRPrgOZ6TKXgtDSP1XJI6nb4hWqWyIRnJfrUOr2pie/VCquHFdPPGeb1fcNC2ZSa7j16C1qffGxM9mWtfNOECCvtm0yI9rWiLtMuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evcK+GS5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evcK+GS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715796925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=8nFn5bvdBW4AsQ5YTuGNNNTcA1XQHPb7RVCvLk4JYTU=;
	b=evcK+GS5s8AXoRh0pR+Q/wqo7+s7RNXA7c+VrxBUJKGPWyezI09GK20YeS9jDDD7No96To
	yM/Jr6RPuoVDZK6bdao0Qh0MFkiLsw0PvNfsFsICgUHbhmYKBOKjIYFq3KjRHPhx4PaWQV
	4fUND9fRh6gf4Rwyq6p6/eIQYor2cqY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-p4OHpuzlMOqdDeW0eSOvXQ-1; Wed,
 15 May 2024 14:15:21 -0400
X-MC-Unique: p4OHpuzlMOqdDeW0eSOvXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31A111C031AC;
	Wed, 15 May 2024 18:15:21 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E484D2024511;
	Wed, 15 May 2024 18:15:20 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id CD28830C1C33; Wed, 15 May 2024 18:15:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id C906D3FB4F;
	Wed, 15 May 2024 20:15:20 +0200 (CEST)
Date: Wed, 15 May 2024 20:15:20 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>, Ming Lei <ming.lei@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: Useless test in alloc_multiple_bios
Message-ID: <ec2ba8a0-5a8-6dd0-eb56-33c8e7a389ea@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I found this piece of code in alloc_multiple_bios:
int try = (gfp_flag & GFP_NOWAIT) ? 0 : 1;

The problem is that GFP_NOWAIT includes __GFP_KSWAPD_RECLAIM and GFP_IO 
also includes __GFP_KSWAPD_RECLAIM - so the test always returns true and 
we always start with try = 0. This code was introduced by the commit 
4a2fe2960891f1ccd7805d0973284fd44c2f12b4.

I am inclined to remove this logic at all and always start with try = 0; 
- trying to allocate bios first with GFP_NOWAIT makes no harm (and it 
improves performance because we don't need to grab the lock) and if the 
allocation fails, it is retried with GFP_NOIO.

I'd like to ask - if you think that this piece of code has some purpose, 
please describe the purpose.

Mikulas

