Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CDF175BE
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 01:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717033632; cv=none; b=eY42XmwHrV5q+xpNttKUAC7IeL8wL8WxBfBfKRShuNQ+BiCZpNyjJdg50qsyNRzQalk4W/D9lfkuWWNA9HBVhgj/RC3mkHPb5w+NGHe4EbHm1z6KZ/B5CwPQUwhSJaFWUN07KhILW/m6ce/sVgYiwirzIawSX4pHTT2JXydj9vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717033632; c=relaxed/simple;
	bh=x1jS0mxgpy/2saLRwCgP0IDOSIhPVz9T5ZHuv9e2c30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mlLLJc4n8WQH129fqbiwOCMa5fEd+zH/XEHAKYHYJxscGy17m9UMu0/aJq8Ua229iVq1P/AcygkD55Q2yhD2brjn7ZZ0W1mhW5ixWbRi33EBAk14cxoMbUnxrLCflDhL9ofusCJq4I4M1vKu5VHnizBrMdQIqdtDnQW1Zbxhs5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=YaU2R4pG; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="YaU2R4pG"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-62a080a171dso2685607b3.0
        for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 18:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1717033629; x=1717638429; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtKBdXnoQfLOHhfUlX9Bxsk6L3lUvasMxrh9oed50QE=;
        b=YaU2R4pGqGzqtuQTgaw5l4mTq+llFmq81n+UnhpMjs1+26kd/bBmx5ts7ivJaumxdl
         y17l9X2Bxt8enBY7Fb5BNuCmkMdmMACaelp9jX/7j2bPEeV+3KTpUYm1sD6br6JJJWu7
         /4bRJjN1puHLSeGu+pOqp2QB60MNIwTEgaAXg7v0b8d1EwKs2j7GtI8DsxjZtOX5wyuN
         xix42D6MuS29NWdVMM7nOfXhkauO2Jp064RUkZeUKqEoB272dHknoREBxy5quey875uy
         fI/6wrQXnkQo+IGGw2RrlMVHIsya317AGD5tiEUH99M2N8F5/WlAVq6qRw7T9bv9W/cs
         +1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717033629; x=1717638429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtKBdXnoQfLOHhfUlX9Bxsk6L3lUvasMxrh9oed50QE=;
        b=Wp745VGA2n2aLXQJy2Hn81tL8QihZpLAa7kOIO59CjKfDjSZHh1bdy1VCkYEfRZ0+S
         cH8uG4idWZIIgnxMFVlIXGJgQf+TgmekysHVNpRHzDLe9Kga6rAko7T5WKFXFopDWD6y
         jN7VIwIsxfEHVHsRzntlNBLjVKorQQdLPZa8dsmLfZKDerL5zQq1MCUmrXu57kzHWymC
         qxrwUgvEeH6njSxTqUhOxKy0pQZ9WAXeo9re4omTaJOJIanho1k9grAlWdNBbxP3pUqz
         THZux5h5t3IsoSSbCnHslLKuTpz3PhpG4zjkYlIWRXYNqjxykT23Zku1H8AseEtcjgap
         JzGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoaMx7GVWqNe04RFDAKgnI6UQctNjEgGpePF08GMGS4qFI7U1tw4Bx3F7kFSAo6KI5jKszefgICb9XnKO0ejq8EFKgkHIXSdE=
X-Gm-Message-State: AOJu0Yzf+KXiw80m8C3YiCEwJ0cakavYbe3ILPDPUo/92kO7Z8SJd4Ny
	iPvQV/Nn3PlMD7pTAtCw4hbTJ6ZFo042bwmk91/792r3fMVhmdypv/3IiicZC22Q8tTe0snTICw
	Y77yn5NVcGT70z+AGzzqRQ3J/jlWBI8VCJGb6
X-Google-Smtp-Source: AGHT+IHE8pHh5vgrRzbkNWJnz/7ABaPo+xQvVDp6nIkAadJxWm7yBQS/PqPj3c4uPz54TzSylU9FuipuoCMPbpIsfP8=
X-Received: by 2002:a05:690c:ecc:b0:627:ecd3:6223 with SMTP id
 00721157ae682-62c6bc79ed6mr10295197b3.35.1717033629104; Wed, 29 May 2024
 18:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com> <1716583609-21790-16-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1716583609-21790-16-git-send-email-wufan@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 May 2024 21:46:57 -0400
Message-ID: <CAHC9VhRsnGjZATBj7-evK6Gdryr54raTTKMYO_vup8AGXLwjQg@mail.gmail.com>
Subject: Re: [PATCH v19 15/20] fsverity: expose verified fsverity built-in
 signatures to LSMs
To: ebiggers@kernel.org, Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, 
	tytso@mit.edu, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, 
	mpatocka@redhat.com, eparis@redhat.com, linux-doc@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 4:46=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
>
> This patch enhances fsverity's capabilities to support both integrity and
> authenticity protection by introducing the exposure of built-in
> signatures through a new LSM hook. This functionality allows LSMs,
> e.g. IPE, to enforce policies based on the authenticity and integrity of
> files, specifically focusing on built-in fsverity signatures. It enables
> a policy enforcement layer within LSMs for fsverity, offering granular
> control over the usage of authenticity claims. For instance, a policy
> could be established to permit the execution of all files with verified
> built-in fsverity signatures while restricting kernel module loading
> from specified fsverity files via fsverity digests.
>
> The introduction of a security_inode_setintegrity() hook call within
> fsverity's workflow ensures that the verified built-in signature of a fil=
e
> is exposed to LSMs. This enables LSMs to recognize and label fsverity fil=
es
> that contain a verified built-in fsverity signature. This hook is invoked
> subsequent to the fsverity_verify_signature() process, guaranteeing the
> signature's verification against fsverity's keyring. This mechanism is
> crucial for maintaining system security, as it operates in kernel space,
> effectively thwarting attempts by malicious binaries to bypass user space
> stack interactions.
>
> The second to last commit in this patch set will add a link to the IPE
> documentation in fsverity.rst.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>
> ---
> v1-v6:
>   + Not present
>
> v7:
>   Introduced
>
> v8:
>   + Split fs/verity/ changes and security/ changes into separate patches
>   + Change signature of fsverity_create_info to accept non-const inode
>   + Change signature of fsverity_verify_signature to accept non-const ino=
de
>   + Don't cast-away const from inode.
>   + Digest functionality dropped in favor of:
>     ("fs-verity: define a function to return the integrity protected
>       file digest")
>   + Reworded commit description and title to match changes.
>   + Fix a bug wherein no LSM implements the particular fsverity @name
>     (or LSM is disabled), and returns -EOPNOTSUPP, causing errors.
>
> v9:
>   + No changes
>
> v10:
>   + Rename the signature blob key
>   + Cleanup redundant code
>   + Make the hook call depends on CONFIG_FS_VERITY_BUILTIN_SIGNATURES
>
> v11:
>   + No changes
>
> v12:
>   + Add constification to the hook call
>
> v13:
>   + No changes
>
> v14:
>   + Add doc/comment to built-in signature verification
>
> v15:
>   + Add more docs related to IPE
>   + Switch the hook call to security_inode_setintegrity()
>
> v16:
>   + Explicitly mention "fsverity builtin signatures" in the commit
>     message
>   + Amend documentation in fsverity.rst
>   + Fix format issue
>   + Change enum name
>
> v17:
>   + Fix various documentation issues
>   + Use new enum name LSM_INT_FSVERITY_BUILTINSIG_VALID
>
> v18:
>   + Fix typos
>   + Move the inode_setintegrity hook call into fsverity_verify_signature(=
)
>
> v19:
>   + Cleanup code w.r.t inode_setintegrity hook refactoring
> ---
>  Documentation/filesystems/fsverity.rst | 23 +++++++++++++++++++++--
>  fs/verity/signature.c                  | 18 +++++++++++++++++-
>  include/linux/security.h               |  1 +
>  3 files changed, 39 insertions(+), 3 deletions(-)

Eric, can you give this patch in particular a look to make sure you
are okay with everything?  I believe Fan has addressed all of your
previous comments and it would be nice to have your Ack/Review tag if
you are okay with the current revision.

--=20
paul-moore.com
