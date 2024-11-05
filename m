Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6651CB9E6
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823749; cv=none; b=P+Uisbh4Vw8Nm+wIxaDyYMCrgG1X1jORvQP+3Cu7Ue7EQiDkFANE/sEnlLpe4xXa5gHTrJmUX14N70sO483Uq4GX0MEf7T+Iz82eo+fDXEIJmYRef5wBfgIWZVQJrZT6n1XdCESkaIY7aDOU3fiTpq1A/DhRbT0yvRsN2+sv+8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823749; c=relaxed/simple;
	bh=PIGAarUdUVz4dgUSq/0utXLUhMn2y5oFkPoKavjO2Bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pBjjcSEVSfYb4J3kKR8hluw/+eQgclLBE8dMf8aMzjWYZH0L867fQoR9eUq+BYoOWmeVlEkqfsPgHAd7cgQTV86eGVgB4LnF/jfH9422xsgXl4AVLAAU+fB9TPl8FVGyGCsuDyGPWTcVmALmy9m+aRZfKGCgeMLXlls1Q+fhkh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M48y2teQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M48y2teQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730823746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFZBxEyeKfBYKEq5HGozZDuDcJ+Fsz4qDByA+V+i9aw=;
	b=M48y2teQhrune8vF+G/JHd6rzpJJKmpMcKK2JfbNegwJe/JoF/wgFBeAYft8WN6ZHXLYdl
	7lIzc+wCokAIyDS/SDbBGY+ChXbCWXjIK8JPhqIJt5wYipPfiLk6JI1p1Bp2mF/wDbQk70
	S5qhHEkoZnAn5rZa9yngdrm/HUmuN2A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-cDHrQMy6PQOUilbkXm16OQ-1; Tue,
 05 Nov 2024 11:22:25 -0500
X-MC-Unique: cDHrQMy6PQOUilbkXm16OQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F4BE1955EEA;
	Tue,  5 Nov 2024 16:22:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1F1819560A3;
	Tue,  5 Nov 2024 16:22:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A5GMLjl457439
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 5 Nov 2024 11:22:22 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A5GMLbq457438;
	Tue, 5 Nov 2024 11:22:21 -0500
Date: Tue, 5 Nov 2024 11:22:21 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: Re: [PATCH] multipathd: checker port_state before setting it.
Message-ID: <ZypGPZOaJt9HnZQU@redhat.com>
References: <20240917155858.959835-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240917155858.959835-1-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 17, 2024 at 11:58:58AM -0400, Benjamin Marzinski wrote:
> If the rport port_state is already Marginal, trying to set it to
> Marginal causes an error like the following:
> 
> multipathd[365376]: /sys/devices/pci0000:c0/0000:c0:01.1/0000:c4:00.0/host0/rport-0:0-5/fc_remote_ports/rport-0:0-5: failed to set port_state to marginal: Invalid argument
> 
> To avoid causing this confusing error message, check if the port_state
> is already marginal before trying to set it.
> 
> Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Ping. My in-kernel fix for this was accepted, but it would be nice to
have this work on older kernels as well.

-Ben

> ---
>  multipathd/fpin_handlers.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
> index be087ca0..6b56f9b7 100644
> --- a/multipathd/fpin_handlers.c
> +++ b/multipathd/fpin_handlers.c
> @@ -169,9 +169,14 @@ fpin_els_add_li_frame(struct fc_nl_event *fc_event)
>  /*Sets the rport port_state to marginal*/
>  static void fpin_set_rport_marginal(struct udev_device *rport_dev)
>  {
> +	char old_value[20]; /* match kernel show_fc_rport_port_state() size */
>  	static const char marginal[] = "Marginal";
>  	ssize_t ret;
>  
> +	ret = sysfs_attr_get_value(rport_dev, "port_state",
> +				   old_value, sizeof(old_value));
> +	if (ret == sizeof(marginal) - 1 && strcmp(old_value, marginal) == 0)
> +		return;
>  	ret = sysfs_attr_set_value(rport_dev, "port_state",
>  				   marginal, sizeof(marginal) - 1);
>  	if (ret != sizeof(marginal) - 1)
> -- 
> 2.45.0
> 

