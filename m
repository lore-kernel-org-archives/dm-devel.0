Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F833F8C5
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769441234; cv=none; b=e+gZKEx6vWpvz4sPRmqnpvoncJPC2k5exesSEnnmuDAAa6FAf5bs0lNAbufDngCWUQvQXOmzqXAAGQYiiXlq8G9W9ZEbnZPLKe2NitDEU8GajoEHJA6dFIaiVGPXYPumxMCzccJK7t6AChkpMoaz9NK5g3yudsAGIkn3Jyf9/TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769441234; c=relaxed/simple;
	bh=pn5JeZQU35qEdRJMrjAEd/FQ4nCcU0prp75YxGWJSH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=J2Lfb/jqgY2y4fnNpawbCh+LxayUTTwEv+YQV8EbK35/yiWnm01NF0JkUToHvckpxn8PhQnf9/yn9BlKOWimERTEX6DXerC6t3CDqwnmB0tl537seWQuiySnlQEjZrzMmy4IDFNO0kHTDXcm+oJcM+jHg8uEI+iM6WOtz9lcEEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4roZ7+Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4roZ7+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769441231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Up7sQFHZ9aeEQLwL7CCpjH7le2N1vjhn8OstuebeEsA=;
	b=C4roZ7+QFEPA8ommeruBuqjTBhW4IEY9eFSBI6fxisucjCq+VcGr145e/VoQFd8uAY5MHv
	98nSNNOwl4Q+i6pHSnRanx90YZBP5oSz5USUTtR6T4NG+ipg/3BgTCsCriLGOF+kpCNxML
	15AlWo6S7lMu625ewlAsewCUCVdj1+c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-7oBXf_7cP2eDNzwGc0C7Yg-1; Mon,
 26 Jan 2026 10:27:09 -0500
X-MC-Unique: 7oBXf_7cP2eDNzwGc0C7Yg-1
X-Mimecast-MFC-AGG-ID: 7oBXf_7cP2eDNzwGc0C7Yg_1769441229
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5E49180044D;
	Mon, 26 Jan 2026 15:27:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39376180066A;
	Mon, 26 Jan 2026 15:27:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60QFR7me4126557
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Jan 2026 10:27:07 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60QFR6Ah4126556;
	Mon, 26 Jan 2026 10:27:06 -0500
Date: Mon, 26 Jan 2026 10:27:06 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] kpartx: fix segfault when operating on regular files
Message-ID: <aXeHyiI7YtdQKCZx@redhat.com>
References: <20260126121325.208908-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260126121325.208908-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _rznhVCgKDTk33SJvURLcfKwx853JMUiRUdHXa6XpAQ_1769441229
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 26, 2026 at 01:13:25PM +0100, Martin Wilck wrote:
> The following problem has been introduced in multipath-tools 0.14.0:
> 
> > truncate -s1G /tmp/img
> > kpartx -a /tmp/img
> double free or corruption (out)
> Aborted                    (core dumped) kpartx -a /tmp/img
> 
> Fix it by always allocating "uuid" on the heap, rather than
> using a static char array.
> 
> Fixes: 8c39e60 ("kpartx: fix some memory leaks")
> Fixes: https://github.com/opensvc/multipath-tools/issues/139
> ---
> 
> Note: This issue also affects the pending github PRs for the
> stable branches 0.13.y, 0.12.y, 0.11.y, and 0.10.y.
> 
> A fix will be pushed to these PRs ASAP.
> 
> ---
>  kpartx/devmapper.c | 16 ++++++++--------
>  kpartx/kpartx.c    |  5 ++++-
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
> index d49c680..45dac58 100644
> --- a/kpartx/devmapper.c
> +++ b/kpartx/devmapper.c
> @@ -1,6 +1,7 @@
>  /*
>   * Copyright (c) 2004, 2005 Christophe Varoqui
>   */
> +#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -699,14 +700,13 @@ out:
>  
>  char *nondm_create_uuid(dev_t devt)
>  {
> -#define NONDM_UUID_BUFLEN (34 + sizeof(NONDM_UUID_PREFIX) + \
> -			   sizeof(NONDM_UUID_SUFFIX))
> -	static char uuid_buf[NONDM_UUID_BUFLEN];
> -	snprintf(uuid_buf, sizeof(uuid_buf), "%s_%u:%u_%s",
> -		 NONDM_UUID_PREFIX, major(devt), minor(devt),
> -		 NONDM_UUID_SUFFIX);
> -	uuid_buf[NONDM_UUID_BUFLEN-1] = '\0';
> -	return uuid_buf;
> +	char *uuid;
> +
> +	if (asprintf(&uuid, "%s_%u:%u_%s", NONDM_UUID_PREFIX, major(devt),
> +		     minor(devt), NONDM_UUID_SUFFIX) >= 0)
> +		return uuid;
> +	else
> +		return NULL;
>  }
>  
>  int nondm_parse_uuid(const char *uuid, unsigned int *major, unsigned int *minor)
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 9bdd204..cfd8212 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -334,8 +334,11 @@ main(int argc, char **argv){
>  	 * This allows deletion of partitions created with older kpartx
>  	 * versions which didn't use the fake UUID during creation.
>  	 */
> -	if (!uuid && !(what == DELETE && force_devmap))
> +	if (!uuid && !(what == DELETE && force_devmap)) {
>  		uuid = nondm_create_uuid(buf.st_rdev);
> +		if (!uuid)

We should probably print an error message before we exit, but
otherwise, this looks good.

-Ben

> +			exit(1);
> +	}
>  
>  	if (delim == NULL) {
>  		delim = xmalloc(DELIM_SIZE);
> -- 
> 2.52.0

