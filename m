Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EC81DDF4
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718115091; cv=none; b=NjQwmYSSk6Ey1vZD98QN4MjCUf1E/Bp68wy2jKUCK3B7JVMtb+P6zUDSGv5RY6/eVlkV1H10a+O2Ffk6WNL0S5krfgaXykfwwHi1VA/Cb0nTTx1NWaje4USnY7Tb8IAafYeq+haDZNAQGqsUpDJEMbdfamfDS5wNk4J8hNIR2L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718115091; c=relaxed/simple;
	bh=ogJBOT3jxjmLFCMjRiIfHExdGIpJwUHEgc3x+6zuUyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAjB84+myMAUWFE5VN1gRKSJQoW3V20My9e01upM1MVrR3ra4ITAgSxWXmcoTpEBxduA7b8fNiv5haWO5ToaoHeaz3a+nyT/icIfxOjOLldHi7b7vSy9uxthPrKmL67dEMWNkAyIEPjiLG5ibwdCfeIEKtnoYOa/Pkf+YdSFuck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 253BA61E5FE05;
	Tue, 11 Jun 2024 16:10:33 +0200 (CEST)
Message-ID: <12441f87-6e61-4618-a2f5-a2b2b202b26e@molgen.mpg.de>
Date: Tue, 11 Jun 2024 16:10:32 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 md-6.11 00/12] md: refacotor and some fixes related to
 sync_thread
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, mariusz.tkaczyk@linux.intel.com, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Yu,


Thank you for your series.


Am 11.06.24 um 15:22 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>

It’d be great if you wrote a small summary, what the same fixes are, are 
what patches are that.

Nit: Small typo in the summary/title: refacotor → refactor.

> Changes from v1:
>   - respin on the top of md-6.11 branch
> 
> Changes from RFC:
>   - fix some typos;
>   - add patch 7 to prevent some mdadm tests failure;
>   - add patch 12 to fix BUG_ON() panic by mdadm test 07revert-grow;
> 
> Yu Kuai (12):
>    md: rearrange recovery_flags
>    md: add a new enum type sync_action
>    md: add new helpers for sync_action
>    md: factor out helper to start reshape from action_store()
>    md: replace sysfs api sync_action with new helpers
>    md: remove parameter check_seq for stop_sync_thread()
>    md: don't fail action_store() if sync_thread is not registered
>    md: use new helers in md_do_sync()

hel*p*ers

>    md: replace last_sync_action with new enum type
>    md: factor out helpers for different sync_action in md_do_sync()
>    md: pass in max_sectors for pers->sync_request()
>    md/raid5: avoid BUG_ON() while continue reshape after reassembling
> 
>   drivers/md/dm-raid.c |   2 +-
>   drivers/md/md.c      | 437 ++++++++++++++++++++++++++-----------------
>   drivers/md/md.h      | 124 +++++++++---
>   drivers/md/raid1.c   |   5 +-
>   drivers/md/raid10.c  |   8 +-
>   drivers/md/raid5.c   |  23 ++-
>   6 files changed, 388 insertions(+), 211 deletions(-)


Kind regards,

Paul
