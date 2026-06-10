Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56443822A1
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 23:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781134916; cv=none; b=kiWtFqcgytKrN5kXmfaPweB3+1HbDFjfnr49Pemq+aF9mgL5gwF8jiwp51yUV0F9AIKdSwdsHiNJZpToBSdJWJalci7Aivl/9BRQ1XHtAMEzZmW/sPDZvg9tSBpVsTWX7cX59YdHqsi2FRl+R8wLwaXvoEa7e5gWKoUG6bIECPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781134916; c=relaxed/simple;
	bh=iGx+hXYcAxM7cEBQIrVyneBDGiFc0i2Ri4+CE0dG/ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mAkUmb49XOBiRG0Nlyzdgp2f+u4VTxlxKCwk9yCiSc/hqsqIpYMRF1+TZzwNliY/mcmVyaO+jy3VCwA1JEnO0TXxX+c18loc5xwMUyWqyjpVHnY62FwfV4pY/vzSLv3FFKODcqT7coCyqK56wNlPSx6a8dSSRDksAiqDLGoiye4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MzR9B5KJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MzR9B5KJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781134914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XBJQFxlz71CL3SSgYQALjiWWN8x/z1/kRL0iRZlZv6I=;
	b=MzR9B5KJswF/uoPDH6rWkosFHDh0xgKWdexNdp5EDj25MvwqYNTdNjg8qG2xtAaanFkHSA
	8st99Dh8387A3+B8yp0o2yfEsU7uDxmnGWt6vOhBJMEFMU4GhkkL2AYZPpMfM196ofpkhW
	qgAoo/u2JnZIbjpwlJlWNM80oXWyyz4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-Le0c4XtpNg26hZnIGddmQQ-1; Wed,
 10 Jun 2026 19:41:50 -0400
X-MC-Unique: Le0c4XtpNg26hZnIGddmQQ-1
X-Mimecast-MFC-AGG-ID: Le0c4XtpNg26hZnIGddmQQ_1781134909
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 229CF195C257;
	Wed, 10 Jun 2026 23:41:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D203F180058C;
	Wed, 10 Jun 2026 23:41:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65ANfluN620975
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 19:41:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65ANflYu620974;
	Wed, 10 Jun 2026 19:41:47 -0400
Date: Wed, 10 Jun 2026 19:41:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/3] multipath-tools: remove explicit widths from macros
 in the remaining man pages
Message-ID: <ain2O4JctM79JEeT@redhat.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
 <20260607103831.336833-4-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260607103831.336833-4-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xgauswxYhly1EKUgF_dShSHV4zu9CojO0vgIB4wDmAc_1781134909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 07, 2026 at 12:38:23PM +0200, Xose Vazquez Perez wrote:
> This allows man/groff to calculate the width automatically, preventing
> excessive whitespace and improving readability on various terminal sizes.
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

