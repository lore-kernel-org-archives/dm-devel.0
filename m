Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC2820F091
	for <dm-devel@lists.linux.dev>; Wed, 19 Mar 2025 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742419138; cv=none; b=AvfyH/WE7IvHCuFrps3P9olOvNzsiJzHDj6tadhhvX4xndu0BNL8M7NfgmmfOT4QAgWY+KGBujRu0lokSleSbcEyP09dyp92tkQ3zK0vVI8MrXgXEPrdyUOZec5m+EYqTd6UXb6PQ0DIW/IVaR64FPNmyIu8pf+kXnVlNaDIslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742419138; c=relaxed/simple;
	bh=8Qk21XtAtuMr8WU/6FPqNPIz8trBEboe6geXCafiXGo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g2JXvDuwdfVKg42RQ/AD9ynAsrCsogokPBk0Fkxcg7OZjIv25Y5+BweYNWyTDREW2DOIVTLhloivmeAC1GTfNNxRquL3Kym6iLA65uTXKr2LNLq66vzcpoYF7QwUVP3g7R4QFKh5//0zRw9nI6xgMn7qkQG5pFtC1H88bvEhvbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RAfcYTKx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAfcYTKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742419133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yANbqU707rXdx8XQYm6bZXg9kJ9aFMXd583FayRRhY0=;
	b=RAfcYTKxjIW9fcNANXjP/4hGuouYm0zm0AqUwABMA77a4eITpwp07oxsDQVPnaaDTgby7F
	WDFrnP8H1Q3L+V+KaAaqPmsNQufiT1zLpI5rNTZvKDPY5KfjmAe20x+U+PhwUdzYdiUwdy
	qUPpWCWV/Me65sBLQT8IRUo7mMT8uH0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-C9pNz4odPf6XF8mc9B_G6Q-1; Wed,
 19 Mar 2025 17:18:49 -0400
X-MC-Unique: C9pNz4odPf6XF8mc9B_G6Q-1
X-Mimecast-MFC-AGG-ID: C9pNz4odPf6XF8mc9B_G6Q_1742419128
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C545F1801A00;
	Wed, 19 Mar 2025 21:18:47 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 750C11800370;
	Wed, 19 Mar 2025 21:18:44 +0000 (UTC)
Date: Wed, 19 Mar 2025 22:18:39 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Ming Lei <ming.lei@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
In-Reply-To: <6ebdd2ae-8fc2-4072-b131-a7c0da56d3f2@kernel.dk>
Message-ID: <d04fcd9f-b4a7-100a-e9a4-b0d4d45b372b@redhat.com>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com> <Z9mJmlhmZwnOlnqT@fedora> <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com> <Z9ocUCrvXQRJHFVY@fedora> <6ebdd2ae-8fc2-4072-b131-a7c0da56d3f2@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Tue, 18 Mar 2025, Jens Axboe wrote:

> > Yeah, it looks fine, but I feel it is still fragile, and not sure it is one
> > accepted solution.
> 
> Agree - it'd be much better to have the bio drivers provide the same
> guarantees that we get on the request side, rather than play games with
> this and pretend that concurrent update and usage is fine.
> 
> -- 
> Jens Axboe

And what mechanism should they use to read the queue limits?
* locking? (would degrade performance)
* percpu-rwsem? (no overhead for readers, writers wait for the RCU 
  synchronization)
* RCU?
* anything else?

Mikulas

