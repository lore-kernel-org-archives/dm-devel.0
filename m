Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B705A11D
	for <dm-devel@lists.linux.dev>; Mon, 24 Jun 2024 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719245059; cv=none; b=tTTXfYUSoI3AL7lMxt+mvHNQYBjZTM0V2Gb6teQK7HcN7QsTlWbbtEYbSiKR+od7h80MU7w5HRttKMOfuifu2vHjio/Zp3dqmVrFFs3nZ+sonsM6t4Ka0ULnyBi5rO6Ji/2VzjTarVjnA+7Tf6xpAsWKlMEuq772Ke91uHvvXbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719245059; c=relaxed/simple;
	bh=fZS4l3PEuYoO21ZHnM7hFqZm6dGfxc9d0lJqZ7TZxnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=W4S9bKk8KzRD1KRgx2q/JbnqYLGfSS6gr5YFv0cOSFzIMrqGXHJlaPhY1A49764CozxyzyGpaWMxsndXgXbpoWnpRZslD2Daxe+AiOnlk4DXPsA4UfO4zCUwUdBaeD1fTebvhS0oy7o6PKZYjYeg8/ip6y89gCsUGrRGxkQUJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QJHZuYEW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJHZuYEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719245056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ceXVl3uTb6RE9U3ONKR2K0O9UswuZED7mg5hcygn6xs=;
	b=QJHZuYEWp3/LD40BLN9ucOeP3glO+t4LeSou/ndEDS33DMXGB6uKiYPT6ioiuoEYmhsdd5
	97lVW45Yejj7vS4y+w/xRNQvIfAQXxz73Mrzmiu9l0p1YWzVaqx1+0Cv91wdS6fPPQ5VcK
	E1WPeCu/y4xc7p+B8Y62WuSki99ingE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-iLxOuLRzOZy5klkXn-PrkA-1; Mon,
 24 Jun 2024 12:04:14 -0400
X-MC-Unique: iLxOuLRzOZy5klkXn-PrkA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0C2B19560B5;
	Mon, 24 Jun 2024 16:04:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E93331956087;
	Mon, 24 Jun 2024 16:04:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45OG4AE11341163
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:04:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45OG48UA1341162;
	Mon, 24 Jun 2024 12:04:08 -0400
Date: Mon, 24 Jun 2024 12:04:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: 303146950@qq.com
Cc: dm-devel@lists.linux.dev, mwilck@suse.com, Kou Wenqi <kouwenqi@kylinos.cn>
Subject: Re: [PATCH v2] multipath: display the correct configuration when
 dumpping config
Message-ID: <ZnmY-Mu2hcmU_4Qm@redhat.com>
References: <tencent_FE02DEB8FF48DD9EE156F288BCE172E25709@qq.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <tencent_FE02DEB8FF48DD9EE156F288BCE172E25709@qq.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2024 at 09:45:27AM +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
> 
> "multipath -t" and "multipath -T" might show the wrong
> multipathd configuration items "retrigger_tries" and
> "force_sync". Make sure they don't.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
> ---
>  multipath/main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index ce702e7f..f4abdad0 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -842,6 +842,8 @@ main (int argc, char *argv[])
>  	char *dev = NULL;
>  	struct config *conf;
>  	bool enable_foreign = false;
> +	int retrigger_tries_ori;
> +	int force_sync_ori;
>  
>  	libmultipath_init();
>  	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
> @@ -852,7 +854,9 @@ main (int argc, char *argv[])
>  	if (atexit(uninit_config))
>  		condlog(1, "failed to register cleanup handler for config: %m");
>  	conf = get_multipath_config();
> +	retrigger_tries_ori = conf->retrigger_tries;
>  	conf->retrigger_tries = 0;
> +	force_sync_ori = conf->force_sync;
>  	conf->force_sync = 1;
>  	if (atexit(cleanup_vecs))
>  		condlog(1, "failed to register cleanup handler for vecs: %m");
> @@ -924,10 +928,14 @@ main (int argc, char *argv[])
>  				conf->find_multipaths = FIND_MULTIPATHS_GREEDY;
>  			break;
>  		case 't':
> +			conf->retrigger_tries = retrigger_tries_ori;
> +			conf->force_sync = force_sync_ori;
>  			r = dump_config(conf, NULL, NULL) ? RTVL_FAIL : RTVL_OK;
>  			goto out;
>  		case 'T':
>  			cmd = CMD_DUMP_CONFIG;
> +			conf->retrigger_tries = retrigger_tries_ori;
> +			conf->force_sync = force_sync_ori;
>  			break;
>  		case 'h':
>  			usage(argv[0]);
> -- 
> 2.27.0
> 

