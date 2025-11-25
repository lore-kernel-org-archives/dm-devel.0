Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A34721E097
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764114090; cv=none; b=LHQmX5qeyUx6/qCaGCmR6xahtDvj2/soYhJJgOD7WEcDgt6XXQYgo+WHmJBufRnEcvz6Vnct5Ujf3VY2CVB69J/oUrpW4B1B7dl1cCS+Vb27CYHubpDjLcz92B1qLC1CX4qVhm7tzJfhThaDiD8O5WYAzGvI9BVPZww5xH4XieU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764114090; c=relaxed/simple;
	bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cuwRX7WmICnv/u91P/WsodFx5YPRQXG5mmcOgvlhIrmC4R/PLHD1kEYt45nvgqcM0VvwW753SNVQKr9zfYfglEEurW2IMkwpbGaclo0piWil+rOuE8dRz6r33+9CSRpX1s0XaTSQparmw1Xwrbob9L1GEcUIiPViCMOogwtjw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+23V2U7; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+23V2U7"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-340a5c58bf1so4108238a91.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 15:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764114087; x=1764718887; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
        b=h+23V2U7rYF9Ety/EVcdn7psF45Y8CYz+MvsVDRUjn5qp+X/NHTXiQKhhxZuWOy58m
         GlxGg26VVEzcBkUloSrozCdq7Ec41Mtktxx1emy044aqXc8q2nevTL8UevUd2rNt2/PV
         1JMSySCccsvGT5D1BLojr0ex4ok0xQBvPz3rLXqzQb/c4lRiQHLRlu4RL2eJHzo5lDmm
         cPrRkStJWPizptyMrTiNmUMFJ64OoBdk9OyNR7M1o8VgIII7/2OE+XDGTpeMD22JEv+t
         uJHXyIIUF3y/g9BhaQOlNoe6jIqQLphb3lwaw1JxrFIvdyfB8+yEwfZh76U/LbYVzO/u
         I3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764114087; x=1764718887;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
        b=BOYcLk22eheJraY94VVZ0NmeIJNmQsNm+0MZhyok/iHSkpLVZXpmEQ8eXERdt1/ERb
         7jJyeLDQEZzA9hJxJHfmvoj4N2nQbRcL9jJRqgK3nvT2gX+F9HAoCM9Y2GZodl9RAa7A
         R0zznbfXCABgBixoObk8zxzjiA1fRPyXk250S4c5EW7nDbIzbKRbGvJCAlAnpI1WDwhK
         KfNPQnBjymEk2fu2S00djsrg2reEFjx8DyOdBxundWEHmbJBGbbNLYQvsDFfkfHBa/CZ
         yI0Fplv+hvmI27Yg+dccSXq1xuEJHEFWk+UZPST068JhNgotZX/ykyGO/EQxANyBfPGl
         mR8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5gOKfdzXv0MuqnQVmOdkdx6c09d2hk343sqiuHfsTrA4PTjqGqfHsKtzULLSH0BMumyu4S0mXHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk279WRAnb4fPrHa6OU9CgU1DF+huF+dpTVB381hxJecAShRWT
	AFaY0GfWaPsGucKVM51yWyS/SFK3clIAYAZ++vmyVAdjx7EsUPkINwpE
X-Gm-Gg: ASbGncuyu3wCM3ju3YBcBJ3+q3eDVhF77DPrto0THBJg++Obec4Wl0eF45OJMqutBBL
	HS52ySoP1FHVWlNl6hp3ejsZJqbiDm1OXrr/qQAs68DDfEc0cC7Mng5HtIVy0IMYotjo7q1rNbU
	GVkKzYXQEy31wlboWdTsO0OHET4FcnXGRaIg0Hi28LmU8NuEgWzEWAFhDlZog84auLsuhOnf44L
	P4g3FXeKUxrSLESF8RdgNy+nPTWilA5P82Kam1QsR8Ul3lwFfm6CzORXRIPIrUq41gsnR9zzldY
	RBwl16s6cr54uiGuBiKrwoIwbR8Z0M0WceHRWsauXLrK/mjHlyIm3zFlKXyKMKhO57HjTEyVUOd
	9/7Y/v78YC0aaHIYxxc4vZcjad9I4aGgjsJjpppsIV+017uojh6oVvmC841PDOKrUsSpp+h778V
	fgkI3ODrgT3ED7i9V8N81gMfv9+byAIeu3U+YHtQ==
X-Google-Smtp-Source: AGHT+IERAr6ZaAk8N2XfP1sLPZ8ltdcZpy2by33AewknK2HCsGdLuO/dThk3nDRSpzRLveBkNTfbCg==
X-Received: by 2002:a17:90b:3b41:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-3475ed6ac44mr4636649a91.26.1764114087385;
        Tue, 25 Nov 2025 15:41:27 -0800 (PST)
Received: from [192.168.0.233] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0e6c9bcsm19291748b3a.57.2025.11.25.15.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:41:26 -0800 (PST)
Message-ID: <2f356d3564524c8c8b314ca759ec9cb07659d42a.camel@gmail.com>
Subject: Re: [PATCH V2 2/5] dm: ignore discard return value
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, 	chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Date: Wed, 26 Nov 2025 09:41:19 +1000
In-Reply-To: <20251124025737.203571-3-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
	 <20251124025737.203571-3-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sun, 2025-11-23 at 18:57 -0800, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making all error checking
> at call sites dead code.
>=20
> For dm-thin change issue_discard() return type to void, in
> passdown_double_checking_shared_status() remove the r assignment from
> return value of the issue_discard(), for end_discard() hardcod value

Hey Chaitanya,

Typo here s/hardcod/hardcode. Otherwise, with the split as other have
suggested:


Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Regards,
Wilfred
