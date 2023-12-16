Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B7F4681
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ffk8GQ8P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702697826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FrdU0+AOoI0Lz2HqWZ9fReqYHA5EiurlcrHdPAQ7g7M=;
	b=Ffk8GQ8PBC7p1x9jhIgI2F0EZ0PIEyvvKA1+glg87/tLDvMvn5wbmqx0WKMBZSX5+bWKxS
	ADtXl8gpOkqoe3CF3GHwKEflIdHjPcmcvZmrZZvrCqKgtdDSLfnm/Bdee4+/N7rtkyg1jS
	Gdje2RyDY01MaOFKFa0MolZHip0aPOA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-O9DZwu4JMsOuAnyUFHtZ-Q-1; Fri,
 15 Dec 2023 22:37:02 -0500
X-MC-Unique: O9DZwu4JMsOuAnyUFHtZ-Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1BBC1C04194;
	Sat, 16 Dec 2023 03:37:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C687492BC6;
	Sat, 16 Dec 2023 03:37:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3b2jE678007
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:37:02 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3b2vF678006;
	Fri, 15 Dec 2023 22:37:02 -0500
Date: Fri, 15 Dec 2023 22:37:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 16/16] multipath: Don't always retry deletgated remove
 failures
Message-ID: <ZX0bXu0mvP9cPxWI@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
 <20231212235320.440336-17-bmarzins@redhat.com>
 <7e24501a5434ed0d11108c23062f407156aedce8.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7e24501a5434ed0d11108c23062f407156aedce8.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 06:26:58PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > Now that multipathd is running the same code to remove devices as
> > multipath, multipath doesn't need to automatically retry the remove
> > if
> > it fails.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> If we know that multipathd executes the same commands that multipathd
> does, why don't we just call delegate_to_multipathd() repeatedly until
> the retries are exhausted?

We could. The benefit of the multipath command is a more specific error
when the device is in use, and it will work even if multipathd is
wedged. On the other hand users can always check the logs for the
specifics of which device was in use and we could handle ETIMEDOUT or a
reply of "fail\ntimeout" specially. We might want to do that even if the
user doesn't ask for retries, since it would be useful for all the
delegated commands to failback to doing the work in multipath if
multipathd is timing out.

-Ben
 
> Martin

