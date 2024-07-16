Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8BD54BD4
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721141544; cv=none; b=M1A7IdD2ibhNDju72wvprjuejn7bUunuw5WuxofieMj1hM7lW2q4QVFJ3gfmBO8ky20lfHkkpQonNKnM+amg02a2EqeY9Mx5XUi1M20ncKku4hhX/imP4ZgMVc1ZhBwfZ1fqMdWEmoI7/QEsEVEl3dN4sBkYImv7zSSsq9O+enI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721141544; c=relaxed/simple;
	bh=dYso7bmsgalggJwj8Qx6tiHyQ6odGgfOI41y4veqx9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=lOUHzV4a1r8ywJOv8g9UO9hNJz+GCH7+kByAyflOBoQQhjw1k3pfUYu8I1vP6XMsVMOkLnzxalFAiWDLwyc2yLBKe+j3GbsCfjnXlQpie3g9U+EnpAHbOKZ3xwi1FjS9Es5yvIcorxPPGvc5vZH2eUEwfnxRitXJt7KQcsV+AYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCn6onzx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCn6onzx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721141541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KFqGxwUwywv3ENyivc9BuHHSHK0rcNopE/eJZYkfJyE=;
	b=cCn6onzxY6lJ5aZizfMffU9mgoDk8uNVDReqJyQIusI9aD4QQX5h9kqjMf08+bKzpzTtV0
	nVdd++gf0PmI4XwFSKykD4n1sLsN9i4raeoVSNk5eZAg1G6HUzLQOp7MJo0UgA1ibzjiwt
	o44tbxonLduaP0ykJcsZ6lva89ByvRg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-GesbhPDMPFqAnf7imDzhgQ-1; Tue,
 16 Jul 2024 10:52:17 -0400
X-MC-Unique: GesbhPDMPFqAnf7imDzhgQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCCBF1955D52;
	Tue, 16 Jul 2024 14:52:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 485FA19560B2;
	Tue, 16 Jul 2024 14:52:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GEqEA62121161
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:52:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GEqEQx2121160;
	Tue, 16 Jul 2024 10:52:14 -0400
Date: Tue, 16 Jul 2024 10:52:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 09/22] multipathd: set pp->tick = max_checkint in
 handle_uninitialized_path
Message-ID: <ZpaJHme9GN2YrswA@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-10-bmarzins@redhat.com>
 <eab659b313c56abfb6f6bb8780bebdf656cd2994.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <eab659b313c56abfb6f6bb8780bebdf656cd2994.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 06:00:33PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > When handle_uninitialized_path() checks a path, it will either:
> > 1. trigger a new uevent to initalize the path, in which case it won't
> >    check the path again until that uevent is processed and updates
> >    pp->tick
> > 2. blacklist the path, in which case the path gets removed
> > 3. intialize the path correctly, in which case it sets pp->tick = 1
> > 4. fail to initialize the path, in which case it was supposed to set
> >    pp->tick to max_checkint, but instead it set pp->checkint to
> >    max_checkint, which never worked correctly.
> > 
> > By setting pp->tick to max_checkint at the start,
> > handle_uninitialized_path() will continue to work as it previously
> > did,
> > except in case 4, where in now works correctly. There's no point in
> > messing with pp->checkint for paths that haven't been initialized
> > yet.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Q: I suppose it makes sense to backport this to earlier releases?

It's not a horrible bug. Previously, we set pp->tick to checkint early
in the function. This just means that these problematic paths will
be checked every checkint instead of every max_checkint.

Also, do you mean distros backporting this change? I'm not sure how
much value there is in maintaining upstream stable branches.

-Ben

> 
> Martin

