Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717A4541E58
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988708; cv=pass; b=o1B/dP5BKIBjuAdzuLVDyTfeTgg0h2STHa3gENAZ6bv91hriBdetWAjNmfHc9qpl61hK2kUl/OBAh5hErcyIbzWXibJwQCXVTGff81vNJDK4ZUk1IL5c/M5N2c0unnYlHaGqnAv7DCwsw2igKFF26Syy3RCiSaWLgjNbEAcYb/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988708; c=relaxed/simple;
	bh=Ht8GLTCoCKkoVxwpD5KYA+Pz/0xMc+C2begOQBfsCnM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LLiqn7fiCV028xCS36qWImGRmqKGHD8E8ul0XT/YwhFwK/eIjHIbQKoitTIwAAsxxgLGYPA7CR2cWlafLufoJBAP5vrpICWnVUcy1eunHeCFwMXkLKYNiU4b6Me7mJa7auAUZe5r//n3PN0eTYSWOPjuAVWvjrpELwwi2igbb4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3Io18GN; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3Io18GN"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1cc392d8bso1443146a12.1
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 07:38:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791988705; cv=none;
        d=google.com; s=arc-20260327;
        b=qKkEQMfmvsBtiNVry92k0iC8Ak/FGRWg3Nd63LFxvXwXrrI3VSFZNPab943hbMmN5Q
         lG5S7XyxgteSIo0lsbQjTbbq4O1YPG2Rl4ZaTg7qUfW68yQmz+UlMsW15HYmMD5MhGbt
         JTQolPSPnEhKtseKJMrfBogga4yMoq+TtJx4pA3aVQ51hGC90jCmN38IJQotQ5zY9HOF
         wNL2pXcrs4rqMe2fNO6ImjfN8xWZJ7btLQBqIIvvmaqkklffQkwBGwqMLZRaLGL3iNZ2
         YYPEB+YNygV5BXpB0OtWD+jELyz4BpD6SXLKq9ECwFMVDfTOaDR1JW8/WAwH4W4U6X7p
         Mz7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ht8GLTCoCKkoVxwpD5KYA+Pz/0xMc+C2begOQBfsCnM=;
        fh=fdbU1juhz0wm9l6Fw7paoqsNAJaxyFFcLSCL75v6vv8=;
        b=ArSQVttgjkZ5LXIsljaXgOVBg1aZGX5fqkVd3fGs/iU/ZsTB0VKRSXhWNocSaBHwRU
         BfQvWs+HSrOeNh5jFhrgq1QMD5K3C4B/b/YBJV4Hfpn9FppPlExviXuo1cVplWvyUMWc
         /yN/iC9/Lg9jL/xNypNjER48aBGwY9vO/ebb3afNAhrmwgK6LGP2svziFMnotKQNLbux
         VR2b5oTuVVYwn9FrMONvShS7GH/WTHqnTynguC3z2+oZqhO0eFu494aZLFJXVbBkgrAW
         430HFXQUAnFSPTnx6wrDan0R4x/YGwwhL5g6Q4cuEgRQyigzPFNml0nGGKM4gcDcdwZ5
         mCdg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791988705; x=1792593505; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ht8GLTCoCKkoVxwpD5KYA+Pz/0xMc+C2begOQBfsCnM=;
        b=b3Io18GNXPeV4WIBEnuOMZuGzall0FPenCh6j541+CP1zMqj/wEzth3kS6D3Fw/OzR
         XOc+3s+jXnZsyRqW7MCwPQglA5o0Rlw9TYs5do/zXgUcO7cf+MmAgGkaIdOuo0RO4rYS
         W6CNnvmVvYaAze1UoBMUbmvIRWOCTUskoWFNnyNphHUp3AXbY3V7OIq7MwJL8KaF8XEF
         zzGA2KKW9x2L+8etJ4+cx++O8npVb0v7VevgjvP/u6Wktdxm02AtCvrJQhw5GuDXjadS
         T1N8yqrX4wdCMxY8D39BGUzCtc8oNFGAcyP3fSLKGh2aKukbvXwirzhtGuMCc6rP7IHd
         5PrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988705; x=1792593505;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ht8GLTCoCKkoVxwpD5KYA+Pz/0xMc+C2begOQBfsCnM=;
        b=SrWTiuNjnhjj7tHMzZrL8rnV947Argx+iFjkWCgVLtNO0UFopXMjJoXk8YDqrnICBy
         TH2X4QFEH0fQMEyeW11jB7JKmiOpU6Lo/mFPRea4QHjQjCo6pFCX5GgqyhFeaUa1j/C3
         x4wMDdCxgXlxOTiC7Q6J9GbqVezAvhWzWNaO3OdsvbVEU8Laq6S6pD1/N9QSpSJfSRLe
         QUfh31iKeketTV6JVi5FpRgnXn1iUUQEswVhNpyUAQa8eJRpAW57tWqx6kfFaskz2eiO
         L8riGMRJ63qAI1BGpO8ddoCtoT19ydOI9kP5FLXXNC0TikDhYGAbUYnGLEl3fOd1N+Fv
         k5OA==
X-Forwarded-Encrypted: i=1; AKwUvBy4wOw1dM98Jc9OzmtZsdzUyc/GgnuQ4OEPQ7nu8YUX4SkX3ebiI/tz2S2xCkNU+SQP9YD85mD85g==@lists.linux.dev
X-Gm-Message-State: AFq9FYLmKLfwofZNBAERJW/4l8WXqtErMGihC3myax2njAqUT2MaEx7b
	WhJ99XlVwcLeCCq9Cj8YHySe1tEw0Vkr4+fD4jVKMNzrmfKYu9lb0oouVUzFDLxKR5UvHMOa/EF
	4u+x81zNhFH2Rziq+WIv2zOqp0zu1Fg==
X-Gm-Gg: AYBFou3SalZM0FAF/8PtMpgp4lGWtwl0LXBpFiaoK77ZOobxgRIaCNPG9EJCyss3YgJ
	NLsel7jBytaJQtva0wa8UrDuFavs2Sd8KvWbEbUsxwC14qH5ycl3Bi6TYBxXZvz2KiUXUMFfuiT
	3H/IaRpBAp2wzML6XFA4Yy/cFCzKs+tiFxZClH7/cSq1Z5JU1lItK9jqWCD/M2FML6RvoVG4StT
	iW6iFPQ7IwEBhAL+09jHk7XSeihIPL4h2C5Pq9sB9pGZnS4lRrXhpOQBQsOsMU8rbHcwVVu53j7
	bFtLQuWQB9vU+xZGGM/o9TJnDM+kPdInvOQb/XfFV/SLA6YLz9Q8+0TrY03hYlMyYrA4L/v1nsh
	YFmk7uVDHisjXd1Xf8qr4OFw3vqmPdPBr+2P/HsY=
X-Received: by 2002:a05:6402:1912:b0:6ac:b9b5:8e8b with SMTP id
 4fb4d7f45d1cf-6b17c2a3670mr12616709a12.15.1791988704432; Wed, 14 Oct 2026
 07:38:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1791975048.git.asml.silence@gmail.com>
In-Reply-To: <cover.1791975048.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 14 Oct 2026 20:07:46 +0530
X-Gm-Features: AclHuK8DZ9QwF2AgJ3SDr4lT4xl3Cf9evBnlWqjNFK8bj0mT2h6JXCYZXSbhb_A
Message-ID: <CACzX3Ases=5auovox0XFNheDHY9iNmxv2BvB0dugC-W3mnjGLw@mail.gmail.com>
Subject: Re: [PATCH v11 00/13] Add dmabuf read/write via io_uring
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
	William Power <william.power@intel.com>, Matthew Brost <matthew.brost@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> Tushar, William, Phil did a lot of testing and experimentation on various
> devices with previous versions of the patch set, and I've received lots
> of help from Anuj, Kanchan and Nitesh with investigations, testing, and
> patching. Earlier benchmarks by Anuj for IOMMU optimisations with udmabuf
> showed:
>
> STRICT: before = 570 KIOPS, after = 5.01 MIOPS
> LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
> PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS

I've been involved in the development of this series, so I won't add a
Reviewed-by tag, but I tested it on NVMe with both an AMD GPU dma-buf
and udmabuf exporter, using the liburing tests and custom fio plumbing.

Feel free to add:
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
