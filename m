Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D9F6C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 06:57:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-RX790-xxMm-PQUE7HID-tg-1; Thu, 21 Apr 2022 02:57:43 -0400
X-MC-Unique: RX790-xxMm-PQUE7HID-tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3820F811E78;
	Thu, 21 Apr 2022 06:57:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26973111F3DF;
	Thu, 21 Apr 2022 06:57:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC04B1949763;
	Thu, 21 Apr 2022 06:57:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C29419451EC
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Apr 2022 06:57:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39042111E3EA; Thu, 21 Apr 2022 06:57:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3469A111E3E9
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 06:57:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1760C381A82A
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 06:57:37 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-iBU8eKCYM4y2bGQVXD5ljQ-1; Thu, 21 Apr 2022 02:57:33 -0400
X-MC-Unique: iBU8eKCYM4y2bGQVXD5ljQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nhQkd-00BuPJ-S6; Thu, 21 Apr 2022 06:57:15 +0000
Date: Wed, 20 Apr 2022 23:57:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YmEAS5hi7Os9Lgcq@infradead.org>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-5-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220420020435.90326-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax
 access mode
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
 peterz@infradead.org, djwong@kernel.org, x86@kernel.org, david@fromorbit.com,
 linux-kernel@vger.kernel.org, willy@infradead.org, hch@infradead.org,
 dave.hansen@intel.com, dm-devel@redhat.com, bp@alien8.de, vgoyal@redhat.com,
 luto@kernel.org, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
 dan.j.williams@intel.com, ira.weiny@intel.com, agk@redhat.com
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

> +	if (bb->count &&
> +		badblocks_check(bb, sector, num, &first_bad, &num_bad)) {

Weird alignment here, continuing lines for conditionals are aligned
either after the opening brace:

	if (bb->count &&
	    badblocks_check(bb, sector, num, &first_bad, &num_bad)) {

or with double tabs.  I tend to prefer the version I posted above.

The being said, shouldn't this change even be in this patch and not just
added once we add actual recovery support?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

