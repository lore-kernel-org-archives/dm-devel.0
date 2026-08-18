Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497C443E39
	for <dm-devel@lists.linux.dev>; Tue, 18 Aug 2026 09:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044955; cv=none; b=DcLCk9jQWHbQ+GEC2ToL0Zvs0WRPAUrbGoPdAV4BlE06+VUW293agmMNSsQRwZs0TMThsMM8gXf0ZZIqiZ4vRt43FLMBBbW/ITlba9MT7sqG5ERfQTBLELbBwEsi5DDV2WwTHtW3KsKPoTezGHFrbSh955q8zbgzZvRD069zH/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044955; c=relaxed/simple;
	bh=IsEOygGtfFLHYmbUDLsIQtZMoWYKY4eGibyUiU33wNg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KDVbA4ubFGM+sGL6QzKjMYuUrNNBIQrfqd2ruKSWfIgKm1uNnjI0k/yaMpDEkYdccFuhj5HEA4bTitEgk2vscpt6DF+wj0r/UXsXfCYDA9icTu17PhlFVFvOT34D8e2bz8aac8o3iF6G9ozglsza+3WEDnSKCr2jI+JEqKaY+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f69B+bKY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f69B+bKY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787044953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kSRhIRY7DhW+zYPGde8sb9EbsmtFd08VqSJIXF3N0po=;
	b=f69B+bKYBs78NaLepE8SITk7sD5xGdde8nkpVz0bTf3n7yezUtEd1UxR80Dt3b0BgVPVAo
	m0abeEl/6dD/jQfxqhmbVuhrMC/MdBIQjTp86+5UJjBsgVO+jZdd+sBZGzpbllfumeMxIw
	dm53mcfMrcIxKCWSP/e+xdoEdOli99A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-5KoqOPY-NUePqti-6YtenA-1; Tue,
 18 Aug 2026 05:22:27 -0400
X-MC-Unique: 5KoqOPY-NUePqti-6YtenA-1
X-Mimecast-MFC-AGG-ID: 5KoqOPY-NUePqti-6YtenA_1787044947
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEBB41800D80;
	Tue, 18 Aug 2026 09:22:25 +0000 (UTC)
Received: from [10.44.48.124] (unknown [10.44.48.124])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4D2B434;
	Tue, 18 Aug 2026 09:22:23 +0000 (UTC)
Date: Tue, 18 Aug 2026 11:22:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Junzhe <junzheyu1@gmail.com>
cc: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [BUG] dm: unbounded recursion in dm_blk_ioctl via cyclic DM
 stacking
In-Reply-To: <20260818075627.322-1-junzheyu1@gmail.com>
Message-ID: <c51ba72b-6fb6-2b66-ec9b-3211c0c3518e@redhat.com>
References: <20260818075627.322-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: zFl6QOcTbTHGlcXp43uZs7646bFil0FTmHbwiqWfGIY_1787044947
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 18 Aug 2026, Yu Junzhe wrote:

> Hello,
> 
> I am reporting unbounded recursion in dm_blk_ioctl(): it forwards a 
> block ioctl to the underlying device with no depth or cycle guard. A 
> two-device DM-on-DM cycle then re-enters dm_blk_ioctl until the kernel 
> stack is exhausted.

Hi

There is also unbounded recursion in bio_endio when stacking bio-based 
drivers. Many years ago I tried to fix it, but there was no intereset in 
fixing it.

If you work with block maintainers to fix the bio_endio recursion, I can 
fix the dm_blk_ioctl case.

> Table load rejects only a device mapped onto itself (dm_get_device: dev 
> == disk_devt(t->md->disk)). A->B->A is accepted. bd_link_disk_holder 
> rejects only a disk holding itself.

Regarding A->B->A stacking - the user just shouldn't do recursive 
stacking.

Mikulas

