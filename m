Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7444C77B75
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 22:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684880095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A+vlqZtfTyXpIWCf0h54SVBUkjRJlaGVWRJe+rtqIc0=;
	b=IiwW3nbMdmhULi/0e84MNAQGcg3c2koioqIE943rVV4FgG7eRODPFtB01YyfApQWk7b1Re
	bDpmIvlYfy2YD69RNv0KKQ/Id2HXr5JDHSTW4s5RzvzgMirPaxShsm7O8gkolgR/tx7wpW
	b7mg0s3iikiV0+Xn0fHtslVfdEi1iLU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-vtSycywsNZCCLp0bmF_3XA-1; Tue, 23 May 2023 18:14:54 -0400
X-MC-Unique: vtSycywsNZCCLp0bmF_3XA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 203EC101A52C;
	Tue, 23 May 2023 22:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0AF6E2166B25;
	Tue, 23 May 2023 22:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B2BE319465A8;
	Tue, 23 May 2023 22:14:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BAF419465A8
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 22:14:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E95F92166B26; Tue, 23 May 2023 22:14:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E15E62166B25
 for <dm-devel@redhat.com>; Tue, 23 May 2023 22:14:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C86D0280AA7B
 for <dm-devel@redhat.com>; Tue, 23 May 2023 22:14:51 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-4CoPrHfYPFaB7-p7REiIhQ-1; Tue, 23 May 2023 18:14:48 -0400
X-MC-Unique: 4CoPrHfYPFaB7-p7REiIhQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 39240627B5;
 Tue, 23 May 2023 22:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEDDC433D2;
 Tue, 23 May 2023 22:14:46 +0000 (UTC)
Date: Tue, 23 May 2023 22:14:45 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "J. corwin Coburn" <corwin@redhat.com>
Message-ID: <20230523221445.GC888341@google.com>
References: <20230523214539.226387-1-corwin@redhat.com>
 <20230523214539.226387-4-corwin@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20230523214539.226387-4-corwin@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 03/39] Add memory allocation utilities.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23, 2023 at 05:45:03PM -0400, J. corwin Coburn wrote:
> diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
> new file mode 100644
> index 00000000000..00b992e96bd
> --- /dev/null
> +++ b/drivers/md/dm-vdo/memory-alloc.c
> @@ -0,0 +1,447 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright Red Hat
> + */

Copyright statements need to include a year.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

