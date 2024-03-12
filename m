Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FF61428E9
	for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274075; cv=none; b=cvTZ1pqKtFBrD1u0UBuGI3KU0xFw3+tl9EaOsq5qWdow4gBKvvT+bchnxGaN1TqqYPKj8EIIh1zcCXg0WegIMNG3ij5SXMhCBM/v2l0XJVtYHCJ83s2twUVR9LC5d3KqAZ4gvxe40ZLLdRRRLLfAAI2HiP7b39R7cAHlFHukh1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274075; c=relaxed/simple;
	bh=KK3vfTC21FfD3a3vNi4VaniP6dAy7ashn5OtgY1y6Kc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YzZ1pUW4XY5q8YeI7P7GvAMCXCs1/KrBVJt9eNv7K8oVV84Vh3MUbzji5ABkhSPPX8FBgOo/CPZ9SsH9oGgDYhbRFcHx1yby1StaRxM8wVaEcIiGf050Vfg6nS13uY4pHNJZUgxcCNSBHIYX+h5dFoMol7T8e1fDeZmeAAPXQM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=G6ytg3XK; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="G6ytg3XK"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dc25e12cc63so225524276.0
        for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 13:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1710274073; x=1710878873; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIM56byQCwYfF5RCflaFTltitkLV02ChrYWIQLMiS/Y=;
        b=G6ytg3XKJqkbIPWKug+eMzfcmTkfM8crI1HWo37RuIW0gggOJ0FAvhvYxjc6t8peSv
         1DV4SsHthqDiAyAg88gbCsjkjq4Cv7xWfOcn3yw9FwKYeevwoa9cir1JOC6AjPd4YObn
         dzll/Fiu043dqOhP6LyhP8FKEqTS2xWUA2rqwgjAByvi2zU0222/LTXJ+v+cXqNNIxvx
         G/rzeJpjxKY+KjdMgLEodZ7iLm+79du54U4s2qTImabeGxn9BXJN/ftY+jyLokwnj1DU
         Iz/SHyaPr1UCe+PHFZo/1o0xHH6v4yVbARDeg3LzPtcqmUK/fzJkoQ5NQAhGLN+2zhlG
         C6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710274073; x=1710878873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIM56byQCwYfF5RCflaFTltitkLV02ChrYWIQLMiS/Y=;
        b=YLjhcUbzC0hIWGrF5pYKl72Dj3pTFt8TCPEPehKtBuGEY4FT7wzkcutUC5oil2H1lT
         9zUoQQtzpujxvkWbJ/I85tKaCjpgsES+eoKzcKKQhDV1n6vLt202F2ymo4DwVET85+xQ
         TjGCw2Nm5K3nVTHmS/IRru3KZBdz+f8NB210fYIjqCfKHqFZQg7+eCj5OwDQwQUr3Esp
         s1BjuK0tmlcGfpdVU79qxVrQ5A6O5ubu7XtaC9yF4RKVZoRsxZVIQyN4rVEYAbe2rcjE
         /bMVFJok1W6/Orq2K1RDszSi/VnPk+eEQmEsSI4/0C/uwaGY4TSGtOgttgE3wgA6C/qv
         nV8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQqew1NmPCLLkf03rlXMQgRbsyTmJgDyLPfqBReJCoSyEMd4lHs/G2B1nDdqWDN8+E2aQPjxpcGScY60QtyLPI/NwLtVww/OE=
X-Gm-Message-State: AOJu0YxcMOBKwd0hu0OIr9YIpYmZWjZUE2sqdnC8ppc/dUDokMH5nk3Q
	o624ys3j4LAeF1AM0SY4ACv1rD0k1zirsZDjJt63uA/THpGWQOwCqfq9MhXu+qlMKghfbrcWDal
	78zyRrD7gM8/0heFH3c4QeQ/oQc7IjFFFwmvq
X-Google-Smtp-Source: AGHT+IFUO9loFBNfYwY2rilDGi4a1ZxrFKhf7gDp1B59xt2uvInDy15QqH6xxud+73LelILqgfwJCkTcRwHNX1HB0r4=
X-Received: by 2002:a25:c714:0:b0:dcd:b806:7446 with SMTP id
 w20-20020a25c714000000b00dcdb8067446mr396824ybe.1.1710274072732; Tue, 12 Mar
 2024 13:07:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain> <20240312030712.GF1182@sol.localdomain>
 <51810153-eb6e-40f7-b5d0-5f72c2f4ee9b@linux.microsoft.com>
 <568fae5e-a6d4-4832-a1a1-ac3f4f93d650@schaufler-ca.com> <746a5548-0e98-4953-9e71-16b881c63aa8@linux.microsoft.com>
In-Reply-To: <746a5548-0e98-4953-9e71-16b881c63aa8@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 12 Mar 2024 16:07:41 -0400
Message-ID: <CAHC9VhTYoT-XrSp4h5QwT5tnzBS6NHG0XSQ=cKLueM0iM0DvJw@mail.gmail.com>
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM hook
To: Fan Wu <wufan@linux.microsoft.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Eric Biggers <ebiggers@kernel.org>, corbet@lwn.net, 
	zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, 
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 3:08=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> We could also make security_inode_setsecurity() more generic instead of
> for xattr only, any suggestions?

For the sake of simplicity, since security_inode_setsecurity() doesn't
work, it probably makes more sense to create a new LSM hook rather
than make significant changes to security_inode_setsecurity().

I'm looking at the fsverity hook usage in this patch as well as the
device-mapper hook usage in 13/19 with security_bdev_setsecurity() and
I'm wondering if we could adopt a similar hook as we do with block
devices:

/* NOTE: these are just example values, more granularity would likely
be needed */
enum {
  LSM_INTGR_DIGEST,
  LSM_INTGR_SIG,
} lsm_intgr_type;

/**
 * security_inode_integrity() - Set the inode's integrity data
 * @inode: the inode
 * @integrity_type: type of integrity, e.g. hash digest, signature, etc.
 * @value: the integrity value
 * @value: size of the integrity value
 *
 * Register a verified integrity measurement of an inode with the LSM.
 *
 * Return: Returns 0 on success, negative values on failure.
 */
int security_inode_integrity(struct inode *inode,
                             enum lsm_intgr_type type,
                             const void *value, size_t size)

... if the above makes sense, I'd probably adjust
security_bdev_setsecurity() both to have a similar name, e.g.
/inode/bdev/, as well as to take a lsm_intgr_type enum instead of the
character string ... unless we really need a character string for some
reason, in which case use a character string in both places.

--
paul-moore.com
