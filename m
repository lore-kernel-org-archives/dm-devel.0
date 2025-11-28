Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DFF259CBB
	for <dm-devel@lists.linux.dev>; Fri, 28 Nov 2025 13:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764335233; cv=none; b=GvVCP/EGy2iqFXr5tIlUSs0WSgsH68UviwEOjyfUHti4J6TQY6+JgC05qiJG46577rD0ztfy9U5XzPrAKmWJufKt6Jitg8TbDWgWD8nDEtsF2fh3M0smO4Kvvt6j6TCzyhc/JlSp3TBtOythF4+++nR2YIvNSXz+qPvnV17MJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764335233; c=relaxed/simple;
	bh=VHYHgexxgHbQ5OsrvArm20YDZku2gPKDHZpeBEhBbkM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sWadKP0ZmBiiWgEbsbLaEOn+X/vMMp/wSsLWc0thjf2wZfaZ+RzClkffiTxk1V7ZClrbhmeH46v9EFkTHHq3u8poG1xr02+FvxoRf0iNMQa1/x+mG63HIf1SAIZf2Ugv9lGI1TMRr71e96LcQzSkHHxCajc+bR79LYRPSKz5Hl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LuKz+o0Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LuKz+o0Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764335231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WyCsOey8Tb1Q5O93zaNxc9kNDhLa6VYXzjywxnyvYKg=;
	b=LuKz+o0ZWNbQRdyzNs6RZCN7LBpsnvDg1xRISzLQZeWdWO7QB806N14n1ess6skQtVNFNS
	2OmsgLYJoKwi6waU4jfrAxK0/mMhMD98cLnNt5CZ0y24faNaBuRcE9VNEvnpvksqIg+Hie
	jDajLw+pXsvoEMEIUpQQ2g0iWFb+TH4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-fSAN69SkOnqKsAn7fqhwuQ-1; Fri,
 28 Nov 2025 08:07:05 -0500
X-MC-Unique: fSAN69SkOnqKsAn7fqhwuQ-1
X-Mimecast-MFC-AGG-ID: fSAN69SkOnqKsAn7fqhwuQ_1764335224
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CD071956071;
	Fri, 28 Nov 2025 13:07:03 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1443A195608E;
	Fri, 28 Nov 2025 13:07:00 +0000 (UTC)
Date: Fri, 28 Nov 2025 14:06:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Kurt Fitzner <kurt_cryptsetup@va1der.ca>
cc: Aaron Rainbolt <arraybolt3@gmail.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-mm@kvack.org, cryptsetup@lists.linux.dev, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <804601778974c504d42f4423d335a94d@va1der.ca>
Message-ID: <32c2c4c6-d8c0-297a-b0eb-f06a939d5e44@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5> <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com> <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com> <804601778974c504d42f4423d335a94d@va1der.ca>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Thu, 27 Nov 2025, Kurt Fitzner wrote:

> On 2025-11-27 13:54, Mikulas Patocka wrote:
> 
> > Encrypted swap file is not supposed to work.
> 
> Do you have a reference for this?  The concept of encrypted swap files has
> been a valid workflow for a very long time.
> 
> > So, this is what happened to you - the machine runs out of memory, it
> > needs to swap out some pages, dm-crypt encrypts the pages and generates
> > write bios, the write bios are directed to the loop device, the loop
> > device directs them to the filesystem, the filesystem attempts to allocate
> > more memory => deadlock.
> 
> If it's the filesystem trying to allocate memory on writes to a swap file that
> is causing a memory allocation/swap race, then any write to a swap file would
> engender the same result, regardless of encryption. The encryption layer is
> redundant under the failure mode you propose.

No - when you swap to unencrypted file, the kernel bypasses the 
filesystem. It creates a block map of the file at swap activation time and 
when it swaps to the file it uses this block map and it doesn't call any 
filesystem functions.

This bypass doesn't work when you put other block device drivers over the 
file.

> I can confirm I have put kernels up to and including 6.14 under heavy memory
> stress and have never encountered anything that feels like a memory allocation
> race.  All my systems have encrypted swap files.
> 
> I can't speak toward later kernels, or any bugs that may or may not be
> presesnt, but I know of nothing to suggest that encrypted swap files remain
> anything other than an intended feature.
> 
>     Kurt

So, it works by chance, not by design.

Mikulas

