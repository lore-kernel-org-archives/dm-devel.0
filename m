Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794963131;
	b=usHzx3PN836LojVrQBoJzb1FKO3Gyo9RNY2jOiE31+xGk5bDlOZzNxvgcGHCvwFiInuR
	 TrSwnXKUHxnzAECoYYSn98iH4PzHXN/GDFol6eCcxrXGvP6ox0AnRxlh5gEj9wDqH4idE
	 c2G56xSBz8fsOLmuq86pP9lZaghXTsiGl4DcrD5wG+XISnhs+Z+CjLZ/krlLElaVtdElc
	 piKhPyfDyumCEnn3xScg2drv+rcZvUKmbP5qoY3BvTw9Wozz7C2fOch3pnlzqG6bpPTtz
	 F5HCjDlHo/XuuyNELz/L1UDWk1Fh1mv+gjPQNVEhcGRHWcNxUwtWV4hsJMLrAwdO47g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794963131;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=kln/hNnmMrnzVCApzGzQusWUmbr2uj6lH/eTkc+hpFU=;
	b=lj8Lg2JfFjXQmioedXbneUADbAK7RqDtfGuuM6g99PhsdRlizhH51lhpPCRVbvcXZLyr
	 /N3EmU2Y6ZuEsJ+jdIP1xnWo+CtSE9z3dP+sdpYiOApCP0Yu8wkBfQwSIaFrBKu7yc9Wb
	 5iuD6aOrXRNL/G8pXVNB6MG5+6O3TBYSp37ueIZv+D7uKR7WM9zXl5IUgW4Vb6B/+AhbF
	 a3r44q3zw3rlTIrXUqJtg+BipI+GvZqlxgYQC1O2zKCJrFNI01FAwIr+PVUTo27bk2KzW
	 lWrNqdIfSuBzxrL6OP7nytY05eeb7yzx+OFE+4Bij/K4N94ePdSXwUDhnn/I12vkTHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BJZzKIRL;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE752606A331
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 00:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE752606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BJZzKIRL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794963128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kln/hNnmMrnzVCApzGzQusWUmbr2uj6lH/eTkc+hpFU=;
	b=BJZzKIRL/v2GGD1oi9OsLvYPYA9l7BcM9G/3FhMrg+lkdRF4a5dibc0suORdKpyfwVtwd0
	kaGMZmir5/96GZuu7+ouGmKZvduQsiR7Cj/BTyvEpYdypvFeh4QZd1EUxRFqbuSeX8LQdk
	uwJobL2ZTygfCJuQS/EHpnZuULJZmB4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-iRjuXzO3Mt2m2J6ZMIplFg-1; Tue,
 17 Nov 2026 19:52:04 -0500
X-MC-Unique: iRjuXzO3Mt2m2J6ZMIplFg-1
X-Mimecast-MFC-AGG-ID: iRjuXzO3Mt2m2J6ZMIplFg_1794963122
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3839B195606C;
	Wed, 18 Nov 2026 00:52:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C57911800543;
	Wed, 18 Nov 2026 00:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AI0q0Ze3962128
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 19:52:00 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AI0pxLp3962106;
	Tue, 17 Nov 2026 19:51:59 -0500
Date: Tue, 17 Nov 2026 19:51:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dm thin: drop the grace period from thin_ctr()
Message-ID: <avz2r1E3cS08yPIS@redhat.com>
References: <20261116-bug-dm-thin-rcu-gp-v1-0-14ed3567da3e@linux.dev>
 <20261116-bug-dm-thin-rcu-gp-v1-1-14ed3567da3e@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261116-bug-dm-thin-rcu-gp-v1-1-14ed3567da3e@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: SaSdJIOegjMp__B8ffmQNJxE-NBEkXfGwdnBfA7rWxc_1794963122
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 16, 2026 at 12:12:03AM -0500, Qiliang Yuan wrote:
> thin_ctr() adds the new thin to pool->active_thins with
> list_add_tail_rcu() and then calls synchronize_rcu(), so that a
> wake_worker() call can't miss the bios of a thin that isn't visible yet.
> 
> The grace period doesn't make the entry any more visible. A worker that
> walks the list after list_add_tail_rcu() finds the thin, and the thin
> gets no bios before its table is resumed. A walk already in progress may
> miss it, but the wake_worker() for the first bio queues the worker
> again. Still, activating a thin device waits for a full grace period,
> which takes about half of the activation.
> 
> Remove the synchronize_rcu() call.
> 
> Activating 100 thin devices of an idle pool with dmsetup create takes
> per device (mean of five rounds, min-max of the rounds in parentheses):
> 
>   before (ms)        after (ms)       change
>   15.4 (14.9-15.9)   7.6 (7.3-7.8)      -51%
> 
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

