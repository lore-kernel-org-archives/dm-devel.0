Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A0B193086
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742942000; cv=none; b=t8P0trRhjeGEd6S5TctMN/i8m+n185sR9u5m1Bk0bdJpueOJoLLJAS0rSEj4TJlHzyUbU3ZBUtfAw4LcCROpKCjf9Wx24jam2EODstvQ/uMeziJqSgD/9WaUzwPHRVCX3NAMLR8qtzPsBl7mXu6FUduGu0BZpjMalbgtphQcaeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742942000; c=relaxed/simple;
	bh=6rSIdakFn8Evp7lA3hWg3IeoEgbUkYuUex6nZW6MmSU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=euLTzT0Gg78IDUStqJvDUlYz79jjLAu07eW8K6I68r6B5zzqmcLAE58aoiDF0yn1z0I78qfOAssb8JRS/kK5GrQD2GIHyrJ3zW8MaNBXfJ6zsAMcLRFR3VemSXX4Qj7X60mmiyJwiKU5a09B3/GRWTqgSaeM37Q/uMQR52bMaI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gwrL8yxy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gwrL8yxy"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf034d4abso65714055e9.3
        for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 15:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742941994; x=1743546794; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6rSIdakFn8Evp7lA3hWg3IeoEgbUkYuUex6nZW6MmSU=;
        b=gwrL8yxyd7gRQ4Neg+jlurx5z3WUOTQyBwh6F+yHCHweaYVaRVoUfLjn/VG2j2aSeW
         zmMUdnjIFoWg06JoN2Z6MtNdz6Ikouv78JJLdv3pSdquP76WZocu6yRcRkhZtebpUMIl
         PfIEzTJddAOIFSJFA4j9XfqtuJh70WzLDyZRHPX1PuNDEDkPz/mI7KSXJ1pMpfmkCkgN
         NDcYwrvgyaDhP7lZfcCKY7BLGeWku4LZ+EI/vZLs+i7OI+CymkrJ7cmeqp4kgoq2/N8W
         8yWPKEnfqaKKdxIRdsjqXX2QFssKzCWSiaDyuWLKQHWzZuTngRncSAmb5fqp6rX7ypAq
         p7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742941994; x=1743546794;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6rSIdakFn8Evp7lA3hWg3IeoEgbUkYuUex6nZW6MmSU=;
        b=m9YXF2V2XZj0fhS4rbLBDQ+Oy90+qX440YpvkfbvOtH0qmYGmUlr0GE3NsNwLXMHfp
         fx8AkeGst9dlUtFGXl9cWDAG3Mnw4E30RQ+M1eRmcIilZ6GydEoxJ8E/mS3SX7p6Bqx7
         XNTIriFj8Bj93fXB+pCYBHC4imIkTms+nLt6SMU2ntWVXholxaIQp+h4PqnFONMOYqyY
         XAPm+wXA90s72opMeBiooYGERJjuUQyAM4t1PluxH2YrC6Qt59PwXzbPRU8GE1cpra+B
         8cbpy9qpP79CdgCTBksD6jBuZKJGgWAOhjJmMAW5Ps+upQTYjUrLQMYODBMmoyQFXeMS
         3hIg==
X-Gm-Message-State: AOJu0Yzpx4eJ9jHBqlyFNKsFwDvX7VCX8Zl4xPOAKJ93CFYPNrceqYkD
	FibQbdvhiBByykJBjCUAOpSCyuNvz0Qb35unr0ebWt6Z/fml+4haKOY6RfCNqVEMubRcZf5//R/
	O
X-Gm-Gg: ASbGncsuqDwCb1Hr9zHZ88dQQkCN7dMXMsp7doVkhgtRw6AoTxBUjyGt1sUIV2jvNfR
	528bw6nGndYQSB6F5pEUulQn9WzgEN9i9IA65UNLTCZJ+NDE2ha1YwhKu0cJ4kFi44DHqcAkzu0
	bouLr29YlDWi02u7qEhcxWsb0crkgBt4ZEGfLqmRfRmkRJL+yIErYUT/Za/OtxNkJOB+UIE0Xt6
	hKnUh91XxLZVIsOwzWIeyq7KbSYtmAX+gnjfqMp6ya/b0oyzZsHi3Pv4FdGJX2NOJCPjPK2SzUb
	9Lq4GsCFLI+iNPuK3kMwEF3I49w7r2mMyHTdCZawmYZ/YNAQbF0KSj/1SX+jBfXOfVh6waPRl0a
	RUDRJFbVXmjFvQvbMH/+6UniENStaiN1Fg21kxQkrB2HAnWwl5wbvyBOwQ9wghnQH+qoos7HIBT
	1Wmbg=
X-Google-Smtp-Source: AGHT+IFLhXaO+zP1ixwDwarrRRkaZ/L7liws7bI64NUZikKgQWPnqO/LeDsTXDQlc52GnTwN3evwiA==
X-Received: by 2002:a05:600c:4ec7:b0:43c:e7a7:aea0 with SMTP id 5b1f17b1804b1-43d50a35fb0mr131010865e9.26.1742941993860;
        Tue, 25 Mar 2025 15:33:13 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9efc9bsm14668405f8f.87.2025.03.25.15.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 15:33:13 -0700 (PDT)
Message-ID: <99b1d67f46298eed77b2d77ec396a1b0727481d0.camel@suse.com>
Subject: Re: [PATCH 1/3] multipathd: monitor new multipath dev even if we
 can't update it
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 25 Mar 2025 23:33:12 +0100
In-Reply-To: <20250324205504.2523493-2-bmarzins@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
	 <20250324205504.2523493-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-03-24 at 16:55 -0400, Benjamin Marzinski wrote:
> If a multipath device was created by the multipath command,
> multipathd
> might not agree with how the device was created. ev_add_map() can
> reload
> the device with a different table by calling add_map_without_path() -
> >
> update_map(). If this reloading of the map failed, multipathd was
> simply
> ignoring the multipath device, even though it still existed.
>=20
> One way that reloading can fail is if a path that multipathd already
> has
> initialized goes offline. If a multipath device is created by the
> multipath command while the path is offline, it will not use the
> offline
> path, since multipath won't be able to get the necessary pathinfo.
> However, multipathd will already have the pathinfo for the path, and
> may
> not even know that it's offline, since the path is an orphan. When it
> tries to reload the device, it will include the offline path, and the
> reload will fail.

Am I understanding correctly that during the reload, bdev_open() failed
in the kernel because the path was offline?

I was thinking about my recent tests [1] where I'd come to the
conclusion that reload failure is hardly possible. While I'd realized
that "trying to add a path device that was not previously mapped" might
fail, I didn't think of the scenario you describe here.

[1] https://lore.kernel.org/dm-devel/ee6fcbda31fd1f13969653782417fbed748f5b=
c7.camel@suse.com/

>=20
> Instead of ignoring the device if it can't reload it, multipathd
> should
> just montior it as it is. When the path device is no longer offline,
> it
> can be added back to the multipath device by calling
> "multipathd reconfigure" or "multipathd add path <path>".


> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

