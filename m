Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D463B8944
	for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 12:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342611; cv=none; b=ZHG/jGuxiygA7UJxKaE6IvVEVDGROEfzNQycmf06P4QjJ3WjJmimCWLHGxWOHgX7dpsyXPXylbXrX1HvJHT/zxdA2aZ1uXnjEeRQdv1nTIGunfGzAXWTZYJC5awbkV6Ei/6oHs5i7Z6xeX1NhST9DlLyY+13lYbWDEC4BQOf7+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342611; c=relaxed/simple;
	bh=K/4afwQ5p31SSvbXjWdzi0L0oqupXfEEFTghGQ4JcSM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXGXZyyemKhVkgbj0w9PX38MOP9yETk3YA+5jeYs4rN0WI7ux78p767C1d5pxCViO/ArxCc37SpQ1EBqT9LiTeZF4hfiMs550sZHJmcMurq1UcQgK3ntYyERjNUvbQmdktV9UJ+AFfjCKfBSASZ1X0cwLaXMOnefmkqNGOSyido=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B/ewG270; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B/ewG270"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4887f49ec5aso95897555e9.1
        for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776342607; x=1776947407; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wD5n29vJmomxS6DITZYPjUM6os1Itf/93DfNIu2KPog=;
        b=B/ewG270R+x2GJOHvpKWlfDG7vkh45I2jovyL3KlZ6TKtP2s9yOB27L23gwuJFGexQ
         SaAOeHFRJWaVNmOuCbtOpYaZcDZeuWu7b7L/v2+2ZcquO1CuPas/Nj2EEAnGhHXYdnc4
         4y6ueao5ihmbmU23M//pVOH669HrsHt55RJRo5Z08MV3b5bDhZFElTEVvBBHgIkzuDp1
         Tnbv3txHWeTp9HQ9bwQFilhpY9+zhGGmhwKLhj1sH6L52O3pL/s9BYMwEIReBFq6aToz
         iqwWisCRMEFk190v+H18C3BcNjtdHNACTI77plKgI9TTog0TOGZG95w8oDfPjpskg3S9
         ysLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342607; x=1776947407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wD5n29vJmomxS6DITZYPjUM6os1Itf/93DfNIu2KPog=;
        b=DULdoi1hdoveKkqn+8arimW+jOs/vfLAoBeHv2EUITE+5FO5A2XJhfI9GrrD5pj0Mb
         7xOPGAIyteSJdMNP6AuSPAA7b7gJjK2rDrXU1FxRoI7WY3CknH6N2gK3CBmAczS2ZTRy
         pT2DwpoTyOqB8ptQON4mlCDmO/XrD7L4EfrMS/lz8vFo1NuiAA83STFmWyJnTA5HF6Vo
         HNYR5RtP7JAWjh93+AKfIql10DQ+X+B41GkaQOGmhR1fVnHyvpef/G1g3N9zmu3IYyjS
         fB2lMDrPhGXoAZVRa90KR858/IUCzZphAeT6ywLJi4C9+4kOowVwFOM51++CG6MfTPPt
         aMAw==
X-Forwarded-Encrypted: i=1; AFNElJ/IC/6xVa7pJ/WBl9DKw72tFc7fy/JJpLEb7CsLmfHJrakzOay53SNwARryOB36/Q60VbmL+NKW1w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxE/KYuQZdwJfARAHnzEgz+hNTVFjvQ8m8aOZS0sGZS+/0dtZ6p
	heOJ02nq4KE7ahe00qLOK11rDTV0iWGCElVEYBnvYJOr2edKTXY4PskP
X-Gm-Gg: AeBDieukiiKaJ8d12/tGhIrKtCnCzrvBicNvMlY73V3gRwRm76yMnw1dQ5hSgr0VZzJ
	rw1h5rR3BqEa+PGp+brHePWUoj1zoLNSFN9z2vkIk1B4n9rXbuo0xBOnlV0uPrKY1ZgPADMgFPM
	1zpsltlHSdh+dwXC8dgm0HBs+7jaIdu8AlQxrP4Euvpvj4CCoZq2Ypf1eaZoVmSHWyHwqdrvyJQ
	8u6syWhUy4xlI+4n0VQK6wPTT6GIr7qrSoVGBU/eQlyfrJTphQVjkQHJ+IPUhItUOd3bqA6Y4xr
	m0sa2NtqSynjqQGYfXNMW0RJJiTyHnNcia/8JOo/ZHTI/PkRT4XewOKRXyGQRzev9KxNyAVytue
	+qyIXmxRVgK3vrfnPk0ZsLFgcj+h7DgrCj1zRGibDnmNlexXRdT9G3MTkDA6JhbCWbOMUK7euuZ
	z6n6QQvy++l/GXPphZkiXPx/pY1b1R7mjlrcQ5bLSsSVio9M7BzQCHTXs13xC+Oqbm
X-Received: by 2002:a05:600c:45ce:b0:485:3e19:9e01 with SMTP id 5b1f17b1804b1-488d6890c9dmr355637165e9.28.1776342606991;
        Thu, 16 Apr 2026 05:30:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f0e9c668sm69981255e9.4.2026.04.16.05.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:30:06 -0700 (PDT)
Date: Thu, 16 Apr 2026 13:30:04 +0100
From: David Laight <david.laight.linux@gmail.com>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, paulmck@kernel.org,
 frederic@kernel.org, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, atomlin@atomlin.com,
 jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list
 with double-linked list for reverse traversal
Message-ID: <20260416133004.07bd2886@pumpkin>
In-Reply-To: <20260415070137.17860-1-chensong_2000@189.cn>
References: <20260415070137.17860-1-chensong_2000@189.cn>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Apr 2026 15:01:37 +0800
chensong_2000@189.cn wrote:

> From: Song Chen <chensong_2000@189.cn>
> 
> The current notifier chain implementation uses a single-linked list
> (struct notifier_block *next), which only supports forward traversal
> in priority order. This makes it difficult to handle cleanup/teardown
> scenarios that require notifiers to be called in reverse priority order.

If it is only cleanup/teardown then the list can be order-reversed
as part of that process at the same time as the list is deleted.

	David


