Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438347;
	b=pEauYId8b4vp/H9JlbwKnE3DvYo3DVGHFIsZKGQgq9kZTW4LcPNSeU1xklvQ9t5jFuCc
	 k3jNNNy8kCfa85vpRDy3LlEWzKZmBiAgr4mI5dSMVbnetblgyGPnHkcKnECrpkMWo4qt3
	 yRODSHmNKhLWRJ+YYtbFNvNt7hG8v1DOjT7S5qisCKrvbpTyoywQUkVdz1PpGhPWtVou+
	 bqnQX1jAZidOcJOfa9YJEcLhJbJy7Xyb1p9qsXYzLx8S0TQzdvPI4MiqrKtM92RMlhgJH
	 gVEOWvce6JnrkCLQsUZyBiS8xE5KfmbHTXliigt9eIA9Y/ylUhhvxD9gjDWnTolnqbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PAtBW+9ywMPOIfbMm41eVJQFmgBYU+QNa5qiiJV/Hdw=;
	b=Lj8assMR4q0VMcfji7IbTxI5/fawzhnSYz2NnaVwBEkWvkT1XOT8L3/Qdwz9Py5se0ml
	 hnRUHcBOEl7ZtXivJ8EDX+YIV6wXDE9X8Tw8VGxfFFNB0G9QedoS6EP+bOrDk6xeDQS+L
	 LT3gQadokQmE6crteqZrJklGbqA3Sa9MS3I5FQZN5CO0Dt+8bdR4HACnSf3yyF1nOupPb
	 NuavnmR6wOvhKAxuKNtQrsGQ7M1scCxUZdjxjQRPJmv6zF9iWWUz64dZ5XG0HmnjsJEV+
	 hTzjUikHRse3ppYpFMUWkgYa5tq9/XACDSC+5L2PojQ4SKQCiNvX8fL4NI4xNbjK+8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=NWOfpz51;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1B5606A321
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 23:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C1B5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=NWOfpz51
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3700ed8dbe3so6586033eec.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 15:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794438345; x=1795043145; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PAtBW+9ywMPOIfbMm41eVJQFmgBYU+QNa5qiiJV/Hdw=;
        b=NWOfpz51KUZzFvh55OWaX9upGS694kbphgGJ+zpIxXPV8O1Kwp2+YqhUgIxQ8UQKr8
         JauohF/6JoYYDYUh3dzoq/y4DgOnhZ2d8Lm+nqJMvErC/gJV0nmweRmHm/JolitozO89
         lO4GdmEqADUGYjXFku+8MUj7U/SRBfRwDe9JlEUGeWd4b+8It8t5FUw0s3lXesTo6xrb
         9XyIEBsCsQb1Ynpl09BZYvsjkX93J05coh9YBZtl/opQEPXv4xQeoYejfxO8WFKCayD5
         1nUdl3JpnwkEm0bRi3CryX+l3nNdbSYu+4UB/Iq+PRCp5FRDtjm7xJYaP/hMigETY/by
         eGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794438345; x=1795043145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PAtBW+9ywMPOIfbMm41eVJQFmgBYU+QNa5qiiJV/Hdw=;
        b=OzRgYeJRzRMvtEWweQ3GUgKfc66olhSC4W66RjwmUi2thu3H5Ax7mf/B1RqTMu+Y5f
         YW6DGp5zsGfNaKx/jJwMpYKP5EK6/FPMcZFO5rLLftTpRExgfkKNDnpw8ouqrkL3p5fB
         EHQOiNPpS91LyMEpcQu9ymeyu3CzTpdXU1mT3LdpX7do9XYJyXy1PQYSMTyPWcse+TXj
         uJVRQ7K7oUjusluFDahYuvQsWfFLRp2G86H4yOTS5YX1XLFjS6UrrqwjygYVAkqtifoW
         VKjv/RVvP2E7GK/1pytOHRgzWmztbc7fFWZ5MXr1mEQ7ifuJ5XaPJtq7d5FectPS6jKO
         t1lg==
X-Forwarded-Encrypted: i=1; AL+hErGcPRPY32gXgUfuYiGOKEnNfiQcpIdV86uznGr9rc4CIykm5aTKFyqJnpA2EPNLuDIm8ehuf03mtg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8iNnTF9RO5ye1EbOVyTfF56yVZFt2qdUuFHUQE/WHo5eIH/9hh
	aYiNcSLvRrqR1HXwU1bYBnKI4rHlDjZ+VdttFcXL3bVz33d1hY6IUnMcIZnAekZKO3I=
X-Gm-Gg: AYBFou2FQNzjpiNEPQk3dH9NvpJnQlPQjKkRZXkTkg4cQRKcCqmHUFTPJj8K9gQnXSz
	EOKGXGRASk0TTPnk4iSE0vAYa2DoreTdMUoi96qZswfO+gxFrglC7CWs2sE8qh/KhO2J1A+LP0a
	u/1gTU0FMB3yLud7mtN/crULKq8S/tiLltufgEAExPhKmJ/4o2vwmAyb8mCkAHPrhHBv58gBEIg
	q0gvwyv9jeXc8u1hzKjqhe2DvtNirCbD/HIg8i21+1gK8Ea4ndKqWCstOrD+d+eTQAmVDpyRrUJ
	QkPVZxu6OgdSJS8z+XTfLLTcyzhwRUmlQMX3JvBx1gTxr+FG3BgFxzrPHIN5J8ZTp2FdD2POcMm
	Ol9f0TJjNwuAx5CvhXcuc/zD9/Id3SYoA8MYb3cLpVmFZkvsH9U7ZD15IdfDoMnHl4SOBVeC9TS
	IZSjsZmVow7eKpODvyT+WXxR9nQ2+DIBYcWJIJAwA2oRE9PdBYe6FNeQ72gTPkcSn01Vanmm3H0
	A1/rxaBIicsG9GnZN6Y89ixOpd8if+82+5vdvnPRu5+I0/oiNzV54FmF6vesEjzgHtATu8qUQ3N
	+4Err2gyA3fobfgBj37hagw+0hJLjmmcqn+3x8TsgSJ6FcWxDZqZC/UrcP2HV4tZ9rJ6oiojuLX
	LOIWDUoBhDEEZLRWDcdoLIP7fzlSqbhkQqN8n7vKZfuYEOeuQoORujEdYnG3AEomKYHtMixidK4
	9qouSj4BKNm8X+0+Ze9H7+HEDe
X-Received: by 2002:a05:693c:41da:20b0:36a:79e7:2fd with SMTP id 5a478bee46e88-3768721410bmr4343347eec.40.1794438345215;
        Wed, 11 Nov 2026 15:05:45 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bfb58dsm36388538eec.18.2026.11.11.15.05.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 15:05:44 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 0/1] multipathd: check re-added paths' WWIDs against sysfs
Date: Wed, 11 Nov 2026 15:05:34 -0800
Message-ID: <20261111230535.12947-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
References: <20261109185556.27139-1-brian@purestorage.com> <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com> <20261111174259.41911-1-brian@purestorage.com> <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
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

On Wed, 2026-11-11, Martin Wilck wrote:
> Right, but "newer" doesn't mean "more accurate". You write below that
> there is no indication that anything actually changed, so time
> shouldn't be a factor. If a wrong VPD reply is possible once, it can
> also occur multiple times. If it's just an unlikely failure, a purely
> stochastical thing, it would help to simply repeat the same request;
> if the probability for error is 1e-4, the probability for two errors
> in succession would be 1e-8. However we don't know if it's
> stochastical.

Fair, "newer" was the wrong word, and we can't show what caused the bad
reply.

I think the patch stands without that, though. recheck_wwid already
exists to stop a path whose WWID has changed from staying in, or going
into, the wrong map: multipathd checks the WWID with the device when a
failed path comes back, and when a path is added with "multipathd add
path". The re-add in uev_update_path() is a third place where a path is
put into a map because of a WWID change, and the only one of the three
that acts purely on the udev value. v4 applies the same check there,
under the same option.

It also costs little: nothing unless recheck_wwid is set, and with it
set, one INQUIRY on a re-add that only happens after udev reports a
changed WWID. If it ever refuses an add, it logs the udev WWID and the
one the device returned. We'll run with recheck_wwid enabled on our test
initiators and watch for that message. If it shows up more than once,
we'll come back with those logs, which would be better evidence than the
one run we have, where we didn't know at the time that our test tool was
flooding udev.

> I'd go one step further and say that it tells us nothing at all.

Agreed.

> However from the time line you provided, it makes sense that your
> patch would have been effective in the error case.

Thanks.

Brian
