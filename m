Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA71519B9
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869215; cv=none; b=beXJ860ceJPZU+sccFomBprAvPAwaMfwHq8uks9gdXvtdqBEGMDaJxPDCJUvS8OITBPEv2eP8V7mOusjYgYg/UMIe65sH0Thr0+5KlhumRSHBnqkWd1hJ2VpOf40Eu482wuEu2YykuZBW5yNQcmip3TqSg0Hu1EZcUq0K29hnBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869215; c=relaxed/simple;
	bh=w8HamvXIfF70c1Jlwsqol6xTtkLLfkKWH8FsKxJjU2o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Nn9tSd7vxg3cng5Wjg4GJ1uHAOWqX/ms1o2Fb3NZ8aaaFqDezmXdYV5bxVLP6Xx0oekMAp3/ZOXyPFzASh3n93kby6SlBVCPxCWNhLcqBB5VoV8iNn46un9OgLJJa1dU3lnAGl9M1sdZ/uvD96qXdqE+RkWvX79PPykDZCpCKUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AZf5ReaF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZf5ReaF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750869213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=amCEsrQtfa1hXwyWRd1ZdiWEeRbV3sK8Ec08uUHcKsw=;
	b=AZf5ReaFSu5vdIjK9uYj+Ex+chfMC8tebCnzpET2aac/u4vrBFKo5518LjngkKNVweODE8
	mZSGOMDyBq2ShQC9bpVlSbcWD2FIM47WJdf18tRCl1t90FqQ1Fys5EKHHGMcd07MunhVQO
	ZML68d1FDK6uTOA/UsLMGFt9/JkFq7o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-12-4k-j-2ifMhKxIGTS_sbVDg-1; Wed,
 25 Jun 2025 12:33:27 -0400
X-MC-Unique: 4k-j-2ifMhKxIGTS_sbVDg-1
X-Mimecast-MFC-AGG-ID: 4k-j-2ifMhKxIGTS_sbVDg_1750869206
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D11318862E6;
	Wed, 25 Jun 2025 16:33:10 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E95EA195E761;
	Wed, 25 Jun 2025 16:33:07 +0000 (UTC)
Date: Wed, 25 Jun 2025 18:33:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
    dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 3/4] dm: dm-crypt: Do not split write operations with
 zoned targets
In-Reply-To: <40690cc0-e941-4db1-904c-a5d60718d852@kernel.org>
Message-ID: <917d9f55-6ee2-c5c7-b6a5-fe188ad42590@redhat.com>
References: <20250625055908.456235-1-dlemoal@kernel.org> <20250625055908.456235-4-dlemoal@kernel.org> <96831fd8-da1e-771f-7d19-8087d29f2af1@redhat.com> <07d71ad1-a6de-474b-bee4-a64180284802@kernel.org> <5c9898e1-3fae-d271-b0b8-a23371d22cb0@redhat.com>
 <40690cc0-e941-4db1-904c-a5d60718d852@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Wed, 25 Jun 2025, Damien Le Moal wrote:

> >> Do you have a specific example in mind ?
> > 
> > What happens if a bio that is larger than "BIO_MAX_VECS << PAGE_SHIFT" 
> > enters dm_split_and_process_bio? Where will the bio be split? I don't see 
> > it, but maybe I'm missing something.
> 
> See patch 3 of the v3 I sent: dm_zone_bio_needs_split() and
> dm_split_and_process_bio() have been modified to always endup with need_split ==
> true for zone write BIOs, and that causes a call to bio_split_to_limits(). So
> dm-crypt will always see BIOs that are smaller than limits->max_hw_sectors,
> which is set to BIO_MAX_VECS << PAGE_SECTORS_SHIFT in dm-crypt io_hint. So
> dm-crypt can never see a write BIO that is larger than BIO_MAX_VECS << PAGE_SHIFT.

OK.

I acked the patches and I suppose that they will be sent through the block 
layer tree.

Or - should I send them through the device mapper tree?

Mikulas

