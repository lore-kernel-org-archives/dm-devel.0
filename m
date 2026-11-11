Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794421174;
	b=yC4lQdKyUJt45QlIV0O3sKLXl8oxfC3P1PTBcRbf6HYJxWR4N3QrwW1bcg4I4AXrRTij
	 P+3C52jw4FhqG5F+/e6VLuJwRd8o5dVHlDBY1r+c4Y7PrTgDD+xpG1Kzk3OTttzojV0dE
	 MpmALsrn1Uw+bz85haPNvt4/ae2CKLjpG5Stjfz7yYX6oUnf34d9SdA5RLLelqnbavuyT
	 BLNhnY7UDz32itB9q1o3MW7gBTd84zeQmLNP/QHUBxMcGyKeQZp4XY3jIDD1XDr/AUVK7
	 aaPrnFLQ1KWZQvABo58clNwtDe4RAbc26dhuYvBGijom8EqvV/zR2aCiZzrZxrk9tUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421174;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=zl1dTUx/s3eQdZ2BQcrKSS3OAEwI932sxvXKDeKD+90=;
	b=o326hel/DaibXL5i7blXzR5LttEfTxZdU9Mpn7xsKI3SGkNszn6aLGykoc0J16ZOedmG
	 oR8jJRAuWaqbJGlLOjiKuPJf/6bpulD11JS9S1QtFLKdxnu/J1TcoE2WslGlvK0qoRmG9
	 OTQfFZB80zYV2ZKcH2R3CN1WHlrS2cBiyWyhdO3htMCj0HFwTgKkfeD0g3UnKI5zxeAiA
	 u3jxYZVEq0rYF8AV7j9zDxKUmg65B0i9RdHAtPrbiCgkSXqNjshM49X3gNaTYHxKLBjbw
	 yPZIfod31epSSftHMRFc2PlAw+nzQFh1vdOmdNrOtgXFk7xJYl5fZ/zxVO5pYHLHa5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UoTcksHA;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E1A606A31C
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 18:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1E1A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UoTcksHA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794421172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zl1dTUx/s3eQdZ2BQcrKSS3OAEwI932sxvXKDeKD+90=;
	b=UoTcksHAGU82Vmn8fyCOJvxIUj/8wPhpg7ljiD5lhz8chLrFTsY62LtRc7IMr63Afok9RW
	sbQXgAv3cYKlir0Rm9FPB5f8/25RgcmBTCoRfGuD0sCrzTOF1zMkDuGok+A/SJycIVUqqw
	+noG0lZAhHNCOoTacmkI5GRDgD1fGRY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-WupDvi07P3uWAAqYho_Skg-1; Wed, 11 Nov 2026 13:19:30 -0500
X-MC-Unique: WupDvi07P3uWAAqYho_Skg-1
X-Mimecast-MFC-AGG-ID: WupDvi07P3uWAAqYho_Skg_1794421169
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3adef2bf843so471731fa.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 10:19:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421169; x=1795025969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zl1dTUx/s3eQdZ2BQcrKSS3OAEwI932sxvXKDeKD+90=;
        b=GeWuJ5+BhzSek7vpcU3tNxIUMtV8Zo7VC4TCQaaKHKpeO1JrrCOfBG1rbefXXg6mYq
         XDrWsMDycde/IgxbVyu7adJeOGmrQjE6TwKQfHM+jSpPR52NsNJL+dOpsz5lba+dz2rm
         bo4PGRhM4ZsFLonNXoU3IgwlwiTcslCdndyFoL0FzYGuQwY3osvtLF9rRiIMlyGLXXA4
         P63ACh7m1gte9OAIxIoYcilEpfefPtvcr2KodFEK/rfvtJ/3xskh17j2H6hinZRhtWXD
         pLxv2qLMmRHs1QvB+D57pZJsDxyZQJDxAj8XTArCQgJ9BSadNBPftNSFpzpxpEGZPZhw
         sVSA==
X-Forwarded-Encrypted: i=1; AL+hErFhOyh6obaE+ylSBnPopw7OouJQb6bq+MJD9C8TzvUCeleOKOgmjYLPTuINGOW5zrjuBByTuiycDg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9H4OtGcHSKJZCm+wYlMgyT36jczCNyJmXxyFbAKK0+HJTr+0G1
	cz/jtRqqWRrfgyIUj/Qihlw2leOG+u1UPhLsaeCNrDsQa7FfeEPdfr3vJb3pVekFbX6Q7Z9MUw2
	4HELPXEhlT/N5e+HSayd5IvXXfwkkwm/X0A6ySV99Qqyt85rPsL54kKXNYc8E4naBwu0uD/QVYe
	inZOCwvJSUCGttfIEKWbDP1BW33U4y88yEBw==
X-Gm-Gg: AYBFou2DEUUUsBsY9gwiEZ9WpbP385ecRpJDo32pbhN8ZXtLydpWcoTPwEAzghKxX8y
	FV8/3KbfXLlfSQh2nGMSQs9Xm45qG56tD4hPmqN5ncazh2Wves7En3wOiXGku0ga2GZtRjBGiVw
	PyBGikWzm8hoHzyRjSe+LLfsSSfIvE4P1ciefrfdYeK50J8L+OEVtZIDTNRTca6Ml3rQB5U7dwt
	Jg6S+0fMkM/1FF5Wg==
X-Received: by 2002:a2e:a80f:0:b0:3a9:7c85:a16d with SMTP id 38308e7fff4ca-3ae1bfb8026mr500871fa.5.1794421168603;
        Wed, 11 Nov 2026 10:19:28 -0800 (PST)
X-Received: by 2002:a2e:a80f:0:b0:3a9:7c85:a16d with SMTP id
 38308e7fff4ca-3ae1bfb8026mr500791fa.5.1794421168194; Wed, 11 Nov 2026
 10:19:28 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <05b79ec2-42f7-ffe3-20e6-1dc499e60cf5@redhat.com>
In-Reply-To: <05b79ec2-42f7-ffe3-20e6-1dc499e60cf5@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 12 Nov 2026 02:19:16 +0800
X-Gm-Features: AclHuK_9y6V1vZ4yV-XQJ4SHi7Jt1HE1WIRwHtu8AOg6cHOLgEkYvd78qv1rVzs
Message-ID: <CALjSBEtYAUZY=vtYW_TW5EH2FE00HS5ofsi4dNfAWRKuPzfOvg@mail.gmail.com>
Subject: Re: [PATCH] dm-cache: fix NULL pointer dereference on open failure
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 81Tx-jkNGOFluz01OFszPiwfWWCpR1Olw9G1tls8Zls_1794421169
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 2:55=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> When __begin_transaction_flags in metadata_open fails,
> dm_cache_metadata_close is called. dm_cache_metadata_close attempts to
> execute list_del(&cmd->list);, but the "cmd" object is not on any list
> yet, thus it crashes with NULL pointer dereference.
>
> Fix this by initializing cmd->list after cmd is allocated.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
> Cc: stable@vger.kernel.org
> Fixes: c6b4fcbad044 ("dm: add cache target")
>
> ---
>  drivers/md/dm-cache-metadata.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: linux-2.6/drivers/md/dm-cache-metadata.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-cache-metadata.c
> +++ linux-2.6/drivers/md/dm-cache-metadata.c
> @@ -766,6 +766,7 @@ static struct dm_cache_metadata *metadat
>                 return ERR_PTR(-ENOMEM);
>         }
>
> +       INIT_LIST_HEAD(&cmd->list);
>         cmd->version =3D metadata_version;
>         refcount_set(&cmd->ref_count, 1);
>         init_rwsem(&cmd->root_lock);
>
>

This bug triggers when dm-cache fails to update the superblock flags
while opening the metadata. A dm-flakey target can simulate the write
failure:

1. Create a fresh dm-cache device.
2. Remove the cache target.
3. Replace the metadata device with a dm-flakey target that drops writes.
4. Reopen the cache device.

Kernel logs:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000001: 0000 [#1]I
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 93 Comm: dmsetup Not tainted 6.19.0-rc7 #100
PREEMPT(voluntary)
RIP: 0010:dm_cache_metadata_close+0xaf/0x260
Call Trace:
 dm_cache_metadata_open+0xfb2/0x14e0
 ? __pfx_dm_cache_metadata_open+0x10/0x10
 ? smq_create+0x1d/0x30
 ? dm_cache_policy_create+0x108/0x2c0
 cache_ctr+0x1505/0x3710
 ...

This bug happens only from the dm_cache_metadata_close() call inside
metadata_open(). The other two callers get a linked cmd->list, so they
are safe. A different data_block_size alone cannot trigger the bug
either. __open_metadata() checks it before all persistent data objects
exist, so metadata_open() frees cmd with kfree() instead of
dm_cache_metadata_close().

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

