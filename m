Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0090C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 08:43:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-xplme4WNNyK_Z4o2gmTDAQ-1; Tue, 22 Mar 2022 04:43:03 -0400
X-MC-Unique: xplme4WNNyK_Z4o2gmTDAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1988185A7B2;
	Tue, 22 Mar 2022 08:43:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B4D01121324;
	Tue, 22 Mar 2022 08:43:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40ABC1949762;
	Tue, 22 Mar 2022 08:43:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CBEE1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 08:43:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2AE1E4B6946; Tue, 22 Mar 2022 08:43:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26E2F4B693F
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:43:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D36A80281D
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:43:00 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-czNA5B1TOTijHf1SZNcUCw-1; Tue, 22 Mar 2022 04:42:58 -0400
X-MC-Unique: czNA5B1TOTijHf1SZNcUCw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nWa6M-00ASLb-Cr; Tue, 22 Mar 2022 08:42:50 +0000
Date: Tue, 22 Mar 2022 01:42:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YjmMCjDuakvTzRRc@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-3-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220319062833.3136528-3-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v6 2/6] x86/mce: relocate
 set{clear}_mce_nospec() functions
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
 djwong@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org,
 willy@infradead.org, hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
 vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
 dan.j.williams@intel.com, ira.weiny@intel.com, linux-xfs@vger.kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +EXPORT_SYMBOL(set_mce_nospec);

No need for this export at all.

> +
> +/* Restore full speculative operation to the pfn. */
> +int clear_mce_nospec(unsigned long pfn)
> +{
> +	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +}
> +EXPORT_SYMBOL(clear_mce_nospec);

And this should be EXPORT_SYMBOL_GPL.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

