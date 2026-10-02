Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4404B361DD0
	for <dm-devel@lists.linux.dev>; Fri,  2 Oct 2026 21:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975380; cv=none; b=dmh/nxM5xIAoWJ0yzQq2xJGoy6EBtqRQWW2GWtoPtUpUnEDJw0UjVt/AUXFTghF6/FsxArng80CZFizhe9ikbgtol6Aacy/UY5gz9vRsbjHp4Vz/H/rbZo3zLNne4/ovhQkTaz/+rfhSVfRXL4GJhXo9VUpmOsvKdTYJ4nnZy68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975380; c=relaxed/simple;
	bh=MpIoTBBXxdNSspdULR8GCp9JszZpUItsvrZUtwxm1XQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=O6JIEdm5aKGdpfbE9aQO7TSL3ICzi3WRYBLBOe+135AucXwlcEkTV5j7JHgVf2GLvdGwW76gQFDQMdoBuWkrW2460BfKlATswLgAUGePONt5KiJvKWzmtudzYB5zOxSRd4DE2WObBuZzZhImYomdjF5jGr6tnJXHB2UGCz99DEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NfiZXk52; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NfiZXk52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790975378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9PDlFKZuG83RD1GvxW6bUR6/hm5hUc293+hbuEuqEAg=;
	b=NfiZXk524A3DIX+4Eqmbi5OMVkHaefoY/Bsq5yL5n4EBhtxusJGGbg1AJ2fEDhOry5zPG7
	Ev5YofesLsVduCVrAs6Hq+5+iVV3c51VZfHS49XoopL4nUzN+wiVM8rZuqOGCqGWfmzT39
	3o3ed98Oot9/kf0cZ1TUNa0p7hyxDDE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-yM_L3XyLPUK4YPNaccZQgw-1; Fri,
 02 Oct 2026 17:09:34 -0400
X-MC-Unique: yM_L3XyLPUK4YPNaccZQgw-1
X-Mimecast-MFC-AGG-ID: yM_L3XyLPUK4YPNaccZQgw_1790975373
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD83B1977528;
	Fri,  2 Oct 2026 21:09:32 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47B4F41D;
	Fri,  2 Oct 2026 21:09:29 +0000 (UTC)
Date: Fri, 2 Oct 2026 23:09:26 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: Lorenz Kofler <lorenz@sigma-star.at>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    upstream+dm@sigma-star.at, David Howells <dhowells@redhat.com>, 
    Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel
 keyring
In-Reply-To: <20261002201419.GA205250@google.com>
Message-ID: <bf54a398-a6b0-a188-85a5-5c3f3fc139fc@redhat.com>
References: <20260928062734.3805458-1-lorenz@sigma-star.at> <20260928062734.3805458-2-lorenz@sigma-star.at> <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com> <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at> <1e53661e-42f4-72b2-3331-33af21e9fe0f@redhat.com>
 <20261002201419.GA205250@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 17gZ6iIb8MKpPH8Dy1a542cMKl31fVhxPQG71EYjwmQ_1790975373
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 2 Oct 2026, Eric Biggers wrote:

> >From what I understand, the point of the keyring support in
> dm-{crypt,inlinecrypt,integrity} is:
> 
> - To support "trusted" keys.  But that is not what was actually
>   implemented in dm-inlinecrypt.
> 
> - To avoid having the key be readable with STATUSTYPE_TABLE.  But that
>   is not what was actually implemented in dm-inlinecrypt.  Keyrings are
>   also unnecesary to solve that problem.
> 
> - To cause security bugs such as https://lwn.net/Articles/1090568/ .
>   Since otherwise things aren't exciting enough, I guess.
> 
> Not sure what I'm missing.
> 
> But if you really do want to support all four key types in all three of
> these targets anyway though, then sure, the code might as well be
> shared since it would otherwise be the same code in each.
> 
> - Eric

Yes, I think that the key support in these targets should be unified.

Mikulas

