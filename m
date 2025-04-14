Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92631D7E54
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 20:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744661364; cv=none; b=em5rHOMQF87pKp+GNoFI6rW2J8RyD34p4j7Q6B1k2OnRUHUSrHP+csrRaX2KYDjykd9MB4PQCvD1hkqdji3M/otv1F6+FlTwaKVke2KWFH8cMK6IirhA8uS4v0cH31KKNnBwB6vgtva+e2JrIg4fL4asKfe+LVDTV78jRSbdOpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744661364; c=relaxed/simple;
	bh=SHmt7N2Uqvyez10gxysfn+TSZ7jAkSMotkeh2MFOTUQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=X7oktI+K4dRasN0GI88oElRQo9fNHPBLkSG4VE57OASqYUGJe/DDjlCeM0vCoA6055l8WcEPYb8+2hwClp6E/NIMXWYIZGrOAWG1eRJUd8AVKgIGLYo+RsYpE0K5R5L2zbPbbxDTEnEFOVO6LiJ7M7LC4a8tT9viaA8S9VKCRnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G7myL+em; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G7myL+em"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744661361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I29XMXD3H9SJVUhzlhifG6/sMKjoPFSk9mg5ZjTy0l0=;
	b=G7myL+emLGQzfm2J2N2uADPNNNUYihSkRFQvPypCOS2hwNbeAzSNlvrgjb3Fa1EalqPyGp
	gkTxVpLpTJ0J1D4WY4y9EOEO2FGbWivJzbVFPhiV58cqGoY7QBpTSgvV2O+5E350RU4GU6
	14LFF1OyFPaBRMMYjkys1o8sYDZQq3U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-2m5UlWwgPb26rMbylRsT1g-1; Mon,
 14 Apr 2025 16:09:18 -0400
X-MC-Unique: 2m5UlWwgPb26rMbylRsT1g-1
X-Mimecast-MFC-AGG-ID: 2m5UlWwgPb26rMbylRsT1g_1744661357
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32AFF1800263;
	Mon, 14 Apr 2025 20:09:17 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29CEC19560AD;
	Mon, 14 Apr 2025 20:09:14 +0000 (UTC)
Date: Mon, 14 Apr 2025 22:09:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Damien Le Moal <dlemoal@kernel.org>, 
    Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH] dm-delay: don't busy-wait in kthread
In-Reply-To: <Z_09e7Zddckboca9@redhat.com>
Message-ID: <af034f2a-8b47-cbe2-cfbc-d30eeea6dad4@redhat.com>
References: <20250411205656.60709-1-bmarzins@redhat.com> <459f3125-843a-0067-dc37-b04d5b67b556@redhat.com> <Z_09e7Zddckboca9@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EFU8fDMCi2JIjO-dPXAGfsuDuuYUo9Z7YT0iJh_O7fA_1744661357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 14 Apr 2025, Benjamin Marzinski wrote:

> > cond_resched() shouldn't be removed because fsleep may fall back to 
> > udelay.
> 
> Again, your version is fine, but I'm not sure that cond_resched() was
> ever necessary, since there already is one in flush_delayed_bios().
> Also, at least the way it's currently coded, fsleep() will only resort
> to busy-waiting when the delay is 10 us or less, and the shortest it can
> be with this code is 62 us, so I don't think this cond_resched() will
> ever do anything.

Yes, but this is implementation detail that may change. Someone may change 
fsleep to spin for larger timeout without knowing that dm-delay depends on 
fsleep not spinning.

> > The patch should increase target version.
> > 
> > I fixed the patch so that it applies on the top Linus' tree and applied 
> > it to the linux-dm tree.
> > 
> > BTW. do we need to backport this to the stable kernels? I think not, but 
> > if you have some reason why should we backport it, explain it.
> 
> dm-delay is basically a testing target, so I agree that it seems
> unnecessary to backport this.
> 
> -Ben

OK, so I removed the "Fixes:" tag.

Mikulas

