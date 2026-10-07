Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB834402B
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337226; cv=none; b=V4tNHfGBfW9b+q9zzkxjhuIJ9yKYyOQUl8hjEaGuFBFZwdShLE7U7nG/v7nghxK7i7k3WTcadIYBxftFrhMhZ64bi9T5fG1ijn7B1teA2s2wk1lF3k9KcYNTYUcyHrLB/H2TbVU8ESHp6rqMIkQfNolnQPdKUcrWnWAQWSgdGNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337226; c=relaxed/simple;
	bh=QqRyjMBmDnzUZnIY23vMQ6AFOZE8h+6eq2IWzLNGPW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LkkttAuv0BtosY317EoFpgr76WztpbA/J2Iy67pj+ZefcEcmDzWGYh85wnW7btIKCvfv/FWPOes/x2Zfts3agfBsx5UmBfunasp3YyS9i+G0U1ipPoHesBiXrDVK31r/QdNp+bOj0u3+tfPtVFq+ctgfovt03hy8SGkJ/Kxs1TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMJxAMHy; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMJxAMHy"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48c5358fc28so2038934f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337223; x=1791942023; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HDM/IhuAZ+mZ2yb1biv87C3WVL00TVKLh/5oVRCg27Q=;
        b=kMJxAMHyVBWRsGju1DsqvMigSWq56ENAjVh5NHW7Yl3f0JMqwpX2k1L4itN3G/BKZe
         /m0MDP8/5xOM9fuV0y7MLVzryYrrYrIYEcFwdZdISrDt3BCO4Lwxa1dFWZlD6coNByCV
         ryDX+0trC8Kva0wk97++XwvIAwQ7pVInkz84zwPBXcR29Jvt9T6VRdYzj+2Gu/RtrrYZ
         1UIdRPuGKso4zezrlUbx7hX2xykS0tsLTrxa71ZBIIuB0M73ARztVqj0zI1NaA9uiLY4
         PU5PiI2P+gGMz6dd1K2uZHk+AMHsNYoKhkO/g+vYNVQFSj232/M4KiG1AzXUZs3rottw
         Y0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337223; x=1791942023;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HDM/IhuAZ+mZ2yb1biv87C3WVL00TVKLh/5oVRCg27Q=;
        b=ax6TVBk+sZ5OQ7lisAUIiGEmShKcDeWG9SbjLNze7UHlTiVRoWILs7aGiGRU9CX0NL
         SEd6gJXMpKFkCvtzLltEub2yZuWtjpQ9c4y3yq5adYlluaVpwjmMJNuWyB4a1kQG21s8
         URX/QktYAwHEvxiFuzWKCQHX9ldBupe+HW/2eKtvkKyaUxh+aJUI+8JVi0z4DV2NG2yJ
         VGpuYZ4yiWUP4pcGS3nPrHQXkgCmp+eywlAWz+1jcwRKFy6EjSM70LjZ0XACY27U91bm
         gVdbWSPe55PZyRVrSB0WPJnXih2uk/JXjydaAqA4bH7gnkoihx38klbJkjjevyWQxEKE
         PIoQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzkANiiKgY93ecXLdw/rtIlC/s//niPHSNs4FbH6Oe56PcSV2HGsz5Z3I6vaRPao3sOgqv3KtTSw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIOLzHRG28gPBazSqjQblTymfByv/IEaaTNnCbhTsA/kVSnZpkq
	y28c5vZMgX3srNmdIzP+yjKZUZEzfg0b8px+HpA4H9MKtLzR9Q33B8Xz
X-Gm-Gg: AYBFou3mvwGc2Ms7YyrsiVhdAVvKDFwn2uqkKt6Sh3g9yNlSTd1u7wgvooIgxMdze+o
	Qabp/JulPBA/h9groUAhss8TN3SX6B+BsPnWEL0c3YRrh4PtXRhGS0lND6jv0y2dLJ4P/ntemEa
	GzJUQPzdjsYrm81bDRAY/hcsuctPwJdfL9I803skZbDY7LIRMt6u/fKXJzFUnRRt1v3n4AbuFSm
	jTB0CCtJGlQGQT90gHmDk7+l/JEM4nvl0VZhAyOlfcU8hBPsThpFaor/xls+/oDnT9xndTp9i4W
	cwVimV5D/BaswLMD8KAtsTUktIW4elQrke574kvp6yIrbqrtE8S5Ivy/usV7nm3etfAGCsJvLbw
	tHvB17ntDzgSTf81kQmjTrtCMPEVibpDmYrdu+pFj+/TsuV0PNpxU3EpN5FEvjZ5DXXRmJx7GnJ
	p4BVe5VWAOCAcozS9iuTtZpTsdNVloAtcUZBd5V4xlexVEXRtg5O/v2QJJct+2Eu1NTLc11oSSS
	XZ/bHfdQeLXWRYgjx0Svf0i+lOIZElhuTFRUvA/nF54h9bg0qLOcvd8T6pSCKiw2MalgIWjm5z2
	1m0Y5jDqD4scTG/+kGCs/s2l66wqpIUvb7Z5kay2D9RZtVn5
X-Received: by 2002:a5d:4b10:0:b0:488:8546:d0b2 with SMTP id ffacd0b85a97d-48c7289605amr1226256f8f.51.1791337222906;
        Tue, 06 Oct 2026 18:40:22 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c7202fa0bsm2238873f8f.3.2026.10.06.18.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 18:40:22 -0700 (PDT)
Message-ID: <38719270-2ee9-477b-aa31-b4f90bcba020@gmail.com>
Date: Wed, 7 Oct 2026 02:40:15 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/13] Add dmabuf read/write via io_uring
To: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336002.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1791336002.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/26 02:31, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1],
> from where I borrowed a number of changes. Later it was brough back up
> to life by Tushar and Vishal.

Apologies for a messed up submission, please ignore. I'm going to
send v9.

-- 
Pavel Begunkov

