Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204488;
	b=cv7y3bgLD/gZGHW/mKa0u78MFDVvoMqxciyoorl9HR3RexblX7pTje+XK2k/aG/tU/te
	 TRouxOXulnwuHoS6XUr0OULUuysrSTr+iHeYB0dcdugKsvW5w1QpNmQS6hgf2ypS6JE2a
	 9z80qUcZPmX0x7YxoGOGsh3waLe7VaASf73EI0tcHGUMHZkaRZSpklXqRk/K4P4OvsO7z
	 dN6MyNHLoacRT6OWaRo3luVukv1TEj5hE34Z22mE98Pqxbp5+6WrOI1+H0RtahPfGaytf
	 MADegHoBwK+pd3rmzO7iJiB/tRvQop04qKIygSZkzRHEnQ3RNIW23sx5xpbSiGAPkVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204488;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ZpjLU6b1rBwqQ5orG9e7Qyn7cJGoHGcmVy6blKVnMJM=;
	b=l+hITRY7Lldi3GK3aPWYv/nPQ7Ox0uxm/RYCmzHjy7Gw4I0NaSr5NRE3Hf3zcrFdmge/
	 mWh6mWLDVy31mprrTpCWNi8SMT3Dl2v7HpzQ/1V5C79MdUFuWYeUusqa70dICXD/dghkT
	 nZj08/QZ/FWYajAXGJZ31yVjR1gCwotfAynRMA22GkVjwa3bmvhdAanfIW2PzBpM2spoY
	 aIL9GUAcJq+q9MmmZ5rCij3ih7sSlWWzJnbSnELLQKMeAlUZA22mO5fZKU3UUypr1ycQR
	 OsMt1vEJYxquv6UZYt0+EoILqaCc++zrOc/m8ElI0bJoJp/BTPBd6FfuXFHWy+cL3fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFc7c24i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A8606A31C;
	Mon,  9 Nov 2026 06:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFc7c24i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC63D1F0089F;
	Mon,  9 Nov 2026 06:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204487;
	bh=ZpjLU6b1rBwqQ5orG9e7Qyn7cJGoHGcmVy6blKVnMJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aFc7c24ikxzvKOCn+qV55jPlrhdZbe/43PFxyNLpvjwBOv+3kqU7SbtsWsa3eu7Di
	 FOh3T/KkC06EIL2Qt84s+Z+lDKoCuhG+opgBx9O+YHFylscf1B3LCtd8PFD40Dnp/x
	 WFCETWy61arbSG/zk8uTdPyJizoxoeTv8LXns9EpmU9C8y91TTdXZ7p6OtymmIRTcS
	 ztm/QMhzRS3z5umWscOpEXjLXMVOoe+nJE38xsvEbEqox8YpsEZ1PLOox/7W/mi+0b
	 oU42CVd8PyE/yrME5KCx5AIDr/ID3DS/D8PfhHDDEFjp54zETG1fcnqZlR9mD2kTJg
	 4dUquTEyfIUnA==
Message-ID: <0197be1d-1257-4597-aea2-1a065fe0a1d5@kernel.org>
Date: Mon, 9 Nov 2026 15:08:03 +0900
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: defer async write submission to write thread
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Ignat Korchagin <ignat@linux.win>,
 Milan Broz <gmazyland@gmail.com>
References: <20261105072708.30722-1-pepe.schlehofer@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261105072708.30722-1-pepe.schlehofer@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/26 16:27, Josef Schlehofer wrote:
> With no_write_workqueue, kcryptd_crypt_write_io_submit() submits the
> bio directly, even when called from kcryptd_async_done(). An async
> cipher may run this callback in softirq or with BH disabled, where
> submit_bio_noacct() must not be called because it can sleep.
> 
> Submit inline only when async is false. Async completions are sent to
> the write thread, as is already done for submit_from_crypt_cpus. Use
> the async flag rather than in_interrupt(), since callback context
> depends on the cipher driver. Sync ciphers still submit inline.
> 
> Tested with cryptd in QEMU (x86_64 and arm64) with
> CONFIG_DEBUG_ATOMIC_SLEEP, and on a P2020 running 6.18.55 without it.

Originally, this was added to avoid write reordering for zoned block devices.
So did you test this change with that (scsi_debug or null-blk) ? You can also
use an emulated NVMe ZNS device in QEMU.

> 
> In QEMU:
> 
> - 4k writes logging "sleeping function called from invalid context":
>   100/100 unpatched, 0/155 patched.
> - nr_requests=4 on a loop device: 0/6 unpatched runs completed,
>   4/4 patched runs completed.
> 
> On the P2020, a warning in blk_mq_run_hw_queue() appeared in the
> 6th unpatched run and did not appear in 30 patched runs.
> 
> Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> ---
> Based on dm-7.4 (dab527d83462).
> 
> To reproduce, with CONFIG_DEBUG_ATOMIC_SLEEP, DM_CRYPT, BLK_DEV_LOOP,
> CRYPTO_CRYPTD, CRYPTO_XTS and CRYPTO_AES:
> 
>   modprobe -a cryptd dm_crypt loop
>   truncate -s 256M /dev/shm/nowq.img
>   L=$(losetup -f)
>   losetup "$L" /dev/shm/nowq.img
>   KEY=$(od -An -v -tx1 -N64 /dev/urandom | tr -d ' \n')
>   dmsetup create nowq --table "0 $((256 * 2048)) crypt capi:cryptd(xts-aes-lib)-plain64 $KEY 0 $L 0 2 no_read_workqueue no_write_workqueue"
>   D=/dev/dm-$(dmsetup info -c --noheadings -o minor nowq)
>   dd if=/dev/urandom of="$D" bs=4k count=1 conv=fsync
>   dmesg | grep 'sleeping function called'
> 
> For the nr_requests=4 case, run this instead of the dd. The writes did
> not finish without this patch:
> 
>   echo 4 > /sys/block/${L##*/}/queue/nr_requests
>   for i in 1 2 3 4; do dd if=/dev/urandom of="$D" bs=64k count=512 seek=$((i * 512)) conv=fsync & done; wait
> 
>  drivers/md/dm-crypt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 8853e9af1c3d..c0552a300e62 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1982,8 +1982,9 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
>  	/* crypt_convert should have filled the clone bio */
>  	BUG_ON(io->ctx.iter_out.bi_size);
>  
> -	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
> -	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
> +	if (likely(!async) &&
> +	    (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ||
> +	     test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
>  		dm_submit_bio_remap(io->base_bio, clone);
>  		return;
>  	}


-- 
Damien Le Moal
Western Digital Research
