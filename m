Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC80C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 13 Mar 2022 11:18:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-kSMqwLrnMcepy7OX0TXUsg-1; Sun, 13 Mar 2022 07:18:27 -0400
X-MC-Unique: kSMqwLrnMcepy7OX0TXUsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7589C3C00103;
	Sun, 13 Mar 2022 11:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1FF5140D2962;
	Sun, 13 Mar 2022 11:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFE631940370;
	Sun, 13 Mar 2022 11:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EFBF194035B
 for <dm-devel@listman.corp.redhat.com>; Sun, 13 Mar 2022 11:18:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F6C61458306; Sun, 13 Mar 2022 11:18:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B9CC1458301
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 11:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3322329AA38B
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 11:18:24 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-k8d3KdwEPxCzYH8F2xSjMA-1; Sun, 13 Mar 2022 07:18:22 -0400
X-MC-Unique: k8d3KdwEPxCzYH8F2xSjMA-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nTLsW-0039Vi-NW; Sun, 13 Mar 2022 10:55:12 +0000
Date: Sun, 13 Mar 2022 10:55:12 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <Yi3NkBf0EUiG2Ys2@casper.infradead.org>
References: <88a5d138-68b0-da5f-8b08-5ddf02fff244@gmx.com>
MIME-Version: 1.0
In-Reply-To: <88a5d138-68b0-da5f-8b08-5ddf02fff244@gmx.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Mar 13, 2022 at 06:24:32PM +0800, Qu Wenruo wrote:
> Since if any of the split bio got an error, the whole bio will have
> bi_status set to some error number.
> 
> This is completely fine for write bio, but I'm wondering can we get a
> better granularity by introducing per-bvec bi_status or using page status?
> 
> 
> One situation is, for fs like btrfs or dm device like dm-verify, if a
> large bio is submitted, say a 128K one, and one of the page failed to
> pass checksum/hmac verification.
> 
> Then the whole 128K will be marked error, while in fact the rest 124K
> are completely fine.
> 
> 
> Can this be solved by something like per-vec bi_status, or using page
> error status to indicate where exactly the error is?

In general, I think we want to keep this simple; the BIO has an error.
If the user wants more fine granularity on the error, they can resubmit
a smaller I/O, or hopefully some day we get a better method of reporting
errors to the admin than "some random program got EIO".

Specifically for the page cache (which I hope is what you meant by
"page error status", because we definitely can't use that for DIO),
the intent is that ->readahead can just fail and not set any of the
pages Uptodate.  Then we come along later, notice there's a page in
the cache and call ->readpage on it and get the error for that one
page.  The other 31 pages should read successfully.

(There's an awkward queston to ask about large folios here, and what
we might be able to do around sub-folio or even sub-page or sub-block
reads that happen to not touch the bytes which are in an error region,
but let's keep the conversation about pages for now).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

