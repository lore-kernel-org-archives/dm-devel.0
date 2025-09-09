Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E232D63E5
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410979; cv=none; b=mfvQxoON9ED2nezvMxUrTjngcHz63bQWTfAl7O+vTtY39tEjKIElNB1gZFQtS9Nyk5zOOK4gYAgVU/INYrvNeEJtGsBeegyfRM9cTVp9/+0BMGQrKYe1AZ76+IxWljvAwH2hu+VQ8X+6uWWrlNa0RPeVlI7YZnDShXD9sVgfgiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410979; c=relaxed/simple;
	bh=AtUy6aIIot5lDF+wKFSl7rcei/z70NVEMFnA2kJkg0s=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iPqBcKoSltDfjyLB5gxPmGxDP/q4UMLYRb/TJfTKrVZO/Qn3mIC/EkanZzbYi7MbEq6IrEBIWxvRukKxKSWFnpi5DivvKfPlMORW5xk3B+WOflONSKPzogAdy8W5nG8/Tf7UtSYr2xuG6qUrCy7KPDY65mhaWFnrzZOv0kCkgQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ad05eV1i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ad05eV1i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757410977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8TXKMFE2iYY6l6MMvYjd6bP03MknA5YdLtc79Mf87gU=;
	b=Ad05eV1i+njSAHFPbFhFHjQLKH6fklRjUfXunIO0Qd91MYXq7vWYZcO1v4JcQH8sFAfD4s
	rLWVPcymfmmQLMg0ocnz/hqV0mZGPVBQ7syiAwtux8Ba6hs1eQwbl7VE8xDxqgUulaHa/U
	TXY8GohUSUHJ2xjvBu5SDZN8MQKLqMU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-cIEobM8sPEiPrgx-pI6J6w-1; Tue,
 09 Sep 2025 05:42:53 -0400
X-MC-Unique: cIEobM8sPEiPrgx-pI6J6w-1
X-Mimecast-MFC-AGG-ID: cIEobM8sPEiPrgx-pI6J6w_1757410971
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 634E219560BB;
	Tue,  9 Sep 2025 09:42:51 +0000 (UTC)
Received: from [10.44.32.12] (unknown [10.44.32.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B3A81956095;
	Tue,  9 Sep 2025 09:42:47 +0000 (UTC)
Date: Tue, 9 Sep 2025 11:42:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ingo Franzki <ifranzki@linux.ibm.com>
cc: Harald Freudenberger <freude@linux.ibm.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com, 
    snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
In-Reply-To: <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
Message-ID: <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
References: <20250908131642.385445532@debian4.vm> <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Tue, 9 Sep 2025, Ingo Franzki wrote:

> However, combined encryption and integrity seems to have problems. Not 
> sure if this is related to your changes in dm-integrity, or if there is 
> still something missing in dm-crypt, or the interface between the two:
>
> I did:
> 
> # cryptsetup luksFormat --type luks2 --master-key-file '<key-file>' 
> --key-size <size-of-encryption-key-in-bits> --cipher paes-xts-plain64 
> --pbkdf argon2i --pbkdf-memory 32 --pbkdf-force-iterations 4 --integrity 
> phmac-sha256 --integrity-key-size <size-of-integrity-key-in-bits> 
> /dev/loop0
>
> # cryptsetup luksOpen /dev/loop0 int-loop
> 
> The open step succeeds, but the following errors are shown in the journal:
> 
> Sep 09 04:54:50 fedora kernel: crypt_convert_block_aead: 12 callbacks suppressed
> Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
> Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
> Sep 09 04:54:50 fedora kernel: buffer_io_error: 3 callbacks suppressed
> Sep 09 04:54:50 fedora kernel: Buffer I/O error on dev dm-1, logical block 43872, async page read
> Sep 09 04:54:50 fedora 55-scsi-sg3_id.rules[2378]: WARNING: SCSI device dm-1 has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules

In this mode, the encryption, decryption and authentication is done by 
dm-crypt, not dm-integrity. dm-integrity just passes the tags around.

So, it looks like a dm-crypt bug.

Please, revert my patches and run the same test on a clean 6.17.0-rc5 just 
to verify that the patches do not introduce the bug.

Mikulas

