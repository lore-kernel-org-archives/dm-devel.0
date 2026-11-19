Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115281;
	b=QEOw00nlL4h+lPXJz60oGmQEKmet+SFs/5Bd3u4os58NhSOxPtxg3ipslGyxnNzO76wh
	 ccNL7wxt1RqiuDBIaPf7S6+DgiJuuOYdhE8ooDhvOyCqKNCGMiVBE+nI0kCsWEma6ic46
	 nyFT939jelowOi94ET329ZmbUAaQXDaH/OrxblMqg79dhYUeYSCMRfWneY3Y74UN5Tx3W
	 WNLyrd1Hgcs1BTexCH+viH/9HHbDiBopz80OWw5oJb9Zt/J+72p3MZCDBRheMAqJWzqom
	 Y4ZPscZ5hAJeUFlhVGkDR0kTglZ8W6wweUVlVGWPbIl34TaBaHc2leDLgZIlcfP6JLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115281;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=Qs/jQHCr6KOrKZVIubHRrdhZdl05mQLtVMwJtvYwUok=;
	b=GgyBq25aNLbK2wxJyuYpfGqelQ824SJNJz63jMwyYqaLjRnYz/Ug6BCI1Q0F1q9RaDZ9
	 z1VsWpa1CwRPws/6PLOM3NfEy/un0fjbRxNrj5ZTCYeyq/FHQZhsfZvJ4irsbXZYRvuRM
	 TKzRNA/RZTK6E9VGnytrJKyS8vSiXssvRVDQV3py7REv9osvNDLO6VWh5J1V/bWL1oHPv
	 I92S57oTIcAsN9ZM/eVhxqdUPid1pmMLUmnDvXiO2yz9hkL1N25Tz8pAB7Z0thFKl9TF9
	 rU4+4AcVLbfxutr5RbV3siB+fPbuytNoJBN+3K4NKOHOWJDJpInbA+ztd3EXvDVeXZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iRl5c0LR;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C08606A8CA
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 19:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08C08606A8CA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iRl5c0LR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795115280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qs/jQHCr6KOrKZVIubHRrdhZdl05mQLtVMwJtvYwUok=;
	b=iRl5c0LRbYCxSiK2wn6i3JkREY2sXCnKG7XaKHIX3U23mpLzYl7YEg1+kX4UzHTmSX6cZg
	niVKJYDYEE3i8rT3sBeiHFcwSKYAKEeiEoGql9DV5EcQCucJX95QBgDWPckfUP5Rx+k++U
	mVtLcxwXrckLdugdXCE9DxaSnlLeIVQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-ZbAM0Ug3MSSUXRJNT7cd4w-1; Thu,
 19 Nov 2026 14:07:55 -0500
X-MC-Unique: ZbAM0Ug3MSSUXRJNT7cd4w-1
X-Mimecast-MFC-AGG-ID: ZbAM0Ug3MSSUXRJNT7cd4w_1795115273
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B90681955DE4;
	Thu, 19 Nov 2026 19:07:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 384BE1800543;
	Thu, 19 Nov 2026 19:07:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJJ7pIb875236
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:07:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJJ7pUw875235;
	Thu, 19 Nov 2026 14:07:51 -0500
Date: Thu, 19 Nov 2026 14:07:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 08/13] multipath-tools: hwtable: add EMC/Celerra
Message-ID: <av9JB06RtotZ5EMv@redhat.com>
References: <20261119083942.194958-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261119083942.194958-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1ORqWkDQoUngczkCeSTuHsIynoX2zW_vyPD7BFzQJJM_1795115273
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 19, 2026 at 09:39:42AM +0100, Xose Vazquez Perez wrote:
> >From "Dell Technologies Host Connectivity Guide for Linux" (May 2024, #102):
> vendor "EMC"
> product "Celerra"
> path_grouping_policy "multibus"
> path_checker "tur"
> no_path_retry "30"
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

