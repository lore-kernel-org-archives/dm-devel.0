Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E668C7618E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 20:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682108137;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dQGKtAuGpnwdMT8l5G2/T2eolOmOevyO5oO1O5XD864=;
	b=Ivb3slTk0d2x/47bgRcZv7SDX/3NH38z47p6Eb1ot8g/BRqIdshiuOoAGCai26NVinOoGK
	TTpT55NS2VTnXdNWDtomwctf2gGirAA3KxENEuoaLIBqvAPJem8Y2zJ8lzu690/RPDRERE
	jaMsRe2l1gOmbvpKQpnahfBdSlmBHTk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-8M7dU3YtM8SOFImXEeUByg-1; Fri, 21 Apr 2023 16:15:35 -0400
X-MC-Unique: 8M7dU3YtM8SOFImXEeUByg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4826C800047;
	Fri, 21 Apr 2023 20:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 371AA492C3E;
	Fri, 21 Apr 2023 20:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 118451946A40;
	Fri, 21 Apr 2023 20:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9351819466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 20:15:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57B1040BC798; Fri, 21 Apr 2023 20:15:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 507BE40C6EC4
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 20:15:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2975B29AA2C3
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 20:15:27 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-FXchvCnIN3Wj3RJjdVMOKw-1; Fri,
 21 Apr 2023 16:15:25 -0400
X-MC-Unique: FXchvCnIN3Wj3RJjdVMOKw-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1ppxA3-00FZsC-AG; Fri, 21 Apr 2023 20:15:15 +0000
Date: Fri, 21 Apr 2023 21:15:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Message-ID: <ZELu017UCTZWrCjv@casper.infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-2-mcgrof@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230421195807.2804512-2-mcgrof@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 1/5] dm integrity: simplify by using
 PAGE_SECTORS_SHIFT
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
Cc: djwong@kernel.org, philipp.reisner@linbit.com, linux-mm@kvack.org,
 dm-devel@redhat.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, p.raghav@samsung.com,
 senozhatsky@chromium.org, snitzer@kernel.org, linux-block@vger.kernel.org,
 kbusch@kernel.org, axboe@kernel.dk, da.gomez@samsung.com,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, minchan@kernel.org,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 21, 2023 at 12:58:03PM -0700, Luis Chamberlain wrote:
> -	*pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	*pl_index = sector >> (PAGE_SECTORS_SHIFT);

You could/should remove the () around PAGE_SECTORS_SHIFT

(throughout)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

