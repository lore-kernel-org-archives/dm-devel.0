Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE57190679
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 09:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672761; cv=none; b=BRWkcJNcFllCScdGYCYiZzFOY31cxTS3niUVXCVsNNsj9UIPZwF+dEQjdMkottBPxrwcTdcIjFligAwGAtd1DcyXKyahCKwa9vpA0DXkGInOuU0McEnoytl1HV423nbQlaocqYsWsypoqKGnfdxPuNd+I1DgWlQDYtgWuDiaolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672761; c=relaxed/simple;
	bh=lRnlHQxe3lzyEiQ+WWs+wwoF3NizrLdS6kuM/WgNays=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iIuXP/2aDV2u/XXPjETZKukC4Vg/32KGOvPKF7wjQLP7Yx9tpf5NAMEuaTYuPcjgGaUezkun3X4mFw8F2diGnEATONvsrXs51flsIfoiFGsilXoURKkrGDYyz75mVoFb+5/018ilP1PUBOJ/JK6cjPBICm59xTcxxSl7y5THeTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgciApr8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgciApr8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750672758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Z2zDSCACR/4ckkoVIUWIgV/F6thhK0MTe+kxiEDWA8=;
	b=dgciApr8xxilWW7yp9CbWUTSnTW+WjFmnNdfV5XGWYD7s8ruUSKYp7cLoRfFIgxzTK1eLu
	bHNWjiy/Nu7py7vL8hTmpE0+Qygy3peHHoPMHBV5Rw2IcP4JMw8mvEqkTBjcvBXS/WZBba
	GvUJnMITbizgMOSGhuVf3w7lGs9rQTY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-d4ZBcCU2NH2LfT37_BS1Wg-1; Mon,
 23 Jun 2025 05:59:16 -0400
X-MC-Unique: d4ZBcCU2NH2LfT37_BS1Wg-1
X-Mimecast-MFC-AGG-ID: d4ZBcCU2NH2LfT37_BS1Wg_1750672756
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E926B19560BE;
	Mon, 23 Jun 2025 09:59:15 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA3671956096;
	Mon, 23 Jun 2025 09:59:13 +0000 (UTC)
Date: Mon, 23 Jun 2025 11:59:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: dm-table: fix checking for rq stackable devices
In-Reply-To: <aFHze2MNk1LU1_13@kernel.org>
Message-ID: <1ca5ff9e-5e48-4909-7cef-1090c83c882f@redhat.com>
References: <20250613230852.2838268-1-bmarzins@redhat.com> <aFHze2MNk1LU1_13@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4lhwi0Fxuw0fhqAOYrRC0McvX_GbkbTEHSbw-mSlYSU_1750672756
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 17 Jun 2025, Mike Snitzer wrote:

> On Fri, Jun 13, 2025 at 07:08:52PM -0400, Benjamin Marzinski wrote:
> > Due to the semantics of iterate_devices(), the current code allows a
> > request-based dm table as long as it includes one request-stackable
> > device. It is supposed to only allow tables where there are no
> > non-request-stackable devices.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Amazing this type of bug is still lurking, thought I audited all of
> the iterate_devices callout functions.. anyway, thanks for fixing it!
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

I've applied the patch, thanks.

Mikulas

