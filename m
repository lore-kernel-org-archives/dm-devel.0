Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005FDC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:14:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94D8961B72
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 94D8961B72
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637194493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qccvkvG7zWjQ0+X431E9yfQluMMMHEiNn9o+2Q0Jqd0=;
	b=eYczUaaJY4I7Xy6Mled8nGn7ofd3v7ma/5WWqPNCuZAXsEAdn1GBeXI/OpkUeGiyX2dTR8
	Iq/jKypuVQqy79GOe6nah/AuhtbZE9VjlJIcCXLiFHCBpf77+qfCi2RXDGZNOhVTaCFYLU
	eXGHpDjlM9ko/LubkZ+m9aUjSWiwRvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-nADq7x_2MaiU3mpxgCKpZA-1; Wed, 17 Nov 2021 19:14:50 -0500
X-MC-Unique: nADq7x_2MaiU3mpxgCKpZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B17201B2C98A;
	Thu, 18 Nov 2021 00:14:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81C909808;
	Thu, 18 Nov 2021 00:14:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D20B04A703;
	Thu, 18 Nov 2021 00:14:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AI0EHOL007188 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 19:14:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4B59A3AEA; Thu, 18 Nov 2021 00:14:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96BF99329;
	Thu, 18 Nov 2021 00:14:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AI0EAJw006087; 
	Wed, 17 Nov 2021 18:14:11 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AI0EAc8006086;
	Wed, 17 Nov 2021 18:14:10 -0600
Date: Wed, 17 Nov 2021 18:14:10 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20211118001410.GE19591@octiron.msp.redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<8d2e8d87-67dd-e4e1-3253-abcd229c4546@huawei.com>
MIME-Version: 1.0
In-Reply-To: <8d2e8d87-67dd-e4e1-3253-abcd229c4546@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 3/5] remove unnecessary free
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 16, 2021 at 10:00:09PM +0800, lixiaokeng wrote:
> arg will be free by cleanup_charp. FREE(args)
> is unnecessary before return. Remove it.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/prioritizers/weightedpath.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
> index ea03fc3d..32d1cf0c 100644
> --- a/libmultipath/prioritizers/weightedpath.c
> +++ b/libmultipath/prioritizers/weightedpath.c
> @@ -75,13 +75,12 @@ int prio_path_weight(struct path *pp, char *prio_args)
>  	if (!prio_args)
>  		return priority;
> 
> -	arg = temp = STRDUP(prio_args);
> +	arg = temp = strdup(prio_args);
> 
>  	regex = get_next_string(&temp, split_char);
> 
>  	/* Return default priority if the argument is not parseable */
>  	if (!regex) {
> -		FREE(arg);
>  		return priority;
>  	}
> 
> -- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

