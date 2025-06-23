Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D582367A2
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750673241; cv=none; b=LNboMefoE4MuZNEeGrN55s4kbgx2gqCTyInQJQqrUnqmV3+kpZfCjNWYuD/SHcVaF7U7a+xot7qQL6+iXSbosfQJxGtdNuLiS6b5tmlbF+6VO6CwgMjzMrjHeG/jQCJ7vgwV7JvzgjI7fTVFF7BNFiJLSxt/hQxSpYSl1vLuIic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750673241; c=relaxed/simple;
	bh=GK4s1OrT+Cfcr4yn+GzoU0akj8AAT0xJdbPCtGD5v9U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ite5v/JK3eF2JnIFwcQDQExXpELcHdvwibqyGwIriRzW05rrhQ8Mg1gDrC8zqGIaqQgrUqQ9VncStrqr75ntPY2kYlguy5hMfY5DnQbLGkSDso4GysUY5siU4VCS3Kv1p9OM4xvZmiM8rBm4VmA/vm9WLKXiiNVLMPBSnJMb0uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YfGl0qdC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YfGl0qdC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750673239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yp2+zyC4x8tzEgD+RrpQHhWTfwML2EqdwJSN656Xjts=;
	b=YfGl0qdCqExo+Q+aEh88s5q8LexqtZM/Yrm+u8iBXoFH9loCrCXnv2g5v2zIZkH3IjUoNd
	beb9pNd18aGxSwEy+5lAmXjdBtZCogsqwTp/pVwWJ7Yl5qaW2U2u1IQwZOkpKn+jn/4ZPD
	a26MOdatHkL5wjXInH90/Miy60S8ly8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-yosmeulaNSe2m04rL0QUJw-1; Mon,
 23 Jun 2025 06:07:15 -0400
X-MC-Unique: yosmeulaNSe2m04rL0QUJw-1
X-Mimecast-MFC-AGG-ID: yosmeulaNSe2m04rL0QUJw_1750673234
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A440195608C;
	Mon, 23 Jun 2025 10:07:14 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 174451956096;
	Mon, 23 Jun 2025 10:07:12 +0000 (UTC)
Date: Mon, 23 Jun 2025 12:07:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Kent Overstreet <kent.overstreet@linux.dev>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-flakey: Fix corrupt_bio_byte setup checks
In-Reply-To: <aFGWiZkvqsJUfozi@redhat.com>
Message-ID: <165fcf6f-01eb-f6c3-7d9a-2b0edcf2e868@redhat.com>
References: <20250611191221.3011309-1-kent.overstreet@linux.dev> <aFGWiZkvqsJUfozi@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tW343U1GacRwNQNzEGq6fY-JrTG1lJTxjp9tKUw0x9E_1750673234
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 17 Jun 2025, Benjamin Marzinski wrote:

> On Wed, Jun 11, 2025 at 03:12:20PM -0400, Kent Overstreet wrote:
> > Fix the error_reads mode - it's incompatible with corrupt_bio_byte, but
> > that's only enabled if corrupt_bio_byte is nonzero.
> > 
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: Mike Snitzer <snitzer@kernel.org>
> > Cc: dm-devel@lists.linux.dev
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> This commit header should include:
> 
> Fixes: 19da6b2c9e8e ("dm-flakey: Clean up parsing messages")
> 
> So that it gets picked up by the stable kernel.
> 
> -Ben

I've applied the patch, thanks.

Mikulas

