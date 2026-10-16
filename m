Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B13BB9E0
	for <dm-devel@lists.linux.dev>; Fri, 16 Oct 2026 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792162407; cv=none; b=btH9t5IqeQHr2X0qTyYdbthUaV3WsolOm3atLCqA1zUYkYpgM3CRQCtlzxFDabeImK1mISaCB9lH9K/aAISbp1KB+CFQIwDAsYJZkdjvjhc2juw+oabmJapDZLPRdKRcf/d8BZBI/uARIBCBC5mNiomiBU/wRj8wI1nErLNbavI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792162407; c=relaxed/simple;
	bh=uFX4zjvXso4VeDI316ejRhA10e98d4MoCS8GSbY45IA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=lTutBXlNCrLH3bKojRgV0E4qGz8XLpj1kr2JxQbwjWJ6gMSY0A8bQiCoALPlE26BJRNKxd3Vblee2g/qxlOqs2slHvbMURCBRYlb9sAaL7yzhauen4rWwHL4TEj0IfDXAN1A6tk21Nty9j/NzDTCbX1N9Wotiy91UdsZyxbPeZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBoE0KxK; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBoE0KxK"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso48339a91.2
        for <dm-devel@lists.linux.dev>; Fri, 16 Oct 2026 07:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792162405; x=1792767205; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uFX4zjvXso4VeDI316ejRhA10e98d4MoCS8GSbY45IA=;
        b=mBoE0KxK4Uxxgn594gI06EeILe7DEcJLakKN6RDaSuC9VfwNizFjt9Sw54c2wT7ylr
         nYH7XfB2Wwgf0UFBzjU709k6jJH8TDG5UFwBic6zDlza3lwdBGFdTKf7gAOlW1tGxFX6
         OYslPbdnq3GdmKvm36OgA0cg/Da3sVc0gTSeTXTGUQt+lI0L1i/wsrs/OUklKyn+y+6v
         1hY7UCtCGIGyUCUesqjl0ylQvLPsR0NNJxdWANSaH8+xWMtL5cUQokwimu5Ro05w/BZ5
         acQ9j26yVGlevchPknDQkBUe7HluWedailJkxyfxphD3RnAe/obDksq+vCQt2Yvu6BkD
         sUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792162405; x=1792767205;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uFX4zjvXso4VeDI316ejRhA10e98d4MoCS8GSbY45IA=;
        b=r9VrRjTvH1u76WNRZ3zXC64mlGqD7t1BEvaEVhUAnyuzgHrVbxuc5W2fSC2pZhLH2I
         DmBkfVHVzE2D19j6AnxikQolEnTumKN3uPMQB1ZpkZwbuSUSMNIm6BWP6ojzc/asPO/t
         /orajZAA7rFtW605PRCYIITw9sl/lD4/ByXTOGjuaWN2l+GzvOSjyswwNRfloGVT0YBl
         yqr3XWILc37L3Ev9OmVXWJtj2dcS9qnyUSwTVYfAMH9qcJlEjE+XvmIKT2VbM4m4Te66
         ysqabtxcmmkxjnWxj4amZO6mp7dvAGKTlD/7/TDXGZBtTIjlLUuF7z02VcEjMLyPoaRf
         Wdrw==
X-Forwarded-Encrypted: i=1; AKwUvBytERi/21SC805XW3bia8xszcj+0PbfO5lZeqHF5LJhhYZ8Mrr8ScHh27Z4GDl0xXMQNweeJHi5SQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYLZbrChpiWx0jAwKti6TLwCmEbwg+5f8NMv8LRn/3FYfxw1hsRe
	T2eUriV0RASN5Pyt+Mk5MAS8IYSEZclcsODohUUzvTgMWG8c5sG7aU0c
X-Gm-Gg: AYBFou3oZnhQjEmY+Q7Y3LSWyE3876fC6xiRgF4pkHuskzYAjxboavL7iQ+GFbF0Vyj
	JIEusg537sElHblp9c19kiL3KvNbOjcKVViiFaQqnQW1AKwTgwUJjNHnyYUQq5Ax3CA2JhVUzvH
	l5om0wcT4MkAtKbL+URvmwKnJ2n5RC115lVNrNuRMVz14tTSuVbdbo0z2ZPFj1+DLdfdgerQI9J
	8inqRbLADAjITWwbVIb8jXLxyPfbnQ09Jmh2XzuhehgWRduWeW7tfn/9/JyJH4mW4hc//tXddi5
	0SD5II0b+l8Vb78EEzmOo0UaBFQeBw4DLBvndLk6zu7oe8g4mJFvUhktEW2Jy7CJD3XDuDlJf6y
	h0GJSNUSBSY8sazK20TWtl2Q0LtJgEcppYnqd02Dp6kDow/U5qA7rvPxU5qK0Q/qDAVj8qt0IKg
	1fwsRiyBkabIerVYnQ1eX+mEtgqt1ULMRq9aHFLx670dgKss0YgoTWicxrNspbcggSY87XRvcBE
	nhFpV179iQlxnFBRM2i5cqYGcDFQNWsAah+LXeKcxEu0k+8UwKjHbf/ygCgzG6JNlZ8/Gi+TiQj
	LAE=
X-Received: by 2002:a17:90a:e7ca:b0:3ab:f38:2b3c with SMTP id 98e67ed59e1d1-3acef13eb0cmr59920a91.28.1792162404946;
        Fri, 16 Oct 2026 07:53:24 -0700 (PDT)
Received: from localhost ([153.61.198.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9474b52fsm10875551a91.9.2026.10.16.07.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 07:53:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Oct 2026 14:53:23 +0000
Message-Id: <DM6CJUE4J2LX.2NR5QB5X3N0Y6@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer"
 <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "David Howells" <dhowells@redhat.com>,
 "Jarkko Sakkinen" <jarkko@kernel.org>, "Paul Moore" <paul@paul-moore.com>,
 "James Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Andrew Halaney" <andrew@amutable.com>, <dm-devel@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <keyrings@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <bpf@vger.kernel.org>,
 <fsverity@lists.linux.dev>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/3] keys: Add well known IDs for
 fs-verity/dm-verity keys
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
X-Mailer: aerc 0.20.1-349-gb940a4174a3e-dirty
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com> <20261012-broschen-inanspruchnahme-gebilde-d72cf2b99cda@brauner> <DM5UD20248FG.3BXPS76LK06F5@gmail.com> <20261016-ratlos-endkunde-eindimensional-1fe5eef08d13@brauner>
In-Reply-To: <20261016-ratlos-endkunde-eindimensional-1fe5eef08d13@brauner>

On Fri Oct 16, 2026 at 8:27 AM UTC, Christian Brauner wrote:
> On Fri, Oct 16, 2026 at 12:38:11AM +0000, Alexei Starovoitov wrote:
>> On Mon, Oct 12, 2026 at 12:38 PM Christian Brauner <brauner@kernel.org> =
wrote:
>> > Applied to the vfs-7.4.keyring branch of the vfs/vfs.git tree.
>> > Patches in the vfs-7.4.keyring branch should appear in linux-next soon=
.
>>=20
>> What is this branch based on ?
>> v2 was sent against bpf-next, because
>> commit 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature=
 validation")
>> is only there.
>> All hunks in keyctl.h, key.h and process_keys.c have its lines as
>> context, so the patches don't apply to -rc as-is.
>> And patch 3 documents KEY_SPEC_BPF_KEYRING.
>
> It's based on the portion of bpf-next that has Daniel's keyring patches.
> Which means I just wait until bpf-next is merged and then send it as a
> follow-up pr.

ohh. that should work. If it's simpler I can take this patch set into bpf-n=
ext,
so you wouldn't need to monitor merge window that closely.
