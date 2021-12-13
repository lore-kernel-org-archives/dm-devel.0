Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358F1C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 08:08:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-9XguMkyEMwSDLstE4l-w2Q-1; Tue, 14 Dec 2021 03:08:49 -0500
X-MC-Unique: 9XguMkyEMwSDLstE4l-w2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7944801B35;
	Tue, 14 Dec 2021 08:08:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB8D760CC9;
	Tue, 14 Dec 2021 08:08:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97B244CA9B;
	Tue, 14 Dec 2021 08:08:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDNRBp6031716 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 18:27:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3BAD3492CA4; Mon, 13 Dec 2021 23:27:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3780A492C3B
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 23:27:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E1D9185A79C
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 23:27:11 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
	[139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-330-imGn2XkcM1C0AiQZDhQzkg-1; Mon, 13 Dec 2021 18:27:06 -0500
X-MC-Unique: imGn2XkcM1C0AiQZDhQzkg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id CDCE36127D;
	Mon, 13 Dec 2021 23:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0534CC34601;
	Mon, 13 Dec 2021 23:19:58 +0000 (UTC)
Date: Mon, 13 Dec 2021 17:25:38 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <20211213232538.GB60133@embeddedor>
References: <20211118203640.1288585-1-keescook@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20211118203640.1288585-1-keescook@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 14 Dec 2021 03:08:25 -0500
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-hardening@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm integrity: Use struct_group() to zero
 struct journal_sector
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 18, 2021 at 12:36:40PM -0800, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark region of struct journal_sector that should be
> initialized to zero.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/md/dm-integrity.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 6319deccbe09..163c94ca4e5c 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -121,8 +121,10 @@ struct journal_entry {
>  #define JOURNAL_MAC_SIZE		(JOURNAL_MAC_PER_SECTOR * JOURNAL_BLOCK_SECTORS)
>  
>  struct journal_sector {
> -	__u8 entries[JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR];
> -	__u8 mac[JOURNAL_MAC_PER_SECTOR];
> +	struct_group(sectors,
> +		__u8 entries[JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR];
> +		__u8 mac[JOURNAL_MAC_PER_SECTOR];
> +	);
>  	commit_id_t commit_id;
>  };
>  
> @@ -2870,7 +2872,8 @@ static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
>  		wraparound_section(ic, &i);
>  		for (j = 0; j < ic->journal_section_sectors; j++) {
>  			struct journal_sector *js = access_journal(ic, i, j);
> -			memset(&js->entries, 0, JOURNAL_SECTOR_DATA);
> +			BUILD_BUG_ON(sizeof(js->sectors) != JOURNAL_SECTOR_DATA);
> +			memset(&js->sectors, 0, sizeof(js->sectors));
>  			js->commit_id = dm_integrity_commit_id(ic, i, j, commit_seq);
>  		}
>  		for (j = 0; j < ic->journal_section_entries; j++) {
> -- 
> 2.30.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 
> 
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

