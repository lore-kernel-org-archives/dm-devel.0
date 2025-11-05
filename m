Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C20248F69
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354819; cv=none; b=oCQuSwzPvyTPLG03bLvvB3Y4DU6BIxGy8HSuh1Xm2Akc9AZSt37FqKqoWo5naJ+SHzwHEXAc0gbKp5kzthwR+erLR3j9UguLlYFiirm4DMEhvW2PNP09kHkpeIgShTxzD5XeNQ6Geug1D9Saabh0UEXEfOLJ6hhRurjcOsOuGpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354819; c=relaxed/simple;
	bh=/xHG7/RCYWQAa+bkfE8aeoiZlsbo93P7IurY3vqV7mQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dtkQfwZa1qJYFt/7LPTk/fKEe0IL0dA5ZbLs8F8gpitUE9gVN/froSbgaHyrFceYIWI7cWdx82bZRzrC74kqqXJGpqZHh89J9G5KeAqOy2Zx5FhazMwUnUyOsi9ke5habYAzmgqCRmtZlG9lRGrtz9UkgAlb4RPFerBx7DQLACo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBhikcOY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBhikcOY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762354817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3cyoqJqiv/oF0QNMIvZ0g+cOocDC1VR+gWhIP5LUPQ=;
	b=YBhikcOYquj2H6GAn8Ca+OvbT8j9cZm1c97TB9ANSdfBjetlMC9Eduv5Pui9TVQ2dNNtCJ
	vtzueRjOBw17FAsFsHcqZGFpDpM1lACbXti+zjH1PRQLK+G67e2ShKzIPkxc0F/oHUZjVb
	iKzf4fygp6EWjUaQq7l+KDSKTO9pERs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-wwQfDpLHN1-RtXoXGyznjw-1; Wed,
 05 Nov 2025 10:00:13 -0500
X-MC-Unique: wwQfDpLHN1-RtXoXGyznjw-1
X-Mimecast-MFC-AGG-ID: wwQfDpLHN1-RtXoXGyznjw_1762354812
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D071195608E;
	Wed,  5 Nov 2025 15:00:12 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E3A4180049F;
	Wed,  5 Nov 2025 15:00:10 +0000 (UTC)
Date: Wed, 5 Nov 2025 16:00:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    michael.christie@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH 0/2] dm-crypt atomic writes support
In-Reply-To: <20251105120244.99752-1-john.g.garry@oracle.com>
Message-ID: <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com>
References: <20251105120244.99752-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bJgKf8zvxZhrKlAqxAyAppraZrfAqplNoJse9gcNFz0_1762354812
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 5 Nov 2025, John Garry wrote:

> This small series enables atomic writes support for dm-crypt.
> 
> Apart from setting DM_TARGET_ATOMIC_WRITES flag, we need to make the
> following changes:
> - limit atomic write size to dm-crypt max write size
> - BUG_ON() any partial completions for when REQ_ATOMIC is set
> 
> John Garry (2):
>   dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
>   dm-crypt: enable DM_TARGET_ATOMIC_WRITES
> 
>  drivers/md/dm-crypt.c | 21 +++++++++++++++++++--
>  drivers/md/dm.c       |  5 +++--
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 
> -- 
> 2.43.5

Hi

Thanks for the patches, I reworked them a bit.

Regarding the first patch - note that the device mapper stack may be 
arbitrarily reconfigured, so it is possible that REQ_ATOMIC bio may be 
sent to a target that doesn't support atomic writes - and this could 
trigger the "BUG_ON(bio->bi_opf & REQ_ATOMIC);".

So, we need to reject atomic bios to targets that don't support them.

Regarding the second patch - max_write_size and 
DM_CRYPT_DEFAULT_MAX_WRITE_SIZE is a performance hint that may be set 
arbitrarily by the user (it was added after we discovered that too long 
bios would not paralellize compression/decompression and it caused 
performance regression) - so it shouldn't restrict the size of atomic 
bios. The size of atomic bios should be restricted to "BIO_MAX_VECS << 
PAGE_SHIFT" - that is the hard limit.

dm-crypt already has logic to not split writes if ti->emulate_zone_append 
is true - so I joined this logic with the REQ_ATOMIC logic.

I'll send updated patches, please test them.

Mikulas

