Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AEBDC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 13 Mar 2022 17:45:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-Cy05jvajMrCW2iM5j0Mliw-1; Sun, 13 Mar 2022 13:45:00 -0400
X-MC-Unique: Cy05jvajMrCW2iM5j0Mliw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 992F33C021A5;
	Sun, 13 Mar 2022 17:44:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38FB758A46A;
	Sun, 13 Mar 2022 17:44:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0F07194037A;
	Sun, 13 Mar 2022 17:44:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 605DB1940378
 for <dm-devel@listman.corp.redhat.com>; Sun, 13 Mar 2022 17:44:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D991A203B7BF; Sun, 13 Mar 2022 17:44:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4DD8203B7BD
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 17:44:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E166101AA48
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 17:44:49 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-aL2AL8R9MlCQeqQYaLSt9A-1; Sun, 13 Mar 2022 13:44:47 -0400
X-MC-Unique: aL2AL8R9MlCQeqQYaLSt9A-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nTSGq-003NAF-9z; Sun, 13 Mar 2022 17:44:44 +0000
Date: Sun, 13 Mar 2022 17:44:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <Yi4tjPfXd6ZkRmbW@casper.infradead.org>
References: <88a5d138-68b0-da5f-8b08-5ddf02fff244@gmx.com>
 <Yi3NkBf0EUiG2Ys2@casper.infradead.org>
 <d8ea4246-8271-d3c4-2e4d-70d2c1369a05@gmx.com>
MIME-Version: 1.0
In-Reply-To: <d8ea4246-8271-d3c4-2e4d-70d2c1369a05@gmx.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] Better read bio error granularity?
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
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Mar 13, 2022 at 07:03:39PM +0800, Qu Wenruo wrote:
> > Specifically for the page cache (which I hope is what you meant by
> > "page error status", because we definitely can't use that for DIO),
> 
> Although what I exactly mean is PageError flag.
> 
> For DIO the pages are not mapping to any inode, but it shouldn't prevent
> us from using PageError flag I guess?

For DIO, *it is not your page*.  It belongs to somebody else, and you
can't even look at the flags, or the ->mapping, or anything, really.
You have a refcount on the page to prevent it from going away, but the
only thing you can do to the page is use its address and put your refcount
when you're done with it.  It might be an anonymous page, the ZERO_PAGE,
a pagecache page for another filesystem, a pagecache page for your own
filesystem, or even a pagecache page for the same file you're writing to.
The DIO might only be 512-byte aligned, so different parts of the page can
be being written to by different DIOs, or parts or the entire page might
be being read by multiple DIOs.  It might be registered to an RDMA device.
I haven't been keeping up, but I think it's even possible that the page
of memory might be on a graphics card.

> > the intent is that ->readahead can just fail and not set any of the
> > pages Uptodate.  Then we come along later, notice there's a page in
> > the cache and call ->readpage on it and get the error for that one
> > page.  The other 31 pages should read successfully.
> 
> This comes a small question, what is prevent the fs to submit a large
> bio containing the 32 pages again, other than reading them page by page?
> 
> Just because of that page is there, but not Uptodate?

This would be a bad idea.  Pages can be !Uptodate and Dirty, if they've
been partially written by a block-aligned write.  So mindlessly
expanding a read of a single page to be a read of multiple pages will
result in data loss.  Also we might not have pages in
the page cache for the surrounding pages, and we might be low enough on
memory that we can't allocate them.  And pages have to be locked before
we do I/O.  They have to be locked in order of file index, so you would
need to cope with trylocking the pages before this one and those
trylocks maybe failing.

In short, this would be prohibitively complex.

> > 
> > (There's an awkward queston to ask about large folios here, and what
> > we might be able to do around sub-folio or even sub-page or sub-block
> > reads that happen to not touch the bytes which are in an error region,
> > but let's keep the conversation about pages for now).
> > 
> Yeah, that can go crazy pretty soon.
> 
> Like iomap or btrfs, they all use page::private to store extra bitmaps
> for those cases, thus it really impossible to use PageError flag.
> Thus I intentionally skip them here.

I'm actually looking to get rid of PageError, but I think the other
points stand by themselves even without that intention ;-)

> Thank you very much for the quick and helpful reply,

You're welcome!  Thanks for starting the discussion rather than rushing
off to implement it ;-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

