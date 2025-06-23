Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5925334B
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 13:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686782; cv=none; b=Is+Esfkb2YbJzm07Gq0+jvW0w7VAXFyHY68e/pcMRAdhaTSxPbleWABp8rilSndPEdfG/YBN2dd8AxCaireiO64G/xAd3M7u6xwU7Y0LUQ9gzdgTmys3ayfdvvBLyfxMaBCYayAdRnxMqaF0NFDfMkiRoxHGkszKqYar/0ZhaKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686782; c=relaxed/simple;
	bh=FY3jkeB92b7BGnDfJpOMcD0RwuYZIYvvPvXICGivyf0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qNaiK5BWjcxyM+Li1dBbYjRZudWWQAg1dfYFG0CeZiXSzSu4YNG3R/nny23JSKtBO6HCzs/KhrR+3RhLlz0YZJHBDw1aH5+H1ME0gRC1cda8QMOcWI4jWtNnemX1F9Ek8Bv9v2I7z53nVC+JOQxDFU7CxZwA14jfc3Uz6xqIx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R92CsMmg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R92CsMmg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750686779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VWXjwBv+sTKLkxTdMOp3a2bylcwQ4VO2TcWFVWVPk8=;
	b=R92CsMmgSxZmQDuIMKpHdudFCZYfxVn5biMPeBcQSMgBS+bjlEtOY6/dSu0KHrv2sGIwaS
	i4NtgS/rWamo5+rtjR8Ggj9L24JTSxw06+BQw7EqGcT1qiUag5uLdHpgTz5XSN692gmidO
	4aQa3z6sdW12sW8xIJW31P8Tj0mVh14=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-7FWdWuxxMK6RS4CrHLPhYg-1; Mon,
 23 Jun 2025 09:52:54 -0400
X-MC-Unique: 7FWdWuxxMK6RS4CrHLPhYg-1
X-Mimecast-MFC-AGG-ID: 7FWdWuxxMK6RS4CrHLPhYg_1750686773
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB0F118089B6;
	Mon, 23 Jun 2025 13:52:52 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5238830001A1;
	Mon, 23 Jun 2025 13:52:51 +0000 (UTC)
Date: Mon, 23 Jun 2025 15:52:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: Christoph Hellwig <hch@infradead.org>, dm-devel@lists.linux.dev, 
    Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 2/2] dm: Check for forbidden splitting of emulated zone
 append operations
In-Reply-To: <62be55ad-a52e-49b4-90ec-a1f6bcf04550@kernel.org>
Message-ID: <eef8d701-1323-a001-6738-cf7e65756418@redhat.com>
References: <20250611011340.92226-1-dlemoal@kernel.org> <20250611011340.92226-3-dlemoal@kernel.org> <aEj3-S0aJWU5iEVg@infradead.org> <62be55ad-a52e-49b4-90ec-a1f6bcf04550@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZoGt_rsIf9jkHmHhakBZq07YZoaFtIjlNu9jlq01RmE_1750686773
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 11 Jun 2025, Damien Le Moal wrote:

> On 6/11/25 12:28 PM, Christoph Hellwig wrote:
> > On Wed, Jun 11, 2025 at 10:13:40AM +0900, Damien Le Moal wrote:
> >> @@ -1322,6 +1323,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
> >>  	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
> >>  	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
> >>  	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
> >> +	BUG_ON(bio_flagged(bio, BIO_EMULATES_ZONE_APPEND));
> >>  	BUG_ON(bio_sectors > *tio->len_ptr);
> >>  	BUG_ON(n_sectors > bio_sectors);
> > 
> > Shouldn't all these be WARN_ON_ONCE and error return instead?
> 
> Yes, I would prefer that, but that would be a more involved cleanup.
> I can switch to doing that instead of this simple check.

dm_accept_partial_bio doesn't return anything. I think that making it 
return an error and then checking for this "impossible" error in all the 
callers would just bloat the code.

Mikulas

