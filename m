Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D9F36B056
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 21:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773868420; cv=none; b=I2rszX0NcJj8vYYj4X06hJ9+ZrWSTINyjiVQZBYSmkmYZ+IGvUusNPEtwpIg8TTFGmRxLt3WWlmh8kmIgon9vduSGfqBxlN/p3Il523O6ar9ajTta6Ojd1ceW3XkFNZVMvD8WDkg0YZx/EvncXu1+bdFqCjhoI9UbOUH86sG0HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773868420; c=relaxed/simple;
	bh=DnSXVtgeWG1A0ClZ5fTYM+squvRZMvlpgAekTWYcBJU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PO98dVXPjZNyUKjqtqhsN91+g94Mo7HyPDurBVq9K0Ln0Gsfl07swqatP37CJjayaS12znY+VR8P4sqSgUWMCQlygAIVVpjB7SGH1w/9Fe18yNwuVdp8fiK2NPFMv4QjlUMdWT0THi47kT8MqAPrZBmJZeKIrMIssZ+SybZchsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g22zdEqV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g22zdEqV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773868417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w1MPr/Y2OYs/6DUml9V9UNan2lkgXjy2qRgvUJHpje0=;
	b=g22zdEqVmZJznahn2WdkfQYIc3+3yZ/elBGjLjnqN+2zTzsu/iJeM7bwvSLsW2pMimOwro
	k+wJ3U3Xft5aK1YN+7jzD0zHQivxwe3muFkswiK0JUVDFm3P4flDCwaw6Ypn5NYh6xvG25
	NBvBTydaB8825vGjXEqMcKGQA1guxy4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-ZXdWG96PO9ayDf8xbTwQrg-1; Wed,
 18 Mar 2026 17:13:36 -0400
X-MC-Unique: ZXdWG96PO9ayDf8xbTwQrg-1
X-Mimecast-MFC-AGG-ID: ZXdWG96PO9ayDf8xbTwQrg_1773868415
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F1E419560AE;
	Wed, 18 Mar 2026 21:13:34 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FA8F1800765;
	Wed, 18 Mar 2026 21:13:31 +0000 (UTC)
Date: Wed, 18 Mar 2026 22:13:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Peter Korsgaard <peter@korsgaard.com>
cc: Guillaume Gonnet <ggonnet.linux@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@schwermer.no, 
    chanho.min@lge.com, jaeyuel.im@lge.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
In-Reply-To: <87y0jpf2ar.fsf@dell.be.48ers.dk>
Message-ID: <0964cb66-6273-9e42-c393-31ff799a2d01@redhat.com>
References: <20260317213229.18371-1-ggonnet.linux@gmail.com> <46a69472-84a8-c02b-1879-af30da13523c@redhat.com> <87y0jpf2ar.fsf@dell.be.48ers.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: SmUf9ouyfBiFglf74v0Xu7jez5jLIECxj4OOxNMKhc8_1773868415
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 18 Mar 2026, Peter Korsgaard wrote:

> >>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
> 
>  > Hi
>  > I staged the patch, thanks.
> 
> But how does it work? Do we still need the other wait_for_device_probe()
> call? This looks nontrivial, a comment would be helpful.
> 
> -- 
> Bye, Peter Korsgaard

So, if you want to add some comment to the code or to the patch header, 
let me know, and I will add it.

Mikulas

