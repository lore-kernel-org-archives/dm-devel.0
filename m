Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DD81428F3
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083778; cv=none; b=eKNgWwIGrGr7dyq0Xf00nuJAit8Xeeo5LeZimSYeqmyPVpSQYfSkvj+r2RPE5lnw9saxd3Gwdysm3SAwcaDfa7Rvt7c/XpyIqVXgDaOENfNawKAvHPzn+2jPqTiIg38RqQpENeLSRN+l8XJ1Bl/9s4oqDvZeGd119Mup/8nL2lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083778; c=relaxed/simple;
	bh=5s+6uUs6U2Wyeim650iUoSlAb6XcY437YvK9YMuZJvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HZogHaQ+aBZV2imdrPFMRsMT8AaSphyw5Da6TbEwcmmf80R1xcT3RjXcCBXYv799DcFBQypAGQzJ4w+cEnDHU/7WpPFmdEugPApnSX+nGZ6gFmzPW0FKEu6GslSMQ/If5V781GAxToPX+Vm95Svl/BU1LkCf/s7PvGS7d0eoh0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QumkEON2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QumkEON2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bB7KexFKOZbl4yl9T3k7sATUsSCUuZcw1Mlo0+tzZmc=;
	b=QumkEON2SEWsR2jfE0Ehu+W2AI4jWGppVkZ9VWQVJpEIe+VVorPTwKigmn5a92biiM7ZvZ
	unx5bY/ULPCFlu8TqP8+i1qSP/R+Icy9WD99iBPhm+aQbmEsBDT35HsizUpuHtUWrMmbFX
	QW5GAMT4BCR6FSJXhlYqm24oIOO6VkY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-rEHxFQRePvSYVH2abwf_cw-1; Mon,
 15 Jul 2024 18:49:30 -0400
X-MC-Unique: rEHxFQRePvSYVH2abwf_cw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3522F19560A2;
	Mon, 15 Jul 2024 22:49:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C259D1955F3B;
	Mon, 15 Jul 2024 22:49:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMnRpf2096933
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:49:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMnRZK2096932;
	Mon, 15 Jul 2024 18:49:27 -0400
Date: Mon, 15 Jul 2024 18:49:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 46/49] libmultipath: fix deferred_remove logic in
 remove_partmap()
Message-ID: <ZpWnd7TNBP121cOB@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-47-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-47-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:54PM +0200, Martin Wilck wrote:
> The logic for returning DM_FLUSH_BUSY in remove_partmap() got
> accidentally reverted in commit 20aeeb6. Fix it.
> 
> Fixes: 20aeeb6 ("libmultipath: fix deferred_remove function arguments")
Oops.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index b52b10e..5749d63 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1383,7 +1383,7 @@ remove_partmap(const char *name, void *data)
>  
>  	if (dm_get_opencount(name)) {
>  		dm_remove_partmaps(name, rd->flags);
> -		if ((rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
> +		if (!(rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
>  			condlog(2, "%s: map in use", name);
>  			return DM_FLUSH_BUSY;
>  		}
> -- 
> 2.45.2

