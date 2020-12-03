Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA56EC4361B
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:08:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2878420769
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2878420769
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-nqi78RDbN06Y-sjK-GVk-A-1; Thu, 03 Dec 2020 15:08:26 -0500
X-MC-Unique: nqi78RDbN06Y-sjK-GVk-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D393195D564;
	Thu,  3 Dec 2020 20:08:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 352D5189A5;
	Thu,  3 Dec 2020 20:08:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D50CE1809C9F;
	Thu,  3 Dec 2020 20:08:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3K8IOs026401 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 15:08:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B61952166B2B; Thu,  3 Dec 2020 20:08:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B10F52166B27
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:08:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82741858284
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:08:16 +0000 (UTC)
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com
	[209.85.219.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-439-DgLSPKskNpS5jDJYGyE-rQ-1; Thu, 03 Dec 2020 15:08:14 -0500
X-MC-Unique: DgLSPKskNpS5jDJYGyE-rQ-1
Received: by mail-qv1-f66.google.com with SMTP id ek7so1622917qvb.6
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 12:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=E84Y9Y3bd1KIA8HHEQMxy31r/xw7wqJxEtjP5gzLCWs=;
	b=P5TfFpRRmVYnLmmFBHViJNA3gai0cTYzHR54Jw7612oPKj92M+LYLioSWjBJ+oCN5F
	QLDGvsDtQpbG3TFLft4Q7wu/8YG197FKmiAxBIh/ZG36nIhloEj5DeWTVDdHZ3UZI3E7
	yMrpJlVsYEM8T5tRQSoy571nv2LoyLnF+hpZEdnwZknlroHi6XkpOH8paNxXUZ9aA2ZI
	cnnssJC/fiE8tWyqLtZlEHV21XVrPef+zXYCDdjncmLh1pDxvV58LhAJ2u3lkXTa4AYf
	jm92fTbwJqIZ7koLMeJ3u8AR9OseThe0AFgg2YwM1qNIgDpJ0GYl/zD7FdaJ40HVhVvS
	nSqg==
X-Gm-Message-State: AOAM533J9/CQH/6WGRBWPKLfGC03XGNQLSUGVbhv9JoiBon7lZkHFtim
	UIILjJTCXICmj3gl9b8f+z8=
X-Google-Smtp-Source: ABdhPJz2hKm+lDGvYgkLs4zZstumCaJyp1ncEaTsz5fZ/q5sogUAJL5+G1fZy7sdgZxiWwMHQjG2vg==
X-Received: by 2002:a0c:9121:: with SMTP id q30mr841418qvq.17.1607026093641;
	Thu, 03 Dec 2020 12:08:13 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
	by smtp.gmail.com with ESMTPSA id
	b14sm2407880qti.97.2020.12.03.12.08.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 12:08:12 -0800 (PST)
Date: Thu, 3 Dec 2020 15:07:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8lFkSc2nZtbfibs@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-5-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
 to the block_bio_remap tracepoint
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 05:21:38PM +0100, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

