Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559B27441
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 20:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713557766; cv=none; b=BjKDViNMvkJer0Wwi1+aMO93jEjc0oCOTL+ceuSXI8S2jVld4tywTFu0K9Dl6C0ssKvSosx3tjHQprciojH5+N+Yyzaqj5KvIypBjs8GxtEWNejak75+wRrDlmoRqA4NYreYwwMT8le5bN+DxYaOMqtsm3jCFXAEzyRKE9x9BZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713557766; c=relaxed/simple;
	bh=41DL4PaY7gGVH3AjEJmYnythNANuIf2ui8XDE+zCOdg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jBiA9zAikpobJHXDw6mtPmmUWA6nBnpAR/SC61qrBL4yZIPJzoT5i1UpSLadR4u/E1i+vUHjwAAd9MK94xk7gsowk714pl8Lh5aAf+AcKmJe9OjJgmtmfCSiYK4rGjx4yEwR2bQr5QAcU3rMzE1FKjedCTigpUpp3J9xLWuZwuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gZMM5Fi2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gZMM5Fi2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713557762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YL2qhvglRGJm6Ao+SzatfCOugzNFNUVpstyj623/HRw=;
	b=gZMM5Fi2giZCaM51ysQuYClu1xyzGbTvh6dDFio42yGvNZm66Pr4Hsa9k9zE5uiYqq7Got
	gVVt/3SmBYNrKjMryGK9rjoCc7idpegEfy8lFkCJZoHN46JMTRveUQjQ3TijcD+LkpJ1hm
	rMoeuSBHcC27xAEPbJd2/XL2XcwMf1A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-JCPEKxIMNLG1RNgl1dVX3g-1; Fri, 19 Apr 2024 16:16:01 -0400
X-MC-Unique: JCPEKxIMNLG1RNgl1dVX3g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B21631044572;
	Fri, 19 Apr 2024 20:16:00 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D4BB40BAA0;
	Fri, 19 Apr 2024 20:16:00 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id F067630C2BF6; Fri, 19 Apr 2024 20:15:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id EBE913FB54;
	Fri, 19 Apr 2024 22:15:59 +0200 (CEST)
Date: Fri, 19 Apr 2024 22:15:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zack Weinberg <zack@owlfolio.org>
cc: Alexander Monakov <amonakov@ispras.ru>, Paul Eggert <eggert@cs.ucla.edu>, 
    "H . J . Lu" <hjl.tools@gmail.com>, 
    GNU libc development <libc-alpha@sourceware.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
Message-ID: <4f9517c-46e-367c-8891-e452d7983b67@redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com> <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com> <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com> <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com> <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu> <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com> <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
 <a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 19 Apr 2024, Zack Weinberg wrote:

> Yes, but the compiler does not know that bzero/explicit_bzero/memset only write
> and do not read, which means if you have something like
> 
> void aes256_encrypt_in_place(const uint8_t *key, const uint8_t *iv,
>                              uint8_t *data, size_t len)
> {
>     __m128 round_keys[AES256_N_ROUND_KEYS];
>     aes256_expand_key(key, round_keys);
>     aes256_do_cbc(round_keys, iv, data, len);
>     explicit_bzero(round_keys, sizeof round_keys);
> }
> 
> and aes256_expand_key and aes256_do_cbc get inlined, the compiler might
> be able to keep the entire key schedule in the vector registers *until*
> the call to explicit_bzero.  But right before calling explicit_bzero,
> it will have to copy the round_keys array onto the stack!  And the copy
> of round_keys in the vector registers *won't* get erased -- the exact
> problem being discussed in this thread.

On the SYSV ABI, all the vector registers are volatile, so you can erase 
them in explicit_bzero.

On Windows 64-bit ABI, it is more problematic, because some of the vector 
registers must be preserved.

Mikulas

