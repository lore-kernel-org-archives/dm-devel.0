Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354012D948A
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 19:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533339; cv=none; b=cUTpvf/AN8urFZnRdKNFfYCZ3CO9KpYfHdAmek11YBeQ3jqCg5hT8n+Kmxggmu6Qp/tbRkw6nqvgZxS9P6zvDnX2bMl74ezjdKQ9n99qPvkPvZkQ+N7qWSOi1KNEhZmzZmsqD2TztXGCsk5U2Q+7schR0VDJNRQeUKRMtsCz2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533339; c=relaxed/simple;
	bh=Q2xLzOtW1n0IRoSSdF1kmhg7xdneqEAHtNNLSu4XddA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bEBNuPg8bHOh58S2uT5Rg40OFZVW+nNPVLQit6V1H7LSWTc2J2PT1vYIweUfEHpuZmBIH/zKMHFK5McDcYpoEjtOQEAAeGAnBxgvrKjKMX/wb9SILnjNo+UB3ju8IKniqHMLiA/raGYQ/RasxKyijQVLH++3aXzmR1A6Kw3iSUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=azmNtlQB; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="azmNtlQB"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b9bc2df29so10200885e9.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 12:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757533336; x=1758138136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AtbBQqTC0UbJS9G0wguwXe70pun0sA8T4xOQlPBLnXk=;
        b=azmNtlQB7HEzkB2URTSut9q/ZcOnP77CnX/ZxQ6oN/n7G/Ii2dOMxpnbhW0Rten+a+
         4TiIrBskjF4hgEVS+GvozjUADl3IXLTsPd32uPOTj/a7prHaNhQSYbJKG75LxNJftu6H
         QSVClAE/6v/CZT+5aOejnw2wL6K/8OvkrSApC+4YeJI9SgDJ2jlVHBdVlbjHROfTrTty
         QbCB4uWLhulAvXQKy0P0iU0VZeLix8eqyZFgXZKvrI2cKVtcYpzZrpNO37NlbSnQPeHN
         wZGwGiSRonthXLM1GtE4JhYWq5aJX1iI8tkMncAUAq7JB4z+agS/u4/+DXiy74LPW122
         hUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757533336; x=1758138136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AtbBQqTC0UbJS9G0wguwXe70pun0sA8T4xOQlPBLnXk=;
        b=sdt+qbLWov0gJaFc1EIBlQ5KW/BnuhZNBBe2Y65b9SwuDp0fQHveALrf23k4dQiY+x
         Xc9/XrDjLIaE75prm5LuE06/Pp/yI5Q77xuDRy69SEQN03mr2UOTh8m0pwqEh/dX4mGw
         N7YhYkjLB6oUstFBexIOYiTG3Zp79Fa66QwHGedpr6jtJza/qtU2GICo0FrcgPZPoY+s
         pIGqESQx8p2uRbP5fGZAlxMDWsDOcq1cyWk6jG4D+AYh2tRjyp7q6rTwxJsyn9MEFM+c
         9+n3ZgkssXuQw45ACMVVw6yo+2AehyVdSUc6JwFo1IFmag+65sOBplamHfWMgtMECIwg
         0Yog==
X-Forwarded-Encrypted: i=1; AJvYcCXspMfEnr5ed2WBNcZ85QQ9kpEn++V+Bakf2QF19v/8ccmGXX0IVieJEX0Uj2w8q8znTBDX7I2jQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YygDZTIf+98EnEmYhmiZVwNMk4qeZX6ex3fvwuEBv0c+d4ENKT0
	qopiYsJXtKJtPpSNsM9fGiMVSx7GiO6zq9vc0r0DFI8KQNe/g0Jt3uo=
X-Gm-Gg: ASbGncvA8lIEUfvvllCfFZJp/OUyaTfkrB8TkKi97Pw5q0PN1wDZy9PtQ7PtLUN/eUe
	bDUgOAPb2GWc+5UTI1eLLrgcZXYkzZ8QhBda4zfIsFZGyMtuTkB56+q0V7fWN0zpajEQNUoZXBQ
	pdHd37h4RA5/xFz/mxO99DRR9D9hUAnzXU7W7bhrBZDyQAUSvysG9kkqa2ldWCPffsiM/6Tjsjs
	AmhdOB8h2arPYLlC0RDtFhjEUPJLhZtEzKEnSfF6jr2IiiK2pDb5ciH3d6TjJKfBp8/1DD7KkiT
	VkI9ouLANYu306VWqwaAT8giELdMazHz4a0XdbHyai2v6L2L0Zm7zxa2H2TERKnZcKza0UNSoMh
	r1vH4xT0dyzZJIgMVJVZdGF2ki8kZu6rYnIzyOa1+bEUtWcYLa0I3IhVvSvLg
X-Google-Smtp-Source: AGHT+IEDpwxWCDd0WhelVNutJx3LxN0uC7yWQLIvbTW242qHzmsCPqpgl9T9y+KysI6GGRt9N98hlA==
X-Received: by 2002:a05:600c:c4a5:b0:45b:71fc:75cb with SMTP id 5b1f17b1804b1-45df909a155mr14030185e9.5.1757533336037;
        Wed, 10 Sep 2025 12:42:16 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df81c72c7sm39505265e9.4.2025.09.10.12.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 12:42:14 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/3] multipath-tools: add new devices to hwtable
Date: Wed, 10 Sep 2025 21:41:56 +0200
Message-ID: <20250910194205.145919-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Xose Vazquez Perez (3):
 multipath-tools: add Acronis Cyber Infrastructure to hwtable
 multipath-tools: add EqualLogic PS to hwtable
 multipath-tools: add QSAN to hwtable

 libmultipath/hwtable.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.51.0

