Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808D53403F4
	for <dm-devel@lists.linux.dev>; Mon,  3 Aug 2026 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772330; cv=none; b=ZGVIW9ZaexzUCuzM3ivq24N3Y0dPDck1PJReqnHSwi5UghtNekJ/q0z244NKeqVA9CwwiiHcYaOtNlGdpemRKlIHBwCjP+E3h3YrP/SagwU6WJCqB+65EQEtemETv+Bq8eSAfWOhPRSngWW75mcYfkTimyYfcHoNuTIyz7lDGWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772330; c=relaxed/simple;
	bh=IMeaVsl8g5s1xgHi0Iz9wIxC9UTZPbVbRMlNYbrrM4I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nrzPbhrPP6Jsx+giDKUy6a3KI+hxTtIVAzREpF9rwtwgf81yVK4Xc3dIwz10WksyrOKwt99dCpzG8ApG+szpVDUD9HHt9y6R19Y/1fsZS5Fn69pQI/sJ7o+06XiCDgIUQw3UCT7w01AGefCrLEG+yz1Qa1z/ribqiyEgbvWvlBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OpHVY8b1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OpHVY8b1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785772328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro3G49vUnUovrch8zqwSdAuuWst2KqH6Syt2Sx++3i4=;
	b=OpHVY8b1WcCai1stihgm01AlPxKg1wi5IKSlwEHVhgyPzCxSuscNN2LbH/sfxN+fWdUpEU
	xR2UCQjWzL5wAJyCNPxZavUcqjU4wdIyqaQDBEZ+uaYN5g6h3R/6OJnJVxoppgIEs8P7P5
	1io+YokAKhxOm784T6C1SROILkgb+hE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-GjlcptmoMPSdaLCXkaW1yA-1; Mon,
 03 Aug 2026 11:52:03 -0400
X-MC-Unique: GjlcptmoMPSdaLCXkaW1yA-1
X-Mimecast-MFC-AGG-ID: GjlcptmoMPSdaLCXkaW1yA_1785772321
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2916A180034A;
	Mon,  3 Aug 2026 15:52:01 +0000 (UTC)
Received: from [10.44.32.79] (unknown [10.44.32.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 898BC1800480;
	Mon,  3 Aug 2026 15:51:58 +0000 (UTC)
Date: Mon, 3 Aug 2026 17:51:55 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
cc: Shukai Ni <shukai.ni@kuleuven.be>, agk@redhat.com, snitzer@kernel.org, 
    bmarzins@redhat.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: Re: [PATCH v2 1/1] dm-integrity: replace forgeable discard filler
 with a keyed sector marker
In-Reply-To: <2d413e76-2709-4d11-8bd8-b34bb7465368@gmail.com>
Message-ID: <4f5d02ce-5861-6d72-83ae-70018e63b6d3@redhat.com>
References: <20260728143350.44279-1-shukai.ni@kuleuven.be> <20260728143350.44279-2-shukai.ni@kuleuven.be> <5a838e63-f772-7ef9-ab45-8bc2c1ccae87@redhat.com> <2d413e76-2709-4d11-8bd8-b34bb7465368@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 9aYoQU7uXdzY0bs3p0X6AThLZCkZeglTQ_n34fO1My0_1785772321
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 31 Jul 2026, Milan Broz wrote:

> On 7/30/26 5:29 PM, Mikulas Patocka wrote:
> > Hi
> > 
> > I accepted the patch (and made some small modifications to it).
> 
> Mikulas, you added this part to constructor:
> 
> +	if (!!(ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) !=
> ic->discard_keyed) {
> +		r = -EINVAL;
> +		ti->error = "Mismatch in the discard_keyed flag";
> +		goto bad;
> +	}
> 
> Unfortunately, this is not going to work.
> 
> In integritysetup, allowing discard is an active flag, not a format flag.
> It should be ok to activate discard later, but this check blocks it.
> It should also allow to activate the device without discard (even if it
> was activated before with it).
> 
> IMO, it should upgrade the superblock if allow_discards_keyed is set
> on activation (and then do not allow it to revert back).
> 
> With the current approach, I cannot add this option to integritysetup.
> We just have no way to send allow_discard in format action (as it is
> an activation flag only in our API).
> 
> Milan

OK.

I updated the patch at the top of the linux-dm repository, so that keyed 
discard can be set, but not disabled.

Mikulas

