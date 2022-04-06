Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08419C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 05:22:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-waA8Zi1qOpaz2PMJviX0XQ-1; Wed, 06 Apr 2022 01:22:38 -0400
X-MC-Unique: waA8Zi1qOpaz2PMJviX0XQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A271F18A6583;
	Wed,  6 Apr 2022 05:22:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D84491415130;
	Wed,  6 Apr 2022 05:22:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E15151947BBB;
	Wed,  6 Apr 2022 05:22:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BDD2019451F3
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 05:22:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3AF502024CAE; Wed,  6 Apr 2022 05:22:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 364F32026D64
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 05:21:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B0CB85A5BC
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 05:21:58 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-9Xqy0QOCNLa2niTINyrRPQ-1; Wed, 06 Apr 2022 01:21:50 -0400
X-MC-Unique: 9Xqy0QOCNLa2niTINyrRPQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nby6y-003oOR-F6; Wed, 06 Apr 2022 05:21:44 +0000
Date: Tue, 5 Apr 2022 22:21:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <Yk0jaC9rHwwoEV11@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-7-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220405194747.2386619-7-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v7 6/6] pmem: implement pmem_recovery_write()
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
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
 djwong@kernel.org, x86@kernel.org, david@fromorbit.com,
 linux-kernel@vger.kernel.org, willy@infradead.org, hch@infradead.org,
 dm-devel@redhat.com, vgoyal@redhat.com, vishal.l.verma@intel.com,
 linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, ira.weiny@intel.com,
 linux-xfs@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 05, 2022 at 01:47:47PM -0600, Jane Chu wrote:
> +	off = (unsigned long)addr & ~PAGE_MASK;

offset_inpage()

> +	if (off || !(PAGE_ALIGNED(bytes))) {

No need for the inner braces.

> +	mutex_lock(&pmem->recovery_lock);
> +	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> +	cleared = __pmem_clear_poison(pmem, pmem_off, len);
> +	if (cleared > 0 && cleared < len) {
> +		dev_warn(dev, "poison cleared only %ld out of %lu\n",
> +			cleared, len);
> +		mutex_unlock(&pmem->recovery_lock);
> +		return 0;
> +	} else if (cleared < 0) {

No need for an else after a return.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

