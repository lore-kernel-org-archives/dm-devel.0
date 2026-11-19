Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060921;
	b=lBNVQVYGqY1gQg81LXMlJ2OiM9kYdUjLyiMkklmlP6sPikXQguy7B0+tkZ5kFuxW80Yr
	 Md2JCDe6ixZpO4FEOEIdZF4QIH3Iuw9sDzzWgYKBTKt9LijYy1eAzSNyKz/Zkwed69hU7
	 xTBoJ6NJqwrAqlFLUnUz/N6UT4iHlnjbN8EQet3LDkQylBZXhAYgffKyxSkXGq81B4U2+
	 tIfRM4EvV9Bah4rog97h2I3iR0LFF3z+37VPzSYIeOXYpR0cz7eMPUxyzQDN+Zm3V4yBG
	 gGGGLxH1HKLwXpN3iS6p66Fv4avfSR8lyYLQD5aWuQ55A5FEg86FrjSvFFEc4nlTysw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060921;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fJtfrhmQx1vX1xY6U2FJkZOWiHHtkvB17JwO8I1Z3tA=;
	b=3s9XBzJDEmERRt29MJVK4DbpowrvaTEcH5oxXm+YJGbaqrnO/cXI8LEpDCGEfpfcy+NX
	 1s3wWOUEVntGUy59YDpmpF5P2bw0YbJ15ivtUAgFFecEuH8CHQmrmkdR8VZY7QEOmTd3c
	 9lldGB1cUWdiHOUIOKrx3OI4F+pBsAubflWDjbcVzrBEvaQ+bw+x9gqgRQg83Ph0fG4wC
	 NWcqOsjiXoUjkVwxM+TcmZ9ugyvZwvM2KSjANXnG4IowVNiMrab8b01DOr0XRz+QGLFUu
	 zWEZ+UA1nwn7buuvjkeG2iZYkhrUStA9CHw99BYcodO7Kyd2yRdPPtjfeBlJEKDZvlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p6ykFh5q;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7AD606A32A
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 04:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F7AD606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p6ykFh5q
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a60f90a924so852366b3a.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 20:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795060921; x=1795665721; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fJtfrhmQx1vX1xY6U2FJkZOWiHHtkvB17JwO8I1Z3tA=;
        b=p6ykFh5qHEZ3sr0wmsXLZ+gzFr4H321ukFMUU+RdQa6r79NfbNKonXWDo7K2Wghtq6
         piBscdQwiCdjkzJr0RV287gYCt13MAteZMtylaNcBPLKpzAJDGFhK4h6B7YGIfOblwkE
         KC8BDsuatFzcfn+MlYL0bWW44eXZj5AdtH1dC9QlZn/XVuKaBqqLoPykW+BQHWG16tkM
         98+P8ySaSt7rRUM4QI/TaT540ujUL8lVJ9R1baLzgzmSHAYJ0Jf/E6qnePUvOG0IyV9c
         Sgr07KKzhD499gbnm6PAoYqp6QJm82lDQ2/8Qc7SZGZ+NEdx7CYwny0BCbdXT9kJAMaa
         j7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795060921; x=1795665721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fJtfrhmQx1vX1xY6U2FJkZOWiHHtkvB17JwO8I1Z3tA=;
        b=bkCZxO6JryjidpaYZwiQ0UUZIaI7ZsfK64O0DpCWkkhhh6y+HkxAiSCqHtPfGHPx41
         g65u5xcYWKWl5td81CnwEruakGRDjA5hEt2nkj2umu81dqV81bBMNi5Xo25ZXwS3H+G1
         x8/57KNV2bk889I4oKGtIZCKNLkX/PWk35oqzofP1T53cj61P8JXw1KgPUCGbXtHoVdz
         qe6UOEjCIJ9MJDfNDVRT7BAXu/U7dw/fbED9zUQvWUDuP2J5tYmjWqowwaHt1b1gs5hm
         Hs9vHx0F/2mFFGpNZyN7/8exGXCpXj1Pf1ZKLRC16qfw06rgpbm4hjQsdGYQliD+Aq8m
         B15Q==
X-Forwarded-Encrypted: i=1; AL+hErFgJds0WeUAg2PXPYdUDKXnGHXKxm2r9gTZlbSZbQs2qc1WTaXu3J7VwrwMecin4gcweXR8dOAa6g==@lists.linux.dev
X-Gm-Message-State: APuU4Z/dC9z/QbwpA4eQn7d7gmskaGgpOwvLbjbVSi9e+xUdYX06GJ5Z
	zbxKQISEpUpOU5lVdwI0HGTWI+Cz0S0UP9kvVaXU5Y8jpnz2qJ50lxp2
X-Gm-Gg: AYBFou3xlv72GTETnZE1B5Lu45AEkLLevoKrwQTY+vSn1fO+ZaEiH3+QuLTbRknH8yT
	5vTHGElZkPixk2sWSWTIU4C96GO28UhJ8fIq0hfdgP7W+W2/uRmUWhCShwcZurLCdQk2xhXLt6a
	1LPUKp16eq4TpX0TyvgrXaEfxyB1xO+XeCpwTLG+PXXpha9L/EWPr+2L6o85OKUf0pJI+LNbGUF
	ESpO3ZU5Ht4f5z9xfoOJzM9u4YMx7eOlvqdM0cE9AZTE4Qsg/CrExluXoDYDxaNR8SqYnKIMoDb
	ubW1vSWwDtib4Z5UC+U8XFWIQ6zakvLIpHRMPe1gDiOFsvhsdeMW5jzv5DQis1JOLwW7u2yPWpP
	kDvTLSqzki9GHrhcl6u5eHKHA0zgacxeFSjzoLRQHhLu7153KU59Fcd5Qd1yCVJ7H9JFAn2710x
	XYw+C2rMp7SArfCPSYnv7Rbma5rXwWI9daL5gJazoctV0iDKKfBWIsSQI20pz5RlclGClI2khC2
	xOnnY37pvAOwyVjpF8WfjI+gj7xA5YRt58rndkxgs/ptRmAavy+stDn3xIunYZuoMcmQyWSMjlF
	TsRz/TgpNhL7vJShx2MaSX2Ip/u2jtSKojkCRD4KooobfMsrB42jXyyE1rpz8BxXpSx/jVtoBad
	zj5IyUvnW
X-Received: by 2002:a05:6372:a713:b0:3fb:5869:81e9 with SMTP id adf61e73a8af0-3fe97aefad9mr4332724637.27.1795060920424;
        Wed, 18 Nov 2026 20:02:00 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde534aec9bsm920462a12.22.2026.11.18.20.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 20:01:59 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: mpatocka@redhat.com
Cc: agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
Date: Thu, 19 Nov 2026 12:01:55 +0800
Message-ID: <20261119040155.1076781-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <d4fc9150-4768-f747-ca97-688bc9bebc46@redhat.com>
References: <d4fc9150-4768-f747-ca97-688bc9bebc46@redhat.com>
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

On Wed, Nov 18, 2026 at 05:41:42PM +0100, Mikulas Patocka wrote:
> There may be multiple targets in a table - if you use the name of the md
> device as the base directory, they will clash.

That would be a real problem, but none of the existing dm-bufio users
can reach it for now: dm-verity, dm-thin and dm-integrity are all
DM_TARGET_SINGLETON, so a table can hold at most one of them and the
directory under a device holds at most one "hash"/"fec"/"fec-data"
client per role.  If a custom targe_type which allows multi target and
each of them have a dm-bufio client, that will be hard to handle. I just
want to show the client info through sysfs, how about show such info via
message?

> There may be at most two tables for a given "md" device (the active table
> and the inactive table). Each will have its own dm-bufio instance and they
> will clash.

That did collide in v1; in v2 the directories are detached in
->presuspend (names freed, kobjects kept until the table is
destroyed), so the new table's directories are created synchronously
at resume, with no warning.

> Another problem is that if you reload a dm table, you lose all dm-bufio
> settings that were set by the user in sysfs.

That applies equally to messages. The default is recomputed from
hash_retain_percent at every ctr, only an explicit runtime tweak is
lost. Most of the sysfs content is state anyway (current_bytes/buffers),
not settings.

> What do you think? Which of these two possibilities is better?

I prefer messages, please review [PATCH 4/4]:
1. The constructor line would have to be taught to veritysetup,
   dmctl in android and lvm2; a message is one command, no userspace
   change.
2. This knob wants runtime adjustment (raise at boot, drop later);
   persisting it in the table line makes every tweak a suspend/resume
   reload, while a message adjusts the live device directly.

Thanks for the review,
Yongpeng
