Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23511CF7AF
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 09:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753089333; cv=none; b=GGj2evib/X6TVMlFKSJul7Du0B8mAOhgRw+2mQd8xaIgwsYhGtSWrjNlIRFezuI4dQypjsmZJArYyU9Hd7zjX5ou4STWoaOu0kQG9sS6UkVxY946o9jwfnS4pKXkBSYUYAPHlXuy506/FhXuVgVllWJ7N0KBWAx4Sbu5Bbr2/GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753089333; c=relaxed/simple;
	bh=VUqpeieItmRy+6krQTtjvBkMriLDepTx2K1OxLH8LA4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GtHYVihgmvcMT9vPrARC2FQZcCWcU3UPhsGtBBhXconBGawmi1rdaeOkPXqpFDKsTNUWGjT5+VYm0eFHF8ujiNMPZM9/L2aBlWm9YMYj184dn2ae4n9EYrBYe6g6sXSs5NXnD/WOjs7sP3XSIfpcW8aqWwtCBOSRlh3tXYARAbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CcmG6r51; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CcmG6r51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753089329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8gOo2Uhf03mStzeNe5O5JtC75m9m/G/QejYzox/jWos=;
	b=CcmG6r51exi46qPi0uEIu0tr4ngXxmywqgeFv96TGZWh9MfS+ofpZMKHCBVKCig+Qagpr7
	uMJHB3YWaOho/ny0FaV82cpqJ5MP/xhUeBKNwLaPaBF/0f2L79AUid8CsQ5tBQ59E0pWIe
	eCM4oR26U1v6kjv1HjIAT3xxLH8YvyQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-SsbRPYtZMF2PXQCL6dCeUA-1; Mon,
 21 Jul 2025 05:15:27 -0400
X-MC-Unique: SsbRPYtZMF2PXQCL6dCeUA-1
X-Mimecast-MFC-AGG-ID: SsbRPYtZMF2PXQCL6dCeUA_1753089326
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40CE419560B5;
	Mon, 21 Jul 2025 09:15:26 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E37F1956094;
	Mon, 21 Jul 2025 09:15:22 +0000 (UTC)
Date: Mon, 21 Jul 2025 11:15:16 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai3@huawei.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Konstantin Khorenko <khorenko@virtuozzo.com>, 
    Denis Lunev <den@virtuozzo.com>
Subject: Re: [PATCH] dm-raid: do not include dm-core.h
In-Reply-To: <20250721034929.374552-1-ptikhomirov@virtuozzo.com>
Message-ID: <d524e3d7-69e2-0267-b9ef-b4dc576e6c55@redhat.com>
References: <20250721034929.374552-1-ptikhomirov@virtuozzo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Mon, 21 Jul 2025, Pavel Tikhomirov wrote:

> In commit 4cc96131afce ("dm: move request-based code out to dm-rq.[hc]")
> we have a note: "DM targets should _never_ include dm-core.h!". And it
> is not used in any DM targets except dm-raid now, so let's remove it
> from dm-raid for consistency, also use special helpers instead of
> accessing dm_table and mapper_device fields directly. This change is
> merely a cleanup and should not affect functionality.
> 
> Fixes: 7168be3c8a6b ("md: record dm-raid gendisk in mddev")
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  drivers/md/dm-raid.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index e8c0a8c6fb51..4fb5ddf50560 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -14,7 +14,6 @@
>  #include "raid5.h"
>  #include "raid10.h"
>  #include "md-bitmap.h"
> -#include "dm-core.h"
>  
>  #include <linux/device-mapper.h>
>  
> @@ -3305,7 +3304,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	/* Disable/enable discard support on raid set. */
>  	configure_discard_support(rs);
> -	rs->md.dm_gendisk = ti->table->md->disk;
> +	rs->md.dm_gendisk = dm_disk(dm_table_get_md(ti->table));
>  
>  	mddev_unlock(&rs->md);
>  	return 0;
> -- 
> 2.50.0
> 

Applied, thanks.

(I deleted the Fixes line, because it is not really a bugfix and it 
doesn't have to be backported to the stable kernel branches)

Mikulas

