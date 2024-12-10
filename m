Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C411A0732
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733848570; cv=none; b=AIrJ6NCKEI+qYMLhxGAbZQ5uObEV+R92j1VIkhYTRB1Uv4B7SHCjr/9x9bdRZLf07unHkma1O/bguA76PX6+ysca2v+uAbwQ2N9tIA/SOqLZTltrGG/pa8HRZZEuxhsn5yq/vC4tt2b7rCSPV4x1YYfuRLqHobYru6DE5oI6s1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733848570; c=relaxed/simple;
	bh=YRvplP75upgmEAbfBjJak6swigsrgCROz/UFKEZ+VdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHUAeCgaj9EO4oGv71vRPriyXepRWlaNwnjbXqK4wZpVP0tlT+EgjdnbGne+UULMTOXyZi2aKg8uFzSxBSw9jo+xvHwEKNhoMZMt1Z04wKNGO+gCPqopMFbb2FsBef1xl6LpU8lBZ/up7WQ+FWduVqh2ss1n6vZb76iWTGwA60k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSvzolvD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSvzolvD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733848563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4YIQVABvdLTnt0jktjf+YhdkYHNLYH2QkR9WsI0E+8=;
	b=jSvzolvD0MVqO2j6ymho0ebL+SHUd04hi9Xw6fF1SC9f24g2HJxwMnF/TnA8te83wzf0Hv
	cCueZ73iQa4dxdtI7lgo3RJTNq/9+pDc9JgEoFF8ZXab7mbvv0byk6XJbe7nwrMh4DF1Bz
	Cg0VbQYwXwpHYYrbt/BMglR3s92cAIQ=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-c6b5HTuRMeKN8Tc9k8eIkw-1; Tue, 10 Dec 2024 11:36:02 -0500
X-MC-Unique: c6b5HTuRMeKN8Tc9k8eIkw-1
X-Mimecast-MFC-AGG-ID: c6b5HTuRMeKN8Tc9k8eIkw
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-6f013249180so28620737b3.0
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 08:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733848562; x=1734453362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4YIQVABvdLTnt0jktjf+YhdkYHNLYH2QkR9WsI0E+8=;
        b=nh1XQNy7MgYDG7u4WoFQuQP8qZ9qAKcMSzu+BgaN7gIZua0s4/E/TgQ9ob9pGpEpgC
         XvVhKT8u3QyGJ+YP2q9z8/zShsoUskJKPCwa+LZOuSMk21LQZydSOlHyW3UhC2ibXUnI
         bR0TzfV6AZvWFfJ0RayKXa3PiC1UmzamqISUqeFzO9WyzWoKmEqQsFGmwH+PHlJLRzIp
         7EhYH0LTY9RLxV7OV6ln028S806XoxokT3NaD0kxscMtAJOZlIsN9RHE0PpeD8FKONLl
         Rt5Vz3DgYNxXSN4F4UjVZ6oO74SGVAc0ozmJzxQqUxSmjxkePpb2nyvN5tkFOAtFUMNE
         +YMA==
X-Gm-Message-State: AOJu0YzNhBqQnobgpTSYjFmJIEL5Z6ZyF/AvxY2PXjK/1BqjRErDnRCR
	BdX6EofYzfaE/gxE03xeTtj3e7lIwCf3Rm6NenYtIB+tfKRboe+Q04uFe32GqxlJ31gkHNFo3Lf
	ssTtKVuZQpqrQb2DY50n/GTxdpM9zldJazHoiiTnOXsIBMpIa5ckFuEjVblPFnBactBQUidDj5B
	ju9zmr2P7be0JfyB63ceoXWnli/97lRpc=
X-Gm-Gg: ASbGnctaFbSiL8eUvibZ/rhom7leCbeMv4rXeJj9/k4DYUamByGXFsRLfcWTSZNsI6G
	4YLOkunzhPCvLKRxoqo88qfCnSdg3TtpPNwg=
X-Received: by 2002:a05:6902:c0a:b0:e30:e144:64fd with SMTP id 3f1490d57ef6-e3a5dcb0803mr3764451276.14.1733848561865;
        Tue, 10 Dec 2024 08:36:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtqe9iwIvcnyEfSKYAFZdFqGldvG8WxCAYBgem3hCtK2fYhVyqPSEjrxnHi/5bNzMx9IonDtRecIybohbnots=
X-Received: by 2002:a05:6902:c0a:b0:e30:e144:64fd with SMTP id
 3f1490d57ef6-e3a5dcb0803mr3764420276.14.1733848561594; Tue, 10 Dec 2024
 08:36:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203173756.1257967-1-mtsai@redhat.com> <20241203174857.1259403-1-mtsai@redhat.com>
In-Reply-To: <20241203174857.1259403-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 10 Dec 2024 16:35:22 +0000
Message-ID: <CAJ0trDYR6HNPy4fDC4kONTY0uG+rESqCeH5G8pVbBY0Z54Df9w@mail.gmail.com>
Subject: Re: [PATCH 2/3] dm array: fix unreleased btree blocks on closing a
 faulty array cursor
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kg8d6ObtwHzvOL5D3XSQV6sTrSnpVFoR2hloXmGL0yU_1733848562
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: thornber@redhat.com

On Tue, Dec 3, 2024 at 5:49=E2=80=AFPM Ming-Hung Tsai <mtsai@redhat.com> wr=
ote:
>
> The cached block pointer in dm_array_cursor might be NULL if it reaches
> an unreadable array block, or the array is empty. Therefore,
> dm_array_cursor_end() should call dm_btree_cursor_end() unconditionally,
> to prevent leaving unreleased btree blocks.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
> ---
>  drivers/md/persistent-data/dm-array.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persisten=
t-data/dm-array.c
> index c46a374f7459..1c3af717ee4f 100644
> --- a/drivers/md/persistent-data/dm-array.c
> +++ b/drivers/md/persistent-data/dm-array.c
> @@ -961,10 +961,10 @@ EXPORT_SYMBOL_GPL(dm_array_cursor_begin);
>
>  void dm_array_cursor_end(struct dm_array_cursor *c)
>  {
> -       if (c->block) {
> +       if (c->block)
>                 unlock_ablock(c->info, c->block);
> -               dm_btree_cursor_end(&c->cursor);
> -       }
> +
> +       dm_btree_cursor_end(&c->cursor);
>  }
>  EXPORT_SYMBOL_GPL(dm_array_cursor_end);
>
> --
> 2.47.0
>

