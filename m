Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213E3C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 07:48:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4CE58619FB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 07:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CE58619FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-8tH9u_1JMRWaWgfPUkHHjQ-1; Wed, 24 Mar 2021 03:48:13 -0400
X-MC-Unique: 8tH9u_1JMRWaWgfPUkHHjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7728381433D;
	Wed, 24 Mar 2021 07:48:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8672A709EE;
	Wed, 24 Mar 2021 07:48:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 233B81809C83;
	Wed, 24 Mar 2021 07:48:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12O7m1XA010401 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 03:48:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6231880566; Wed, 24 Mar 2021 07:48:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CC75AB418
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 07:47:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C36EF85A5AA
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 07:47:58 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-27-XGLkrwSxMrOPyYjVQvZSVw-1;
	Wed, 24 Mar 2021 03:47:54 -0400
X-MC-Unique: XGLkrwSxMrOPyYjVQvZSVw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BC6D68B02; Wed, 24 Mar 2021 08:47:51 +0100 (CET)
Date: Wed, 24 Mar 2021 08:47:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20210324074751.GA1630@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
	<CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
	<OSBPR01MB29207A1C06968705C2FEBACFF4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4iBnWbG0FYw6-K0MaH--rq62s7RY_yoT9rOYWMa94Yakw@mail.gmail.com>
	<OSBPR01MB29203F891F9584CC53616FB8F4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4gn_AvT6BA7g4jLKRFODSpt7_ORowVd3KgyWxyaFG0k9g@mail.gmail.com>
	<OSBPR01MB2920E46CBE4816CDF711E004F46F9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<OSBPR01MB29208779955B49F84D857F80F4689@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4jhUU3NVD8HLZnJzir+SugB6LnnrgJZ-jP45BZrbJ1dJQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jhUU3NVD8HLZnJzir+SugB6LnnrgJZ-jP45BZrbJ1dJQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
	"qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvdimm <linux-nvdimm@lists.01.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 01/11] pagemap: Introduce
	->memory_failure()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 23, 2021 at 07:19:28PM -0700, Dan Williams wrote:
> So I think the path forward is:
> 
> - teach memory_failure() to allow for ranged failures
> 
> - let interested drivers register for memory failure events via a
> blocking_notifier_head

Eww.  As I said I think the right way is that the file system (or
other consumer) can register a set of callbacks for opening the device.
I have a series I need to finish and send out to do that for block
devices.  We probably also need the concept of a holder for the dax
device to make it work nicely, as otherwise we're going to have a bit
of a mess.

> This obviously does not solve Dave's desire to get this type of error
> reporting on block_devices, but I think there's nothing stopping a
> parallel notifier chain from being created for block-devices, but
> that's orthogonal to requirements and capabilities provided by
> dax-devices.

FYI, my series could easily accomodate that if we ever get a block
driver that actually could report such errors.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

