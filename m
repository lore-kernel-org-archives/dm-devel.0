Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C128C13AC2
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKcvA+8B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702696739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K4Ds+1nMGPC7+vjM+xS3+1N88bGz8jWtGYCE5zGqpeY=;
	b=XKcvA+8BvHkfou6P7QcJZJ6fkSls4AHRy/JKpIdw867AG5ojaLZMlvS8qcx+6WLguLz/ul
	hZ9OQLUTgSdMXWzcPVUjjNoXL8zVU4c6HAqwvTTdpnYs+h7NLwdl/HjWwMZsazABF/ORJ8
	IEhGiU7Ug977e8pOHxqJH1I5soR953Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-9CYNYhC_P6ezG_e6rPLZ3w-1; Fri, 15 Dec 2023 22:18:56 -0500
X-MC-Unique: 9CYNYhC_P6ezG_e6rPLZ3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A38CE185A781;
	Sat, 16 Dec 2023 03:18:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D86140C6EB9;
	Sat, 16 Dec 2023 03:18:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3It3u677833
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:18:55 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3ItJx677832;
	Fri, 15 Dec 2023 22:18:55 -0500
Date: Fri, 15 Dec 2023 22:18:55 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 07/16] multipathd: always start failure replies with
 "fail\n"
Message-ID: <ZX0XH8E93IR73OcO@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
 <20231212235320.440336-8-bmarzins@redhat.com>
 <9836ec8493130fd6f8ee3323fa7bd9d6da7a9cd2.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9836ec8493130fd6f8ee3323fa7bd9d6da7a9cd2.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 14, 2023 at 06:08:34PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > When multipathd interactive commands fail for certain reasons, like
> > timing out or incorrect permissions, they do not reply with "fail\n".
> > Currently, multipath and multipathc expect that a reply other than
> > "fail\n" means success. Instead, prefix all failure replies with
> > "fail\n", and adapt multipath and multipathc to return failure for
> > any
> > reply starting with "fail\n".
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libdmmp/libdmmp.c   |  6 +++---
> >  multipath/main.c    |  2 +-
> >  multipathd/uxclnt.c |  2 +-
> >  multipathd/uxlsnr.c | 12 +++++-------
> >  4 files changed, 10 insertions(+), 12 deletions(-)
> > 
> > diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
> > index 0025e66d..77f8a6a0 100644
> > --- a/libdmmp/libdmmp.c
> > +++ b/libdmmp/libdmmp.c
> > @@ -321,7 +321,7 @@ invoke:
> >  		}
> >  	}
> >  	if ((*output != NULL) &&
> > -	    (strncmp(*output, "timeout", strlen("timeout")) == 0))
> > +	    (strncmp(*output, "fail\ntimeout",
> > strlen("fail\ntimeout")) == 0))
> >  		flag_check_tmo = true;
> >  
> >  	if (flag_check_tmo == true) {
> > @@ -364,8 +364,8 @@ invoke:
> >  	}
> >  
> >  	if ((*output != NULL) &&
> > -	    strncmp(*output, "permission deny",
> > -		    strlen("permission deny")) == 0) {
> > +	    strncmp(*output, "fail\npermission deny",
> > +		    strlen("fail\npermission deny")) == 0) {
> >  		_error(ctx, "Permission deny, need to be root");
> >  		rc = DMMP_ERR_PERMISSION_DENY;
> >  		goto out;
> > diff --git a/multipath/main.c b/multipath/main.c
> > index c37befa5..4b399e21 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -804,7 +804,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
> >  	}
> >  
> >  	if (reply != NULL && *reply != '\0') {
> > -		if (strcmp(reply, "fail\n"))
> > +		if (strncmp(reply, "fail\n", 5))
> >  			r = DELEGATE_OK;
> >  		if (r != NOT_DELEGATED && strcmp(reply, "ok\n"))
> >  			printf("%s", reply);
> 
> Perhaps here we should check if the reply length is > 5, and if yes,
> strip the "fail\n" part. That would make the output consistent with
> what it used to be.
> 
> 
> > diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
> > index c3ae5db6..2401199d 100644
> > --- a/multipathd/uxclnt.c
> > +++ b/multipathd/uxclnt.c
> > @@ -31,7 +31,7 @@ static int process_req(int fd, char * inbuf,
> > unsigned int timeout)
> >  		return 1;
> >  	} else {
> >  		printf("%s", reply);
> 
> Same here.

Sure.

-Ben

> 
> > -		ret = (strcmp(reply, "fail\n") == 0);
> > +		ret = (strncmp(reply, "fail\n", 5) == 0);
> >  		free(reply);
> >  		return ret;
> >  	}
> > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > index 4d6f258c..4df01666 100644
> > --- a/multipathd/uxlsnr.c
> > +++ b/multipathd/uxlsnr.c
> > @@ -392,6 +392,11 @@ static void drain_idle_fd(int fd)
> >  
> >  void default_reply(struct client *c, int r)
> >  {
> > +	if (r == 0) {
> > +		append_strbuf_str(&c->reply, "ok\n");
> > +		return;
> > +	}
> > +	append_strbuf_str(&c->reply, "fail\n");
> >  	switch(r) {
> >  	case -EINVAL:
> >  	case -ESRCH:
> > @@ -406,13 +411,6 @@ void default_reply(struct client *c, int r)
> >  	case -ETIMEDOUT:
> >  		append_strbuf_str(&c->reply, "timeout\n");
> >  		break;
> > -	case 0:
> > -		append_strbuf_str(&c->reply, "ok\n");
> > -		break;
> > -	default:
> > -		/* cli_handler functions return 1 on unspecified
> > error */
> > -		append_strbuf_str(&c->reply, "fail\n");
> > -		break;
> >  	}
> >  }
> >  

