Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28E5340404
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535413; cv=none; b=SUFHdIwbqgtHh09i3dTq9Ub5pIX5NQVhJd1klPrQwrRZdT1TZZ5A3PJwIaRXkxAdPW/zMd8Lc4KwFYeO40fGiBedlJyZ2zLEIft+0p5jtCCQuf9KizbLG/BS9s1or5Hm4qafvtjZgRwWflpEoJrot0tgC8ksdRx7En1CoSo+IZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535413; c=relaxed/simple;
	bh=a5grERLxFxLzBGCTLKoyX0X7js876dnv5gaISNV3iOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PpcfiNk8JZl1Y6O4uqGmdDugLjh+71Pg/UK4MKUX/SY4Tpii1cP4r2F4Gicpx6Pn1uiMWBxnUMTSEcy2iawOuloq5lJrblxnQ3zwqmArWVXKCzrZZYXoAnWfrFbK1EgOvvEMD6VlQt3WnV+kHHCX1Zl1CMJ0+rkHvXp8+3rABB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ctdN6kvS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ctdN6kvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781535411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uqd9LRbtLE5W7TWPyRbfwgH0Qmtsa0/jv5X2ByIlZlY=;
	b=ctdN6kvSiN9FOQS/g1kGEbHgbCtr54T5oTLBkXSrkJGljl2AadqVMG22TJddgDgfa5hwyV
	ad4kwqSXQDsHs3qu8+iWtEdHQS2Dn4000ObsFPtgOWt5W4P/ewHAG9MQdm7AzL7ruAyfqO
	pRjCY7cVxByuKo16+H4LrDXM0x2X5Oc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-KDjLPvS-MuSmjp3lE3tGrg-1; Mon,
 15 Jun 2026 10:56:48 -0400
X-MC-Unique: KDjLPvS-MuSmjp3lE3tGrg-1
X-Mimecast-MFC-AGG-ID: KDjLPvS-MuSmjp3lE3tGrg_1781535407
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1ED6B195411F;
	Mon, 15 Jun 2026 14:56:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0C7030001A5;
	Mon, 15 Jun 2026 14:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FEujIQ790629
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 10:56:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FEujIi790626;
	Mon, 15 Jun 2026 10:56:45 -0400
Date: Mon, 15 Jun 2026 10:56:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/3] multipath-tools: delete obsolete information from
 multipath.conf.5
Message-ID: <ajASrXKCvccL7g65@redhat.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
 <20260607103831.336833-2-xose.vazquez@gmail.com>
 <562d0c52ef13cfc1f8dec3c59b05b56304ce2c02.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <562d0c52ef13cfc1f8dec3c59b05b56304ce2c02.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: auhS-nraoBrTtptTjzc_JocpWWR7k2ar6wMJrXWvYTM_1781535407
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 15, 2026 at 11:11:07AM +0200, Martin Wilck wrote:
> On Sun, 2026-06-07 at 12:38 +0200, Xose Vazquez Perez wrote:
> > repeat_count (rr_min_io, rr_min_io_rq, rr_weight) has been
> > unsupported
> > since kernel 4.6 ( commits 90a4323ccfea and  21136f89d76d ).
> > 
> 
> I can't make up my mind on this patch. It is true that most path
> selectors in the kernel have ignored the repeat_count argument
> for a long time (historical_service_time still seems to honour it).
> 
> But this is multipath-tools. _We_ still have quite a bit of code for
> handling the minio and weight settings. We should add a hint the the
> man page that these settings are ignored by modern kernels, but it
> would be simply wrong to say that _our_ code ignores them while it
> doesn't. 
> 
> We can decide to remove this functionality from multipath-tools, which
> would obviously mean removing it from the man page as well. But if we
> do, we should apply further cleanups. I suppose that providing the
> "weightedpath" prioritizer makes no sense if we have no path selector
> algorithm that takes such weights into account, for example.
> 
> I should also note that there have been discussions with some partners
> about re-introducing parameterized path selectors. This was a topic in 
> the context of Fibre Channel FPIN notifications: FPINs can be used by
> FC fabric to notify hosts about overloaded paths. With a parameterized
> path selector, the load on such paths could be decreased by multipathd.
> temporarily until the situation is normal again. While there has been
> little progress in this area, I don't consider it cast in stone that
> the kernel will keep ignoring path selector parameters forever, or IOW,
> that there won't be new path selectors in the future that do accept
> path parameters again.
> 
> No doubt that the way these parameters are interpreted in different
> ways ("minio" vs. "weight" vs "repeat_count") and the way this is
> exposed to end users in the configuration file and in the man page is
> broken and confusing. But fixing that would be a larger effort.

I actually do have a patch set I'm testing that rips out the rr_weight
and rr_min_io_rq code completely. It leaves the rr_min_io functionality
(on the grounds that we many have a use for it later), but it now
defaults to 1 and is deprecated, so it can't be changed. I assume that
even if this code gets reused in the future, rr_min_io will remain a
bad name for the option.

I feel like the weightedpath priortizer shouldn't be effected by this.
It is still useful to manually assign paths to path_groups when combined
with group_by_prio.

-Ben

> 
> Regards
> Martin

