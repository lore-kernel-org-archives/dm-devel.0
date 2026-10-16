Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3CD282F14
	for <dm-devel@lists.linux.dev>; Fri, 16 Oct 2026 00:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111095; cv=none; b=hQJvVp0/t0cXz8xELLbhOP6AFBuwqt543s852O5RfESVtLh91Cc0xnA0r/ExZMau29WsJvYwEsSL11DHlDfSjVgg4VDSp9BGl0o4xD9SE5M/9mGXuyhPkOitqqrXW+mEet6Q6DuoGGmn7EleGOtidCruIxKmap0o0OtDENjgaog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111095; c=relaxed/simple;
	bh=wJv6Oy02ZyVpQIEV4S+JLl2ZMXIUTlylj7/wOCMhJJY=;
	h=Content-Type:Date:Message-Id:Subject:From:To:Cc:In-Reply-To:
	 References:MIME-Version; b=JyT9NNJp04fXgsteNWen4vbJIq4xqjjY4RVKaIreVEXLWm3D/zZUF9uO3+pB7VwKx9sEpihrvaxm2q9jSw4rKmEHR6L0lKbVRH1Cj7E+zx0wL6Kv1qZ4vN+g3unEJLzMSoow4vaBd1k15oXfNOuUXqjJ1U6Bg6fiZpZFtXGVQc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSLLsWcO; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSLLsWcO"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-ccc6b11a19aso2704775a12.0
        for <dm-devel@lists.linux.dev>; Thu, 15 Oct 2026 17:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792111094; x=1792715894; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wJv6Oy02ZyVpQIEV4S+JLl2ZMXIUTlylj7/wOCMhJJY=;
        b=GSLLsWcO+wJQALu8B+YYCizYd/xGXXiCDKWhTGOpe1lQRbd6sThJvLig51oa6kGc6X
         sJCUb8pWzKwRhoozX/7clQY+B4qABsFScNnlbAx2CkSTlPKeiLlumedbKQm+xd3kEhUn
         F0nGgtzFF4C82gPQcgAZodoMOTZNai1cLO4oYgpuHjRIvEDlgDV0DIA4Jr8OJd8gb9sS
         lvZrAskDjeal7MIXhigg0R9gL7/coXgFPd3V+uSiGGKdCXjCa2hI2ws7vBDG0Fo6TAJD
         tyNddMatM4zJYieOcyHyEFUJpV0otIsJMJA7LfDm5yupmRAGZKHcr6WxlvDR0jClyTGc
         jzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792111094; x=1792715894;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wJv6Oy02ZyVpQIEV4S+JLl2ZMXIUTlylj7/wOCMhJJY=;
        b=1sysWPlcIfKDjF0c3SvJxyBjithU5UlC0sAegyL89LfGJeSHHSzsswu2xFpFvfxBYk
         e9MuYcQpQfwmn+Z2laAnyO1DLMJbLvXbMH5CgcnF/6CVs3vDVHpY1U+5a3AD87OA5iPj
         SCocd0ljezgDIIAzJJkYuaW2lHOtBFcg/AcsQm/pMna6TPDOv5Uw16vvJuUOuuPEu0nS
         qAg8/xEzSRk/PWKMUJe9oiwyDwHZq70kqTF3IUzHlO2+3qjmvP79KYKYE/mySGs5GOFn
         ws4TrBmxjqIMgvwA+17cdJ7iMKuZxi+9r2lY4KhKPRS6LZqY/WaOYJNImwKRrkAmypk0
         TIcw==
X-Gm-Message-State: AFq9FYKPPFlDiKIRdQoWudBW5Eb2DIxjz9WdBGqOuEc/9R1j97yEoSN7
	zHokVL0IQjz6fzdx8MhtV6H1wWXXPbXcdlMqnJEkN1bEBqAODLqtzORw
X-Gm-Gg: AYBFou2ve7g8Ptlj0xUgEgBAwJ45OHjoNNP+ZV4HGPyuVL0/jOGjeGnUPB/SrXMv/Wx
	8PfZhwWXWaEDm8BmMAOcNzZUGiV/xj3TdYA0zjEcqJjDg18qu0nsXkPamf4mmzX0IPhkCWpcAN7
	h3R5GJSz3XnwNgKLDnJX9pK/ImrxZR7LlkUvaYk0bejYxXV7F+s5CghlsE32NbdjlO9KKQ6+gL3
	nI9Jxc1Bs7FfRZcmvEmTgJqLhhQCFNncGQyOlo+r0H9SkW1nZH1mCQdR9Ke7govzK1s17gMeLQr
	zqo/QyIHv6zzEyc2ObLHJPfdIXpwpMJK2HCOx+pSPc7KkkGZTjFAUO3FBt+hzvASRuXshNuqkCs
	l7esXpENT840nN51h1aXAKeaUv8/RsxbjBLks1GRd+0t9TRe9ZcDUc81wfBezMw76t2opKRAdKZ
	DM4hD5J/vIfGGN53ttu4jTH/fvxpoYEbUf/MtDDiqIDQHo38xa3H0LS54RZ8MDwHXAMMAM3Eda1
	Zqtg0HozoPQSgn+ZZnZYr6E7ztMINGouKJQ5IRDcI/e5KJ9b1s6ILfUS2CjSAKsJnDi27OhKwtk
	Cas=
X-Received: by 2002:a17:90b:1d4f:b0:3ab:c80:936f with SMTP id 98e67ed59e1d1-3ab3a94ffa7mr15824328a91.16.1792111093664;
        Thu, 15 Oct 2026 17:38:13 -0700 (PDT)
Received: from localhost ([153.61.198.253])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947dfa00sm6462107a91.17.2026.10.15.17.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 17:38:12 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Oct 2026 00:38:11 +0000
Message-Id: <DM5UD20248FG.3BXPS76LK06F5@gmail.com>
Subject: Re: [PATCH bpf-next v2 0/3] keys: Add well known IDs for
 fs-verity/dm-verity keys
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>, "Alasdair
 Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Benjamin Marzinski" <bmarzins@redhat.com>,
 "David Howells" <dhowells@redhat.com>, "Jarkko Sakkinen"
 <jarkko@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "James Morris"
 <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Andrew Halaney" <andrew@amutable.com>
Cc: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <keyrings@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <bpf@vger.kernel.org>, <fsverity@lists.linux.dev>,
 <linux-doc@vger.kernel.org>
In-Reply-To: <20261012-broschen-inanspruchnahme-gebilde-d72cf2b99cda@brauner>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com> <20261012-broschen-inanspruchnahme-gebilde-d72cf2b99cda@brauner>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, Oct 12, 2026 at 12:38 PM Christian Brauner <brauner@kernel.org> wrote:
> Applied to the vfs-7.4.keyring branch of the vfs/vfs.git tree.
> Patches in the vfs-7.4.keyring branch should appear in linux-next soon.

What is this branch based on ?
v2 was sent against bpf-next, because
commit 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")
is only there.
All hunks in keyctl.h, key.h and process_keys.c have its lines as
context, so the patches don't apply to -rc as-is.
And patch 3 documents KEY_SPEC_BPF_KEYRING.

I'm confused.

