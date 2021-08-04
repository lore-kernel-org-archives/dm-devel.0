Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D55C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 814DC61055
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 814DC61055
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-1pjJbZfmNLWOTcP71ex4EA-1; Mon, 09 Aug 2021 02:53:47 -0400
X-MC-Unique: 1pjJbZfmNLWOTcP71ex4EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6DD294EF0;
	Mon,  9 Aug 2021 06:53:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A828B5D6A8;
	Mon,  9 Aug 2021 06:53:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7DF2718005A2;
	Mon,  9 Aug 2021 06:53:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 174Aa1Vu011484 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 06:36:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BEF83EE847; Wed,  4 Aug 2021 10:36:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9A35DAF25
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 10:35:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B528D1857F02
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 10:35:58 +0000 (UTC)
Received: from www.kot-begemot.co.uk (ivanoab7.miniserver.com
	[37.128.132.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-303-8XOboiD-PPSDI4oKULGjxw-1; Wed, 04 Aug 2021 06:35:56 -0400
X-MC-Unique: 8XOboiD-PPSDI4oKULGjxw-1
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6]
	helo=jain.kot-begemot.co.uk) by www.kot-begemot.co.uk with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1mBDqd-0007cx-Mc; Wed, 04 Aug 2021 10:10:03 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
	by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1mBDqa-00016q-Pt; Wed, 04 Aug 2021 11:10:03 +0100
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-12-hch@lst.de>
From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <0abadeca-d0fc-26ad-088e-2b137a029957@cambridgegreys.com>
Date: Wed, 4 Aug 2021 11:10:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-12-hch@lst.de>
X-Clacks-Overhead: GNU Terry Pratchett
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
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Ilya Dryomov <idryomov@gmail.com>, linux-um@lists.infradead.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>
Subject: Re: [dm-devel] [PATCH 11/15] ubd: use bvec_virt
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 04/08/2021 10:56, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/um/drivers/ubd_kern.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index e497185dd393..cd9dc0556e91 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -1268,8 +1268,7 @@ static void ubd_map_req(struct ubd *dev, struct io_thread_req *io_req,
>   		rq_for_each_segment(bvec, req, iter) {
>   			BUG_ON(i >= io_req->desc_cnt);
>   
> -			io_req->io_desc[i].buffer =
> -				page_address(bvec.bv_page) + bvec.bv_offset;
> +			io_req->io_desc[i].buffer = bvec_virt(&bvec);
>   			io_req->io_desc[i].length = bvec.bv_len;
>   			i++;
>   		}
> 
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

