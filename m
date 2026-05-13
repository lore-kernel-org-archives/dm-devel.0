Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D52EC086
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633759; cv=none; b=e2PRmzpnO/Qwhg1mKLKAzkA7pZvEE6BwmnaSyAES9HdzUZzQMv08oZIMnXofnMdWXn5clbuV81nvPr18abn3b0ih5gvBy5WtVY1Yif+PPXONv8DOVdiZXfPA+r4cyOaen5PW5XetMVI0+T0GRmgclj5ImN1Mgrg3ZYY6K22X1go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633759; c=relaxed/simple;
	bh=Rvb43mU1d/pLDFoPMkNOuNcJ4sxoiBm/B5YC7ghC/5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=grT9yw3vpSbwrNmBVhdERk5jPguYKToiwTlLPPJHA/AIMsRBG+CxQqJYVlfbm2/CCzkx+Ao7po2wLvmvf999Ik1oLTCK3ykI71l+D0UF6s1ksHpa7UpUoosq5C5KZZ0DBjP3TN7v3z55cUXB7WGwjLkxfS8TYas6EXy3AxXAivk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpJmnwqN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpJmnwqN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778633755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qRl5EMvcq8roATxxaEb3FtfZcRycFpEhVlokbJhxecg=;
	b=fpJmnwqN4PdwSeKYTD62JSKUgzhqZYA1RbUCtSylJME/gjdPL8GIBLAjfaMGEwFtmDqX0i
	4gzU1mgFfCGi61QBbONlF+g50wDq70JjJku3RSqIWHED0/t43x5tltjyvy6RZ0x/kqacU0
	64LQ1EaJ26QJjor+2RXa008RwKcpGHs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-VFZDI7l0N0aANiqu7_FNWA-1; Tue,
 12 May 2026 20:55:54 -0400
X-MC-Unique: VFZDI7l0N0aANiqu7_FNWA-1
X-Mimecast-MFC-AGG-ID: VFZDI7l0N0aANiqu7_FNWA_1778633753
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D295195608E;
	Wed, 13 May 2026 00:55:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B368B1955D84;
	Wed, 13 May 2026 00:55:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0tp9Y3331990
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:55:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0tpC13331989;
	Tue, 12 May 2026 20:55:51 -0400
Date: Tue, 12 May 2026 20:55:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/18] libmultipath: add generic async path checker code
Message-ID: <agPMFwUEqNoOE8w5@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-10-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-10-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cRHs4zzUAWfnVKYVQiGRmUGFzFPOqPt4pyXtROURxX4_1778633753
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:23PM +0200, Martin Wilck wrote:
> Add a framework for an asynchronous path checker utilizing the
> recently added runner code for thread handling.
> 
> This code has been derived from the TUR checker code by removing
> all references to the actual sending of TUR ioctls.
> 
> Follow-up patches will convert the current TUR checker into an
> instance of this async checker class.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/Makefile        |   2 +-
>  libmultipath/async_checker.c | 216 +++++++++++++++++++++++++++++++++++
>  libmultipath/async_checker.h |  35 ++++++
>  libmultipath/checkers.c      |   1 +
>  libmultipath/checkers.h      |   2 +
>  5 files changed, 255 insertions(+), 1 deletion(-)
>  create mode 100644 libmultipath/async_checker.c
>  create mode 100644 libmultipath/async_checker.h
> 
[...]
> diff --git a/libmultipath/async_checker.h b/libmultipath/async_checker.h
> new file mode 100644
> index 0000000..835de2a
> --- /dev/null
> +++ b/libmultipath/async_checker.h
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +// Copyright (c) 2026 SUSE LLC
> +#ifndef ASYNC_CHECKER_H_INCLUDED
> +#define ASYNC_CHECKER_H_INCLUDED
> +
> +struct runner_data;
> +struct checker;
> +typedef int (*async_checker_func)(struct runner_data *);
> +
> +struct runner_data {
> +	int fd;
> +	dev_t devt;
> +	async_checker_func afunc;
> +	unsigned int timeout;
> +	int state;
> +	short msgid;
> +	char checker_ctx[];

checker_ctx should be probably be aligned.

-Ben

> +};
> +
> +int async_check_init(struct checker *c);
> +void async_check_free(struct checker *c);
> +bool async_check_need_wait(struct checker *c);
> +int async_check_pending(struct checker *c);
> +int async_check_check(struct checker *c);
> +
> +#define CHECKER_MAX_CONTEXT_SIZE 1024
> +
> +/* For testing handling of async checker timeouts */
> +#ifdef ASYNC_TEST_MAJOR
> +static void async_deep_sleep(const struct runner_data *rdata);
> +#else
> +#define async_deep_sleep(x) do {} while (0)
> +#endif
> +
> +#endif
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index a3b9cc8..3a1663f 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -9,6 +9,7 @@
>  
>  #include "debug.h"
>  #include "checkers.h"
> +#include "async_checker.h"
>  #include "vector.h"
>  #include "util.h"
>  
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index 630e987..744be54 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -132,6 +132,7 @@ enum {
>  };
>  
>  struct checker;
> +struct runner_data;
>  struct checker_class {
>  	struct list_head node;
>  	void *handle;
> @@ -144,6 +145,7 @@ struct checker_class {
>  	void (*reset)(void);		  /* to reset the global variables */
>  	int (*pending)(struct checker *); /* to recheck pending paths */
>  	bool (*need_wait)(struct checker *); /* checker needs waiting for */
> +	int (*async_func)(struct runner_data *); /* callback for async_checker */
>  	const char **msgtable;
>  	short msgtable_size;
>  };
> -- 
> 2.54.0

