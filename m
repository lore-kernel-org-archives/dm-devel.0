Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516FC3AC22
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQJjqm77"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698433852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a/DCkfwMeZ3NHcGBe1g3LFMCqDANw+dYdQVlIBCztXo=;
	b=cQJjqm77jpqP83Wo9tn1hJzTWOm6dZpm8IBJvMiiYyIbDfBx0+lDdzd6JdvjhbkBT362hp
	hkilNDE6NPDmTXiRI/X/uTRf85pOKeT7BCSH9FgyvNOacv2tG+vkjjh2xeV6+jBS391icS
	ZurXi7hoTlyr0n9Li08DvXZkbIBjZOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-_NlFcEqcNsylZDBESMXd-A-1; Fri, 27 Oct 2023 15:10:50 -0400
X-MC-Unique: _NlFcEqcNsylZDBESMXd-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07594185A780;
	Fri, 27 Oct 2023 19:10:50 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 015771C060AE;
	Fri, 27 Oct 2023 19:10:50 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RJAnbh049639
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 15:10:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RJAn0K049638;
	Fri, 27 Oct 2023 15:10:49 -0400
Date: Fri, 27 Oct 2023 15:10:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 10/14] multipath.conf.5: fix typo
Message-ID: <ZTwLOSkd82uhkbqq@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-11-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-11-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:49PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.conf.5.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index 226d001..2b70b6d 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -782,7 +782,7 @@ Specify the maximum number of seconds the SCSI layer will spend doing error
>  handling when scsi devices fail. After this timeout the scsi layer will perform
>  a full HBA reset. Setting this may be necessary in cases where the rport is
>  never lost, so \fIfast_io_fail_tmo\fR and \fIdev_loss_tmo\fR will never
> -trigger, but (frequently do to load) scsi commands still hang. \fBNote:\fR when
> +trigger, but (frequently due to load) scsi commands still hang. \fBNote:\fR when
>  the scsi error handler performs the HBA reset, all target paths on that HBA
>  will be affected. eh_deadline should only be set in cases where all targets on
>  the affected HBAs are multipathed.
> -- 
> 2.42.0

