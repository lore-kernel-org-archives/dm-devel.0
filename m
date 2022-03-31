Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4A6C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 05:52:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-tzCXRq5XOkqeVthnqhQozw-1; Thu, 31 Mar 2022 01:52:31 -0400
X-MC-Unique: tzCXRq5XOkqeVthnqhQozw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58EC08564EC;
	Thu, 31 Mar 2022 05:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4F1058D85A;
	Thu, 31 Mar 2022 05:52:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 95CB61947BBB;
	Thu, 31 Mar 2022 05:52:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88A8C19451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 05:52:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 69B97401E71; Thu, 31 Mar 2022 05:52:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65AD8401053
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 05:52:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43D0F804196
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 05:52:26 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-SiOJ3EI3OjqIx3h0cJGRsQ-1; Thu, 31 Mar 2022 01:52:19 -0400
X-MC-Unique: SiOJ3EI3OjqIx3h0cJGRsQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nZmbD-000dqJ-EG; Thu, 31 Mar 2022 04:39:55 +0000
Date: Wed, 30 Mar 2022 21:39:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dennis Zhou <dennis@kernel.org>
Message-ID: <YkUwmyrIqnRGIOHm@infradead.org>
References: <YkSK6mU1fja2OykG@redhat.com>
 <YkRM7Iyp8m6A1BCl@fedora>
MIME-Version: 1.0
In-Reply-To: <YkRM7Iyp8m6A1BCl@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] can we reduce bio_set_dev overhead due to
 bio_associate_blkg?
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
Cc: tj@kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org
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

On Wed, Mar 30, 2022 at 08:28:28AM -0400, Dennis Zhou wrote:
> I think cloning is a special case that I might have gotten wrong. If
> there is a bio_set_dev() call after each clone(), then the
> bio_clone_blkg_association() is excess work. We'd need to audit how
> bio_alloc_clone() is being used to be safe. Alternatively, we could opt
> for a bio_alloc_clone_noblkg(), but that's a little bit uglier.

As of Linux 5.18, the cloning interfaces have changed and take
a block devie that the clone is intended to be used for, and bio_set_dev
is mostly (there is a few more sports to be cleaned up in
dm/md/bcache/btrfs) only used for remapping to a new device.

That being said I've eyed the code in bio_associate_blkg a bit and
I've been wondering about some of how it is implemented as well.

Is recursive throttling really a thing?  i.e. we can have cgroup
policies on the upper (e.g. dm) device and then again on the lower
(e.g. nvme device)?  I think the code currently supports that, and
if we want to keep that I don't really see much of a way to avoid
the lookup, but maybe we cn make it faster.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

