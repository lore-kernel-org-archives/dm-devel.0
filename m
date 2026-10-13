Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F081551C05D
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791906499; cv=none; b=OtS+OTt2qfsWahmKJmZZLu+OZYdkQQmBgwb6YZfDYZ3gg3nGU83pa5qyW+jMeC/n4ngE4TF/PmADX3t1nKEGxZbn7TnszH3YJYmPHGcxu3NgTiaQGEgj4S+2KaZ0bvO62mb9SoqkoH6SLw/+++nWu+COk0u9eCC8Sg5bjOPH3qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791906499; c=relaxed/simple;
	bh=M4Dr3mmrmB08QBfm3/YrbqgmJ52+TmcJTK73+60bfDU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PNNH8/eLgDnghMnM33i3equ1gcS8Wfwa2TvB8ym09qk4ve5LTCD/oSV/PtK9ncEC9UjjLGsmw8doehOA4ffpjAiyFTSYm/HQLJQmHG25AsyYoqycgxpfaYmxy/Se+JTWR8i0Ywg0libpkjzKwG0+Uzcso3ldUZRBghMPfyuAH5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwkPd3Yu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwkPd3Yu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791906497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/XvfBiZWM/Av1Vl2ovaX1nYpdV0/mAukxdFbNs4cOQ=;
	b=fwkPd3Yu1Mht3V74VeVfxktLUmuKpN4NhIKJpUunmpVnwGr0z6rylM84AM6Dp/aeHMjqpF
	ZsE6ZJRJs7RRP5DUKdkUHXlqba0p+YJFMBT2BFxJ9+SmQMtnYUOO6RqDxQFvFs3tFbP38t
	ktrCJPuNR2XVRQDP60cAQxFZhs6JOA0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-TXVQkJKVOee3OfUuzGCORQ-1; Tue,
 13 Oct 2026 15:48:06 +0000
X-MC-Unique: TXVQkJKVOee3OfUuzGCORQ-1
X-Mimecast-MFC-AGG-ID: TXVQkJKVOee3OfUuzGCORQ_1791906483
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB1E21800BD4;
	Tue, 13 Oct 2026 15:48:02 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FACB1956041;
	Tue, 13 Oct 2026 15:48:00 +0000 (UTC)
Date: Tue, 13 Oct 2026 17:47:57 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Kyrylo Biryuk <illofspeed@gmail.com>
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, agk@redhat.com, 
    bmarzins@redhat.com, dlemoal@kernel.org, hare@suse.de, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] dm zoned: fix idle reclaim problems
In-Reply-To: <20261013145522.17499-1-illofspeed@gmail.com>
Message-ID: <b7e35437-de42-d078-e75a-1f08541eb725@redhat.com>
References: <20261013145522.17499-1-illofspeed@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: lIR65h0qOJFFReUBW12mJ_wpp67OAA9z_vtAKDljt08_1791906483
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 13 Oct 2026, Kyrylo Biryuk wrote:

> Mikulas,
> 
> I noticed too late that v3 of this series is already in dm-7.4 and
> for-next (24646f6ed3, 2cca719c63, 5829edd027), so v4 crossed with it.
> This v5 is v4 plus one more fix; if you prefer to keep v3, I can send
> the v4 changes and patch 4 as incremental patches on top of dm-7.4
> instead - please tell me which you want.

Hi

Linus doesn't want development being done close to the start of the merge 
window (or during the merge window), so I reverted the patches from my 
tree and I will postpone them.

I suggest - separate the patches into bugfixes (they have the "Fixes:" 
line and the "Cc: stable@vger.kernel.org" line) and performance 
enhancements (without "Fixes:" and "Cc: stable@vger.kernel.org"). The 
bugfixes may go in later during the 7.4 cycle, the performance 
enhancements will wait for the 7.5 merge window.

Mikulas

> Patch 4 is new. While measuring an idle pool I found that an idle
> target whose random (and cache) zones are all free never stops running
> its reclaim work: since 90a9b8693f1b ("dm zoned: reclaim random zones
> when idle"), dmz_should_reclaim() treats "idle" plus a non-zero total
> number of random zones as "reclaim now", dmz_do_reclaim() finds no
> candidate and returns -EBUSY, dmz_check_dev() checks every device for
> media events (a TEST UNIT READY on SCSI disks), and the work is requeued
> with no delay. In mainline the loop can end when a pass finishes while
> the target is busy with enough free zones; with patch 3 the idle poll
> stays armed, so the loop recurs whenever the target becomes idle.
> 
> Measured on 7.3-rc7 with three emulated host-managed members of an md
> RAID5 (idle, 30 s average):
> 
>   stock dm-zoned        181,195 SCSI commands/s   32 % kernel CPU
>   v4 (patches 1-3)      187,707 SCSI commands/s   31 % kernel CPU
>   v5 (patches 1-4)            0 SCSI commands/s    0 % kernel CPU
> 
> With patch 4, the random zones filled by a 2 GiB write burst are still
> reclaimed once the target is idle, and on three 27 TB host-managed
> drives (7.2.10 with these patches) an idle pool went from about 155,000
> TEST UNIT READY commands per second per drive to none.
> 
> Changes since v4:
>  - new patch 4 (above)
>  - patch 3: Reviewed-by from Damien Le Moal
>  - patches 1-3 otherwise unchanged
> 
> Kyrylo Biryuk (4):
>   dm zoned: back off when reclaim finds no destination zone
>   dm zoned: do not reclaim a random zone into another random zone
>   dm zoned: keep polling for idle reclaim after a reclaim pass
>   dm zoned: do not busy-loop idle reclaim when no zone needs reclaim
> 
>  drivers/md/dm-zoned-reclaim.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 

