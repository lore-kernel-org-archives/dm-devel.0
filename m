Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E191EC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:57:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-bTKM701pPzGGw33S_00B_g-1; Fri, 11 Feb 2022 01:57:27 -0500
X-MC-Unique: bTKM701pPzGGw33S_00B_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E8F21091DA3;
	Fri, 11 Feb 2022 06:57:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11E525DBBA;
	Fri, 11 Feb 2022 06:57:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF5FC4CA9B;
	Fri, 11 Feb 2022 06:57:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B6u7CR016297 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 01:56:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C54B12166BB3; Fri, 11 Feb 2022 06:56:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C04562166BB1
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 06:56:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75C2A85A5A8
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 06:56:04 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-543-nRS_xlACMDi_vNpn0y5x0A-1; Fri, 11 Feb 2022 01:56:02 -0500
X-MC-Unique: nRS_xlACMDi_vNpn0y5x0A-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nIPqb-0061sT-5q; Fri, 11 Feb 2022 06:56:01 +0000
Date: Thu, 10 Feb 2022 22:56:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YgYIgZCMfJ5mgA9t@infradead.org>
References: <20220210223832.99412-1-snitzer@redhat.com>
	<20220210223832.99412-8-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220210223832.99412-8-snitzer@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 07/14] dm: remove code only needed before
 submit_bio recursion
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>  static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
>  				struct dm_target *ti, unsigned num_bios,
>  				unsigned *len)
> @@ -1224,14 +1218,14 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
>  	case 1:
>  		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
>  		if (len)
> -			bio_setup_sector(clone, ci->sector, *len);
> +			clone->bi_iter.bi_size = to_bytes(*len);
>  		__map_bio(clone);
>  		break;
>  	default:
>  		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
>  		while ((clone = bio_list_pop(&blist))) {
>  			if (len)
> -				bio_setup_sector(clone, ci->sector, *len);
> +				clone->bi_iter.bi_size = to_bytes(*len);
>  			__map_bio(clone);
>  		}
>  		break;
> @@ -1350,7 +1344,6 @@ static int __split_and_process_bio(struct clone_info *ci)
>  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
>  
>  	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
> -	bio_advance(clone, to_bytes(ci->sector - clone->bi_iter.bi_sector));
>  	clone->bi_iter.bi_size = to_bytes(len);

Maybe move the clone->bi_iter.bi_size assignment into alloc_tio as well?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

