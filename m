Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A1248C3E8
	for <dm-devel@lists.linux.dev>; Fri,  2 Oct 2026 11:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790941717; cv=none; b=MPoklWWZ8oUlCRbeT8vQ8yyIY/InqXNSYEnK8j4OWShSspQfqL1kQn/ItBPzrxCbF07k8eJq/JNDX47Z3qlRKKd0EP7xGs0htvqyC/S/NJae1exSGRwR/fqfAVBsXEymQvzOxM/QTMSGRcjeY4dXbEKBTjoTHzC+0ezxACMDnKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790941717; c=relaxed/simple;
	bh=tzXbpGlSJGY1eG7pyJ3Hw4M0sXvdlNE59Ym/kPErX0Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QVNsh3eD1I9q1An7TNvmvDm1CxNFSfz7c/3Axt9R1fMEpvafkIDWGjc/FPHpwkogFTHCKUTfwCMmlCzTtJAATpyWbWZkMco7UgLRlvix1qC/sjuIXi8E4VcVrf75U7Og2D9+tjdnr4qC2IJH1PF2L18/ol6Yi1SOtasqf9bg8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EzrsfXcN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EzrsfXcN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790941714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqN5mrFTIgkZSeI2M8frnfxOaXKmJhzuyw4sP+cfndg=;
	b=EzrsfXcNOei6AL1SCPqRpOaDbcl8dvC5ksEu9qwrr2UO1Js0m1vMpodRCo7yEdOAmKr7Vz
	mOyB+A1BKdCRO0Mxbt1htCoPWBgDoMaNxjfCj4TOFs/P6lDVvtGcxtP1RvfUMWHsxRuWZ7
	5+EaFYqZHtvmcvGX9lmMDxcjnxdfHCE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-yxuRXQ1KN2ioW-91s1mDzQ-1; Fri,
 02 Oct 2026 07:48:32 -0400
X-MC-Unique: yxuRXQ1KN2ioW-91s1mDzQ-1
X-Mimecast-MFC-AGG-ID: yxuRXQ1KN2ioW-91s1mDzQ_1790941710
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B3531800576;
	Fri,  2 Oct 2026 11:48:30 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C25305BC;
	Fri,  2 Oct 2026 11:48:26 +0000 (UTC)
Date: Fri, 2 Oct 2026 13:48:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenz Kofler <lorenz@sigma-star.at>, Eric Biggers <ebiggers@google.com>
cc: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    upstream+dm@sigma-star.at, David Howells <dhowells@redhat.com>, 
    Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel
 keyring
In-Reply-To: <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at>
Message-ID: <1e53661e-42f4-72b2-3331-33af21e9fe0f@redhat.com>
References: <20260928062734.3805458-1-lorenz@sigma-star.at> <20260928062734.3805458-2-lorenz@sigma-star.at> <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com> <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: SwmpH-aXL2vp_JevhqnnWt__30lIsTBYaDY89tSF-vg_1790941710
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 2 Oct 2026, Lorenz Kofler wrote:

> Hi Mikulas,
> 
> thank you for the review!
> 
> Some notes below.
> 
> >> +#ifdef CONFIG_KEYS
> >> +
> >> +static bool contains_whitespace(const char *str)
> >> +{
> >> +	while (*str)
> >> +		if (isspace(*str++))
> >> +			return true;
> >> +	return false;
> >> +}
> >> +
> >> +static int set_key_user(struct alg_spec *a, struct key *key)
> >> +{
> >> +	const struct user_key_payload *ukp;
> >> +
> >> +	ukp = user_key_payload_locked(key);
> >> +	if (!ukp)
> >> +		return -EKEYREVOKED;
> >> +
> >> +	if (a->key_size != ukp->datalen)
> >> +		return -EINVAL;
> >> +
> >> +	memcpy(a->key, ukp->data, a->key_size);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int set_key_encrypted(struct alg_spec *a, struct key *key)
> >> +{
> >> +	const struct encrypted_key_payload *ekp;
> >> +
> >> +	ekp = key->payload.data[0];
> >> +	if (!ekp)
> >> +		return -EKEYREVOKED;
> >> +
> >> +	if (a->key_size != ekp->decrypted_datalen)
> >> +		return -EINVAL;
> >> +
> >> +	memcpy(a->key, ekp->decrypted_data, a->key_size);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int set_key_trusted(struct alg_spec *a, struct key *key)
> >> +{
> >> +	const struct trusted_key_payload *tkp;
> >> +
> >> +	tkp = key->payload.data[0];
> >> +	if (!tkp)
> >> +		return -EKEYREVOKED;
> >> +
> >> +	if (a->key_size != tkp->key_len)
> >> +		return -EINVAL;
> >> +
> >> +	memcpy(a->key, tkp->key, a->key_size);
> >> +
> >> +	return 0;
> >> +}
> > 
> > These four functions are copied from dm-crypt.c and dm-inlinecrypt.c.
> > Copying code is generally malpattern, they should be unified and moved to
> > an include file (that would be included in all three targets) or to the
> > key management code (that would be called from all three targets).
> > 
> 
> Yes that is the issue I described in the cover letters. But I don't
> actually know which way is the preferred one. Afaik there are now
> three options:
> 
> 1. static inline helpers in a drivers/md header, so dm-crypt and
>    dm-integrity each compile their own copy
> 2. a small library module, similar to dm-bufio, so there is one copy
>    that follows the value (y/m) of dm-crypt and dm-integrity
> 3. integration into key management code
> 
> Please tell me which option you prefer.

Try 3, if not possible then 1. I think that introducing a module with this 
would be overkill.

The "if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {" 
lines are duplicated as well, so I would refactor them and move them to 
the helper too.

I don't know why dm-inlinecrypt only uses the "logon:" key while dm-crypt 
uses "user:", "encrypted:", "trusted:" as well (Eric - could you 
explain?). So, perhaps, dm-inlinecrypt could be extended to use all four 
key types as well.

I CC'd keyrings maintainers - so, if they have some suggestions or 
objections regarding moving the code there, let them say.

Mikulas

