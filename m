Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794549326;
	b=xMrhsjtyQRw4B8S87HeLgecHc19IR6FO1QZUk77hXkIam0rCtcGTdX/mCUjrj12HymqN
	 VxV5OpMb45NtOTNvD4zZGVI8+N//7kTftlMgSjgZAPGBY4s0pICA0squCOatgsWMsqteB
	 O4FHPCBvLFDnu7eCpw/1yWHZL9xcq143sqBVqdrKf296FX0yCMXp4NsWPboCCKHB1axQO
	 a89ng0c8DM5z7MTN4kg7Vajr5w6EFeVRdQ6NK7WtN4BAVIbkUYGY4ZXt7tcG1N+0ay36h
	 Ln7+0pp0bSGa604JTak7S9BAbGC7Qa7QSt+aymuK72hNhsIXZSAoQVYWgviqf+xbDzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794549326;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=/01lbDODi7NDbVwmLDa+t/6qEZhc6k4Y0iSdWiv8IZE=;
	b=aoj+kLc1RWfxSYdLxCXeQsawPVcv7ITfKHwsDZS6Kpfi2jye5ogQcZAESHL9rArul+J3
	 lIRSfxQzPLdJjdOcAKUyJW2IXgBHitrwF/dibODj4YKqnXA8AVnnGCKv+wspEgt1ApA6O
	 /W6Tm16SflZSj57GtdBmkrgfKaz4BTTMNUlpE30rqZjHXSZXJZEd0fLcYkcwYV/Dk0RDE
	 SiSQVC2bAUdy7PqUgE12clrjDI8yRGiBGnO/6IeU8dHHqPxthsottLtHKSHyT2sZbrX+Q
	 FxQrgjw38NbZNfqC28Cnq1KAhPVlp419fM4WtAOypo7CIIv/txmoW2Hv56Fae7cE0Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inrMicjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D3F606A321
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 05:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inrMicjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223A31F000C4;
	Fri, 13 Nov 2026 05:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794549325;
	bh=/01lbDODi7NDbVwmLDa+t/6qEZhc6k4Y0iSdWiv8IZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=inrMicjZVFVB2PlDeqt+iHdxPxcM56TAktw3wwxzaihgr4dIv7O9H8lC8fJ4zODqJ
	 lSFGmT6aIxSvrSLOIjSCTm6Pq0aHYk5aJfmmJKBPEv89BWDYS/GiY1LWPUlMC6wg8d
	 Uqjx45foRh700nNBNnYyl4OYvTjE44OG2RL4eO0SpVs3A9QmQVWmBxAfrh8Y7ptipx
	 861LJ9GFW/ONL58s+hnRcUxaBMiakWIJWbnk2tzgqhxyev8jBvore13vTNP35yl1+v
	 lN4YIIMjIaGLYNAApUMh8edP4uAthsLtAPQv0z7jZlY2KbV+5uJaZ5HHU5ovd/t7vK
	 yA0fne7amgt9g==
Date: Thu, 12 Nov 2026 21:55:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: =?utf-8?B?5ZGo5Lyf5rGfIChXZWlqaWFuZyBaaG91KQ==?= <weijiang.zhou@unisoc.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	=?utf-8?B?6YeR57qi5a6HIChIb25neXUgSmluKQ==?= <hongyu.jin@unisoc.com>,
	=?utf-8?B?5ZC056Wl56aEIChYaWFuZ2x1IFd1KQ==?= <Xianglu.Wu@unisoc.com>,
	=?utf-8?B?5ZC05ZGo6ZWcIChKdXN0aW4gV3Up?= <Justin.Wu@unisoc.com>
Subject: Re: [RFC PATCH 2/2] dm-verity: don't restart or panic on errors
 during system shutdown
Message-ID: <20261113055523.GB76778@sol>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
 <9cc9b5c7460d4b0db002e7954b2eb893@zeshmbx08.spreadtrum.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9cc9b5c7460d4b0db002e7954b2eb893@zeshmbx08.spreadtrum.com>

On Tue, Nov 10, 2026 at 01:06:21PM +0000, 周伟江 (Weijiang Zhou) wrote:
> Commit 252bd1256396 ("dm verity: skip verity work if I/O error when system
> is shutting down") stopped I/O errors during shutdown from triggering a
> restart, since devices may legitimately be gone by then. Errors that reach
> verity_handle_err(), e.g. through a failed hash block read followed by a
> failed FEC attempt, are not covered and still call kernel_restart() or
> panic().
>
> During a reboot that is both wrong (nothing is corrupt) and harmful: it
> races with the reboot already in progress and replaces its reason with
> "dm-verity device corrupted", which bootloaders such as Android's treat as
> a verity failure and switch the device to EIO mode.
> 
> Apply the same shutdown check in verity_handle_err(). Corruption is still
> logged, recorded in hash_failed and reported via uevent, and the I/O still
> fails.

verity_handle_err() is supposed to be called only on corruption.  Just
as established by patch 1, there is a bug where an I/O error is
unnecessarily escalated to corruption.

This patch might still be worthwhile, to be robust against hypothetical
storage devices that return successful reads with incorrect data while
the system is shutting down.  Just the commit message and comments don't
really match up with that.

>+/*
>+ * Skip verity work in response to I/O error when system is shutting down.
>+ */
>+static inline bool verity_is_system_shutting_down(void)
>+{
>+return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
>+|| system_state == SYSTEM_RESTART;
>+}

The above comment is misleading.  This patch makes this function be
called by verity_handle_err() which is for handling corruption.  It also
occurs *during* the verity work.

> +/*
> + * Devices may already be quiesced (e.g. UFS set offline by its
> + * shutdown hook), so a failure here does not imply corruption.  Fail
> + * the I/O but do not restart or panic, which would also override the
> + * reboot reason of the shutdown already in progress.
> + */
> +if (verity_is_system_shutting_down())
> +return 1;

Shouldn't this go earlier in the function?  By the time we get here,
verity_handle_err() has already recorded the corruption in struct
dm_verity (where DM_TABLE_STATUS can read it) and sent a uevent to
userspace notifying them of the corruption.  That isn't very consistent
with the idea that if verity_is_system_shutting_down() then corruption
is not reliable and should not be reported.

Side note: as Mikulas mentioned, your patches were also corrupted and do
not apply.  You also should not include email footers telling people to
delete your emails, as they may do what you ask.

- Eric
