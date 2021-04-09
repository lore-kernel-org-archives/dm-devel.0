Return-Path: <SRS0=WBCP=JG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1B6C433ED
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:02:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 067E5610CA
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 067E5610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617980561;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=opa6hWrsjwLqQgkQBMw6to875183gnMxWDHBpYJ08rg=;
	b=V33crKexObhsQmVxuk5X+oC1Sy2Doi9Zz9KHV/DkSoEIKxZsyz6g4/Jmc+OUBONE/6zKdn
	G6YlpfckU59aTxjmDK4ofXN3gRi4W5Ozw6qd7UdRx5rFr4iM6twjqIh+eFKPhJP+/ysq8h
	J+ZHDYkuG9w84m/K+ZfiZQqHh2FjdhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-9h_aMC2gOYiZEDAxQflMqA-1; Fri, 09 Apr 2021 11:01:29 -0400
X-MC-Unique: 9h_aMC2gOYiZEDAxQflMqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C009DC7440;
	Fri,  9 Apr 2021 15:00:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 991D35D9C0;
	Fri,  9 Apr 2021 15:00:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CEDA91806D10;
	Fri,  9 Apr 2021 15:00:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 139ExEXC024156 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 10:59:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 982B86A97F; Fri,  9 Apr 2021 14:59:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 965FC60D79;
	Fri,  9 Apr 2021 14:59:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 139Ex8dD016305; 
	Fri, 9 Apr 2021 09:59:08 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 139Ex7fD016304;
	Fri, 9 Apr 2021 09:59:07 -0500
Date: Fri, 9 Apr 2021 09:59:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20210409145907.GB20773@octiron.msp.redhat.com>
References: <bdc30cf9-dcc6-dedb-dead-2aa3db6e25b4@huawei.com>
MIME-Version: 1.0
In-Reply-To: <bdc30cf9-dcc6-dedb-dead-2aa3db6e25b4@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: fix memory leak in
	checker_cleanup_thread
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 09, 2021 at 03:15:05PM +0800, lixiaokeng wrote:
> If checker_cleanup_thread is called after cleanup_checkers,
> the checker_class will not be freed.
> 
> Here, we use free_checker_class instead of checker_class_unref
> in checker_cleanup_thread.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/checkers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 2dd9915d..7cc80f0b 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -368,7 +368,7 @@ static void checker_cleanup_thread(void *arg)
>  {
>  	struct checker_class *cls = arg;
> 
> -	(void)checker_class_unref(cls);
> +	(void)free_checker_class(cls);
>  	rcu_unregister_thread();
>  }
> 
> -- 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

