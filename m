Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DB85914E
	for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710249138; cv=none; b=cDfa3eHvsm6uE9N8jKm43M6kNO4ZcH8n9APFLoH2zQn67PbKyTtEFuyd5pprwh8ZwZsyFi4Sa6K0z4LbPlw7e3M4/wt73WoagTL74I1lQYp1iDdAEE45Ke8U/8ByEPCd9PccIHBWPRz13JtFA12VqCZl1lmi5zeklx+ytDm8nLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710249138; c=relaxed/simple;
	bh=5rt+RWbBJPhAUl1uqDwh5UWlve/OPz4PeCvfGqj3MHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e/zlkqerQTb7Qpi6qkoKzvhwiFb2z0A4/v8a2Bev2Qa1oQl/xsJ7jYW4k6R1K5ytQFe+AIIbk80CcNSrpSqHHlQu/r6gsK+SAErWltzVmCv+Znid2etSCIljmdnPBYn8QASeq3iKwb4DtU5gVFoHNHrPj+KoCgRQPTv2bDPwy/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=B38L9QAr; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="B38L9QAr"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-60a0a54869bso30250477b3.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 06:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1710249136; x=1710853936; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGm6l1YRLh5BPGXSeJhTa5Xkczn4uT6yuT0rED+ytkk=;
        b=B38L9QArwuM3zaqtqMJ/lSQw3AOOMHP3BK9KaJmy4eq3SKrOXIwCkwariHF6oZzItU
         lmlmTOY2fmDiufC+peCFuyXX4XWNqZvdAYPdcHFQhwqWAvms1D5fqmp6kyPxbwmr40OG
         bst3X8QODJSBuGt+y3FQB97TJhawZ2LxVtVRVJw/ToJ0qkDLcZ2UjkV/v7m1EexRDXym
         fzAnzX6Q0NWuSFQwUeL3+o4bqQjU0vNRenw7bKGgDoWKBlPH6oBe/94UdbBATAPzJ8L3
         qxZnWJ+DkHwOeH/xaGdCHD1408wzGNRtbNjRqv4yupN/77Y7IKXD8nivx4NcXq/xSBPv
         p5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710249136; x=1710853936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGm6l1YRLh5BPGXSeJhTa5Xkczn4uT6yuT0rED+ytkk=;
        b=r5XAkO32QoNlHm4GpAPbnlgWPV/qVzZrurcktSVp9mWNUKH9RlVJolFTRmY/q9u/WV
         o0osP4xyHOj4qDQgd3i4/r2H1WVbw9gi9U3LzJpfg6DAJexogPFII7Bk0UgSdv4jOLbK
         W1r6bpLy7ZdSMLFpQtpKfhhIiT1AxYVjU1BVVwVI0PZtWaAGbwcfErt9KNNC//8dVwgV
         LqDasowUWgWgEXtJz0Uv1/GT42hhhXdpXBGoyO4lFni5IbLyDq2zCiMTU7rMGgaCrUiF
         gM3DIf9+XbqCbjc2KiiJxeXDyMcksrMYXS1lxt4Wb+IXxH40FUK5ETlW4DxvKmA28YP5
         uEIA==
X-Forwarded-Encrypted: i=1; AJvYcCUhxVZD3VeFEh4KZLoLz6hocBFnlJvA5dc/y4bfo824GNUlhN+3q+ZW2gUdupYsPkK4cYcb+aYxDkdOA+wACiNdvcDM1SMa8gE=
X-Gm-Message-State: AOJu0YxwgGAPCO63r6OMYqTzbwUF/yQc8I3i5pci9+7iYkNxM7Iw8VDW
	CX28Wlg9IR7kh56XqPKH2XiQlFn08JBwWSv9Vb8KdIlI3s8VzwwQU6uG9YMjqdgMA9zruWvHz9t
	NXF91/nj5smkZzJso1l+c33Ld69PifB7N80kY
X-Google-Smtp-Source: AGHT+IEdiOBkJ+adeSqv+rNybEPwNkGGa7iFCLcf94f4++BXPp1TK3JUSZqCbU2Yvqne0MvrzB+F7Mt8oGlgCeTEfL8=
X-Received: by 2002:a05:6902:2841:b0:dcd:b806:7446 with SMTP id
 ee1-20020a056902284100b00dcdb8067446mr6722695ybb.1.1710249136161; Tue, 12 Mar
 2024 06:12:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain> <20240312030712.GF1182@sol.localdomain>
In-Reply-To: <20240312030712.GF1182@sol.localdomain>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 12 Mar 2024 09:12:05 -0400
Message-ID: <CAHC9VhSSWNa1qwZrWtj-ERFjN9QKR7fz17yb9903P_a2k6ewaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM hook
To: Eric Biggers <ebiggers@kernel.org>
Cc: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 11:07=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> On Mon, Mar 11, 2024 at 07:57:12PM -0700, Eric Biggers wrote:
> >
> > As I've said before, this commit message needs some work.  It currently=
 doesn't
> > say anything about what the patch actually does.
> >
> > BTW, please make sure you're Cc'ing the fsverity mailing list
> > (fsverity@lists.linux.dev), not fscrypt (linux-fscrypt@vger.kernel.org)=
.
>
> Also, I thought this patch was using a new LSM hook, but I now see that y=
ou're
> actually abusing the existing security_inode_setsecurity() LSM hook.  Cur=
rently
> that hook is called when an xattr is set.  I don't see any precedent for
> overloading it for other purposes.

I'm not really bothered by this, and if it proves to be a problem in
the future we can swap it for a new hook; we don't include the LSM
in-kernel API in any stable API guarantees.

> This seems problematic, as it means that a
> request to set an xattr with the name you chose ("fsverity.builtin-sig") =
will be
> interpreted by LSMs as the fsverity builtin signature.  A dedicated LSM h=
ook may
> be necessary to avoid issues with overloading the existing xattr hook lik=
e this.

Would you be more comfortable if the name was in an IPE related space,
for example something like "ipe.fsverity-sig"?

--=20
paul-moore.com
