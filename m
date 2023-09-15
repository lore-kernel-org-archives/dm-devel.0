Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE993CD37A9
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694809904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WvryvWoCbt0M//YKUDtgZKLdOlajO14SefoqOoS/svk=;
	b=BipgXbphmFjSqvFdv2I53p+NhUUPUHb3hML4bkGtB1je99wnuE7vm1KjpWfd44hmM7eVQz
	1adlbuxRVPFsJ28JjYWbc2732L1Q1mTurcHjfBXlSyC6x6UUl03uljmGRRPnVp4eHdGCex
	KmVm5iw+7/zha3KFl2IEX8vJG4MzCW0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-OpVlcEqvPVGYXexq54BvGA-1; Fri, 15 Sep 2023 16:31:42 -0400
X-MC-Unique: OpVlcEqvPVGYXexq54BvGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 117A3101B04A;
	Fri, 15 Sep 2023 20:31:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F151A40F2D26;
	Fri, 15 Sep 2023 20:31:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B02D8194658C;
	Fri, 15 Sep 2023 20:31:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9FB831946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:31:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80AF240F2D2C; Fri, 15 Sep 2023 20:31:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 793BF40F2D26
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:31:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DAB7101B04B
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:31:39 +0000 (UTC)
Received: from omta034.useast.a.cloudfilter.net
 (omta034.useast.a.cloudfilter.net [44.202.169.33]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-EE_2xhDEPKSnRk89J1zC8A-1; Fri, 15 Sep 2023 16:31:37 -0400
X-MC-Unique: EE_2xhDEPKSnRk89J1zC8A-1
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
 by cmsmtp with ESMTP
 id hEuSqd9f0ez0ChFT8qBqNh; Fri, 15 Sep 2023 20:31:14 +0000
Received: from gator4166.hostgator.com ([108.167.133.22]) by cmsmtp with ESMTPS
 id hFTTq9lFnqs1vhFTUqTy6z; Fri, 15 Sep 2023 20:31:36 +0000
X-Authority-Analysis: v=2.4 cv=OO40YAWB c=1 sm=1 tr=0 ts=6504bf28
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=WzbPXH4gqzPVN0x6HrNMNA==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=YoX3If6DFWHe0apXbcEA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
Received: from 187-162-21-192.static.axtel.net ([187.162.21.192]:56308
 helo=[192.168.15.8])
 by gator4166.hostgator.com with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.96)
 (envelope-from <gustavo@embeddedor.com>) id 1qhFTS-002NUI-34;
 Fri, 15 Sep 2023 15:31:35 -0500
Message-ID: <6f1ff9ac-e0cb-68f0-fa2f-91780a3eedb7@embeddedor.com>
Date: Fri, 15 Sep 2023 14:32:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Kees Cook <keescook@chromium.org>, Alasdair Kergon <agk@redhat.com>
References: <20230915200407.never.611-kees@kernel.org>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20230915200407.never.611-kees@kernel.org>
X-AntiAbuse: This header was added to track abuse,
 please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.21.192
X-Source-L: No
X-Exim-ID: 1qhFTS-002NUI-34
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-21-192.static.axtel.net ([192.168.15.8])
 [187.162.21.192]:56308
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 121
X-Org: HG=hgshared;ORG=hostgator
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNfIlpm902X8RJBBLa6ex5zHI6KyyAh7h3qV2pPFQcdL7uS/ZquZiE1wIGO6gfEuVkXmdTA2+yzQAutZb6Nb2wohygOMUav3QtidQeq87W4X0wdNSgPm
 EVYhEeyD9WkRB09RX6TEkAH5xLqmkerFNXVsjgoXHOAoEkGVAN9IOC4HBjNhZK2eRlEoL4TAb0asLSD7tb0PereJsEOJkc/MFZ0=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] dm: Annotate struct dm_bio_prison with
 __counted_by
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
Cc: Mike Snitzer <snitzer@kernel.org>, llvm@lists.linux.dev,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, dm-devel@redhat.com,
 linux-hardening@vger.kernel.org, Tom Rix <trix@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: embeddedor.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 9/15/23 14:04, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct dm_bio_prison.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@redhat.com
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

> ---
>   drivers/md/dm-bio-prison-v1.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
> index 92afdca760ae..9ab32abe5ed4 100644
> --- a/drivers/md/dm-bio-prison-v1.c
> +++ b/drivers/md/dm-bio-prison-v1.c
> @@ -26,7 +26,7 @@ struct prison_region {
>   struct dm_bio_prison {
>   	mempool_t cell_pool;
>   	unsigned int num_locks;
> -	struct prison_region regions[];
> +	struct prison_region regions[] __counted_by(num_locks);
>   };
>   
>   static struct kmem_cache *_cell_cache;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

