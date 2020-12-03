Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D043C47436
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 14:51:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C804822244
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 14:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C804822244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607006094;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JO9gb64+u47G83FcKN7/k9sh3vQ12OUtFPki4Fims0o=;
	b=e7LIVDZUAxR1ivXewqsQwN+agku3J4d+qmP4mNSFs1FbEmLE4tPsPY37Zpp3Ln5tGrXHjo
	l0PLKuPnr4iJk+y5RUJv0Fl6ZUKMyYnhR+Cq+7RrxoJG3iCRMJKdtPP0k7oX46UPviMDMP
	tOEkKCAB+l35Nj8sPqTBV1ljblFabvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-2R7GkmwlN3yfoLUX_v5UtA-1; Thu, 03 Dec 2020 09:34:51 -0500
X-MC-Unique: 2R7GkmwlN3yfoLUX_v5UtA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AA948015C3;
	Thu,  3 Dec 2020 14:34:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22DF471C87;
	Thu,  3 Dec 2020 14:34:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B18644BB7B;
	Thu,  3 Dec 2020 14:34:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3EY7vR017912 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 09:34:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E2BE65DF4A; Thu,  3 Dec 2020 14:34:06 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56D7E5D9CA;
	Thu,  3 Dec 2020 14:34:00 +0000 (UTC)
Date: Thu, 3 Dec 2020 09:33:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20201203143359.GA29261@redhat.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590>
MIME-Version: 1.0
In-Reply-To: <20201203032608.GD540033@T590>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, martin.petersen@oracle.com, jdorminy@redhat.com,
	bjohnsto@redhat.com, linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 02 2020 at 10:26pm -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Tue, Dec 01, 2020 at 11:07:09AM -0500, Mike Snitzer wrote:
> > commit 22ada802ede8 ("block: use lcm_not_zero() when stacking
> > chunk_sectors") broke chunk_sectors limit stacking. chunk_sectors must
> > reflect the most limited of all devices in the IO stack.
> > 
> > Otherwise malformed IO may result. E.g.: prior to this fix,
> > ->chunk_sectors = lcm_not_zero(8, 128) would result in
> > blk_max_size_offset() splitting IO at 128 sectors rather than the
> > required more restrictive 8 sectors.
> 
> What is the user-visible result of splitting IO at 128 sectors?

The VDO dm target fails because it requires IO it receives to be split
as it advertised (8 sectors).

> I understand it isn't related with correctness, because the underlying
> queue can split by its own chunk_sectors limit further. So is the issue
> too many further-splitting on queue with chunk_sectors 8? then CPU
> utilization is increased? Or other issue?

No, this is all about correctness.

Seems you're confining the definition of the possible stacking so that
the top-level device isn't allowed to have its own hard requirements on
IO sizes it sends to its internal implementation.  Just because the
underlying device can split further doesn't mean that the top-level
virtual driver can service larger IO sizes (not if the chunk_sectors
stacking throws away the hint the virtual driver provided because it
used lcm_not_zero).

> > And since commit 07d098e6bbad ("block: allow 'chunk_sectors' to be
> > non-power-of-2") care must be taken to properly stack chunk_sectors to
> > be compatible with the possibility that a non-power-of-2 chunk_sectors
> > may be stacked. This is why gcd() is used instead of reverting back
> > to using min_not_zero().
> 
> I guess gcd() won't be better because gcd(a,b) is <= max(a, b), so bio
> size is decreased much with gcd(a, b), and IO performance should be affected.
> Maybe worse than min_not_zero(a, b) which is often > gcd(a, b).

Doesn't matter, it is about correctness.

We cannot stack up a chunk_sectors that violates requirements of a given
layer.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

