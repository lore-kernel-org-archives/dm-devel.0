Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865240;
	b=p1gMp85VZE/GOlaW19Lg3marMhcv4kAZfaKzmzXWK/dmSmJ/HUUex++lCNGUXaTvlDG/
	 ev1XZ0+CbNosnF9FSGYFHVp8dgb5m1rOgJyFRS+phapUiK6k+Sq00hxYsmPThyNgiTyEL
	 YM8hOLQWfQ3MqjmX5tOjPw/Uq19allYY45UPizeXBqVydDVcPTF7qrcfw89axcamVf4A6
	 Y8byQezv2TRJnRpBUifATC5ksD0gkJU2GqZb3cw8zMLay15zBVVwj4KNmcv11HWeWTJir
	 SbCP4kAeCGbw5NcdyaaasDeAc3z7YlntvU9UHwTDL8BsOctqpDu5Hn6dbM9Twcs01Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865240;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=UWMZogcRoeuy43lgIjiSsowIXZd/CKQOpbry+Ekdk64=;
	b=x+Djq+eB5OsmHGmawxILysEnu7gzrxLhutYLdPznHULdXk3ghuR7EMlfr/adA6rSOdCj
	 di2QzfcZoOF0/jpsoE5TK9ed0FEtkcPRK0YrEMa70/KoqxnULTofUcaGMgI4mj7yFXtki
	 RErToa3GV/9gHYJVZ4yfj30XR97SlmoqyzyniEQUN66l/xZCDzclAbz7rkt8Mrf3GMgj4
	 GDxvaxjnAnCBWu1yQYqGY3rp4TcwXum6moKsHnNUs6DPQ6390y2MBS3r1GhTZUE5wX+bT
	 m0AvqY1veqGARUWjOIVUxEPA6J9iyt/wNA+Skir0jgXs6QYBA5sm0Hw9kXan5rAnZMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZNMeGOLh;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEA7606A31C
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 21:40:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBEA7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZNMeGOLh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794865239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UWMZogcRoeuy43lgIjiSsowIXZd/CKQOpbry+Ekdk64=;
	b=ZNMeGOLhHFmwN5tW+aamgTNDd2V6cqATvBqPOK8ojpahfS9KMl6PdH7gTqAFQJKG76EPvo
	G/MC0hnwvRvq1c1PgNSugTQoNdj/ZnMm9GX8SABvFioZBMBqHFNCNaRg0HTY2G+DBkxWBI
	uRPqcnIt2YL8KHHmr+nSNhbiIqJTpfY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-CdTEG-rMMSi6uaaR3k3DOg-1; Mon,
 16 Nov 2026 16:40:35 -0500
X-MC-Unique: CdTEG-rMMSi6uaaR3k3DOg-1
X-Mimecast-MFC-AGG-ID: CdTEG-rMMSi6uaaR3k3DOg_1794865234
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A8531955E90;
	Mon, 16 Nov 2026 21:40:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E80DE1801975;
	Mon, 16 Nov 2026 21:40:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AGLeW4f3258162
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 16:40:32 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AGLeWnD3258161;
	Mon, 16 Nov 2026 16:40:32 -0500
Date: Mon, 16 Nov 2026 16:40:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 00/13] multipath-tools: hwtable updates and minor cleanups
Message-ID: <avt4UPe3yt64HOwc@redhat.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UxUpcPv8Np9CRnicJ27M-OsjQkVMOEc_ht3CaXTavvA_1794865234
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 13, 2026 at 01:55:32PM +0100, Xose Vazquez Perez wrote:
> Xose Vazquez Perez (13):
>   multipath-tools: multipathd.8.in: fix mandoc WARNINGs
>   multipath-tools: hwtable: make no_path_retry independent of
>                             DEFAULT_CHECKINT
>   multipath-tools: hwtable: add FUJITSU ETERNUS VX710/VX740
>   multipath-tools: add EMC VNXe info
>   multipath-tools: hwtable: update Intel Multi-Flex comment
>   multipath-tools: hwtable: update Pivot3 maintainer email address
>   multipath-tools: hwtable: update template instructions
>   multipath-tools: hwtable: add EMC/Celerra
>   multipath-tools: hwtable: update IBM arrays entries and comments
>   multipath-tools: hwtable: add Dell PowerFlex NVMe (formerly
>                             iScaleIO/VxFlex OS)
>   multipath-tools: hwtable: add Western Digital OpenFlex NVMe
>   multipath-tools: add repology table to README.md
>   multipath-tools: move SPDX-License-Identifier to the top of
>                    create-config.mk and rules.mk
> 
>  README.md                     |  2 ++
>  create-config.mk              |  2 +-
>  libmultipath/hwtable.c        | 58 ++++++++++++++++++++++++++---------
>  multipath/multipath.conf.5.in |  2 +-
>  multipathd/multipathd.8.in    |  8 ++---
>  rules.mk                      |  2 +-
>  6 files changed, 53 insertions(+), 21 deletions(-)
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>


Other than minor nitpicks for patches 1 and 8,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> -- 
> 2.56.1

