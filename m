Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE183B52F4
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 18:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790621470; cv=none; b=tU3i71taOAYx7Ic/8cCFMLCTlMRotgpajdSEjLr1WbhWdCtjrNjFfvBBX2FNrqvbZdyROK8RpFfsHZYUXjp9KoqVacLJSkNc2DXYUJ5QqZsmsbeU2ajGC7+x6Jyg+DbVK2PdkJi78GehvdbYx81JvvBBnO7AuabHloFebYS6stk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790621470; c=relaxed/simple;
	bh=VUKHB0xV/TOUJZKlitGEQ27eafwwJjo6A7gzmKSruAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pHagPLrle9RP6D9aChs3D9mHfIm1O0LSFHoat1qPj3EnB6BGSpWET0sC05DYogqaqayNbVmM0Gcwo59fFq4zLiigAuKkUfobaw5cFtGNRdUf4G7Psu2O0uKugVf3VApCxo6PysaIFphtWnHwb+G3ilUsidOqbvmvgvd4ilFRWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cL5gFgIv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cL5gFgIv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790621455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9y0gKQGOU32GGVOjX7APFNs+U3DEyaUKiY0npgt11E=;
	b=cL5gFgIvcxEWxCL31NLVb3fXc9Dxc/hdl8YZ623idxhflQHw/5n0VpcoJHNUT4/lbni/Wd
	eH6bMw1xwtnRPJuqNvKsEhEscfI/BOBjLxqK4X6PuQ0YNzBpx+9p5FmK9I3Tc+FBT4vrkI
	5GnhP56MOQkzXF+DOOurGpZ0Vt7J5B8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-5_vGulFxP2qjSx4ioxQfUQ-1; Mon,
 28 Sep 2026 14:50:52 -0400
X-MC-Unique: 5_vGulFxP2qjSx4ioxQfUQ-1
X-Mimecast-MFC-AGG-ID: 5_vGulFxP2qjSx4ioxQfUQ_1790621451
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBB5D1800757;
	Mon, 28 Sep 2026 18:50:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C76330000E8;
	Mon, 28 Sep 2026 18:50:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 68SIonND3594252
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 14:50:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 68SIomKN3594251;
	Mon, 28 Sep 2026 14:50:48 -0400
Date: Mon, 28 Sep 2026 14:50:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Simon Dodsley <simon@purestorage.com>
Subject: Re: [PATCH 1/1] multipath: resolve map paths before delegating -f to
 multipathd
Message-ID: <arq3COa2XcN_D-Km@redhat.com>
References: <cover.1790610404.git.brian@purestorage.com>
 <27189ec36e897519735f76a26833e39b0f4557bc.1790610404.git.brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <27189ec36e897519735f76a26833e39b0f4557bc.1790610404.git.brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7Ik9mcG463-awDMf56C8HZ7sSUhkKXLeXr5NXTR18GU_1790621451
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 28, 2026 at 09:54:43AM -0700, Brian Bunker wrote:
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -729,6 +729,30 @@ get_dev_type(char *dev) {
>  	return DEV_NONE;
>  }
>  
> +/*
> + * multipathd resolves "del map $map" arguments by alias, WWID or dm-N
> + * name, not by device path. If a map was passed as a path, e.g.
> + * /dev/mapper/$alias or /dev/disk/by-id/dm-uuid-mpath-$WWID, replace it
> + * with the map name.
> + */
> +static void
> +resolve_devmap_path(char *dev)
> +{
> +	struct stat buf;
> +	char __attribute__((cleanup(cleanup_charp))) *name = NULL;
> +
> +	if (valid_alias(dev) || stat(dev, &buf) != 0 ||
> +	    !S_ISBLK(buf.st_mode))
> +		return;
> +
> +	name = dm_mapname(major(buf.st_rdev), minor(buf.st_rdev));
> +	if (!name)
> +		return;
> +
> +	condlog(3, "%s: using map name %s", dev, name);
> +	strlcpy(dev, name, FILE_NAME_SIZE);
> +}
> +
>  /*
>   * Some multipath commands are dangerous to run while multipathd is running.
>   * For example, "multipath -r" may apply a modified configuration to the kernel,
> @@ -1027,6 +1051,8 @@ main (int argc, char *argv[])
>  		condlog(0, "the -f option requires a map name to remove");
>  		goto out;
>  	}

Thanks for the fix. This looks good, although I wonder if we should
always update dev for a DEV_DEVMAP type device that we can stat(),
likely in get_dev_type(). That would keep us from needing to deal with
this again if we delegate anything else to multipathd. Thoughts, Martin?
Otherwise, I'm fine with this as is.

-Ben 

> +	if (cmd == CMD_FLUSH_ONE)
> +		resolve_devmap_path(dev);
>  
>  	while (1) {
>  		int ret = delegate_to_multipathd(cmd, dev, dev_type, conf);
> -- 
> 2.55.0

