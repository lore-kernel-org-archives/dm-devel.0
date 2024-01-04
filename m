Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904E62C6A1
	for <dm-devel@lists.linux.dev>; Thu,  4 Jan 2024 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekCc9MB3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704401638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zn6co9E7UIQTnk1YX6xIndMIClnuRKLzuL2DkozD51E=;
	b=ekCc9MB3Hwzuql/ebVZpODCJj5WEvKrfZhCO16vzTO60BHPxf7PIavDhwPi7QGKI+n0zRB
	gyAPu1M1JnFUIZYp8a0TA0rOD+hzqJ1HeqnWjRYIEfRJr14z0o49MbAtbvxDkB4oaz8i4k
	fo+pvhSfBbEaEB4/lf9CDrgGDZ7rMw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-c9qKERb4OjWLcB9ukvWLLw-1; Thu, 04 Jan 2024 15:53:54 -0500
X-MC-Unique: c9qKERb4OjWLcB9ukvWLLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A244A185A785;
	Thu,  4 Jan 2024 20:53:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 986B31121306;
	Thu,  4 Jan 2024 20:53:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 404Krr3R035437
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 4 Jan 2024 15:53:53 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 404KrrVa035436;
	Thu, 4 Jan 2024 15:53:53 -0500
Date: Thu, 4 Jan 2024 15:53:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Lidong Zhong <lidong.zhong@suse.com>
Subject: Re: [PATCH] libmultipath: fix ANA prioritizer enablement logic
Message-ID: <ZZca4QTcg5vFNVgi@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240104110732.9110-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240104110732.9110-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 04, 2024 at 12:07:32PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Fixes: 3e71d8a ("multipath-tools Makefiles: create config.mk")
> 
> Suggested-by: Lidong Zhong <lidong.zhong@suse.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/prioritizers/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
> index fdec36e..ff2524c 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -26,7 +26,7 @@ LIBS = \
>  	libpriopath_latency.so \
>  	libpriosysfs.so
>  
> -ifneq ($(ANA_SUPPORT),1)
> +ifeq ($(ANA_SUPPORT),1)
>  	LIBS += libprioana.so
>  	CPPFLAGS += -I../nvme
>  endif
> -- 
> 2.43.0

