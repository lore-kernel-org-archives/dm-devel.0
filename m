Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CED56B7B
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 12:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQjg6Q2Q"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1cf5901b4c8so46220975ad.1
        for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 04:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701175268; x=1701780068; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2gvT/eemWfZnbuwVirPp8cMGK9ZIdrawZbRWTeF6Ry4=;
        b=CQjg6Q2Qgk/Y6lGK9VzTQwJ3RPM6uJ8AZjm/yobKB3Yn9aUEXe0C1+TyaWV8ewerGU
         efFJzP/lmbci6V3MHpf1L9ObGwkIot1N5pwBDRO2MmlGvfHpyUYxJusKmhonl6gwLJfo
         XcFNImeOWpmHcrCzkJe60JjlPPSNJ+GePZegKmM6Hx6lI+xcwfy8oajhoj+mXV2mCs4f
         6Iw4+fs/xYTBTLQQDIcEEXHRIkilNOCLUwdFd9Jhoh38JflhBrsk/hC6MYoPZRVc9Ha9
         5I1J2/7lYN5KkgtVH0GAFoPpTlpqze1koj9fn1jYq80U3iZO95WGcF+t9o57LSbnhpoa
         wDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701175268; x=1701780068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gvT/eemWfZnbuwVirPp8cMGK9ZIdrawZbRWTeF6Ry4=;
        b=eep8ipNpTjOuuQxq3S0XL+a99WuvXatcWdjUx3b7bktlbvHCvDtWhXzeGQyKlboSz4
         4HQHaSRDPj2Jii6C4lqlMfJ1feWlWQvNBAzuy/kCDCpLMnVDEPmLSmhAzzg+h3JXnCBp
         OSjPl+k2GnlzInw+UX/50YvjlFmbZx5QmoIY+n2Wi2KlP0sOcWr18N2Uylnymo37HjMm
         +iK4b+XG7HC8ZuWOiUdJNGXl4lUj/Bivf1vpmh57fs/EAv+Q1AhjzTUB9y9sT3r1Kf9+
         KCLBvSYFY/sDS0pZITg39h1rvm2VUbEqf6MZkbin9Esc2K2lK9M5q68pOe/rn0yk11ig
         ExkA==
X-Gm-Message-State: AOJu0YxufD2Pr1+kiDxZBDIHm9sr+1OgtW4i8JmvXFkNsOUqZrxyOVGX
	IPWsZeF0FcCCOlrVlbjWxwI=
X-Google-Smtp-Source: AGHT+IGyPQepTZKf/8QpPbbXEfU73fNPpR57oJdfkl5//aM7PggI11U1u2zrwxI8KxaDY+iBgyUH4g==
X-Received: by 2002:a17:902:d904:b0:1cf:a2aa:23ae with SMTP id c4-20020a170902d90400b001cfa2aa23aemr13508818plz.35.1701175267509;
        Tue, 28 Nov 2023 04:41:07 -0800 (PST)
Received: from [192.168.50.127] (awork111197.netvigator.com. [203.198.94.197])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090332c700b001cf68d103easm7212151plr.46.2023.11.28.04.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 04:41:07 -0800 (PST)
Message-ID: <74e0f310-fdf7-4a4b-bfcb-4d63c0cdfae4@gmail.com>
Date: Tue, 28 Nov 2023 20:40:39 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] dm verity: don't verity if readahead failed
To: Wu Bo <bo.wu@vivo.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
References: <cover.1700623691.git.bo.wu@vivo.com>
 <b23a4fc8baba99010c16059a236d2f72087199a1.1700623691.git.bo.wu@vivo.com>
Content-Language: en-US
From: Wu Bo <wubo.oduw@gmail.com>
In-Reply-To: <b23a4fc8baba99010c16059a236d2f72087199a1.1700623691.git.bo.wu@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

ping.

On 2023/11/22 11:51, Wu Bo wrote:
> We found an issue under Android OTA scenario that many BIOs have to do
> FEC where the data under dm-verity is 100% complete and no corruption.
>
> Android OTA has many dm-block layers, from upper to lower:
> dm-verity
> dm-snapshot
> dm-origin & dm-cow
> dm-linear
> ufs
>
> Dm tables have to change 2 times during Android OTA merging process.
> When doing table change, the dm-snapshot will be suspended for a while.
> During this interval, we found there are many readahead IOs are
> submitted to dm_verity from filesystem. Then the kverity works are busy
> doing FEC process which cost too much time to finish dm-verity IO. And
> cause system stuck.
>
> We add some debug log and find that each readahead IO need around 10s to
> finish when this situation occurred. Because here has a IO
> amplification:
>
> dm-snapshot suspend
> erofs_readahead     // 300+ io is submitted
> 	dm_submit_bio (dm_verity)
> 		dm_submit_bio (dm_snapshot)
> 		bio return EIO
> 		bio got nothing, it's empty
> 	verity_end_io
> 	verity_verify_io
> 	forloop range(0, io->n_blocks)    // each io->nblocks ~= 20
> 		verity_fec_decode
> 		fec_decode_rsb
> 		fec_read_bufs
> 		forloop range(0, v->fec->rsn) // v->fec->rsn = 253
> 			new_read
> 			submit_bio (dm_snapshot)
> 		end loop
> 	end loop
> dm-snapshot resume
>
> Readahead BIO got nothing during dm-snapshot suspended. So all of them
> will do FEC.
> Each readahead BIO need to do io->n_blocks ~= 20 times verify.
> Each block need to do fec, and every block need to do v->fec->rsn = 253
> times read.
> So during the suspend interval(~200ms), 300 readahead BIO make
> 300*20*253 IOs on dm-snapshot.
>
> As readahead IO is not required by user space, and to fix this issue,
> I think it would be better to pass it to upper layer to handle it.
>
> Cc: stable@vger.kernel.org
> Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
> Signed-off-by: Wu Bo <bo.wu@vivo.com>
> ---
>   drivers/md/dm-verity-target.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index beec14b6b044..14e58ae70521 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -667,7 +667,9 @@ static void verity_end_io(struct bio *bio)
>   	struct dm_verity_io *io = bio->bi_private;
>   
>   	if (bio->bi_status &&
> -	    (!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
> +	    (!verity_fec_is_enabled(io->v) ||
> +	     verity_is_system_shutting_down() ||
> +	     (bio->bi_opf & REQ_RAHEAD))) {
>   		verity_finish_io(io, bio->bi_status);
>   		return;
>   	}
