Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F33F28EA7C
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 15:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751299035; cv=none; b=hO634zIYbzyK122kKFJ6PggbC+XkBLgACmbNGTzBr49xVKnKEziAohGoi/6hskzqVUg/S2I7MbTmr1KY0mj8K6kleTyuBY7vkHXxhTA5gVmVrEB7TpMNmVP7NLjWowznOLavdcYA6gHr32pY4zyeMJExbQi3sVbPZxzs/AMxnPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751299035; c=relaxed/simple;
	bh=BsE1X2c9rilZPjQhwr5Id7FQ7w2ZkWz6SRZqObc50e0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VEwSnDgkCLQZd0CX2uykB4VC6z4Ruejvk273mjIl6aQ5cgdrwn8h8CBRFNt2KbbUReR3Vd7mCkzDXfpDm2BagGq7k3Uf57ZFm4utQlQRd7TL2UvW6ruGn4rfr/IfLupaIvaQ2FI/uASwfd7ZyT49e6RhPJlIOfKrsWf3sTJzohU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eRR7NBCE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRR7NBCE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751299032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1TZO71O3x48RbMemaREgKeiGMRhS/U+1pnDccu/nUg=;
	b=eRR7NBCEqwwjki537NlNa2Bbp1JfpaLCfh3twGxB7KigT2yLSc7yBZLRI5Z7lFuia2WpKg
	+7rc37jBdgjboBGvYLkx+MjJq71yc4UYMcdnAeFdw/EDsarGSUHvOX9Uolawr6YQYiamWY
	9hN1b1WK2gXiVsYEOHZSpG9hnZatfjg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-ipkHMB-AOtuCWwyMgEcdXw-1; Mon,
 30 Jun 2025 11:57:11 -0400
X-MC-Unique: ipkHMB-AOtuCWwyMgEcdXw-1
X-Mimecast-MFC-AGG-ID: ipkHMB-AOtuCWwyMgEcdXw_1751299029
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3943C19107EB;
	Mon, 30 Jun 2025 15:57:09 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6981419560AB;
	Mon, 30 Jun 2025 15:57:05 +0000 (UTC)
Date: Mon, 30 Jun 2025 17:57:00 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BRFC_v2_00=2F11=5D_dm-pcache_=E2=80=93_pers?=
 =?UTF-8?Q?istent-memory_cache_for_block_devices?=
In-Reply-To: <3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev>
Message-ID: <202b7987-5652-ba46-2f9d-1a90679d89b5@redhat.com>
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev> <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com> <3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Mon, 23 Jun 2025, Dongsheng Yang wrote:

> +static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
> +{
> +     struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
> +     struct dm_pcache *pcache = ti->private;
> +     int ret;
> +
> +     pcache_req->pcache = pcache;
> +     kref_init(&pcache_req->ref);
> +     pcache_req->ret = 0;
> +     pcache_req->bio = bio;
> +     pcache_req->off = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
> +     pcache_req->data_len = bio->bi_iter.bi_size;
> +     INIT_LIST_HEAD(&pcache_req->list_node);
> +     bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
> 
> This looks suspicious because you store the original bi_sector to
> pcache_req->off and then subtract the target offset from it. Shouldn't
> "bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);"
> be before "pcache_req->off = (u64)bio->bi_iter.bi_sector << 
> SECTOR_SHIFT;"?
> 
> 
> Yes, that logic is indeed questionable, but it works in testing.
> 
> Since we define dm-pcache as a **singleton**, both behaviors should 
> effectively be equivalent, IIUC. Also, in V1 I moved the call to 
> `dm_target_offset()` so it runs before setting up `pcache_req->off`, 
> making the code logic correct.

If this target is singleton, you can delete the call to dm_target_offset 
at all.

That call is harmless, but it looks confusing when reviewing the code, 
because pcache_req->off is set to the absolute bio sector (from the start 
of the table) and bio->bi_iter.bi_sector is set to the relative bio sector 
(from the start of the target). If the target always starts at offset 0, 
dm_target_offset just returns bi_sector.

Mikulas

