Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C2318C2E
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJq2qo7R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698435319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PVur/+dchcoLhelQAXjagSC6O6HV6KH9KEqV4FMEEEc=;
	b=WJq2qo7Rt4OSN5Y/9bolSUmtqdMkZ8pSaCLnaYZlNlJzrjGaptVR3ZQ9Q4BwFOfRqEkLra
	azYk/c9B1e/6akPrVxyMhjMHx5pq/XlC2UX6P+e/tTH/nwdaJLOF1QD6cxLOd+xAhgHtkU
	Ng4tMKMea3GRsOXCE1co0kjT528XLck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-SlLbzs1ePaGxGhXyWSI98A-1; Fri, 27 Oct 2023 15:35:16 -0400
X-MC-Unique: SlLbzs1ePaGxGhXyWSI98A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FB29811E8D;
	Fri, 27 Oct 2023 19:35:15 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98F3A1C060AE;
	Fri, 27 Oct 2023 19:35:15 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RJZFkv049785
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 15:35:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RJZF3X049784;
	Fri, 27 Oct 2023 15:35:15 -0400
Date: Fri, 27 Oct 2023 15:35:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 14/14] README.md: fix formatting of Changelog section
Message-ID: <ZTwQ8+O+Zx7tNm2h@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-15-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-15-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:53PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  README.md | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/README.md b/README.md
> index 2fb423b..0c9f51e 100644
> --- a/README.md
> +++ b/README.md
> @@ -223,8 +223,8 @@ file `libmultipath/hwtable.c`.
>  Changelog
>  =========
>  
> -pre-0.4.5: https://web.archive.org/web/20070309224034/http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
> -post-0.4.5: https://github.com/opensvc/multipath-tools/commits/master
> +* pre-0.4.5: https://web.archive.org/web/20070309224034/http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
> +* post-0.4.5: https://github.com/opensvc/multipath-tools/commits/master
>  
>  
>  Maintainer
> -- 
> 2.42.0

