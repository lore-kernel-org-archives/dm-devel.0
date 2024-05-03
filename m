Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364AA155380
	for <dm-devel@lists.linux.dev>; Fri,  3 May 2024 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714752508; cv=none; b=lX3CsQH+21hmSCRRp3Y+uE3fptPNPx/I58eXT037bPFTiyBOJG5FIprADDjErYu/bh7kar0nqyjuu/I7QpQjfkLOgqyWUGlgwUNPp/TfHkqaL0TNMQXc8kOnEGeQnqm2NCs1ehkEi1jh7Jh67nKcj2/Q91g0rmlzsA34ZUiMQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714752508; c=relaxed/simple;
	bh=0l7DwsW92awh+4aS6o6qycrIJm+j5dQ3q0O84WBvngg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mGzWNZsZnEQpP5XF5Qr7ohGg5gLS8yyvBrwzW+0S4xm/rSC6lmxyi/lkxeQMmccTUiaPN4xhFA+TqlPq0iCQOf6JzVPAGAqGcSoSXCtIF2kDKwl3cJm/c78bZuRlWXIDYTV1djLLZf0OX6PVI8PtPeGFRncl7UnzPDEk3koV7vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iT8ZKWd/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iT8ZKWd/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714752506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pzSHLoMQ+y2wOjMDjMACAApQsKc1VziaOpdvOIkoK18=;
	b=iT8ZKWd/nJpWTFVTvCPjqjrV71HshN90QHpXyQx5rOO7UFvqhODQtPLTCJ3DYh1g55pYb3
	/iVaDg2TQi6GjW8GQJtcXZHbteJAdRSF5LgK0MPsEhkg9r2/vQhUYfLYuWfd6gdektyrGd
	DwcdiXaEWL/MhFzeQBlS35elusDWmVM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-Ukr2ONzJOxmnjdv9bXaMbQ-1; Fri, 03 May 2024 12:08:22 -0400
X-MC-Unique: Ukr2ONzJOxmnjdv9bXaMbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88A4818065B5;
	Fri,  3 May 2024 16:08:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 654CCC13FA4;
	Fri,  3 May 2024 16:08:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 443G8LYT2543575
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 3 May 2024 12:08:21 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 443G8KHs2543574;
	Fri, 3 May 2024 12:08:20 -0400
Date: Fri, 3 May 2024 12:08:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 0/3] libmultipath: use bitwise flags in devmapper API
Message-ID: <ZjUL9Ih86_7oCcHj@redhat.com>
References: <20240502185946.31192-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240502185946.31192-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 02, 2024 at 08:59:43PM +0200, Martin Wilck wrote:
> This series goes on top of Benjamin Marzinksi's late "multipath: fix hang
> in flush_map_nopaths" series. It introduces no functional changes. It
> just combines the multiple boolean arguments to _dm_flush_map() and
> dm_simplecmd() into a flags variable. This reduces the number of
> function arguments, but that's not the main intention. The symbolic
> flags improve the readability of the code by making it obvious which
> flags are passed to the respective functions in their callers.

Nice cleanup. For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Martin Wilck (3):
>   libmultipath: use bitwise flags for map flushing API
>   libmultipath: use bitwise flags for dm_simplecmd API
>   libmultipath: add argument names to some prototypes
> 
>  libmultipath/devmapper.c | 94 ++++++++++++++++++----------------------
>  libmultipath/devmapper.h | 33 +++++++++-----
>  2 files changed, 62 insertions(+), 65 deletions(-)
> 
> -- 
> 2.44.0

