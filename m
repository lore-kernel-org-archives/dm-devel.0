Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38493C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 27 May 2022 19:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1653680154;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+B3pXvmanXBmD8tZG7PEyfHfgr5rF3N6pOAGyoH1Zt4=;
	b=Dq0wGakUvSuicPHYUhJOaltw3k1nsu+IjrdRMDPVbhjEFF5TeBp9Oz04YRmNdjD/k4W/Cc
	ZfLXaRKxeA30Qv76sVkwAnwMMtY+/Vt6WImP/uCg+/ySAZ6KVH6VdWrt/3Kzpx2f4HhCfk
	XrDvMOX9/Scy7RgjjyX7IGTiOdWA4O8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-mIBozhBxN1y8Ry0jp7o5CA-1; Fri, 27 May 2022 15:35:52 -0400
X-MC-Unique: mIBozhBxN1y8Ry0jp7o5CA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C03901C06EE3;
	Fri, 27 May 2022 19:35:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 819B49D7F;
	Fri, 27 May 2022 19:35:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3B2B71947041;
	Fri, 27 May 2022 19:35:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F72219466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 27 May 2022 19:35:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 226612166B29; Fri, 27 May 2022 19:35:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0911C2166B26;
 Fri, 27 May 2022 19:35:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 24RJZj66020011;
 Fri, 27 May 2022 14:35:45 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 24RJZjbf020010;
 Fri, 27 May 2022 14:35:45 -0500
Date: Fri, 27 May 2022 14:35:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Wu Guanghao <wuguanghao3@huawei.com>
Message-ID: <20220527193544.GM5254@octiron.msp.redhat.com>
References: <d76b39d2-d6a8-8cb0-a1de-aa684c7371b8@huawei.com>
MIME-Version: 1.0
In-Reply-To: <d76b39d2-d6a8-8cb0-a1de-aa684c7371b8@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH]dm_get_map: fix segfault when can't found
 target
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
Cc: lixiaokeng@huawei.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
 dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>,
 linfeilong@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 27, 2022 at 10:27:37AM +0800, Wu Guanghao wrote:
> We got a segfault when we test multipath + iscsi.
> 
> (gdb) bt
> #0  __strlen_avx2 () at ../sysdeps/x86_64/multiarch/strlen-avx2.S:74
> #1  0x00007f694306cd23 in __GI___strdup (s=0x0) at strdup.c:41
> #2  0x00007f69433a147c in dm_get_map (name=0x55d4bc090320 "3600140537cde137ea8c43d8a971462c7",
>     size=size@entry=0x55d4bc0270d8, outparams=outparams@entry=0x7f6941add640) at devmapper.c:688
> #3  0x00007f69433cbbdf in update_multipath_table (mpp=mpp@entry=0x55d4bc026f30,
>     pathvec=pathvec@entry=0x55d4bc063990, flags=flags@entry=0) at structs_vec.c:426
> #4  0x00007f69433cbfe5 in update_multipath_strings (mpp=0x55d4bc026f30, pathvec=0x55d4bc063990)
>     at structs_vec.c:526
> #5  0x000055d4bb52e03e in check_path (vecs=0x55d4bbfad760, pp=0x7f692402d270, ticks=<optimized out>)
>     at main.c:2280
> #6  0x000055d4bb52f3e2 in checkerloop (ap=0x55d4bbfad760) at main.c:2542
> #7  0x00007f694305b3ba in start_thread (arg=<optimized out>) at pthread_create.c:443
> #8  0x00007f69430ddb40 in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81
> (gdb) f 2
> #2  0x00007f69433a147c in dm_get_map (name=0x55d4bc090320 "3600140537cde137ea8c43d8a971462c7",
>     size=size@entry=0x55d4bc0270d8, outparams=outparams@entry=0x7f6941add640) at devmapper.c:688
> 688			*outparams = strdup(params);
> (gdb) l
> 683			*size = length;
> 684	
> 685		if (!outparams)
> 686			r = DMP_OK;
> 687		else {
> 688			*outparams = strdup(params);
> 689			r = *outparams ? DMP_OK : DMP_ERR;
> 690		}
> 691	
> 692	out:
> (gdb) p params
> $1 = 0x0
> 
> If can't found target, we should goto out
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/devmapper.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 2507f77f..450b17ef 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -682,8 +682,8 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
>         r = DMP_NOT_FOUND;
>         /* Fetch 1st target */
>         if (dm_get_next_target(dmt, NULL, &start, &length,
> -                              &target_type, &params) != NULL)
> -               /* more than one target */
> +                              &target_type, &params) != NULL || !params)
> +               /* more than one target or not found target */
>                 goto out;
> 
>         if (size)
> --
> 2.27.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

