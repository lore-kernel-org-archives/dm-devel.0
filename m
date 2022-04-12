Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 390DDC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 06:52:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-G9BZQiyOMlKeHaj3aFiBKA-1; Tue, 12 Apr 2022 02:52:26 -0400
X-MC-Unique: G9BZQiyOMlKeHaj3aFiBKA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31C87801E67;
	Tue, 12 Apr 2022 06:52:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 513F140F4940;
	Tue, 12 Apr 2022 06:52:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E2201940365;
	Tue, 12 Apr 2022 06:52:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69A281947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 06:52:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 46501492D4F; Tue, 12 Apr 2022 06:52:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E2C1492D4E
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 06:52:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05F96101A52C
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 06:52:22 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-5jRZRhtjNICv65N7F9VaTA-1; Tue, 12 Apr 2022 02:52:20 -0400
X-MC-Unique: 5jRZRhtjNICv65N7F9VaTA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1ne8fR-00Bjrs-9H; Tue, 12 Apr 2022 05:02:17 +0000
Date: Mon, 11 Apr 2022 22:02:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YlUH2f66hMyXOP1r@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH v7 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
Cc: Jane Chu <jane.chu@oracle.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
 Dave Jiang <dave.jiang@intel.com>, Mike Snitzer <snitzer@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 11, 2022 at 09:57:36PM -0700, Dan Williams wrote:
> So how about change 'int flags' to 'enum dax_access_mode mode' where
> dax_access_mode is:
> 
> /**
>  * enum dax_access_mode - operational mode for dax_direct_access()
>  * @DAX_ACCESS: nominal access, fail / trim access on encountering poison
>  * @DAX_RECOVERY_WRITE: ignore poison and provide a pointer suitable
> for use with dax_recovery_write()
>  */
> enum dax_access_mode {
>     DAX_ACCESS,
>     DAX_RECOVERY_WRITE,
> };
> 
> Then the conversions look like this:
> 
>  -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>  +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1,
> DAX_ACCESS, &kaddr, NULL);
> 
> ...and there's less chance of confusion with the @nr_pages argument.

Yes, this might be a little nicer.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

