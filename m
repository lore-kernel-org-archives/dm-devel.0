Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4241CB325
	for <dm-devel@lists.linux.dev>; Fri,  6 Sep 2024 11:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725622700; cv=none; b=Pc8CJfhBAsMLfNfu4LVMo8ext8yeM6RjhEqDxAH9WxTXIcBW9TMSrImdLOEFBEXBqDcMbUQM/U0z6aBtHLQvxSIefKshxKChphKWehqNUZWUJDkgP5zdlwZDu7whsWL4km4RYcbb55g3LdZLpJJXgqqU+5QjjqgamdxEEQbz1Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725622700; c=relaxed/simple;
	bh=isfKCo/EJMP0WbCVrPEFfRQBpB4Ab8FpPw1L1SI1k4M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=J1AW/C6F4Qm5xrN4KugK35PWNJoAPJLiuf5W6mHcbjKs77udV48ylufrN0IGvW2pngJi+fWoy4wO0jWC4ukHL6WRlI9CoZTxMT6CPAjFHiukL/9A10zx86u92z+6deIQKUNOUPlwfxQHe+jIkQxRpvaOvvhJYryZv0X0bY9ZL7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qwda6Awb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qwda6Awb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725622697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6AWmXzOPl7WKbXIU5VgiA4pokfrTwMPgrxFCz0ePH8=;
	b=Qwda6AwbMDQYE24cHiWTEyKoutWf7feUcD0i9HVyF8MzXnuVCmGNXWD5pIOTBJDseReY3o
	cj4QMeSQrtWkAP7ma3cf8+qJn6/JENlwuF452HnYQwcKYaQ2AXFm7/G2T9VMorxp+XaOOi
	vOiJjELLDv+WKaAgJWFen1lryxGnY4U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-JKlo3Q2CNTmeCTk9_DIIzQ-1; Fri,
 06 Sep 2024 07:38:14 -0400
X-MC-Unique: JKlo3Q2CNTmeCTk9_DIIzQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA5141955D55;
	Fri,  6 Sep 2024 11:38:12 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90E7E1956086;
	Fri,  6 Sep 2024 11:38:10 +0000 (UTC)
Date: Fri, 6 Sep 2024 13:38:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Chen Ni <nichen@iscas.ac.cn>, agk@redhat.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: dm integrity: Convert comma to semicolon
In-Reply-To: <ZtnBjyn8eSygoaT1@kernel.org>
Message-ID: <d6f3b1b0-130b-f83c-fca1-470d3116b08c@redhat.com>
References: <20240905022832.1642756-1-nichen@iscas.ac.cn> <ZtnBjyn8eSygoaT1@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Thu, 5 Sep 2024, Mike Snitzer wrote:

> On Thu, Sep 05, 2024 at 10:28:32AM +0800, Chen Ni wrote:
> > Replace comma between expressions with semicolons.
> > 
> > Using a ',' in place of a ';' can have unintended side effects.
> > Although that is not the case here, it is seems best to use ';'
> > unless ',' is intended.
> > 
> > Found by inspection.
> > No functional change intended.
> > Compile tested only.
> > 
> > Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> 
> I agree, the use of comma is bizarre.  Not sure how that slipped
> through but...
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Applied, thanks.

I don't know why I used ',' there.

Mikulas

