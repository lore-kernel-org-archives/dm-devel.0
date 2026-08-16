Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8495D4B048A
	for <dm-devel@lists.linux.dev>; Sun, 16 Aug 2026 00:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786838499; cv=none; b=Ab158r8P4oe/5BsiCp+KgNiGKdbb9koom8XxmD61LSDfaa6/GaGEs2kEA/iqxiE/Ptm3Jl4vpMS/bjbyCHx57o6P6ci4j0jmP7gbOlB4+iC02lDztCN6RnqpjtiVcSqYBuxJ+7lekdfwu0+x5gO9LRnkyrmdGRVynpTOI5LsTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786838499; c=relaxed/simple;
	bh=GLv7MLH1JWc+5XrUg1Z1RvY7w8aG92a4ZA0fo54R1DI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KUBJYTuHl5G0fswrJrZFwhR8GAsssWbishK0Ug9VUKLyagtMzX/WqUl2y/SShghLu9q57ibrfNcKXss2SoJYAWvpvDiWQ33+QvF1p2eCU3tpj1xs5zWtgcDQBnbNFfj5eBdA4EPSrsBuE1ONK9MxtCUHZy1SP/n1FbzVbcsKRi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0RvEWBz/; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0RvEWBz/"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4472500e25fso1356466fac.1
        for <dm-devel@lists.linux.dev>; Sat, 15 Aug 2026 17:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786838496; x=1787443296; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZPPcb+6L1tSSLsANqwKI7loeM1EwHu96h0gKbDhNEvI=;
        b=0RvEWBz/x5KBddLcdXAPltYLJYgtXvYeKZ5wd+eSyHozb2IyEpzAXjN5k/nioan9wH
         MR7/k/385B5JBVCliYdeW9VSsy4EjVxAIfA6YX5DzbIXEuwCWuO5A7FkQlnORzE2o0Xc
         O/tp7salVwnLQ6Sf4gT1/lupZz5DJKQn+PrlFMVztVP4jW5vQ30zmNTM8L7yyRnss5Ik
         om3m29nePAeksM9K2Pokn2lM7TGoLbQjZpGG3za28Amf1n3TBy+8mtYSDHv3vG6XNuEw
         aZVzmMEY9lKBvc222nzf+bNORgI4kLBlpcb5hN9efqZ7BnWSbZX/ZF8lnhl3G4owPtP8
         2A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786838496; x=1787443296;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZPPcb+6L1tSSLsANqwKI7loeM1EwHu96h0gKbDhNEvI=;
        b=czTTLlKCdGOz0pBVjuua3oeqY6EvAzbAHzNmKaVi46vG2/QI5857v8hw0FajHbAZJw
         qrIbatBoo1j4eyZ/ggSNT84GF2HSXefVjciVNRgmxlKV7i0VfeQ+1Pgld6u0mOPV+Yhm
         n3rh7cjnhM3fpWAcgbYpRbfSgMMD4CSGkKwTi0y2Ad+ehfOA4pYzc1u4xsK8OHsismqU
         mrvsHJgjgznk+P1KhFg1rEmgUxzyehOb3ZFEloqP5gCbRP3Iaz/JZHSHFrXDHYf2N7G+
         kUpwrRYdwPGbEQ1yImcA4j2UBMVrTyuD2uI9r7ymAehLmLylkv9O1dKdWRCLe/zN6gVh
         VBPg==
X-Forwarded-Encrypted: i=1; AHgh+RrqG/k3qUjUx+YpArwtGjeZuFSWreD1eKd3fiAdwkppFUG8GGy1nVyENoHvVXiJv1BCYDxwDc9ZHA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIzwK9y6Rv+ayeKGMCVo02TvlUF8RFvREzFvyy810Jp6aZ1Spy
	zuzpAGg5HJJZjXa2vAPQkqGpNA/XCsEmp57ndLeUp7jWazfdESDokQGpuybXGA2PNJk=
X-Gm-Gg: AR+sD10tIpnpzBsZc9hC08fNUJ6tp4TIAbY7rI7+wGED9fGYWVnAQLxw0SUFmm4Q3xG
	ItlOgBO3giOGyjxe04l2SFHFTHjnx45Yxm2PCwOvmEog9+UGBpzo7wTI1PzEXiOGPzFkp3IZ6WS
	FOV+RYNxqzFXoz0TCQvS7Rgf0rTGnSx5nBX8+0uctCI1uIHI0bp9Tyj0Srlj59n91junYvltAkC
	pzXP9FGMRryG9REucnU2wB9N3EZBxZBn9Q4bjeb22nCnrWTUukQmEMvYtmgK96tAU8T7lq4tSgC
	hBtPE9/Bx4YVBrk+nrfCJbeOwDtkvRWWf5QJIeB/AU/PyUMbkSuMdpFiueyAKV7YJuNDCcJGIME
	72f0trmcQ09/hyhhbfoYoOc2UkZhBtg6sqEDdoBZKlCM961F7udqp4tGPXCZ8638o8BFqiXt94T
	K4EadN5SFO+48kFbLcuKUtWpqkFUWt3OXvHS+Cykm2YcpEdxXf/eFbCfp0RiSvmEJnqNU4ClHhH
	UcczDBrmI8+dCtIxkZ/kqSpWDcnQxHv1Dc1nEGAOQ==
X-Received: by 2002:a05:6808:23d4:b0:4a4:ddde:5207 with SMTP id 5614622812f47-4b24198f27dmr12801839b6e.8.1786838496365;
        Sat, 15 Aug 2026 17:01:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b24d92462dsm4347729b6e.5.2026.08.15.17.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 17:01:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
 William Power <william.power@intel.com>, 
 Phil Cayton <phil.cayton@intel.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>, 
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH v5 00/16] Add dmabuf read/write via io_uring
Message-Id: <178683847578.1984298.10059277109543676478.b4-ty@b4>
Date: Sat, 15 Aug 2026 18:01:15 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1]
> (from where I borrowed a good number of changes). Later it was brough
> back up to life by Tushar and Vishal.
> 
> [...]

Applied, thanks!

[05/16] block: move bvec init into __bio_clone
        commit: e228404b05c8293f6a1286856e49ba3e55da1933
[06/16] block: introduce bio_iov_iter_set()
        commit: 8b8755e00847da1027fe6624277e43d289e2300e

Best regards,
-- 
Jens Axboe



