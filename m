Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CD332860D
	for <dm-devel@lists.linux.dev>; Thu, 16 Oct 2025 12:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760618276; cv=none; b=s2lIu55PJo6p1w0KxGztIS7sROFHgoMkOKgoKtgSj30CY1IKzPpL36kDib2lHqWnb3uZ5c8YYCieYu33AaovTttBh7UQo5xP3BbELfxKmNHU491EacQBcUcuHKjDC/MJQujFhvECB+DqJvynFj9ghHVfRJiUCNCPWHTu12Mkel4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760618276; c=relaxed/simple;
	bh=qABvMikAEq9b3nMZjKp/3AF0WqNxHc01T42yC7XJFN0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rATGNv12hCVti4PcYJBU816EpeUtQbmgTCpqoyO1NOdEncTPMoNpQ/Ftt9GInj21w9O83MUcnGz8rmaNXruwgsMXQuq6l8wxeJ0daHp2QLLx1OrFazXax0qAMMa7oB6ylvGhgXvBB1jSArdbVjlsSAVvYTxxE/Dy9Uv2+Xxe0/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BohXmghh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BohXmghh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760618273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GDMplX72Tltujs4966LGkfp1VTaUycYhYl8Prwd2LV4=;
	b=BohXmghhS1oXgv6nN75YuLxGtP073+3CWuAT9B36gXS8Qq1gFNNjyZb/A+fD+VKZ4usMt2
	NOSxQ2mUrSKggr0bAkkmBnwukOzEtAC1UzP3YW7gBORUBX/xYX83QV9Ix42iAf0uxTxL9z
	fAMMTFYwftYUtLoTbR6bYivxtcXgQk0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-74uAuvT4NQyS14KVU-XTpQ-1; Thu,
 16 Oct 2025 08:37:52 -0400
X-MC-Unique: 74uAuvT4NQyS14KVU-XTpQ-1
X-Mimecast-MFC-AGG-ID: 74uAuvT4NQyS14KVU-XTpQ_1760618271
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 375171956094;
	Thu, 16 Oct 2025 12:37:51 +0000 (UTC)
Received: from [10.44.32.107] (unknown [10.44.32.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A68B18004D4;
	Thu, 16 Oct 2025 12:37:50 +0000 (UTC)
Date: Thu, 16 Oct 2025 14:37:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lei Li <noctis.akm@gmail.com>
cc: dm-devel@lists.linux.dev
Subject: Re: Writecache target power-off tolerance inquiry
In-Reply-To: <CAMhKsXm7MuxnxRtH6XH869jx_eByOHiU4nQ6rXG+bX6xiAubUQ@mail.gmail.com>
Message-ID: <c033050b-c646-4f65-829d-a0017a6e735a@redhat.com>
References: <CAMhKsXm7MuxnxRtH6XH869jx_eByOHiU4nQ6rXG+bX6xiAubUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SBgWiWElBkRIuZv7HymH3I0R4wWAJzQ83zTX5_plTfI_1760618271
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 16 Oct 2025, Lei Li wrote:

> Hi guys,
> I want to know if dm writecache target can handle power-off situation.
> 
> I've read the dm-writecache.c recent days and got confused. It seems
> that dm writecache may lose data if my pc encounter a power-off. Here
> is my thought:
> 1. There is no replay process for dm writecache. Every time
> writecache_ctr() builds a new wc_memory_entry array.
> 2. metadata update in dm-writeback can not guarantee atomic.
> 
> If I missed something?
> 
> Thanks

Hi

It should be safe w.r.t. power-off.

You need to use the FLUSH bio to commit previous writes to the stable 
storage - see writecache_map calling writecache_map_flush. Without the 
FLUSH bio, dm-writecache can lose data, but most disks could lose data in 
the absence of flush too.

struct wc_memory_entry has "seq_count" and there is seq_count in the 
superblock. The function writecache_flush increases the seq_count in the 
superblock and that makes wc_memory_entries valid.

In writecache_resume, there is "if (!writecache_entry_is_committed(wc, 
e))" - if the system is recovering from a crash and the cache entry was 
not fully committed (it has seq_count >= wc->seq_count), it is ignored 
(because it may have been only partially written).

There is no journaling - the driver keeps all the metadata in memory, and 
the seq_count is sufficient to prevent the system from using partially 
written cache blocks in the case of recovery from a crash.

Mikulas

