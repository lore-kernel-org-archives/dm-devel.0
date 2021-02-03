Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F211C433DB
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 01:34:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9613864F4C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 01:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9613864F4C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-BicqUtXRNMmpqjIjm7zXlQ-1; Tue, 02 Feb 2021 20:34:02 -0500
X-MC-Unique: BicqUtXRNMmpqjIjm7zXlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C8ED1800D50;
	Wed,  3 Feb 2021 01:33:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 752295C224;
	Wed,  3 Feb 2021 01:33:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B91E4A7C6;
	Wed,  3 Feb 2021 01:33:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1131XmVD014798 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 20:33:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3F2BD74CF; Wed,  3 Feb 2021 01:33:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE66CAECAF
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 01:33:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50A5E101A531
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 01:33:46 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-487-gtE_tSswMJ6GdmLU8-IEBA-1; Tue, 02 Feb 2021 20:33:41 -0500
X-MC-Unique: gtE_tSswMJ6GdmLU8-IEBA-1
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DVkgm2h6Jz7fvJ;
	Wed,  3 Feb 2021 09:32:20 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server
	id 14.3.498.0; Wed, 3 Feb 2021 09:33:36 +0800
To: <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "Christophe
	Varoqui" <christophe.varoqui@opensvc.com>
References: <20210202195744.2384-1-mwilck@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <4c3bb639-b359-85a4-ea76-ba83347acd7c@huawei.com>
Date: Wed, 3 Feb 2021 09:33:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202195744.2384-1-mwilck@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] libmultipath: check if adopt_path() really
 added current path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2021/2/3 3:57, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The description of 2d32d6f ("libmultipath: adopt_paths(): don't bail out on
> single path failure") said "we need to check after successful call to
> adopt_paths() if that specific path had been actually added, and fail in the
> caller otherwise". But the commit failed to actually implement this check.
> Instead, it just checked if the path was member of the pathvec, which will
> almost always be the case.
> 
> Fix it by checking what actually needs to be checked, membership of the
> path to be added in mpp->paths.
> 
> Fixes: 2d32d6f ("libmultipath: adopt_paths(): don't bail out on single path failure")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> 
> @lixiaokeng, I believe that this fixes the issue you mentioned in your
> post "libmultipath: fix NULL dereference in get_be64".
>Reviewed-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/structs_vec.c | 4 ++--
>  multipathd/main.c          | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index f7f45f1..47b1d03 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -707,8 +707,8 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
>  		goto out;
>  	mpp->size = pp->size;
>  
> -	if (adopt_paths(vecs->pathvec, mpp) ||
> -	    find_slot(vecs->pathvec, pp) == -1)
> +	if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
> +	    find_slot(mpp->paths, pp) == -1)
>  		goto out;
>  
>  	if (add_vec) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 134185f..425492a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1008,8 +1008,8 @@ rescan:
>  	if (mpp) {
>  		condlog(4,"%s: adopting all paths for path %s",
>  			mpp->alias, pp->dev);
> -		if (adopt_paths(vecs->pathvec, mpp) ||
> -		    find_slot(vecs->pathvec, pp) == -1)
> +		if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
> +		    find_slot(mpp->paths, pp) == -1)
>  			goto fail; /* leave path added to pathvec */
>  
>  		verify_paths(mpp);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

