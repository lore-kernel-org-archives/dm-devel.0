Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1042F1F30AD
	for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742665212; cv=none; b=fgSMcFVDi53B4WD4qnjIaWhz8EH5vwF0Fl1VI2yjsGNyvFEik/S0CBbJzVm8UHCQHph7c+jcLyFpkIH4xE5Zwuq/8Q40Dc2HtbuID2FNLYso9aJ6Mv55kNiq3m92oL7CLFXq8f+tucBVJT3kHxc3WMkncLU+LDeKPxUo/JYnz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742665212; c=relaxed/simple;
	bh=BWZs9OG4et1n2TSvXFMfLdQamlRuWKjLH4SJy6VpjwU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p7vA3xhCN+8x+GpTbsKxG+31+s53ZEn2QCzJatAXSNtaXZ9ocLxkHc3LB2NGLA9qjcUfirYnSi5IemadyoeXWlwfK6pVRJ4pcRyMor7nEZyUQyX2fXzoObHqr++5+8EPYrI9k4h6dzvghmEnguXjqmy3Rmk1tcooCITC9Mz3CFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sxDXK+TH; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sxDXK+TH"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85ae131983eso316939939f.0
        for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 10:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742665208; x=1743270008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQ0ip4i6csdB2mVrH4d/ra32V+NweWM/muWAq5nV5AQ=;
        b=sxDXK+TH4bkjtiENCDbs+Vo1h/BPkm9q59sZpVFV7r1jn4RTB1TZs32FNDD3uC4QXe
         VZ53PIaATIfKcesGRFBLhiYuGxB85/avMmXasxl7jNVKde///c3uQmr2kY0c+34yZWYX
         6wQgWnqUB0yDNh+w+WNuCylCq9W+N8Au3sHxGCWKbKQMqcNRDibsq2IqAeuWiE7ALKyE
         IZeGmTGbYVPB8cqYG40ecbChtMjCuZYeFDp0SC/mXu61G1H2aXZP6EHNPkhpNTn0QJjp
         59b6zcUoAptnC/4rGtNZ4IjGK/17FPbSFGQUXschU7c71WiGHASMOHJGCPKi+HfiTtyz
         E9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742665208; x=1743270008;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQ0ip4i6csdB2mVrH4d/ra32V+NweWM/muWAq5nV5AQ=;
        b=nvuYqJzaHIkY0zXxJ+KeFSKxI4hDO/BT2zkRWVKydm5UeFArp0G3N3dYt1n7ojWrYY
         EW/ns5UMpLUJBqklJdqWOf8VwCA7NCJ3uucehPefQo6Hu2CJCkrlJILPPJC0VJ9J2ds9
         eSjWH2/olh7KIz6SwlK1XOK8vypdLGPf5tGoTNCvko+ACGVvOSCK/c3OAqv+xky1ADun
         mq+4CeYCZzPRlO4crHzmWYehqZVII4v4MbsRUjOI26tn3dtOVx350skc4hdcXwVu4AcO
         j9kigTRdBXpOdl/FL1qEjR/8LoeXeH22AzFPyRfBG3+YYqHIyKm+mJYhe6g6V5ebcVY7
         72PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIkzor4zc+Vr4HYCrzEnoKMX1mJZQXOx3eOwOpFGgHyMdPkMktcKOfd5Y1vDESjJpcOovs7JYf0g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzwbSzvvHPrVRnZA3HJFT0gNn4nyf0Ykm9fCJanm0wA6/II+OOC
	Fw4bTSCcXuWsBxAog2lnemQx13Rqyosh5nzimuaAPGRZyQb7svsWIdI9QlimQmo=
X-Gm-Gg: ASbGnct9JND+dXZhTRZ2AcjmU/QlkMoN61hEDipsR6wJGLs7sfJ5N5fWKof2gBQMECj
	/Q/I9qGiXKMiLqjXqKoPig/nGz08+6liFVfFFpabzkJf0JLHuK1gPYQY+8/vZu4UrsPWd9uJLMa
	SnCBI3I4bW8B1oBnj5J5fRmkGmLXGYB7yNzJp9SAQcpq5ay3ccZ5dANVXg01i9+szpN7HgSFnKV
	dC8DtDgqf1dAl0oB3PF2t98RiXBxC1HQH/NDFaIU4EImsSvYYzWGdH9q2/qNC8/EHXi9xlNxvap
	HIoXUyn69lfGKVdWW5ENRXEdqkCSWpx9CprS
X-Google-Smtp-Source: AGHT+IFIjeQDbLNOW53InplpUybB3IL5ccWLRyeUxtphMPF9esSlQ0I36rytq+tgStMh45iWWeNTlQ==
X-Received: by 2002:a05:6602:6a87:b0:85b:46d7:1899 with SMTP id ca18e2360f4ac-85e2cc58f07mr673000639f.9.1742665208174;
        Sat, 22 Mar 2025 10:40:08 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85e2bc68c15sm89932439f.21.2025.03.22.10.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 10:40:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jooyung Han <jooyung@google.com>, 
 Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com, 
 dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
 Mikulas Patocka <mpatocka@redhat.com>
In-Reply-To: <20250322012617.354222-1-ming.lei@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
Subject: Re: [PATCH V3 0/5] loop: improve loop aio perf by IOCB_NOWAIT
Message-Id: <174266520675.800027.959344570613955585.b4-ty@kernel.dk>
Date: Sat, 22 Mar 2025 11:40:06 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 22 Mar 2025 09:26:09 +0800, Ming Lei wrote:
> This patchset improves loop aio perf by using IOCB_NOWAIT for avoiding to queue aio
> command to workqueue context, meantime refactor lo_rw_aio() a bit.
> 
> In my test VM, loop disk perf becomes very close to perf of the backing block
> device(nvme/mq virtio-scsi).
> 
> And Mikulas verified that this way can improve 12jobs sequential rw io by
> ~5X, and basically solve the reported problem together with loop MQ change.
> 
> [...]

Applied, thanks!

[1/5] loop: simplify do_req_filebacked()
      commit: 04dcb8a909b5b68464ec5ccb123e9614f3ac333d
[2/5] loop: cleanup lo_rw_aio()
      commit: 832c9fec8e2314170c5451023565b94f05477aa7
[3/5] loop: move command blkcg/memcg initialization into loop_queue_work
      commit: a23d34a31758000b2b158288226bf24f96d8864d
[4/5] loop: try to handle loop aio command via NOWAIT IO first
      commit: dfc77a934a3acdb13dadf237b7417c6a31b19da8
[5/5] loop: add hint for handling aio via IOCB_NOWAIT
      commit: 4c3f4bad7a6e9022489a9f8392f7147ed3ce74b1

Best regards,
-- 
Jens Axboe



