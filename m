Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810752D603
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 18:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705602184; cv=none; b=l5uTNuaZFOcvO1YuV/L49WVc+sATcN9vawTzcXXu0ug0vHdLThCUpq9LVdgBeAZlRaQbYVcW0TS0WQDZFq7i4wTCcy7VYOFGL5+IfXyedUT7PEp0aw6u/L3W32fPgQ9uUHUDX7Nw94Pca6+gwQtsoNfxRirMtfmmohXNLQ4ktWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705602184; c=relaxed/simple;
	bh=tSggLnOGvSDo8X3VzP/Z0AE1TkAUwQ+EEegIOS3OPCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QrJ0cDavAjNZgjjRrl5SNrTOEtIoTZgFcHlwv4UoKGaIigbz/cUNSJI68hRw6gy/pwXQaAz4Kex6yy9ApuzCK9rfH2YvDF207kb7KqMBEVRcknT13SFmUfpVzPXTH8MRWlOf378O/TB5gfZjt0gp3/L2CKjcS3dWOK9ENU1jCp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a+YG1b2e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+YG1b2e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705602181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rIwFTeYUpfIPsBQxBTNJ3IenfNGsl7y9QyWxnnjDS24=;
	b=a+YG1b2eK/FvDmF3M98rqkSngkyd0CaAXN/iZpz5ujXSUHDeeB3sGA/ODtMMV2KTSds0xO
	KkDEztp8Pq9ObW4XuzQNyk4F6vSem2k9wKUeRnCe4eqDI4hJEX2bmKEWSOT/d9fAF7m7WP
	Htt9HExzDcFWLFkM6whjl4bz9gFeuDA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-WKY50_IuPeCbW19epC9acQ-1; Thu,
 18 Jan 2024 13:22:58 -0500
X-MC-Unique: WKY50_IuPeCbW19epC9acQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B3533C11C84;
	Thu, 18 Jan 2024 18:22:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4682D1121306;
	Thu, 18 Jan 2024 18:22:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40IIMvVC110095
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jan 2024 13:22:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40IIMuLE110094;
	Thu, 18 Jan 2024 13:22:56 -0500
Date: Thu, 18 Jan 2024 13:22:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/2] multipath: update_prio fixes
Message-ID: <ZalsgJspa-1vr3Yz@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240118114714.3391-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240118114714.3391-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 18, 2024 at 12:47:12PM +0100, Martin Wilck wrote:
> Reworked Brian's patch, and added a small cleanup on top.

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Brian Bunker (1):
>   multipathd: the local path change is not considered
> 
> Martin Wilck (1):
>   multipathd: make update_prio static, and rename refresh_all param
> 
>  multipathd/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> -- 
> 2.43.0

