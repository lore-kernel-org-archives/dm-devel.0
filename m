Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930552405E7
	for <dm-devel@lists.linux.dev>; Wed, 30 Jul 2025 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753878461; cv=none; b=UVOju56CnHGnr8z0+bZvK+V7c7SXXTKC5oHvKzAW62H5cGraXCSAJYpezSPi20Oq8TUIr+IyjqEV7bHzAScyfHjpLc4A51tsPeGbm/hEVYOb7XHIrTvuN9LOpNSdcQzXrzPAqsorCCfJwLel8kfihRdOQdx+2Q/22oxJOr5vHiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753878461; c=relaxed/simple;
	bh=rIBFuOFGXdINfE50uZmoUuis/vCJ1k8Zj556G7HfVRA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l/UYVtMsiU1oam8zFen+vwAV1ZVVWQTQopHzYmtgGxHp13psUF4BWn6lv/y53Eq23pGH39CoJNI1nVoYfRhtME7oj6nJZeYIKNg5FpwJNpyx7jn7JrC8x7GGXbrde34oXsXl1bpHBYWl+1iPIqKP2eXbeCCVCe3N1EpidhttqNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8jaqGWU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8jaqGWU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753878458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DCWo7jpPpTT8Pi0V7/HvdnpiPwX5mpVeIY4tXKtAnkE=;
	b=a8jaqGWUu7DDTKlxiTcWRu8lZRKto922yylGBdk5IzJRvFcrWmBValyrMHH5R6PkecC71A
	oWm9MWGYrUL3AQVa7ITFRC1LOlILP0DJWtNNf5iPzAm+m9KZcu8pk0izDRexRRBPVKYLFp
	1ykSijhMEHc8t/XHsodyfGKR7ailtzc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-pBGMbYavOvy4qo1NSVJbXA-1; Wed,
 30 Jul 2025 08:27:35 -0400
X-MC-Unique: pBGMbYavOvy4qo1NSVJbXA-1
X-Mimecast-MFC-AGG-ID: pBGMbYavOvy4qo1NSVJbXA_1753878454
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E82591800256;
	Wed, 30 Jul 2025 12:27:33 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84A1530001B1;
	Wed, 30 Jul 2025 12:27:32 +0000 (UTC)
Date: Wed, 30 Jul 2025 14:27:26 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
In-Reply-To: <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com>
Message-ID: <f66ace1c-3112-a3c9-5c43-efdbbf82d765@redhat.com>
References: <20250730061718.1966686-1-weilongping@oppo.com> <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com> <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uQONy7J4E9t8ZOMpw2jncJBnBCtPt3d7LI-YbLebVcA_1753878454
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 30 Jul 2025, LongPing Wei wrote:

> On 7/30/2025 6:46 PM, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 30 Jul 2025, LongPing Wei wrote:
> > 
> > > dm-thin obviously can pass through inline crypto support.
> > 
> > Hi
> > 
> > I'm not sure about it. What if dm-thin performs copy-on-write? How would
> > that interact with inline crypto?
> > 
> > Mikulas
> > 
> Hi, Mikulas
> 
> dm-thin's encryption behavior is the same as dm-bow's when COW occurs, and
> DM_TARGET_PASSES_CRYPTO has already been set to dm-bow.
> 
> The key and iv of inline crypto are passed in by the upper layer, which is not
> affected by the specific location of data blocks in thin-pool.
> 
> LongPing Wei>> Signed-off-by: LongPing Wei <weilongping@oppo.com>

How is it supposed to work during provisioning? Suppose that you have 64k 
chunk with no mapping. dm-thin returns zero for it. Then, you write 4k 
somewhere to this chunk. dm-thin allocates the chunk, writes zeroes to it 
and then writes 4k data into it (and only this 4k block will be 
encrypted). When you attempt to read this chunk, the 4k block will be 
deciphered correctly, but the zero data around it will be deciphered too 
and garbage will be returned to the application.

Mikulas

