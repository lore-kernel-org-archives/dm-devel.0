Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793037900;
	b=exf/mOsRI3U/8EjlrXXUQJJR4haxQ0OMdV7ccg4aJx6b+fVCSpOy2C8mLqvM+M4HAmH/
	 GBqHIG6KggHeKtRyg/1gmlPGVyGCrVZU+J/uGnQMzf3eKet28+rwkbqpmVkGxvomBwS6B
	 KvQypuFNcQdt9u1xsRQzjYx6lWVE9+Ns36oDDJyj6R6eO2pn6B7xDYDwhaYEW6ckm7T9g
	 V408W1BgTpTrNvz6l68Lgr3MXQF/WfpNbQGti/0lzhd75jfBm0fSc1eqUiDXx2+lVQwGd
	 DcodY0oPVVzbxMdLueYLNb25e9B1B+Ebx0pt6Mb+eSdlrTnkzD2PNzBLFqGfpNYxH7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793037900;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bCPXNTQPk0AI4pGOr0WSkbfNEADlNe7hECo6+1Hiybk=;
	b=0bIXjmsIgnEjn2W8Rx3G9UqS8oekYe+BoXkdwEZtCB4foUuBEgUvgA7ycCveaRmh7fYE
	 7WeSHDtKlVFK9TDsNhqqhvaeBRTJ0lL2Q5cNyQvp0miGeJcp4Rpst94JCaKLdyDu0gbAM
	 p/W4ZEbJS3MHYK85tJzqQMeZ2UAU98V0JbB/MTRaa24rJSiZKRYfb1rhOkhPu7k4n6c9K
	 VBw9THBdWNxg0iqmzK9mgqq+k0NuiivOSozlQVrZ29i0F19A3uzqBj6OTPKoju3HV5SrW
	 kUNGSv5EOLgsIOooadztgEvb4kK9JTFbc3NXC+pDrQ+tKL2+BxRF2FRpUdhmm5n5xEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b="d0ty/EnO";
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E98606A31A
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 18:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3E98606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=d0ty/EnO
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-15ea896ddc8so5722992c88.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 11:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793037899; x=1793642699; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bCPXNTQPk0AI4pGOr0WSkbfNEADlNe7hECo6+1Hiybk=;
        b=d0ty/EnOa/JH0cM9uwCqa84wKfFprvIo5Xz40/Io4Aw4b0Gp8ugBTG5D/g9L+7ATTf
         nNL9iOOHVRJo6Prmftqj0T+3nTV90iHGMTTrhTUNYytkQ6daGU+tpy6DE1LOHxkD02xi
         66FgkhuQX5pNPPhaDXAC6FQor9dfpykAzpy/17wSP9nS4nQ+m8YM0wB7YJ3vJ3g9X8MC
         ZOpr9YaLIohqlCVnM1VWJDLwRmzIXBvpTk3b+SyXTf6r/qHFNOIGl5NF20y5ntvs7j+8
         tky/WIF+m4RQ+PXiJDJeNBc2QzUi1VWFp4GXezuS6n91oH6/uiLJ9xlNBfuBJAG+Uc6Z
         igzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793037899; x=1793642699;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bCPXNTQPk0AI4pGOr0WSkbfNEADlNe7hECo6+1Hiybk=;
        b=2tS18m9byK8GPMI9ItAcdi2U16KC1cjEzwTgK5YXhOzDzlEPcRmmXqGzYSV17Ar+Y3
         eQjA0UWXflVL2/gKV4Y5GPceNOtYq+FAPnNWN/Q03TDZvE5jluEu+OgUNjdR95dIk8Nb
         6MCoYFn1aMzee1TyUymMRmNbgQ9PUICCwYWcFiFecdUXVLq8TqY/Y44yBQEe1fMh2QJ3
         2GUD2zwVthzPsHQGb6mIZ6B/T+Es5xGesY1wN4Tt38ktjg/jgrFJ2VYxg8D9kTZT5sWv
         SxjYhkDTC1EmJIJGsC89icFGN6xm6O+2b8LBCPj5L+NH3AjGTzpQQNb/Zcc4l4PklTZy
         g4vA==
X-Forwarded-Encrypted: i=1; AKwUvByS/EbF5MHShsGKsPEbg041TDV5l273w0Z8Y68TnJWqmXQtej4uDdVXyM70i19ytPchgjA+UbgaYw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIKB4MgdW0RIBW1Jf+vqpQjWwNa41M7YimPi5TZhapkaoVZEjOh
	ZZlKookeJxXqg9NefW8NZI8+Rx5d4NIU+/gIbr5mq2bkwKYcNPDjXIm8FTl4itIkGNM=
X-Gm-Gg: AYBFou1UiZw7/zd9oWcnciKLOvtH6dF8gagjjMJgXE61NpM09xlgI1+eA6YwFPj5kw7
	6/8098k8uCp7nGeZ3JKs8H2gOvHSNwsgOSr6iVJZ3LRRd6SxRYvNY1tGXaB/nuMpomz1dsvUi1q
	xUEu+ypKToZ1q69OM8v50wqExbp2ZifDsVWb510nO6Vk7wnTbb1xMEoPzzcBbmpyY34jeSS8soc
	eXKgyiWWcCl5wSgHcAu9stj3iMrd0/Zp1Xb3lZDSq1C19X91hdr5fOb+vsYFkKf01s/3yV3YQ4w
	nbSfJBTdT1EVn7KjKwwOFKIV+tERgmae+MmHoCmsw5lcgdcJUgR6D95VlslMGU1xq4WNKhMCFnN
	jKVfaGE/tG4OYE2haxU2kPXWiAfmONKpZc1rz0jeU8xTiLIdIe8Kdkn6xJ628s8xAnzJkDEN1s+
	vBfhJF/NDJNmJnA9SFYtJrCutTB/+GdIxDZLmy+4z+NSN7IfRKxxasTOaaXTg7Go5Yn1+yPsikY
	L8T3pEHwnGqLbhuqna5hFX3U8hNiYlzyJ4he79fzlYwdWTHIuwZEq7If2r7Yc+QgHp5EM65TYRs
	lAqJrS/HUzk/AA2IqAOQTYcDamaf+OAhBmskw5BzPD9M/BM2xqwSVMsf/mv/uu0FBfN94Zkq17I
	Ga2u1qEm7EVg4+C5SN5FfZkNaKjnfnYReoFIF9+hjLBLiRF0tOGEk
X-Received: by 2002:a05:7022:eb57:10b0:196:bf5f:8bb with SMTP id a92af1059eb24-19936e34ba1mr11282177c88.45.1793037898526;
        Mon, 26 Oct 2026 11:04:58 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0f83cedsm32591997c88.13.2026.10.26.11.04.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Oct 2026 11:04:57 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <martin.wilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Mon, 26 Oct 2026 11:04:41 -0700
Message-ID: <20261026180444.31357-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <c52f077ad82585f1f02d5b9cc9c3f640e9fcc031.camel@suse.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4> <20261021231959.69270-1-brian@purestorage.com> <20261021231959.69270-2-brian@purestorage.com> <179270025923.152861.15521453184442767016.b4-review@b4> <atqpOBViqKWLZ7Q3@redhat.com> <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com> <atvweCfhjWkT9i-U@redhat.com> <c52f077ad82585f1f02d5b9cc9c3f640e9fcc031.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 2026-10-26 at 10:26 +0100, Martin Wilck wrote:
> On Fri, 2026-10-23 at 19:40 -0400, Benjamin Marzinski wrote:
> >
> > I do still waver a bit on whether or not we could leave
> > force_readonly
> > set on failed reloads. Once a device turns read-only, it should stay
> > that way until we get another uevent, at which point we will call
> > needs_ro_update() again. Perhaps we just need to make sure that we
> > clear
> > force_readonly when needs_ro_update() returns false.
>
> AFAICS, this is exactly what Brian's v4 patch does. No?

Mostly, yes. v4 sets force_readonly back in dm_addmap_reload() when a
reload fails, so the next reload tries read-only again.

needs_ro_update() doesn't clear it on every false return, though. It
clears it in the dmi.read_only == ro case only when both the map and
the uevent are read-write and none of the map's paths is read-only. If
a path is still read-only, the flag stays set, so a map whose read-only
reload failed keeps retrying instead of staying read-write.

About dm_addmap_create(): agreed that the flag isn't needed for
correctness there, since a new map opens all paths fresh and a
read-write create fails with EROFS anyway. It only saves that first
attempt. Create still clears the flag, so that a value set by
ev_add_path() can't carry over to a later reload. I can drop the
read-only shortcut in create if you'd prefer.

Uday Shankar, who did 430f8f89, also suggested dropping force_readonly
altogether, and tracking the ro state per path in sysfs_pathinfo()
sounds like the right direction to me. But it changes behavior: every
reload, not just the one done for a DISK_RO uevent, would follow the
paths' ro state, and so would "multipath -r", since dm_addmap_reload()
is in libmultipath. So I'd rather do it as a separate series on top of
this fix, and keep this one small enough to backport.

Brian
