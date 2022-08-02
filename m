Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B439C00140
	for <dm-devel@archiver.kernel.org>; Tue,  2 Aug 2022 05:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659417104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9bF6l0vdr38r6dXa+V8SdS7LC3ziqMp7ZsBYlwXzrSc=;
	b=XRPjvbPejnFCjBIg/oKjiXfQGHeL7Xq1PvTZut6TJmpM8KAr0qNjVbvXhz44tboAKh34QK
	5wEcbo5CMFBpL4T7BXXYAC7lfSXmNYkvYrZp8tetIJNAuAxiVJYH3ik80SjhGgRIv4QEg/
	+hpl8gzuFTvS30RYOeLC8OxHB6OLnpY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-UXUhKQBbOv2ZM18qC_d1Uw-1; Tue, 02 Aug 2022 01:11:42 -0400
X-MC-Unique: UXUhKQBbOv2ZM18qC_d1Uw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 288301C004FF;
	Tue,  2 Aug 2022 05:11:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A217A492C3B;
	Tue,  2 Aug 2022 05:11:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79A511946A47;
	Tue,  2 Aug 2022 05:11:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BEF11946A4C
 for <dm-devel@listman.corp.redhat.com>; Tue,  2 Aug 2022 05:11:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D4A72026D64; Tue,  2 Aug 2022 05:11:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69D882026D4C
 for <dm-devel@redhat.com>; Tue,  2 Aug 2022 05:11:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EDB11C006B3
 for <dm-devel@redhat.com>; Tue,  2 Aug 2022 05:11:37 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-hDIYzQjXM9-YT4ZAsoKqkA-1; Tue, 02 Aug 2022 01:11:33 -0400
X-MC-Unique: hDIYzQjXM9-YT4ZAsoKqkA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 63E6CB8188A;
 Tue,  2 Aug 2022 05:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98B3C433D6;
 Tue,  2 Aug 2022 05:11:28 +0000 (UTC)
Date: Tue, 2 Aug 2022 07:11:24 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Yuix/CcmdKsSD+za@kroah.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com> <20220801180458.GA17425@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220801180458.GA17425@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH stable 5.10 1/3] block: look up holders by
 bdev
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
Cc: axboe@kernel.dk, snitzer@redhat.com, yi.zhang@huawei.com,
 stable@vger.kernel.org, linux-block@vger.kernel.org,
 Yu Kuai <yukuai1@huaweicloud.com>, dm-devel@redhat.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 01, 2022 at 08:04:58PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 01, 2022 at 01:19:09PM +0200, Greg KH wrote:
> > This is very different from the upstream version, and forces the change
> > onto everyone, not just those who had CONFIG_BLOCK_HOLDER_DEPRECATED
> > enabled like was done in the main kernel tree.
> > 
> > Why force this on all and not just use the same option?
> 
> I'm really worried about backports that are significantly different
> from the original commit.  To the point where if they are so different
> and we don't have a grave security or data integrity bug I'm really not
> very much in favor of backporting them at all.
> 

I agree, I'll drop this from my review queue now, thanks.

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

