Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A32371B50
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 20:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212805; cv=none; b=qGBqheHiELUXJ5n1avAu6aYX7ZknvqUudhQOxIW6ngTNzvBbP2YqWOqz+ZOlNxBdUWUtxpx4thEf7xCEEdfHe5MuIh6lVdRi+A6M4XQyCsw4pkTitd2OsPL2reb/INtOimypYag7vWzKtDgawST7EkkdEwYS0WKV6xKHXXNM9rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212805; c=relaxed/simple;
	bh=qPJVOjEezsFM2XL6tDYb2RhtONVF0U9eARItJ2ARwKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=d7VT9sWr2PviSFYp1+w7APshqDtH4J07G7uyPstkVY9jQbYpn2ibZkGrD1o0M/xtwr148/Ocb9lst7mSwx/uNPDlgh9mZKSmxErA36WxWy7IMeKEaAW1lW91at4NbxpsQEpWLWd5VVqL0vfWFJNrr89qbD69PeO6XezfrGrIN5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4YyCPon; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4YyCPon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713212803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNlpfyfj8U1n0/Sd2C3M6qnEzCqQjaHBE1WQAjdXoeY=;
	b=W4YyCPon3CJbrpOIkKlbX9srniSPFJqCaY4rL721yJH0oDBjM/PLtKmx5xuVON8RYvIDuj
	6LF/L5DZ3KhJN7BolrdKWSReo1nAa/s4lcC2YfHZjlFk7A+VZXYdUY3Pis/oWBhbOQ+LB2
	xRHr2f8vZwn13qXnwjfVp3yolo9/6Vw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-_DXJlfKKOX2yxJUySwpq7Q-1; Mon,
 15 Apr 2024 16:26:39 -0400
X-MC-Unique: _DXJlfKKOX2yxJUySwpq7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 690253819C5F;
	Mon, 15 Apr 2024 20:26:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F0F02166B31;
	Mon, 15 Apr 2024 20:26:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43FKQcPc1904562
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 16:26:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43FKQc4c1904561;
	Mon, 15 Apr 2024 16:26:38 -0400
Date: Mon, 15 Apr 2024 16:26:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipathd: Set CPUWeight to 1000
Message-ID: <Zh2NfqoNHCWg6-Tw@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240415180646.1903335-1-bmarzins@redhat.com>
 <7959de14debd4e414e40de89a6267f587de14bb9.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7959de14debd4e414e40de89a6267f587de14bb9.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Apr 15, 2024 at 08:18:08PM +0200, Martin Wilck wrote:
> On Mon, 2024-04-15 at 14:06 -0400, Benjamin Marzinski wrote:
> > If multipathd doesn't become a real time process, it was scheduled as
> > a
> > normal process, without any priority increase. Bump up the CPUWeight
> > so
> > that even as a normal process, it will still run with increased
> > priority.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/multipathd.service.in | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> But let's also decrease the default value for LimitRTPRIO.

Sure.

> 
> Martin
> 
> 
> > 
> > diff --git a/multipathd/multipathd.service.in
> > b/multipathd/multipathd.service.in
> > index 18bb367e..1b3fccd2 100644
> > --- a/multipathd/multipathd.service.in
> > +++ b/multipathd/multipathd.service.in
> > @@ -20,6 +20,7 @@ ExecStart=/sbin/multipathd -d -s
> >  ExecReload=/sbin/multipathd reconfigure
> >  TasksMax=infinity
> >  LimitRTPRIO=infinity
> > +CPUWeight=1000
> >  
> >  [Install]
> >  WantedBy=sysinit.target

