Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38E8264FBB
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740418521; cv=none; b=uG3pwdttnu0vK51UUW4GgmAOuOfiDBBlkxWpcaX/Qv48E7lJG3TEnULzz4s7SSxWi0zhrGf91bL+JtWoQ5hphAcRz51r2MUp++zH+Oivwrcq2BCUwQnSSjSEWa5pk7UUR7n6CbW/6c7sU5P089NGfv2Zeo9bsNE5gXbN3c4BcX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740418521; c=relaxed/simple;
	bh=4dg642uFUUrdBKXU44vw+x58yFmspXaedTKF9zIjjY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=a/ubWuLmki3XzAhQUZrfm3N/qNqmoBGjZIuLpT6QTEgn+Si/lTTSLF/xC5lYfQgii1TrGx87cJKWGKlPrSP1H3uiatyuW5E6QLo0BwahsDWVxS3I9ky+wicfoTbjo2X30npHPKyNW+Tdkv2lWyU3LSK6WG/IpEoCLLD4Kmi5gSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBqtDeJP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBqtDeJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740418518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vcyo3TvMnY277sy41zamwBezmvmLISfwrOUNCPLDis=;
	b=EBqtDeJPkqQYtsMrMI/EXLWwN8HPlCACv/hJwhPrW9nmxI28uGfZAY7l8GRcavEtSR6h9X
	ddepqR98qevdMtrkQ0xm0rH7kkNZZco0cWVgiukM2zMR/9Duz8P7X1KvvVqMsJzXnE5fQ8
	7EU9pYJ09QGRpj2QnwGX3jkx7QebsvI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-OznFfT1SNpWEVbocLzoRGg-1; Mon,
 24 Feb 2025 12:35:17 -0500
X-MC-Unique: OznFfT1SNpWEVbocLzoRGg-1
X-Mimecast-MFC-AGG-ID: OznFfT1SNpWEVbocLzoRGg_1740418516
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 754E9196E078;
	Mon, 24 Feb 2025 17:35:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F40DF1800877;
	Mon, 24 Feb 2025 17:35:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51OHZEu8301062
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 12:35:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51OHZEre301061;
	Mon, 24 Feb 2025 12:35:14 -0500
Date: Mon, 24 Feb 2025 12:35:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Alice Frosi <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 09/10] libmpathcmd: honor MULTIPATH_SOCKET_NAME
 environment variable
Message-ID: <Z7yt0vTRWUa1Bj3M@redhat.com>
References: <20250221204108.70631-1-mwilck@suse.com>
 <20250221204108.70631-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221204108.70631-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4trKXgndiUUsSENq89DY3GLGjk6Y9sWviTJjnJHUFPQ_1740418516
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2025 at 09:41:08PM +0100, Martin Wilck wrote:
> In systemd installments, users can already override the socket names
> that systemd listens on. With this patch, clients using libmpathcmd
> can be customized to use a non-standard socket by setting an environment
> variable.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathcmd/mpath_cmd.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index 83cb6ad..5a23236 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -20,6 +20,7 @@
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <stdio.h>
> +#include <stdlib.h>
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <sys/un.h>
> @@ -104,6 +105,7 @@ int mpath_connect__(int nonblocking)
>  	int flags = 0;
>  	const char *const names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
>  	int name_idx = 0;
> +	const char *env_name = getenv("MULTIPATH_SOCKET_NAME"), *name;
>  
>  retry:
>  	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
> @@ -116,12 +118,13 @@ retry:
>  			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
>  	}
>  
> -	len = mpath_fill_sockaddr__(&addr, names[name_idx]);
> +	name = env_name ? env_name : names[name_idx];
> +	len = mpath_fill_sockaddr__(&addr, name);
>  	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
>  		int err = errno;
>  
>  		close(fd);
> -		if (++name_idx == 1)

You lost a "+" from ++name_idx

Otherwise, looks good. Assuming that gets updated when you push it to
your queue branch:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> +		if (name != env_name && +name_idx == 1)
>  			goto retry;
>  		else {
>  			errno = err;
> -- 
> 2.48.1

