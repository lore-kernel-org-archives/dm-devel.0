Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AED470121
	for <dm-devel@lists.linux.dev>; Tue,  4 Aug 2026 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858654; cv=none; b=C4L3U3M39Xd2uBdk2DZKnqyr7RZho5/6uJS0k1DLw9XZxOeh5CKuhxi/uAm0Zt0O98GWiLG2yiEInWKnOWMqp0Rqb+Uu1qeN3sfsvIJ//HjiX84loZnTQzqF+lJhO+48ucY1wejYosxOTcNFbUI+mVC/suIkWfg+xKtigYVupTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858654; c=relaxed/simple;
	bh=kyzc9+lcNFKDesCL0akvLgicEBDdeEeGBkJy4hkCmkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RyW4g2Rr/tdixu3FHzprGezX3PWydFB3MedAgFEP/pxYfo0n0gFYFsinDbBeGfsb6ZvU+QSi5jhcMK59aM6+L8vOb1Nde9w+3WuVbB6QhV48FO3MzFNqrxEuQVZfL2OQ43zKTpJHTiOYfF8JD3twY/5ugs5g2GP0pCuWV0E+TCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqJj0SEK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqJj0SEK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785858652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xt3k83T5cDY3bjCRVW+ov+i31d6eNq4GPXayhq+eAS0=;
	b=dqJj0SEKenu4M9Kzrdp86J4hmWnq2zhztgVFH2YZn7Gr16uervzy/X9somrpnRBPBFLZSh
	gIt9PQpbsXi1SrjGffaHzF8Tm+xkMtSA08FCSgDKieGu0C6wsHkvCNOT3g2zfHfPJgEs2A
	VU+DzMULseWqIxZn7eF9Qkv31SxlLR0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-RNIEtYKpOGuAMqyOkffafQ-1; Tue,
 04 Aug 2026 11:50:49 -0400
X-MC-Unique: RNIEtYKpOGuAMqyOkffafQ-1
X-Mimecast-MFC-AGG-ID: RNIEtYKpOGuAMqyOkffafQ_1785858648
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A12771956055;
	Tue,  4 Aug 2026 15:50:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F0FB195608E;
	Tue,  4 Aug 2026 15:50:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 674FojKH3003082
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 4 Aug 2026 11:50:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 674FojkA3003081;
	Tue, 4 Aug 2026 11:50:45 -0400
Date: Tue, 4 Aug 2026 11:50:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dm dust: make badblock messages target-relative
Message-ID: <anIKVT_EMGB2EgLZ@redhat.com>
References: <20260803140905.383600.be823861719c.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260803140905.383600.be823861719c.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: xdNGuofLSi46jOh5tPWdKMvVflQIuMo6GZbYIjwq54k_1785858648
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 03, 2026 at 02:09:13PM +0000, Samuel Moelius wrote:
> dm-dust currently treats addbadblock, removebadblock and queryblock
> arguments as block numbers on the underlying device. That is surprising
> for a device-mapper target: a dm-dust table with a non-zero backing
> offset can add bad blocks that are outside the mapped target, and a
> badblock added for logical block 0 is missed because the I/O path checks
> the remapped backing-device block instead.
> 
> Interpret badblock message arguments as blocks relative to the start of
> the dm-dust target instead. Bound the arguments by the target length and
> perform badblock lookup using target-relative sectors before remapping
> the bio to the underlying device.
> 
> This intentionally changes the non-zero backing-offset behavior to make
> the badblock control interface match the mapped dm-dust device, rather
> than the underlying device.
> 
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
> Changes in v2:
>   - Revise commit message
>   - Remove call to sector_div() in __dust_map_write()
> 
>  drivers/md/dm-dust.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)

