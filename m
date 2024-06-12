Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2238181BAA
	for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718211633; cv=none; b=R+u9um4WKbRBlX3fUnHHImOJpeSU6EarZ2tJmak9qUaw2pE3POCzsL7YTBc3niCJAeQxujNWl8dU3rfVbzO5kdWVXCR78tHVn2QGQjkgJERUEV9MbtqPDdBsgz10xvKpJubgf7ypRCLiK9D7eUugTM6Cn+GYFNR6KVbr024ykKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718211633; c=relaxed/simple;
	bh=FGodosjCuK1l5IwdCzmgVPoV1DySj8ltOWup6queEB0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=vCNtfyFC6pTwJ4GOXVUrkC0NjPe49a/FmgONZGNGQUFQj7JUHe6/cyzJrqgtv37AZWGug3bR861XellKLGipuXaRKFxo6sdE9CLdegCAt8aaoacXcfCm4FHesatAj+8afn81ae7r6woIP9w3FoiSr4bucBFYDcpBYdTObJ7ieBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DoZhaj+L; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DoZhaj+L"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6f95aac8cdaso3044a34.0
        for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718211631; x=1718816431; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FLC7J8Mgipnai6tMkIu2Aw7sXa9Nh2VSSClMV3jWnwc=;
        b=DoZhaj+LyiEtemPlagFRBosut9SqQt1mo1y1YX5zxbNTlqX5G4QVH38AkqnwXD7WU5
         J226fUMLQhQvXqloYrm3SFryvNJzHhdeBUMp0M82It12gysACtu97w+/cQG69KL/hqLY
         gRtoT2gGGfZZi6m1Slr12qJzNfBQvn+IcGWG4y5udRmZ/w9nWMZNblA7yOU/vBMhe5Za
         RQ/DvLe422++0PtMohDT/e650P8TRyPBi1m8a31B+Gxs4xfJEjXDiYBiPvV3XwK8Yldz
         NJi6zyinrU6MGj2ZeuJ6Nmxqs8imNqYKAhp0S1vxjcZRDOgBuPb1pN5NcNznu4fDbCix
         QFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718211631; x=1718816431;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FLC7J8Mgipnai6tMkIu2Aw7sXa9Nh2VSSClMV3jWnwc=;
        b=kR5EZs8vEnHoTEH6yMbajF60BRVi/uchUvbTbu3ohkNusjZ0Za7L/GXVzrxJuvUuYf
         nFkMNq+54d7lVjjnA+NBXiMBzelGTEFusDDgXE8NMi/NqZNk+l69sT6kuBlTTW5Xh705
         f/v/ZurrbO2ciAYsKzb+RAEmr+XmHYcIoAIZqEYEBRMmK1Rt6oB1ntqCanpye5tpUvLo
         BIsb3WHzs7GdobZQuKIwu0XfuNVMgU54b7llt/MxtRiFmeRav+eAngjP1Wot60CYxHog
         FrQI+dip0wnB93CzDqoNjcVIIis+RtlrUtT7af+G7XL7mcRWKferajuj/bq8WQcnEuLH
         lkBA==
X-Forwarded-Encrypted: i=1; AJvYcCWdEoUhKW2UEA+bW/YLmD9fGD/2/m+yGOIGi+FTyu9zKShDNnJmEFIi2b9X36sp8t55jWxQl6NkcBTkaJqU1l9Yd5agyRYV498=
X-Gm-Message-State: AOJu0YwWK482YXbL7YdV91Lc01sd5k1zKQ+jb+hwsAs9xVYGV9WHK4XG
	nPYw2NAvMaW/IzU9iwgrQpP2wLScqOMWOIJZ7JWhSTBZUYzsSDohtD4w5w6x5Xk=
X-Google-Smtp-Source: AGHT+IGD7kMHTySUNBriw0c8o3eMwK51FQscs0lyEAF7fFxaQMPZPY4smWo7T75MMpdHCPqUCSdWaQ==
X-Received: by 2002:a05:6808:1990:b0:3d2:2412:36a9 with SMTP id 5614622812f47-3d23e0d7019mr2901334b6e.3.1718211629808;
        Wed, 12 Jun 2024 10:00:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d242affa88sm115841b6e.1.2024.06.12.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 10:00:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240607002126.104227-1-dlemoal@kernel.org>
References: <20240607002126.104227-1-dlemoal@kernel.org>
Subject: Re: [PATCH] block: Optimize disk zone resource cleanup
Message-Id: <171821162890.49689.5201501208480966687.b4-ty@kernel.dk>
Date: Wed, 12 Jun 2024 11:00:28 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 07 Jun 2024 09:21:26 +0900, Damien Le Moal wrote:
> For zoned block devices using zone write plugging, an rcu_barrier() call
> is needed in disk_free_zone_resources() to synchronize freeing of zone
> write plugs and the destrution of the mempool used to allocate the
> plugs. The barrier call does slow down a little teardown of zoned block
> devices but should not affect teardown of regular block devices or zoned
> block devices that do not use zone write plugging (e.g. zoned DM devices
> that do not require zone append emulation).
> 
> [...]

Applied, thanks!

[1/1] block: Optimize disk zone resource cleanup
      commit: 1933192a91be0a570663a3c6310c46e4ce3b2baa

Best regards,
-- 
Jens Axboe



