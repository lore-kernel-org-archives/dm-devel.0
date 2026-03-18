Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA9C29BD91
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 17:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855666; cv=none; b=e3kWdb3T2tkhDTdcuMrdu6ZdXn2bi2X/AwLVVsvzCmueGYjpRrJO8mpXt6jkIiXRdg//03sZD+iWYx/ufqdHu8KDsEnSBTJdwbc+zgU/SZCBOzkS8bIEGOAD3MyGkrCOwxL3qgYmMhSywT4efikyKLfsBf2w378Ue4kI2eI+amQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855666; c=relaxed/simple;
	bh=s+CGibtA4y0a9q37S2QRMURGWT/7FAQ7Xjisr08Z50g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BFMcVYlI+WVbMn2RBxWaYwnd44yJkdrveQ6uHHo+ygfebpnGRn253nbtbbYF+d8R+HSrKrjB7c1AzQBEitnSKWtKvQr/D6j91K60ZcN4azUdCrddlfKjnr2dqgJ2Yq5DVyJUy2Lbm6NbB8F7HqLsNJNf44ny1hwNOuIzzcQ4/ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QGhpgkYq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGhpgkYq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773855664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IJufNzU08HIP5/vRywt1rw+U9x8dlUOD1dADKWSYVM0=;
	b=QGhpgkYqplr4KTQIYsx/o6CvyHSaOQE38QT00Ssk8lNWM/JdZg8FvKBAUJaHe6hVGK2k2r
	f9V77tAXfrSupFLWsrI5qtBoJ9/thSpxd8NrwqqYyd3XnrFnaSgW/XA6lV8ibx8dI4lxTP
	9LdMVN6DNHmolQD0VbE4kbzX5+U66WU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-FY46u8Y5MtGuEsFsQ_SoXA-1; Wed,
 18 Mar 2026 13:41:00 -0400
X-MC-Unique: FY46u8Y5MtGuEsFsQ_SoXA-1
X-Mimecast-MFC-AGG-ID: FY46u8Y5MtGuEsFsQ_SoXA_1773855658
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5898818005B8;
	Wed, 18 Mar 2026 17:40:58 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC36A1955F19;
	Wed, 18 Mar 2026 17:40:56 +0000 (UTC)
Date: Wed, 18 Mar 2026 18:40:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@kernel.org>
cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
In-Reply-To: <abraWvuLlTjHF-9q@kbusch-mbp>
Message-ID: <7cdd50b4-afcf-aa5a-af0b-a00a35b88bdf@redhat.com>
References: <20260316150229.1771884-1-kbusch@meta.com> <20260316150941.1813568-1-kbusch@meta.com> <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com> <abraWvuLlTjHF-9q@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: xsf-PXRT4hhex5l-hUncoY7Ap9lTr5m9nkonMmrw85s_1773855658
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 18 Mar 2026, Keith Busch wrote:

> On Wed, Mar 18, 2026 at 05:34:47PM +0100, Mikulas Patocka wrote:
> > On Mon, 16 Mar 2026, Keith Busch wrote:
> > > +static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist **psg,
> > >  			   struct bvec_iter *iter, struct bio *bio,
> > >  			   int max_segs)
> > >  {
> > >  	unsigned int bytes = cc->sector_size;
> > > +	struct scatterlist *sg = *psg;
> > >  	struct bvec_iter tmp = *iter;
> > >  	int segs, i = 0;
> > >  
> > >  	bio_advance_iter(bio, &tmp, bytes);
> > >  	segs = tmp.bi_idx - iter->bi_idx + !!tmp.bi_bvec_done;
> > > -	if (segs > max_segs)
> > > -		return -EIO;
> > > +	if (segs > max_segs) {
> > > +		sg = kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOIO);
> > > +		if (!sg)
> > > +			return -ENOMEM;
> > > +	}
> > >  
> > >  	sg_init_table(sg, segs);
> > >  	do {
> > 
> > GFP_NOIO allocations may be unavailable when you are swapping to the 
> > dm-crypt device and the machine runs out of memory temporarily. There 
> > should be:
> > 
> > sg = kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOWAIT | __GFP_NOMEMALLOC);
> > 
> > and if it fails, allocate "sg" from a mempool with GFP_NOIO (mempool_alloc 
> > with GFP_NOIO can't fail, it waits until someone frees some entries into 
> > the mempool).
> 
> Thanks for the suggestion, this sounds good. Just to note, the use case
> for swap always writes out pages, so it's always aligned and would never
> take this path. The use case in mind where this path could happen is
> just for zero-copy direct io applications.

That's true, but I'd rather like to have the code clean and not depend on 
some implicit assumptions like "swap never uses split sglists".

> But even then, the only thing I know of that really wants this has an
> offset that straddles two pages per block, so I never need more than 2
> segments, and the inline scatterlist has four. There's just currently no
> way for the block layer to report a max-segments-per-block limit, so I'm
> including this patch to be consistent with the reportable limits.

Can userspace use preadv/pwritev with many small iovecs on a file opened 
for direct I/O?

Mikulas

