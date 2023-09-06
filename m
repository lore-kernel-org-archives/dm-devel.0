Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BB3EE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040331;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ku52I7/1S6jFBZ/uuQO3CDZbakSDTxVE75LPO0KTjsc=;
	b=NvBNAox4HoJtwJjlOKOK+ZPjmZKYT2wTHN303jnoQO4oqIZZ4FUjK/QMk8vhIzKD6Ll8sC
	f1LK2uf+IAoNfspS92EREJeBffzICcDjPun72SlF2CgZtkK7F3aRlRFTxm5so13yYlcnsy
	tIoysDIddjulfamgHlznm5m28RLGj8c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-xCpeNBTnOw2wSfrS2gCJLQ-1; Wed, 06 Sep 2023 18:45:28 -0400
X-MC-Unique: xCpeNBTnOw2wSfrS2gCJLQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 674778164E1;
	Wed,  6 Sep 2023 22:45:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54554404119;
	Wed,  6 Sep 2023 22:45:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22F61194658D;
	Wed,  6 Sep 2023 22:45:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B3E61946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:45:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2E255412F2CF; Wed,  6 Sep 2023 22:45:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1657C412F2CE;
 Wed,  6 Sep 2023 22:45:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MjFxl028985;
 Wed, 6 Sep 2023 17:45:16 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MjFno028984;
 Wed, 6 Sep 2023 17:45:15 -0500
Date: Wed, 6 Sep 2023 17:45:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224515.GZ7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-16-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-16-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 15/21] libmultipath: update_bindings_file:
 use a single write()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:28PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Save code and syscalls by assembling the content in memory first.
> write() may return less bytes written than expected. Deal with it.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 76d852f..c26f37c 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -118,22 +118,30 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
>  static int write_bindings_file(const Bindings *bindings, int fd)
>  {
>  	struct binding *bnd;
> -	STRBUF_ON_STACK(line);
> +	STRBUF_ON_STACK(content);
>  	int i;
> +	size_t len;
>  
> -	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
> -	    != sizeof(BINDINGS_FILE_HEADER) - 1)
> +	if (__append_strbuf_str(&content, BINDINGS_FILE_HEADER,
> +				sizeof(BINDINGS_FILE_HEADER) - 1) == -1)
>  		return -1;
>  
>  	vector_foreach_slot(bindings, bnd, i) {
> -		int len;
> +		if (print_strbuf(&content, "%s %s\n",
> +					bnd->alias, bnd->wwid) < 0)
> +			return -1;
> +	}
> +	len = get_strbuf_len(&content);
> +	while (len > 0) {
> +		ssize_t n = write(fd, get_strbuf_str(&content), len);
>  
> -		if ((len = print_strbuf(&line, "%s %s\n",
> -					bnd->alias, bnd->wwid)) < 0)
> +		if (n < 0)
> +			return n;
> +		else if (n == 0) {
> +			condlog(2, "%s: short write", __func__);
>  			return -1;
> -		if (write(fd, get_strbuf_str(&line), len) != len)
> -			return -1;
> -		truncate_strbuf(&line, 0);
> +		}
> +		len -= n;
>  	}
>  	return 0;
>  }
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

