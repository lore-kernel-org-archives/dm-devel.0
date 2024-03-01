Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452FA70CAF
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709308547; cv=none; b=MtzmyjOv1nYdq0kmu7b9rLHV/Ywu4ixobJjKGOI4l3ttTLVIobWIqStbpeVKNfNhNHVdFgj24AQi1cBgubcHh6QeSvh7MnTRYTJAiH06PZow5cxzzW8DK/6jb8piZxZwRlnovIGDhXKATuwVjAmRdAQptGmxZGwC9tRcbmMREvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709308547; c=relaxed/simple;
	bh=z8bQj4nyX9I35XGiew42GRrnNPiJWRmDuZYCF6ZKJPY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=j4vLnIqHViVAQjTSqrqlAA5eSr6AUNOwALW7p+3pnIe8VBCqMlWzsi54gU4GdMfnupN6MVlFrskgFC7yCPDSX9eM6rKv2vX/XO4vO3vxCDDkztZLmDkUpMWdIC/N7O5ziVbZM7f537sUJybcArzcFaRH1G6qqA93sULHPt7Ap8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mdn8PnvV; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mdn8PnvV"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7c82d2bdc31so1688839f.0
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 07:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709308544; x=1709913344; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LgjI9uub3d3zJshf48T+jDOY7FDzlEqVwK3scHxIK08=;
        b=mdn8PnvVmY1Gp3xYZeG0SJea9vi8R+N93JZ8AZbkaHDBdw5vNHpc7ybvUo0k6oEa6C
         PMiuvaF4BOMvYxyIqBmLg8lhZA+Xhkc7JSt6sm5XkDNPqxWMGJWS6pHE2LmvpQZZY2TI
         zOzUuxD701yLdib0qheXUa7D8TIL7uEv75o13JulsninaXFbQjDlgp4YOBXoF8gPkj1H
         rqaGQ39EV9plwSQtonx1fysgzBVYOMkdWeAF7Fc6nCRxeZCilWCPWZ6b65qj9JPFxRDb
         uhgBoT6IasEoavh5svxhfAlk71Uftr5DMY7uaDqAUk8EQDe88xsmDWbO4oB5Kdl2LIwT
         UBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709308544; x=1709913344;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LgjI9uub3d3zJshf48T+jDOY7FDzlEqVwK3scHxIK08=;
        b=h+Kj9oxd8sTA03l6z82d3IvQCdaBolAbebCBYpDEDlPtah0oYqBAgkUC9ZDdy47siG
         gaDAV9ry6gYPMDqkz9M3UXE9FII5ObvoJfEdLW0riERfG9kJ7JTrc/QulooqFPe6Wb+m
         6TudNbce5NOQjkrQMyVl20bpmOQmHAzrR9bUY4ybsvOv7eZ/N0LkZuCZ1f792dhUfkNT
         G/G/VclSxHw2LWvqltjjFAL9JsnPhDA4kzLpcQKfQkajFVG2hon6Djdxvhd3X5uS290U
         Yj2eV3LRQzXYMa1QVHmA4VeAVfHbhBupA280DaukU3K/rqnbig28mpQRozJBN9t0l1D0
         IPgw==
X-Gm-Message-State: AOJu0Yx+06UXrZsuN583Dfbi+yvy27WxvCB92gmA4s0wUiLV1Fv2JoXM
	ydPDgngE3IvTRo5l8lckhGarXdcSL0RrBTgKgbbtXQx+p6+Z8HVdQnp00eJgR5s=
X-Google-Smtp-Source: AGHT+IGSixrXiLDrWM02T9EQx2sINQe1SZ1K5RuRsjIz22eppz96SZfKq161wqvSZyqsqoDy96ZtOw==
X-Received: by 2002:a6b:6615:0:b0:7c8:1ede:72ea with SMTP id a21-20020a6b6615000000b007c81ede72eamr2022129ioc.0.1709308544451;
        Fri, 01 Mar 2024 07:55:44 -0800 (PST)
Received: from [127.0.0.1] ([99.196.129.26])
        by smtp.gmail.com with ESMTPSA id b4-20020a02c984000000b004745e754b73sm894609jap.176.2024.03.01.07.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 07:55:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-raid@vger.kernel.org
In-Reply-To: <20240228225653.947152-1-hch@lst.de>
References: <20240228225653.947152-1-hch@lst.de>
Subject: Re: (subset) atomic queue limit updates for stackable devices v3
Message-Id: <170930853640.1084422.8284935730781819597.b4-ty@kernel.dk>
Date: Fri, 01 Mar 2024 08:55:36 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 28 Feb 2024 14:56:39 -0800, Christoph Hellwig wrote:
> this series adds new helpers for the atomic queue limit update
> functionality and then switches dm and md over to it.  The dm switch is
> pretty trivial as it was basically implementing the model by hand
> already, md is a bit more work.
> 
> I've run the mdadm testsuite, and it has the same (rather large) number
> of failures as the baseline, and the lvm2 test suite goes as far as
> the baseline before handing in __md_stop_writes.
> 
> [...]

Applied, thanks!

[01/14] block: add a queue_limits_set helper
        commit: 631d4efb8009df64deae8c1382b8cf43879a4e22
[02/14] block: add a queue_limits_stack_bdev helper
        commit: c1373f1cf452e4c7553a9d3bc05d87ec15c4f85f
[03/14] dm: use queue_limits_set
        commit: 8e0ef412869430d114158fc3b9b1fb111e247bd3

Best regards,
-- 
Jens Axboe



