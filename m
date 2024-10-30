Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01281EB9FD
	for <dm-devel@lists.linux.dev>; Wed, 30 Oct 2024 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730297116; cv=none; b=JzU4Af03eT0oKkTKmkNnEh5ieAWwPP47IlZnLuBJ0veAOwKZqzThvtpJTF7ucl3Nep/xkqSPSiHsvz1xsPGr95BSK6pg+ddzl0ZYAhQe44JrKGLPtURQcLhNmYVQ8iMCOvhHUD1HflUhzvXtzMe9IQhx1vy9ZWtCCEBFx5z0aPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730297116; c=relaxed/simple;
	bh=w0NT6Gk0ur0HD2UoBG3r5/KsmROJOBMgV8sb7u9f5Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ouvPLFP680QIEsDHqAIqsJIb+GJIafV4615C9eLroMjJQc7nlY4NFV1gNarLlkuiDpzrScJEbo/AATquV2sN59olalRkq45J6Exi5E6fyIrIgUBR7ZCx8w/rQ4GYlObP3rNuD7mB1LGgSwjPYMj+UbNjqAKcYwsWs3mlP6ITGW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LuMlUUPS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LuMlUUPS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730297113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zUCtEJ6E0lawO/E3+W9tg8ydSZ4TRJH53ZybSbExGkc=;
	b=LuMlUUPSUNT33bWqZ4BVFnHBElsuYYryZuR3NqTsmHkYz2+sCF6jFSmAl08amX+cxAMLIk
	z/xfFszMKtwpfF7znRQhWJ9sxRdKV1Z//jRvr+McT7D89UXJWq8wwVoXDMyYVFNwkK7m9p
	Q2ED/H+TWsKCMrlW5M8FNG6CWUndvnc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-PztfLul5P8-LA1cmRN9zmQ-1; Wed,
 30 Oct 2024 10:05:11 -0400
X-MC-Unique: PztfLul5P8-LA1cmRN9zmQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD32A1978C8F;
	Wed, 30 Oct 2024 14:05:07 +0000 (UTC)
Received: from [192.168.37.1] (unknown [10.22.58.17])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DADC11955F45;
	Wed, 30 Oct 2024 14:05:05 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 linux-nfs@vger.kernel.org
Subject: Re: [PATCH] dm: add support for get_unique_id
Date: Wed, 30 Oct 2024 10:05:03 -0400
Message-ID: <ABD563AE-C7F3-43C2-A698-479C7D5924BF@redhat.com>
In-Reply-To: <20241030135214.GA28166@lst.de>
References: <f3657efae72f9abb93d3169308052e77bf0dbad6.1730292757.git.bcodding@redhat.com>
 <20241030135214.GA28166@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On 30 Oct 2024, at 9:52, Christoph Hellwig wrote:

> On Wed, Oct 30, 2024 at 08:57:56AM -0400, Benjamin Coddington wrote:
>> This adds support to obtain a device's unique id through dm, similar to the
>> existing ioctl and persistent resevation handling.  We limit this to
>> single-target devices.
>>
>> This enables knfsd to export pNFS SCSI luns that have been exported from
>> multipath devices.
>
> Is there anything that ensures that the underlying IDs actually
> match?

Match each other in a multipath device you mean?  No, this will just return
the first one where get_unique_id returns non-zero.  Can they actually be
different, and if so should we return an error?

>
>> +	struct dm_unique_id *dmuuid = data;
>> +	const struct block_device_operations *fops = dev->bdev->bd_disk->fops;
>> +
>> +	if (fops->get_unique_id)
>> +		return fops->get_unique_id(dev->bdev->bd_disk, dmuuid->id, dmuuid->type);
>> +
>> +	return 0;
>
> Overly long line here.  Also maybe just personal, but I find code easier
> to read when the exit early condition is in the branch, e.g.
>
> 	strut gendisk *disk = dev->bdev->bd_disk
>
> 	if (!disk->fops->get_unique_id)
> 		return 0;
> 	return disk->fops->get_unique_id(disk, dmuuid->id, dmuuid->type);

That is nicer, will do.

Ben

