Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC837200A3
	for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732214786; cv=none; b=Z+3ssK6RSzJDvOGGhMQ1ZYd+pH+Ymb2zcLQ3XUP7I8vPdC2ZzZbgK0XVo/Hwez/YwvlHi6dhMYc8rEKeopepcU9zIwRsCsHYZEVZnCvOGlxbmzHwdgx/ryM5id4vLRxltlO/L5B1CpvtAbL28eChyrvAclAY+DLS/UWOAHgfEeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732214786; c=relaxed/simple;
	bh=Xrtv1mWfHgRce/YneWZMoAymLEfSBbEIzcqqXl4rG8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CSKX8Ix7VoOXfcfrgyp7rgo/wyoEny7Ne9P5QHF2W0pN9eHdfkfF3A7QtnjJSarLoD+yBeAtc5e8zwGN2RilbPKOJ2A3POUkGJhBEVT+jFf+Wub7XqsyNsSsInTGkmEwO9m5QtepFWraAMzbK1AnJaHumgJkYHweTz3uOZWkVW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3mj32JY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3mj32JY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732214783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qxbp1dH6nAGWPG8IyLlYU2E61PxhDA0dzq6HoRO/DDE=;
	b=A3mj32JYTnSQms0UAcFG/xGefhIVLvDRnVGJgco0u3Idn6zxB/d7+vWqSKW/UDy2/eUBQJ
	bROZbHTo8S0i28LJcmV0HKnxWL9gSakA0eNkXbbvOxQqYnvRF/J5nKAtIRcOGpIWuYFkFt
	phHS3zHFT8JoBjBSy0TyMU7ozacHiic=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-NEm-n7whNZ6o3t8ORb1Xqg-1; Thu,
 21 Nov 2024 13:46:20 -0500
X-MC-Unique: NEm-n7whNZ6o3t8ORb1Xqg-1
X-Mimecast-MFC-AGG-ID: NEm-n7whNZ6o3t8ORb1Xqg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5321D1955EE9;
	Thu, 21 Nov 2024 18:46:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD45830001A0;
	Thu, 21 Nov 2024 18:46:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4ALIkHNq707328
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 21 Nov 2024 13:46:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4ALIkHUB707327;
	Thu, 21 Nov 2024 13:46:17 -0500
Date: Thu, 21 Nov 2024 13:46:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] libmultipath: Fix MAPINFO_CHECK_UUID with partitions
Message-ID: <Zz9_-QcFat49thMA@redhat.com>
References: <20241121001744.699362-1-bmarzins@redhat.com>
 <6f53bcf8b37d466e92609ab0a21672ff50914461.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6f53bcf8b37d466e92609ab0a21672ff50914461.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HUjo60c3XVqYKo7YLtHrPFXR8WmCwuCIEfYLBpWyJq4_1732214779
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 21, 2024 at 06:05:48PM +0100, Martin Wilck wrote:
> On Wed, 2024-11-20 at 19:17 -0500, Benjamin Marzinski wrote:
> > In libmp_mapinfo__(), if is_mpath_part_uuid() succeeded, instead of
> > ending the 'if' statement, is_mpath_uuid() would be called because of
> > the OR operator.  This would always fail if is_mpath_part_uuid()
> > passed.
> > This meant that libmp_mapinfo__() could never match partitions with
> > MAPINFO_CHECK_UUID.
> > 
> > Fix that by not calling is_mpath_uuid() if MAPINFO_PART_ONLY is set.
> > 
> > Fixes: c1aa0285 ("libmultipath: make MAPINFO_CHECK_UUID work with
> > partitions")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Ouch. Thanks!!
> Reviewed-by: Martin Wilck <mwilck@suse.com>

So, in theory the next step would be to open a PR for the upstream
stable branch, if that existed, right?

-Ben

