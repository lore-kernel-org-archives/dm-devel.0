Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662314900B
	for <dm-devel@lists.linux.dev>; Sun,  2 Mar 2025 19:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740943911; cv=none; b=Q8NJ0DR8NHSUge8HQEdsLE2CqmC6M5gLo9Z789joJxAOn/bxy0GQAcGAXED6KNyuwCYgml6NaqkvU5GFbj2rUTkgvpP8054m2mPNr62wHeB2eMyEqrpHC+XU/TSoZ5zyeH1QR15yd/1F7yxBeCb6Wiapbx+8Slv0WOBOJT+RlXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740943911; c=relaxed/simple;
	bh=g200j+RqZWunRfqI2hMOpba4xtVfNv7DKKvwkNP3bp4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sBtRGofQQ7Fbnu+SfRCQ/qWIovmf82w+pITkW+/MgElowqKDqeUI1Cc3CIHL4JmRiY1V8ulnyTPbdD+kx8oBV4wkQeu924pICYkBAePfV7kAmXdT7o9MWk4z+AzDd79n8++Rf6c/F+WSAovT0cTtSL2H+u5wUepdQgOk6QOi+mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Na4ut8iZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Na4ut8iZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740943908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eUNFq54iwM9YK2nNf18rwx3qAq3poVSqT3r3PkcBknw=;
	b=Na4ut8iZeNaQjwmN6nqbxt8LIdli8Y84OzM1hd+mtDjbCjqhzTGmdfwQZuBkTR4su0IF17
	qpmml/lQj6NtV6fHumDL/hCNzDgIeYslwPm8/H3n3LeHJA9aABL9ikuDykYMO1m0qn4PC3
	ojEbNCOe4a2vOKPEKERYoC3rEps4Iu4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-dNPOpblLNs6GvVbrXiw2Vw-1; Sun,
 02 Mar 2025 14:31:47 -0500
X-MC-Unique: dNPOpblLNs6GvVbrXiw2Vw-1
X-Mimecast-MFC-AGG-ID: dNPOpblLNs6GvVbrXiw2Vw_1740943906
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AC7418004A7;
	Sun,  2 Mar 2025 19:31:46 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C14FE1800361;
	Sun,  2 Mar 2025 19:31:43 +0000 (UTC)
Date: Sun, 2 Mar 2025 20:31:39 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming-Hung Tsai <mtsai@redhat.com>
cc: dm-devel@lists.linux.dev, Joe Thornber <thornber@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 0/2] dm cache: support shrinking the origin device
In-Reply-To: <20250228094131.132061-1-mtsai@redhat.com>
Message-ID: <4585427c-4d3a-f161-7e9c-40eb1589fd56@redhat.com>
References: <20250228094131.132061-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kQC50VlFcCf-04uKzOB1gP7_CLLjCn2iOKb6HPSXfSM_1740943906
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 28 Feb 2025, Ming-Hung Tsai wrote:

> This patch series introduces formal support for shrinking the cache
> origin and ensures that failed resume attempts, such as those caused
> by shrinking failures, do not trigger BUG_ON.
> 
> Ming-Hung Tsai (2):
>   dm cache: prevent BUG_ON by blocking retries on failed device resumes
>   dm cache: support shrinking the origin device
> 
>  drivers/md/dm-cache-target.c | 94 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 92 insertions(+), 2 deletions(-)
> 
> -- 
> 2.47.0

I applied the patches, thanks.

Mikulas

