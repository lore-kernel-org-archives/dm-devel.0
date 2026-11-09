Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257496;
	b=mDdKEEx003vDeIkmtZTHfOqA+Cwibrq9z6zrzoIOZQvqaE7uXMci+UCWRrfPlW8gS/My
	 z32YTE3HK1vBtCpmTaX6M0xkl09K7web2jnceP4VHN36kU6VcY77+YXCdwDWipcs4M5xN
	 kgMC0573tJUEdVZn9C2Sr4RWwXLSF0z59PY3AOY/vi5cBBOxQghRZzWXRxJ5z2WJrwE+9
	 /1eKRRhUUqLTIeGsUYHFlW7czQx/1uU5/IDo+Y7GPE5VGlfu3aaXvy0A9Mwhlpshrp8KK
	 oC0tBF5tBt4GTiGCg26CDsUMuIKnypU9engEcrAZr7Ios9Q1ctt796/M9hQNXaXwK3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257496;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2EnKYM1O2foiG13flnejDTAFyfiNY9oWVxa4iq2fMgU=;
	b=hOI1ccdv8VjihUJFGUCf05WE0Ck0UvepNg9MBxAhYzbtJ5rTJwaI9/ls2hfIopTc6mS4
	 JxbX1vM9OvCT3WS9csrfgelP0zFGTCuDVQfyqEFL7GY3eCv8KIRCOcjnSL2QCRzuB3g0R
	 dz2XJGkoMDt104PzmsD8QnYRUdRdKL3CUCXC68LFO24i5qtUPnzrvYzod35VQb0bFUrke
	 4oTRYQxoUNjL13pscrKqVQNYFe6js3W8j+COZi8Mex5wVHzKJSRW3OGibetSppVWqH7LT
	 arxPTrpyv8P5UUzqNKInSMWNel1sxgVr1APX5xA1tBkyxGJAx9B+zO2a/3PmFo3byAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593F606A32A
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 20:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2593F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c247f6687dcso228735866b.2
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 12:51:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794257494; x=1794862294;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2EnKYM1O2foiG13flnejDTAFyfiNY9oWVxa4iq2fMgU=;
        b=IvADVfh1PPz6uxMW7kU9JpaQ64Srs2r3WFW55+znVtfIM/yOQkHe2akXpEsHZGl0k+
         vnWV+SzxaiUskhUXUGWPdjHjmUBrhsz1gqM28vVqjN5dvD1/wBrlibmK0DSVIlz/ALLI
         jXG6ScOFLge0fl1wvX7xZoWl3mgorDo7eti1/UvBY2Uab8uk7cWnmtpOAhZl9gc4Zr/w
         ss2vT8pagjpMaAFBGnC6TKQQg8gqXh1dz1MIMRoi6IPxAdOD4Pi8kJxYhC3c7zQOKCCT
         SaEyE3EWQ1UoE337S0bNZYxt/jG7rfo+WeXed6dzPFX1qDY56jAXSeeUeQCxVUgknZRb
         W7yQ==
X-Forwarded-Encrypted: i=1; AL+hErEzX0wN+ZokoUQqWME7luUeu3sXKiRTLCh2Gw1iexa8Q00vp2oxV0ICFj0AY1j5jKaZr4dEQ8mEgw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+vsFU34GDNM4WoeqY6onjB8Es0v0+CFFaG8aUx5Wk/Tnbd02QA
	AyRimIvuUSBOhd1Ifs/1tyQ+9SvXOfA4PlcuEaXPGhzpLt7Jlty89Rl/kG+P5B9vyI0=
X-Gm-Gg: AYBFou0oXuFGgzxslP9w+Og3WWCvlzDkkvd/ZLFgBeWbWmKaTxTGTauLjKdMbqVN1S6
	poJWvaCHGL72uHn1Ux7/MKk+E5cc0TtpMiLJ5QkXqFcC3WZKyZWEIVb9t/lZwzV6ikYb+36M7NJ
	ks5/RURfOEt/VYTCYifDmHDHAlau0H0uJi15Z8U5KOj2WF54/sniV1k2bLxRjNCM/EibxvkWwf9
	O9CEyO1yFq9uFnCBJScYzO/BNiHEPzQLw4Kt6F3w2hrEnNOt9+9cjbzJ9225aRWcXpqKVU2CzF2
	Lp6AaMotxuxIjlhTAbkzPoyrEnBkrmOQkntkoYq3+6qGkdsdt6ur05JBsGvhnHLRjZHYDi5hatu
	5EbiiV69qJCnnCB7/f5Tn089r2RYGKHn0Pqf8Y4lBfPFSxpMctGogk+D33fDWEtD9swlkxtceIl
	/h7llVdudx6LgKskW3aXf5pMht2l6Cx6G63hodaBTpjDjZ0oGoD1qLuuQxwT/e/HHfmzmtJ1b4q
	uVoJ2mnM8I1wUpZLTdyVwAfJKdk8/BKohF3TtJ7RcEPkv+S6LOsumuU6RjwL4tj7uayVTCsSN6D
	2hth+4RRn3HveV4BXYlhq+1nn1bPpsVbV/kQx3H7jOMJYHxguoqlIrXwssyIUTuOsXZEvYSkopz
	CkQJA
X-Received: by 2002:a17:907:940a:b0:c50:4a99:f6ec with SMTP id a640c23a62f3a-c504a99f904mr27094266b.34.1794257494355;
        Mon, 09 Nov 2026 12:51:34 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a570a9bsm15348966b.28.2026.11.09.12.51.33
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 12:51:33 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4682977f9aso166232866b.1
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 12:51:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHQzePruMsC/KAN5dv0Nb+J2p9IxoN245xKUsLfwXVZPUyJUy5c/+btHwUTvIGR/TQxksbWqaINrQ==@lists.linux.dev
X-Received: by 2002:a17:906:6205:b0:c4c:f85f:aa12 with SMTP id
 a640c23a62f3a-c50495f0330mr43846166b.31.1794257492995; Mon, 09 Nov 2026
 12:51:32 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105072708.30722-1-pepe.schlehofer@gmail.com>
In-Reply-To: <20261105072708.30722-1-pepe.schlehofer@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Mon, 9 Nov 2026 20:51:21 +0000
X-Gmail-Original-Message-ID: <CAOs+rJWmmUbYqU34Yb4qJvJsZ92=AztNwNsqX+xD8WaH8tVz-w@mail.gmail.com>
X-Gm-Features: AclHuK9En0QmOUBY4k-RnKbFBU3eXagm58QT4NOxyknJnRPCI_HjRETQwg25oKY
Message-ID: <CAOs+rJWmmUbYqU34Yb4qJvJsZ92=AztNwNsqX+xD8WaH8tVz-w@mail.gmail.com>
Subject: Re: [PATCH] dm-crypt: defer async write submission to write thread
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Damien Le Moal <dlemoal@kernel.org>, Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 7:27=E2=80=AFAM Josef Schlehofer
<pepe.schlehofer@gmail.com> wrote:
>
> With no_write_workqueue, kcryptd_crypt_write_io_submit() submits the
> bio directly, even when called from kcryptd_async_done(). An async
> cipher may run this callback in softirq or with BH disabled, where
> submit_bio_noacct() must not be called because it can sleep.
>
> Submit inline only when async is false. Async completions are sent to
> the write thread, as is already done for submit_from_crypt_cpus. Use
> the async flag rather than in_interrupt(), since callback context
> depends on the cipher driver. Sync ciphers still submit inline.

At the very least I think it may be an unexpected/undesirable setup
for the user: they enable "no_write_workqueue" expecting a fully
inline setup, but still get io offloaded. Perhaps in such cases we can
do a pr_warn_once() to let the user know their setup is impossible?

>
> Tested with cryptd in QEMU (x86_64 and arm64) with
> CONFIG_DEBUG_ATOMIC_SLEEP, and on a P2020 running 6.18.55 without it.
>
> In QEMU:
>
> - 4k writes logging "sleeping function called from invalid context":
>   100/100 unpatched, 0/155 patched.
> - nr_requests=3D4 on a loop device: 0/6 unpatched runs completed,
>   4/4 patched runs completed.
>
> On the P2020, a warning in blk_mq_run_hw_queue() appeared in the
> 6th unpatched run and did not appear in 30 patched runs.
>
> Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd wo=
rkqueues")
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
>   L=3D$(losetup -f)
>   losetup "$L" /dev/shm/nowq.img
>   KEY=3D$(od -An -v -tx1 -N64 /dev/urandom | tr -d ' \n')
>   dmsetup create nowq --table "0 $((256 * 2048)) crypt capi:cryptd(xts-ae=
s-lib)-plain64 $KEY 0 $L 0 2 no_read_workqueue no_write_workqueue"
>   D=3D/dev/dm-$(dmsetup info -c --noheadings -o minor nowq)
>   dd if=3D/dev/urandom of=3D"$D" bs=3D4k count=3D1 conv=3Dfsync
>   dmesg | grep 'sleeping function called'
>
> For the nr_requests=3D4 case, run this instead of the dd. The writes did
> not finish without this patch:
>
>   echo 4 > /sys/block/${L##*/}/queue/nr_requests
>   for i in 1 2 3 4; do dd if=3D/dev/urandom of=3D"$D" bs=3D64k count=3D51=
2 seek=3D$((i * 512)) conv=3Dfsync & done; wait
>
>  drivers/md/dm-crypt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 8853e9af1c3d..c0552a300e62 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1982,8 +1982,9 @@ static void kcryptd_crypt_write_io_submit(struct dm=
_crypt_io *io, int async)
>         /* crypt_convert should have filled the clone bio */
>         BUG_ON(io->ctx.iter_out.bi_size);
>
> -       if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))=
 ||
> -           test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
> +       if (likely(!async) &&
> +           (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ||
> +            test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
>                 dm_submit_bio_remap(io->base_bio, clone);
>                 return;
>         }
> --
> 2.54.0 (Apple Git-157)
>
>

Ignat
