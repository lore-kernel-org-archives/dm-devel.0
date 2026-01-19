Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932BF378D9C
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768833922; cv=none; b=P8lsWhAaGyw6DgcNlzmn/Zwpxi+4sSiujKzOd8oM3uj0ZwuXFo5pIiTxYY3T7jKjyZRRbbymlMZr4v0GTqOl37doCI1M2Uq214egGh4TRwLE5YPJLW6AP2qcMIxHoPrgSJ2kLy+c3a2X628jqSL9ne4wy3MyfNEmu/zqGIEAcAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768833922; c=relaxed/simple;
	bh=SKKGJwFpnzXCxKT4pq0OjMBmNk1TL3yKZyuVdWRnIGY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=R5MWMvd7jZYmGyTt2l59D1HyTPpKPyyMyHtqGR9U8XakxiDAZ5Rwu0p86DEF5dubv1MB7eTMMp5bk/dPdkg+Sve7AgprIM0A0s6k5OkT8GYMJTYbjV7c2tvEHCiXEqV8Z/CjGwziHVXBSiC+Tnrp3maf4Ftz8Weso/iLLzRjqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClzADvPv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClzADvPv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768833920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IsMCDzu8KvyiEURpp5FZlqfHbkCEMFecTJRfxhuqLYQ=;
	b=ClzADvPvVmkSJRAFw+t0mQ2vzbW5+rNmYnf+LFhXTYFfICR8oc0gelH2WsVKIlsOGh7+lf
	lNPOqT/CPTZf3kyFRcZebR3z1xUbnfFyo7rw+LN4BUKqoMyLv7Q2sHYyhpdiiFhaUX2pZf
	UJlFNrfwosoqR6njuJtvY1Kf207JVxI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-bdfEXHt7NWKXC7lZAj4SGQ-1; Mon,
 19 Jan 2026 09:45:16 -0500
X-MC-Unique: bdfEXHt7NWKXC7lZAj4SGQ-1
X-Mimecast-MFC-AGG-ID: bdfEXHt7NWKXC7lZAj4SGQ_1768833915
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 630851954204;
	Mon, 19 Jan 2026 14:45:15 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68C3B30001A2;
	Mon, 19 Jan 2026 14:45:13 +0000 (UTC)
Date: Mon, 19 Jan 2026 15:45:10 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Sami Tolvanen <samitolvanen@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Optimize dm-bufio cache lookups
In-Reply-To: <20260111213821.94895-1-ebiggers@kernel.org>
Message-ID: <eb29251b-a057-caf9-6396-d2b587a4205e@redhat.com>
References: <20260111213821.94895-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

OK.

Patches accepted.

Mikulas


On Sun, 11 Jan 2026, Eric Biggers wrote:

> This series updates dm-bufio to avoid redundant work when looking up
> buffers in its cache.
> 
> Eric Biggers (2):
>   dm-bufio: merge cache_put() into cache_put_and_wake()
>   dm-bufio: avoid redundant buffer_tree lookups
> 
>  drivers/md/dm-bufio.c | 170 ++++++++++++++++++++++++------------------
>  1 file changed, 97 insertions(+), 73 deletions(-)
> 
> 
> base-commit: 8fbb8fe75d4cf92eaa7b21828ec39c1bf79a262f
> -- 
> 2.52.0
> 

