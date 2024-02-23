Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1873128388
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710163; cv=none; b=FZKS3/uaRzBlixQ4dQO5WqDZtxOxnHRiWfUtdlZMAfKtkM+B/RBiI5bb+k3IuZhOYqp8ytd1jOyK+aMCermSbxEMbrAjFNXiAg82s0IOseIvr1u6v0Dsyxrbl5vC+1XtdqvXIZnwhJna8ZDJF2Cu7zeQJPMQplkma/zTJwDOJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710163; c=relaxed/simple;
	bh=jeZbYS+BcOd8N6/JweKPQT1XTcIDiakeVKNyuTtEwxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JbvIG4J3nmIcpsTiNYmpuQaWzmn3CR/GCV+PXOEZbcG28xncpctwjbVBpeCvMcolm2xA93NKEXY0O7EhXcYn/dakEL8Coiq3XAYg+6baf0Zj9CKQPKd/tBici0Mz37fOVqjd80xIYAFY7ivXlq5L/3aFU8ZrOl32uFCiB+nhpCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YR8nHtZU; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YR8nHtZU"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5655c7dd3b1so1212441a12.0
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 09:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1708710159; x=1709314959; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uYL2xp6+btxz9vbSsFSOIotbONXDjrZtHKQ6wV9cybo=;
        b=YR8nHtZUzw0+80YSAOr50Nyg8+t5+m0dSJYFStL0nVA4/lDXvdJbB/3xVTmGjJBzas
         0VS/QMS0SUdmZZugShia9zlX2AYB1lvxcQKFk2DgClqp0BkGl0LCaO/AOMsyBqtkeirS
         ssm2fJ2Xlf6GwAbImcbHHNZhbvhvuJqcr/h/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710159; x=1709314959;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYL2xp6+btxz9vbSsFSOIotbONXDjrZtHKQ6wV9cybo=;
        b=iErnY4Xz0yvnTk14SL7xIlA1l6gs3Pmmg+8QelOXKrdH2rehBT4WbK5GFoh/VQ41Cl
         YMBnp/vskUx7NpLwiblH5w4yegJ/+nFOZXWx/M7nAqfrKhhqeBNPztZxnnQzqTkySBSw
         G8tqjDOEQcad82OnGEdoQrDGBvsvc1t//VqKvXa90bqZNC3Y4rQkZU3NEieQPZbNqBzw
         VFeNAt7REytZVf2l09Kt6oVElnaCgjPF5nyLaVCIr0dpKkqdFnr6zeXRJjmGgMghTF9S
         9x45Y1vLlNOGrIVRkzUW4EYhyURDQv/85wlh0nHyZCdKV3pzyJ235JpwtRO0Rgg0+nK5
         MPBA==
X-Gm-Message-State: AOJu0Yx7vaH7DBNQ/iAjy+moR8NVkJ/4ODNeGA0zVjMGoNkE8Jj+kRal
	O7qjOaX2PPlHLOlP0FdK5VL6xO0n9oroxeLk5agrPIHHjtbTRtlEthgskfe6NUAoi2g7WjMoeYJ
	Xx7601Q==
X-Google-Smtp-Source: AGHT+IEuspcnxu22wF6m+c/tkHCWloMi0JUCy8QgGV2uHq0sDKVk2Q3S2Bnwn52RdnRLm2idJ7tG2A==
X-Received: by 2002:a17:906:b886:b0:a3e:719b:c049 with SMTP id hb6-20020a170906b88600b00a3e719bc049mr374846ejb.28.1708710159023;
        Fri, 23 Feb 2024 09:42:39 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id tk1-20020a170907c28100b00a3fa5cf6d34sm1245226ejc.141.2024.02.23.09.42.38
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 09:42:38 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a3ddc13bbb3so100244566b.0
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 09:42:38 -0800 (PST)
X-Received: by 2002:a17:906:fa8d:b0:a3f:f8a7:e1f7 with SMTP id
 lt13-20020a170906fa8d00b00a3ff8a7e1f7mr456458ejb.5.1708710157949; Fri, 23 Feb
 2024 09:42:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZdjTMZRwZ_9GjCmc@redhat.com>
In-Reply-To: <ZdjTMZRwZ_9GjCmc@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Feb 2024 09:42:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=whmiQC_F1s1bWmOhM8csz_zxL32B=sPGgaz1kiTK_T2iA@mail.gmail.com>
Message-ID: <CAHk-=whmiQC_F1s1bWmOhM8csz_zxL32B=sPGgaz1kiTK_T2iA@mail.gmail.com>
Subject: Re: [git pull] device mapper fixes for 6.8-rc6
To: Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Feb 2024 at 09:17, Mike Snitzer <snitzer@kernel.org> wrote:
>
> - Fix DM crypt and verity targets to align their respective bvec_iter
>   struct members to avoid the need for byte level access (due to
>   __packed attribute) that is costly on some arches (like RISC).

Ugh. This is due to commit 19416123ab3e ("block: define 'struct
bvec_iter' as packed"), and the point of *that* commit was that it
doesn't hurt to mark it packed.

That was clearly not true.

And honestly, "__packed" really is wrong here.  Nobody ever wanted it
to be completely unaligned.

I think we might be better off marking it as being 4-byte aligned.
That would mean that instead of __packed, it is done as

   __packed __aligned(4)

because "__aligned" on its own only increases alignment (so without
the __packed it would stay 8-byte aligned).

Then the only part of that structure that might be unaligned is
"sector_t", and that would only matter on 64-bit architectures.

 And very few architectures are both 64-bit _and_ so broken as to not
do unaligned loads well. And even if such broken architectures exist,
at least they can do the 8-byte load as two 4-byte ones rather than
doing it as byte loads..

Anyway, I've pulled this, but I really think this should have been
fixed in bvec.h instead.

Jens/Christoph/whoever feels they own bvec.h?

                Linus
