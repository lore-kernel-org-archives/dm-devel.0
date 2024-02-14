Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93768F59
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 01:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707873790; cv=none; b=mFmFVZZFrRu7Q3eDNWMA1sWAlr2LbWMxy37ua9I1IkEV2rEZTHMFi3TS+MDDEtw/AaoNZFbjzTMpIDQpzUffEWI8nPJzU6CA0aB4fUtqXumywhbrK4c7qP4dVw67H59MFTbNCSCYZv+Fc0Zmn5woDYJvO4LTmLD0qobQ+KMpko0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707873790; c=relaxed/simple;
	bh=G6GW53j9NcvDwH+nGa1SDBivZpAB8MULRRKy9J6ioSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=isFBaWJzYJvdfI4fH2mIWwBo7UcJmkU+JZUffcOZKT97wTqk5+dAVOKhpvwG67KSH+cvinc0J5fWQle5tOqWTQA977f0SmB8UjIt5tKQVkE68KaGvH7O3BO9DkD3979URTVQq1GA+KXEfvrsBd1ofWpUaDNRRxeyqsMMxmwgW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gMuEVQJI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMuEVQJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707873787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Us7qRFRMIt+H4iWbNej9O6C/fDJSGYOfNpkUVAUGKYA=;
	b=gMuEVQJIy9nfZlwrWt8iQl2V0V/wpKuAv2fFCk3qImEomvdSnTdsoz90Yqgpv4tZlM8tX8
	/CPDJ04aisaRSTPsYRvnVtYkYAa2tK06L8KHv9nyT3zrUe4VoJYL8aScUUC8zn9XYIUxbv
	Z/vCCdAe4v5/CGtOUHW/CMUTH9YJ0RE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-h8fy4x4wMBSqRsdD8hIZNQ-1; Tue,
 13 Feb 2024 20:23:02 -0500
X-MC-Unique: h8fy4x4wMBSqRsdD8hIZNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B3482932486;
	Wed, 14 Feb 2024 01:23:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F090040C9444;
	Wed, 14 Feb 2024 01:23:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41E1N11U402677
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Feb 2024 20:23:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41E1N18N402676;
	Tue, 13 Feb 2024 20:23:01 -0500
Date: Tue, 13 Feb 2024 20:23:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Arnon Yaari <arnony@infinidat.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Tom Abraham <tabraham@suse.com>, Jiri Belka <jiri.belka@suse.com>
Subject: Re: [PATCH] libmultipath: hwtable: fix fast_io_fail for Infinibox
Message-ID: <ZcwV9el54uXWUF_0@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240131114835.20982-1-mwilck@suse.com>
 <8da0f0ed7b9c70f98bb7e92ecc917831499d04f1.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8da0f0ed7b9c70f98bb7e92ecc917831499d04f1.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Feb 10, 2024 at 06:15:45PM +0100, Martin Wilck wrote:
> Gentle review reminder.
> 
> On Wed, 2024-01-31 at 12:48 +0100, Martin Wilck wrote:
> > The Infinibox hwtable entry had fast_io_fail and dev_loss both set to
> > 15,
> > which has the effect that fast_io_fail is switched off (dev_loss
> > timeout
> > must be higher than fast_io_fail timeout).
> > 
> > Remove the dev_loss value, which will cause the default of 600 to be
> > used.
> > Experience shows that dev_loss_tmo values below a few minutes are
> > seldom
> > helpful.
> > 
> > Fixes: 55da608 ("libmultipath: update INFINIDAT builtin config")
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Cc: Arnon Yaari <arnony@infinidat.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> > Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > Cc: Tom Abraham <tabraham@suse.com>
> > Cc: Jiri Belka <jiri.belka@suse.com>
> > ---
> >  libmultipath/hwtable.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 808af54..9ef3e45 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -1161,7 +1161,6 @@ static struct hwentry default_hw[] = {
> >  		.minio_rq      = 1,
> >  		.flush_on_last_del = FLUSH_ENABLED,
> >  		.fast_io_fail  = 15,
> > -		.dev_loss      = 15,
> >  	},
> >  	/*
> >  	 * Kaminario

