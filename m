Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079F0C7EE2D
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684861013;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oUfdyu8XR8prTMzwjSr6coPekLihxYYAFPY6IBsYBlg=;
	b=A7cZBMSMRlx1JU3bb0HGWRI4F0NXt8YkBMkaOigDxQxyVQeUlEIzsL51wfBtjLyxODRm53
	pZARLb5dfCmsR3+69wEd2STciMGk7OkS9BWbnpuefbb3LzMdNbclaQMnOyylGKKDSlJaE8
	hF8oIIflUq+Seg4TQfT4Ep/XXfG4pj8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-KGYuWlItO8ySTRcpq8msBw-1; Tue, 23 May 2023 12:56:50 -0400
X-MC-Unique: KGYuWlItO8ySTRcpq8msBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5BE3380673E;
	Tue, 23 May 2023 16:56:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DD442166B25;
	Tue, 23 May 2023 16:56:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09D3019465A8;
	Tue, 23 May 2023 16:56:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 41E5819465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 16:56:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D23181121319; Tue, 23 May 2023 16:56:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA9941121314
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:56:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD51D185A78E
 for <dm-devel@redhat.com>; Tue, 23 May 2023 16:56:03 +0000 (UTC)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-i0macFT0Ou6QoQWtZ_tLZw-1; Tue, 23 May 2023 12:56:02 -0400
X-MC-Unique: i0macFT0Ou6QoQWtZ_tLZw-1
Received: by mail-qv1-f43.google.com with SMTP id
 6a1803df08f44-5ed99ebe076so64321916d6.2
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684860961; x=1687452961;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=I895gSBgpzDKKLUi/M3iUfQpFGQN//aYkK8LK5AguTA=;
 b=GxoW80VmxBZfytvTxfjaAGX10gzKUyWgzjwFTST/bEwjnpwSemSvRq9hPWehdDJCjm
 lH/Y/kl0Z7F9/pycJVmLysqmaavdjdaWUPfZtsRY+uc90UGRw/+yT0+kAUXhxQ6JyMym
 7RnRrCzepUIfSG+ZCTk/1NkRfUJVqBEur4mpN8oo9NNRfwpVV5x16vLHq8WOAZyzjhcO
 w65r8uNYd/iB/nYxShix02h7fYS+3vCkTYup+aZ6DOebpeVgdojPbe9uD8Rd33NmWDGa
 QLF40fEMxwVt+e9Xc+wOFfK31fFfN6bFw+FZJ/WdS6UlYCVEe0fc/NTzlmPUCzGXWHZN
 Kz5A==
X-Gm-Message-State: AC+VfDwQRm8O8TB+Cq6EFz0V6+x+5M6vlGBhEzbSvoj0p+anWd9sHfyb
 rBVuX1417hf5p0uBNCZrEb+maWU=
X-Google-Smtp-Source: ACHHUZ7flOXCsLoBxKovnaaX/oi0L/ZSk0yhITAbxyTXaocIhbpqrKl1r3JlMCNYZavegSmc6yz+9Q==
X-Received: by 2002:a05:6214:2aa4:b0:5ef:a772:2731 with SMTP id
 js4-20020a0562142aa400b005efa7722731mr22618918qvb.11.1684860961501; 
 Tue, 23 May 2023 09:56:01 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 cz10-20020a056214088a00b0062120b054easm2895666qvb.20.2023.05.23.09.56.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 09:56:01 -0700 (PDT)
Date: Tue, 23 May 2023 12:56:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZGzwIGPfRggsU0Ek@redhat.com>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-18-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230523074535.249802-18-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 17/24] dm-snap: simplify the origin_dev ==
 cow_dev check in snapshot_ctr
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23 2023 at  3:45P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Use the block_device acquired in dm_get_device for the check instead
> of doing an extra lookup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

