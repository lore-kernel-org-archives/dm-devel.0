Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F86F37883D
	for <dm-devel@lists.linux.dev>; Mon,  4 May 2026 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777910490; cv=none; b=mBs9pv2qNCXU862iKW2/ShTXdo8OdJ+alO/hionwGucnflUs2wX2jv5fecL34uFhp7nLYYJdnjjNolNUuTOW9dqB+v35CWzjJIZDpuXcLXVAzd1D3hzpTnInxgW9cWhxpIVwRp7SAg8RL7EVjtVXpDQbHxmVqH9ng+L1qPQur54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777910490; c=relaxed/simple;
	bh=+X+y9wbpUcIrBvSyOeDaVGT6aHYC5sle01D8edrdCig=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Die21x+R5yVHdxIpkc9VvcvENImA85JlrusEwV35+BzzP7J+YbmGYK5dkSQfteKYwsDMw1ONt5i2rotL/s53/bZrtsoZY4JtlzFNlx6CpO4yOU58WaE10EWm+sAFxoJrBv4SnEVwvPCtBQFGmTS+lxny07FyOoMfxy9fcbOoNe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PicPp29H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PicPp29H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777910488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FlHARMSsla0/wO0Mq8NPxoV9HdZjmV2AhxtCUXz4y3Y=;
	b=PicPp29HjEy+b0fU6Nqriuui3Yva4gMVBHBL0Dm9gSJJrOAYgCbMt7KgrD7v1Fs9bqePii
	6zthqFl0aBNGAOIGKvSrSMdrFxBQL4unlgfESgU94uktrEWI1SVG9wGGeA+t4WwQilYK86
	/fKGHht9d3kQxHKjxe7J4b4WcQVvJ2w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-27ADK7zJPoi7fA1qVvaRhQ-1; Mon,
 04 May 2026 12:01:25 -0400
X-MC-Unique: 27ADK7zJPoi7fA1qVvaRhQ-1
X-Mimecast-MFC-AGG-ID: 27ADK7zJPoi7fA1qVvaRhQ_1777910484
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDEF21800282;
	Mon,  4 May 2026 16:01:24 +0000 (UTC)
Received: from [10.44.34.35] (unknown [10.44.34.35])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0EAD1801546;
	Mon,  4 May 2026 16:01:23 +0000 (UTC)
Date: Mon, 4 May 2026 18:01:21 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Sakai <msakai@redhat.com>
cc: "..." <439291857@qq.com>, dm-devel <dm-devel@lists.linux.dev>
Subject: Re: dm vdo: add optional Intel IAA-backed compression support
In-Reply-To: <b3033f45-ec82-4c01-9234-5616bd9877b1@redhat.com>
Message-ID: <1f86bcf5-eb34-6df6-e69a-7be0ff9240cd@redhat.com>
References: <tencent_C10B5DDE03BCA1510BF6D23F384A4C120308@qq.com> <a986902e-014c-2df6-4e0d-de99a62f90f2@redhat.com> <b3033f45-ec82-4c01-9234-5616bd9877b1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ujNxJEJzzpMsauEtpQVtj1N6KimnME1vgPFEJRQptvc_1777910484
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 29 Apr 2026, Matthew Sakai wrote:

> 
> 
> On 4/29/26 11:24 AM, Mikulas Patocka wrote:
> > Hi
> > 
> > I think the best way how to support it would be to modify the VDO target
> > to use the asynchronous compression API (so that it could use arbitrary
> > algorithms). Then, the support for IAA could be plugged in easily with
> > little or no extra code.
> 
> I agree that this is the right approach, but supporting arbitrary compression
> algorithms will require some significant changes on its own. dm-vdo currently
> has nowhere to store information about what algorithm is used for which
> blocks, so it would require reworking the metadata. (We would probably store

You can store the algorithm in the superblock and use it for all blocks on 
the device. This would be not as flexible as per-block algorithm 
specification, but it should be relatively easy to implement - and it 
would allow you to evaluate whether different algorithms improve 
performance or compression ratio.

> the extra compression information in the compression block header.) This
> metadata rework in turn will require some effort to make sure we can continue
> to support existing users who will want to continue to use dm-vdo volumes in
> the current format.

Mikulas

