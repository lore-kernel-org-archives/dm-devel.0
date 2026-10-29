Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317201;
	b=x3pOIcr9P8G6FAB/JTdanX+zWdeJ6X6EjgbZgkxPV2GDrKML+tIHoZNgUfNpj+WttmBm
	 UsaYk7Vq8Ct++pAmk60ERCeQbRhURYZHrlRKIclZe4XN7J5RYJJbHjTuCk2uZ4435VrtX
	 JQfII6t5ySSIot2kUdDSzRzxBHlFQ8tHwcccRe0w/wTWvXMfwkzJV2vBQQXovbI9FRCAl
	 bTe76AWLkwBo3HRQC1U12Eo+qcJxRapFTuN7DdlTxXCtv+wmq73sJ6OshFwMhNUdTRf2H
	 EehiA3AFxI5taiWdKNLzaR7lBexUa0eRRvwAA80WJO70fWZkEL+dc9LJlMQJ2txoBZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317201;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Aml3qOJir+FPIf91ZakQsy56hRFoQmvVd9FUx7Aze3U=;
	b=0vPnAK4p3p+2C1bWLLWY2rvUZb3TWQmbbePk7HjjY1daiGcJiznS8xhKgJ3YKsh5Jzu3
	 RnvKt3HP/iFA+3HkXaZ+rH1LJBxnwtg8Zv6jFVMhV+Vn6aZJgGfrx2CBgXl2/Y3yEaroB
	 tbI0w1Dqp9GuDtsrDFtOUwrNRFEUMWE7uQGj8Y6dShrxhxUHKrXZ+6INyOizXHYtDCDG1
	 Z7WxFlfTAGDw692WPulmOULKKpPnv+4567gYMUm+1rouAaK5PRt7D6purKiapOsIWFnJY
	 cIYoA09N+32cwWbqUkzBEFyXUs55rkBzhJLjiUCBrfgnAsInQNuZ8LxDJPNKzC9gFOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=YBRCiUJY;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AD3606A31C
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 23:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48AD3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=YBRCiUJY
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-188406bb948so93862c88.1
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 16:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793317199; x=1793921999; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aml3qOJir+FPIf91ZakQsy56hRFoQmvVd9FUx7Aze3U=;
        b=YBRCiUJYNm/bdMecWKOlKR26VxAV4Kbmd1TXQpJGEmDL0ZleV11aPU5feZ09HWWXQ2
         roP2hkXUGebPkErrJzN6fj+PwhHzfNn+mdVm9HSQBg8+dcCBL5PA/z2dDl8AxSpLAaPb
         9VGf501XBbUaVqKYpICuV0N9CN+DVcHHxcTI4bTHiTLwfaHgjxROcLgb0o/SWnlwJRvl
         +bs1RayiMx50NiVnfT9qShFypSvWpKtBrg+JoCBjA319vz6rUu8CVl46Rk3b45fwQHlN
         RIf9BdWbRlII/RWfq3Aga6vL5oIb4dL2lsuH7LJ3I/zh08K7l2g/QGkwkRWZMIGnYhd8
         OvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793317199; x=1793921999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Aml3qOJir+FPIf91ZakQsy56hRFoQmvVd9FUx7Aze3U=;
        b=URRpuq+prDeV17x8Lvo/e9TSMHqLqbTLdZXUOD120ffx+PVM/GxVCDSWjLjMJxIM45
         FHBOgb1gvyuGhd9PicyzeQ8BUTalZ3r08+WYT1cGHpEo25spOvEvpDj8SH8GU73lzdLo
         0TBBbNn30YIznwIednH/4vGHnhcekKMft2lUTA2J84aYh0m3lZXZEj17h/UgCiqZZBm3
         ocphNsTi9TY4JUKHc05lTPU4If3f6T7DmzAZ2M0w+NPyn/5k5n+ytz9V8OslvDvTbc4P
         qdC6KZRt3czrrgzmjYxU0ox8oe4Ego7xkid99r75onyUSQ5OX75x5IctwB0DLBLtJhww
         BnRQ==
X-Gm-Message-State: AFq9FYIE3Zv+Wpqva43xTaQrAK445HCpAPhTSjwcSRRPdY3mAByTO9UV
	vw57UPPjvb5ziZGIjV6KT+6dR+1Mankox9DiDlva26tf18h//rGqlI+guesZzFUKe74=
X-Gm-Gg: AYBFou0dhuSX+L67NjfhiR+ZkBnlBuTjT1GlAKKTkuQXZ/mVWoii6HJLQN5FIClmhI4
	9seYz9zICV3lCxZp9HQMv5QF06SJlHMTfnqr0sYNCYdXn08R583uZEvaFcC4YwOeFi8cD+g0z8D
	0RbfAetm7tzu0kjFVCIsvRKTeikCy7A4vN4Omi85pbk/K88L1zYlPemuO4MteU4rev+i0FC2Li8
	x1g+q/u82IWm+OUBHnNzeBFMnwOa0Q9Lso9vg2OYUkUpvDCSKRBf10kkuez3NMyRCSwZfMNQiP9
	hKyK6tDRFSpvgxHhrJuP1BmKttJQR9kAEScK0q5+PWuFkP0YFVdzAZd8sbgIGDHDLbcEJFB0T/t
	uQgcBb2uvkWfyYm+sKAcMA2iKcsnWF5reVb0CguxkEya82diXndRmz1mLve3rw55OsPFJiXzj5w
	SSCdSik4dwkOXXLEugBZrWqQ+Uw2DNMIoX+b/O8x+MkWE4KfmH9zj7l1X8gc3d46LXFtW2aK9MM
	gr+oVlhsExsK8EWuIYlHcN3JP/jSkwjvhpcGBuFrLeZH6OIz4l7pThR28c/k+k6OxcrRKbmgOel
	EgBv5NDczvdaI8qPtK9va7TXOuT8YH6BXC2y5HzTnXXq4W1wczXUrMjXFfCLs3IxXRkTT254/2D
	WK627WL++JW5Y3HolHkb6io9BDBnCFDzrRESsvOJLsUOFAA8D2lvwmlEnxUchKn/ZhVTil2DdGh
	UOt4LoT83ooJ0LG4iu5vgvQIaq
X-Received: by 2002:a05:7022:2203:b0:18d:c38c:bcc9 with SMTP id a92af1059eb24-1ac56e8a821mr1179807c88.3.1793317198960;
        Thu, 29 Oct 2026 16:39:58 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm1774192c88.8.2026.10.29.16.39.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 16:39:58 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v1 1/1] multipathd: verify udev WWIDs with the device before moving paths
Date: Thu, 29 Oct 2026 16:39:49 -0700
Message-ID: <20261029233950.94756-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <auO6S56Jdjpxh8Bh@redhat.com>
References: <auO6S56Jdjpxh8Bh@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Oct 29, 2026 at 05:27:39PM -0400, Benjamin Marzinski wrote:
> The code all looks good to me. I must admit, I'm a little paranoid about
> forcing perfectly normal ev_add_path() calls to double-check the wwid.
> Currently, that only happens if you enable "recheck_wwid", or if
> something is going wrong with initializing the path.

That's a fair concern. I made the check unconditional in ev_add_path()
because it is the one place every add passes through, but I didn't
weigh what it costs the normal case.

> The issue is that
> scsi devices can have multiple wwids, and the multipath code has to be
> in sync with the code that udev runs to the wwid, otherwise they can be
> different. I don't think these functions differ. I know I've checked
> them in the past. But unless there is a problem getting the wwid from
> udev or someone turns on recheck_wwid (I don't know how common that is)
> paths don't ever run this code.

can_recheck_wwid() already limits the check to SCSI paths using the
default uid_attribute, but I can't prove the two never pick different
designators on some device. If they did, every add on that device would
be refused and retriggered. That isn't a risk worth taking for a path
that has never had a problem.

> We could avoid this by hijacking the need_do_map argument to
> uev_add_path() and ev_add_path(). If, instead of just being 0 or 1, it
> could also be a third value for reinits (we should probably use an enum
> in this case), we could only double-check the wwid on reinits, which
> only happen when there is an issue getting the wwid from udev.

I like this, and v2 does it. need_do_map becomes enum path_add_mode
(PATH_ADD_NO_MAP, PATH_ADD_MAP, PATH_ADD_REINIT). PATH_ADD_REINIT
behaves like PATH_ADD_MAP and is passed only for the re-add at the end
of uev_update_path(). That covers both cases that set needs_reinit:
udev data not there yet, and udev reporting a changed WWID. The
changed-WWID re-add is the one that put sdq into the wrong map for us.
Ordinary adds, CLI adds and the checker's add_when_online path don't
run the check.

The uev_update_path() check stays as it was. It only runs when udev's
WWID differs from the cached one, and does nothing if the device
doesn't confirm the cached value.

> Thoughts? Am I just being paranoid here?

I don't think so. On how common the problem is: we hit it because a
test tool was opening and closing the sd devices read-write many times
a second. With udev's "watch" rule each close sends a change uevent
that runs scsi_id, so the host was producing far more udev traffic than
a normal one. I expect it to be rare elsewhere, but the result is data
going to the wrong LUN, so I'd rather not act on a changed WWID
without confirming it. Limiting the check to reinits keeps that and
leaves the normal path alone.

v2 follows in a separate thread.

Thanks,
Brian
