Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794414689;
	b=R2ZqfXiUXc0SzaZ+MR9g0jOBvJHMWJVbNysFQ9wJqJ3zfaUJsSm0i+3FEpD6hnz1m8hg
	 1LS1tkUx0uLXy00oKwsh3l+ZrqS7a8dm58fL/QLChxVZm0z5VFtMjw2J+CxswPlMUsjLQ
	 K6RUxpQ1cIffidrx+rYo8I4diBfuHsfrAgonlJlo5W/BzdQoS6yL4e6Fd0QUNIEvTwcft
	 qvC+98WhriU3v50IX/Mgx6bvxk3hNE9iP/0bd+XmVhhoqDUVXiMMtsRpJRqlHUPF9O61c
	 ambYbJmjYgtAdNlsVTqEWQv+z2RjKm8eqS+EUbPk5jDUYv+Gsk7uo8FBoNr3Q24ESVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794414689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VfdeayAGq5Ya9uJBrf55kW3ZaL6kl1WA8T1whEpPIt0=;
	b=5Ay7mDj1+923u2HL3JrwqtaR/vku4m2a1jIB88ARb+1P1Qp1Sw6pEzUXHNYV4Y4cH0mQ
	 XAtK4nSFnL4gb8UGB903oxtPOAvkRvWB6Fg2TMdvEpSTrgr2F8maba4tPryPS7wykwyB1
	 n9S88iMMapXqfrLfbOEI/obvB7mtbKXYi35HXe6DX4idxKy0X4Okr/wRX2H6kl4Hp8SE3
	 TYW9vQiPSgJlrAOvuizYbbN6X/cat+WywjYG/IvdwKIOdNxaPhgJG/F9Cypno/vQz63pV
	 uLXSYAczZMZNgYPJ8X9idrB8Lol9BLxzAP0BvoUl4RmvFxvgrhVGvYa/TibSrU7TIUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgBe26vB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80475606A321
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgBe26vB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0556E1F00A05;
	Wed, 11 Nov 2026 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794414689;
	bh=VfdeayAGq5Ya9uJBrf55kW3ZaL6kl1WA8T1whEpPIt0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bgBe26vBsnM6drrWC7D3ugyELNHnhwjN/JI/G3arYVq0DVXobzOP9sKo7CVkRdVL1
	 XUU8ioG1IfLEGwMVI5ex7m/dfbSUJwW7wCJ5mrdYVuKbFNb6CdiARwKB89QWjbBc4Z
	 /7qI/AKERrvISWK2JsWGKqja7Nxohe/CgqfVHkQkweVw+aZCCp/vGfNWZ2NRODfNki
	 +woygcAZ6KGUBss5cG7jhGg9jvla9NgWJTMmdo0ra1KU3Ahk1bUoDdGl5dANCR5J+U
	 ypLJiPR1LEILpxsjztAvJ1pLPoFzbHXhLa9Q3d8Dq6EonJg1v8J658KIM3zT+ulKoz
	 EVDcv/iuE2aVQ==
Message-ID: <sashiko-outbox-209291@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-integrity: don't attempt to commit journal on
 disabled device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Alasdair Kergon" <agk@redhat.com>
Cc: dm-devel@lists.linux.dev, syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
In-Reply-To: <fe63f092-ef07-ac3f-7878-22083541f79e@redhat.com>
References: <fe63f092-ef07-ac3f-7878-22083541f79e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 16:31:28 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] dm-integrity: missed wakeup of endio_wait in
  integrity_commit() on error
--

commit 6f78b56af54c9b05dda8dbe4a7aa354299dc4892
Author: Mikulas Patocka <mpatocka@redhat.com>

dm-integrity: don't attempt to commit journal on disabled device

This commit skips committing the journal in integrity_commit() when
dm_integrity_failed() is true, jumping directly to release_flush_bios.

> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 802b377613b06..c50fcf2212365 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -2908,6 +2908,10 @@ static void integrity_commit(struct work_struct *w)
> =20
>  	spin_lock_irq(&ic->endio_wait.lock);
>  	flushes =3D bio_list_get(&ic->flush_bio_list);
> +	if (unlikely(dm_integrity_failed(ic))) {
> +		spin_unlock_irq(&ic->endio_wait.lock);
> +		goto release_flush_bios;
> +	}

[Severity: Medium]
Can this leave tasks sleeping on ic->endio_wait hung forever?

In journal mode, when ic->free_sectors reaches 0, a write bio offloaded to
ic->wait_wq calls sleep_on_endio_wait() in dm_integrity_map_continue() and
waits on ic->endio_wait before looping back to retry: and rechecking
dm_integrity_failed():

drivers/md/dm-integrity.c:dm_integrity_map_continue() {
	...
			if (unlikely(!dio->range.n_sectors)) {
				if (from_map)
					goto offload_to_thread;
				sleep_on_endio_wait(ic);
				goto retry;
			}
	...
}

Previously, even after dm_integrity_failed() became non-zero,
integrity_commit() still advanced uncommitted sections to
ic->n_committed_sections and queued ic->writer_work, allowing
integrity_writer() to replenish ic->free_sectors and call
wake_up_locked(&ic->endio_wait).

Jumping directly to release_flush_bios without waking ic->endio_wait or
advancing uncommitted sections means integrity_writer() is never scheduled
if an I/O or checksum error occurs while the journal is full.  The worker
in sleep_on_endio_wait() then blocks indefinitely on ic->wait_wq, stalling
subsequent bios as well as device suspend or teardown.

Calling wake_up_locked(&ic->endio_wait) before unlocking
ic->endio_wait.lock would let any sleeping writer wake up and fail the bio
at retry:.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/fe63f092-ef07-ac3f-=
7878-22083541f79e@redhat.com?part=3D1
