Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AD91E98FA
	for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 02:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742437350; cv=none; b=MHfB0UvmXl2sp01EEn2wHXyh1Qgr+rkIpyHoz4OkwgTag+tFM2ryAUtIZGYbaVDUEBsO/JXvvzz2ct5l24Bm72gH4b3JLcsrT1te9yYvkpQmgd4DmaenBk8oVh3zqnK2bCjzVfBYAMjtojIwFr4/y3ZDucsfKgOVsER6m1iboq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742437350; c=relaxed/simple;
	bh=svY3R/mQg+rdzMVDS5G88T9Iv3/0VSEcFG586RfYxXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGnLD7xjoLPZba7ricyMNgr5w/1senDm317Lo41V7ANEGUFmmXD6/cfyiiOsR7e+a0UxdTkAQIg2Sk0tbmwXDyNwY84WykIAKs+q5xJvSbsf+uiUP+TsU66Js+eRcHEABsDynmIfkciq6JFrf00P+Csy4OuESB0BPvEsw+7eXc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBvt4BFZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBvt4BFZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742437347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BhOHJHQ3iKvyBTuMABgfluShtMSX375oKQ9uFwU6pnw=;
	b=bBvt4BFZgFh7vzPbeU/vypGrKv4aY2RIHD/iwm03YcEmVPtF5Qt1/LOyvm57u9cg/ZaDVb
	6dQ6sCOOpOgnLKDqxm2TTbnr0mvZQBmyfeP8uJVJ6leowGwNGJR7g1sw63ctpwRl7+Y0qd
	daCtAYQAzHAgocv7bWy0kMlHCmlk5/0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-FLbfnP19P4G3iWv7DrU0zQ-1; Wed,
 19 Mar 2025 22:22:24 -0400
X-MC-Unique: FLbfnP19P4G3iWv7DrU0zQ-1
X-Mimecast-MFC-AGG-ID: FLbfnP19P4G3iWv7DrU0zQ_1742437343
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A214195609E;
	Thu, 20 Mar 2025 02:22:23 +0000 (UTC)
Received: from fedora (unknown [10.72.120.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA7163001D13;
	Thu, 20 Mar 2025 02:22:17 +0000 (UTC)
Date: Thu, 20 Mar 2025 10:22:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
Message-ID: <Z9t709DZs-Flq1qS@fedora>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
 <Z9mJmlhmZwnOlnqT@fedora>
 <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com>
 <Z9ocUCrvXQRJHFVY@fedora>
 <6ebdd2ae-8fc2-4072-b131-a7c0da56d3f2@kernel.dk>
 <d04fcd9f-b4a7-100a-e9a4-b0d4d45b372b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d04fcd9f-b4a7-100a-e9a4-b0d4d45b372b@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Mar 19, 2025 at 10:18:39PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 18 Mar 2025, Jens Axboe wrote:
> 
> > > Yeah, it looks fine, but I feel it is still fragile, and not sure it is one
> > > accepted solution.
> > 
> > Agree - it'd be much better to have the bio drivers provide the same
> > guarantees that we get on the request side, rather than play games with
> > this and pretend that concurrent update and usage is fine.
> > 
> > -- 
> > Jens Axboe
> 
> And what mechanism should they use to read the queue limits?
> * locking? (would degrade performance)
> * percpu-rwsem? (no overhead for readers, writers wait for the RCU 
>   synchronization)
> * RCU?
> * anything else?

1) queue usage counter is for covering fast IO code path

- in __submit_bio(), queue usage counter is grabbed when calling
  ->submit_bio()

- the only trouble should be from dm-crypt or thin-provision which offloads
bio submission to other context, so you can grab the usage counter by
percpu_ref_get(&q->q_usage_counter) until this bio submission or queue
limit consumption is done

2) slow path: dm_set_device_limits

which is done before DM disk is on, so it should be fine by holding limit lock.

3) changing queue limits from bio->end_io() or request completion handler

- this usage need fix



thanks,
Ming

