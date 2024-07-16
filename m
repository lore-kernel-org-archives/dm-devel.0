Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EFD198840
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721141581; cv=none; b=gGt08Yokw4yqHhpP5R9zwXO6Q/yLglzAM3qovDxG1+CYiMWoWtdTYMRwivDY14K49mlO6YNCY7hLrKSiYK+s7suZBCb3m63cj1rHrKjfy0D2NT7aYvA3lkpsA9beIvZTSzF5Vb5CFQeu+Dqz2eWlcoamaj+C+DDBnCMTtEULqDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721141581; c=relaxed/simple;
	bh=hkUFWCAPyy+cQhWGX5PVZcmMPnv5rh7NVVh6MtgSQy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=URGjwqjpXXgqFXnJvMFZuhOZyDhHdQFHRou/rPEp5mInC8pbRYNM3FRG0aSMlToI/DO/hR35UT9By81d8qQEZqea7eogoGVn6ZsmHJqu1rpcPG6p8DljO1uoac/NkgzSXbnH7TbTYN/sBmIJ87vXP0J5zQmm1DrYYcNjNO7wjJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIH+zN5F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIH+zN5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721141578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YwGDcNHcqVgoeZBaGLHz+NJmubDZKclKXYrUR+1kbJU=;
	b=dIH+zN5FWHW/wr5S0YkPqtKFqYW0kMOb8BP6HMlIAyZneGc3xBHplG3IAN56Un4zcGtLL6
	kaNDqiY6PHc3fWgUbqg2x6o5XoVOM5OYs3cV0iMMBUVl5UOcEN6jOL725LWE+fqOxugbub
	GIiPb/QyXXJG69C9sEdkeZ0PXscOtXU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-dxc7nEWINoib9F8g70EXNA-1; Tue,
 16 Jul 2024 10:52:57 -0400
X-MC-Unique: dxc7nEWINoib9F8g70EXNA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42CED1955D53;
	Tue, 16 Jul 2024 14:52:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6F4A1955F68;
	Tue, 16 Jul 2024 14:52:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GEqs2P2121188
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:52:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GEqs1N2121187;
	Tue, 16 Jul 2024 10:52:54 -0400
Date: Tue, 16 Jul 2024 10:52:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 10/22] multipathd: return 0 from path_check() if that
 path wasn't checked
Message-ID: <ZpaJRqHi9OLDUe-M@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-11-bmarzins@redhat.com>
 <688a240ecca834fec6c2847a292a8adbdc9f74c7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <688a240ecca834fec6c2847a292a8adbdc9f74c7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2024 at 06:05:28PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > If check_path_state() returns PATH_WILD or PATH_UNCHECKED, then the
> > path wasn't correctly checked, and path_check() should return 0.
> 
> You mean check_path(). Other than that,

I'll fix that in the next version.

-Ben

> 
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed_by: Martin Wilck <mwilck@suse.com>

