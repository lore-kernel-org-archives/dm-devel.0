Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD2A497B9B
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993753; cv=none; b=LBpIVRUadL9+20McjTTZMKMte/ea9eydpBa9JGaxf9A/TndZAm7TeR25uwNwc84f5Tm2IAC29g85whK0wbVJSoB0DJOZ9s0K/FK2virbKY/PY5iOWrDphkQfiGH/aMIYhEl9PTrHpGaE92+utn1daulrXHX1/hP1w7CxVRTv21E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993753; c=relaxed/simple;
	bh=20YS5SjF37OLCH0EVjFT8uhc7Zcs/edGBImx9Bu7g+k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BggYBQrJEPwOXU72za3u7Gv7WnJdJNptSkJ1ZU4a6VcVtlffXEIPUir7ryGP3H5Iopk9I1TVUYma+kTbCofqf+ncdygD+y1q177Bihc21STdNNLNu1lbYmzumhXhAaRB9eohLdj5oe0xxa2b+WutenRkqFyDO9wq/5j3AkpPaeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+w1UaX5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+w1UaX5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789993745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3AlbNP8gZQwO885HERqSXE9KP83n74I0uRtyX51JKkQ=;
	b=J+w1UaX5GA5lcKzVC2G7Mdk7oT/ap70eOH0DlJj73Q6jl/R9KwWO96W04fxHEqclwj4Hqx
	IryJbhzD6iogOFvDUyY8E0RVsT0dKybNfj3T7CT9ivhdg+oPnqtp216fgQDdn2OHEghyjl
	afXn3lzK1E1J96vg9mrbDLkgAL9x+Q0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-enNsVpqPPwO8lF7xI10yJA-1; Mon,
 21 Sep 2026 08:29:01 -0400
X-MC-Unique: enNsVpqPPwO8lF7xI10yJA-1
X-Mimecast-MFC-AGG-ID: enNsVpqPPwO8lF7xI10yJA_1789993740
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA63F180AD66;
	Mon, 21 Sep 2026 12:28:59 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EEA219539A1;
	Mon, 21 Sep 2026 12:28:57 +0000 (UTC)
Date: Mon, 21 Sep 2026 14:28:55 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ben Cressey <ben@cressey.dev>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-crypt: reject the lmk IV mode with AEAD ciphers
In-Reply-To: <20260915-dm-crypt-lmk-aead-v1-1-7ecae0b33493@cressey.dev>
Message-ID: <fb4cf0d1-98a6-d850-7731-e4d518c6f767@redhat.com>
References: <20260915-dm-crypt-lmk-aead-v1-1-7ecae0b33493@cressey.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: VuBzjWogjZVdM72AT9QIGkYsMW12jvzeJ24AG4YBrHA_1789993740
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Accepted, thanks.

Mikulas


On Tue, 15 Sep 2026, Ben Cressey wrote:

> A "capi:" table line that pairs an AEAD cipher with the lmk IV mode,
> for example "capi:gcm(aes)-lmk" with the integrity:28:aead option,
> causes an oops when it is loaded. lmk sets tfms_count to 64, but
> crypt_alloc_tfms_aead only allocates one transform, so crypt_setkey
> reads past the end of the tfms_aead array and calls crypto_aead_setkey
> on the values it finds there.
> 
> lmk exists for compatibility with Loop-AES, which uses CBC, so refuse
> it with an AEAD cipher rather than allocate 64 AEAD transforms. The
> check cannot go in crypt_iv_lmk_ctr with the other lmk checks, because
> the IV constructor runs after crypt_set_key.
> 
> Fixes: 33d2f09fcb35 ("dm crypt: introduce new format of cipher with "capi:" prefix")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ben Cressey <ben@cressey.dev>
> Assisted-by: LLM
> ---
> To reproduce, with slub_debug=P: dmsetup create x --table "0 <n> crypt
> capi:gcm(aes)-lmk <32-byte key> 0 /dev/ram0 0 1 integrity:28:aead".
> No integrity profile is needed on the underlying device; crypt_setkey
> runs before dm-crypt checks for one.
> ---
>  drivers/md/dm-crypt.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 9e170de50ad32..0bd22bda3e2de 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2894,8 +2894,13 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
>  		}
>  	}
>  
> -	if (*ivmode && !strcmp(*ivmode, "lmk"))
> +	if (*ivmode && !strcmp(*ivmode, "lmk")) {
> +		if (crypt_integrity_aead(cc)) {
> +			ti->error = "AEAD transforms not supported for LMK";
> +			return -EINVAL;
> +		}
>  		cc->tfms_count = 64;
> +	}
>  
>  	if (*ivmode && !strcmp(*ivmode, "essiv")) {
>  		if (!*ivopts) {
> 
> ---
> base-commit: df2908090cda368b01ff43709f51890076c56157
> change-id: 20260915-dm-crypt-lmk-aead-2e36abe57e55
> 

