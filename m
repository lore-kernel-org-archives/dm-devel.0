Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB01DC432BE
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E09361250
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E09361250
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-4oguMJBGO8GFn2wtGq1YIg-1; Mon, 23 Aug 2021 02:40:31 -0400
X-MC-Unique: 4oguMJBGO8GFn2wtGq1YIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF3AD760CE;
	Mon, 23 Aug 2021 06:40:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93B716A057;
	Mon, 23 Aug 2021 06:40:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 38240181A0F9;
	Mon, 23 Aug 2021 06:40:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KMxOEd031364 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 18:59:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1BFD211E1CE; Fri, 20 Aug 2021 22:59:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FF5111E1E0
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 22:59:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D7F38007BB
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 22:59:17 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
	[209.85.214.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-408-a4yTqOG7OL2Mrg1AtplEsA-1; Fri, 20 Aug 2021 18:59:14 -0400
X-MC-Unique: a4yTqOG7OL2Mrg1AtplEsA-1
Received: by mail-pl1-f182.google.com with SMTP id x1so4239289plg.10
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 15:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=4J9u3EAGcrYRrFr9a28F3qghmkpi2i6oIZ8UbGMRg5Q=;
	b=Z1ZDVXtgwPdSV8/znPAtZJ+AcYbqNLgpQMSyM3tmFMiz4i96kXyQZq3/5yh3CVgv0Q
	uJyeVx4tIkQJqr6VsNtnnJFcA1gll2FzLJvrmR5FSsb/pSKcnWB3K0XMc2nolGEOxp5r
	dEZCxQ2y1WA620BuNk8YEf4YU5y8X8GaoaHhp93rQAfSK/qE/jwN+MTpfqqusCf1ITxo
	oyw8/6F/izvOWjltSjkDudDlUv+PAjGELoI9azkc5g6LVJtu9IpFd0mqVFqwG3p/la0g
	zrKpOLyvURm9NNT0rw+5AB5RXbMtoV7Ay67m1hBx0Z7bquagsLhEEuYmz+Y8usWediEc
	dByg==
X-Gm-Message-State: AOAM530iCP8KGWR4DOJPCkWcXIGNtslAHz4ct7lrv5UHGUJrsgfluyXg
	mbqd4Uqr4MxAK8+IJOIZx1EKKIRgH4aUrxdWEhfBrA==
X-Google-Smtp-Source: ABdhPJzmm+ahkZHadNRsrgbZ7uYrM7d7oiVybo+IGZSGhl9C+B3H/3syn4zyd/DiLhslnXQ3Gq0ivqGhKs2WDDhbCAQ=
X-Received: by 2002:a17:90a:708c:: with SMTP id
	g12mr7031600pjk.13.1629500353664; 
	Fri, 20 Aug 2021 15:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 15:59:02 -0700
Message-ID: <CAPcyv4h8eUKYDz+KLzXeMTEKc03k=8juXtYjYj+XSVQ5ww=KyQ@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 6/9] xfs: Implement
	->notify_failure() for XFS
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> This function is used to handle errors which may cause data lost in
> filesystem.  Such as memory failure in fsdax mode.
>
> If the rmap feature of XFS enabled, we can query it to find files and
> metadata which are associated with the corrupt data.  For now all we do
> is kill processes with that file mapped into their address spaces, but
> future patches could actually do something about corrupt metadata.
>
> After that, the memory failure needs to notify the processes who are
> using those files.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c |  12 ++++
>  fs/xfs/xfs_fsops.c  |   5 ++
>  fs/xfs/xfs_mount.h  |   1 +
>  fs/xfs/xfs_super.c  | 135 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h |  13 +++++
>  5 files changed, 166 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 00c32dfa5665..63f7b63d078d 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -65,6 +65,18 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>         return dax_get_by_host(bdev->bd_disk->disk_name);
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> +
> +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       dax_set_holder(dax_dev, holder, ops);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_set_holder);

Small style issue, I'd prefer a pair of functions:

fs_dax_register_holder(struct dax_device *dax_dev, void *holder, const
struct dax_holder_operations *ops)
fs_dax_unregister_holder(struct dax_device *dax_dev)

...rather than open coding unregister as a special set that passes
NULL arguments.

> +void *fs_dax_get_holder(struct dax_device *dax_dev)
> +{
> +       return dax_get_holder(dax_dev);

Does dax_get_holder() have a lockdep_assert to check that the caller
has at least a read_lock? Please add kernel-doc for this api to
indicate the locking context expectations.

The rest of this looks plausibly ok to me, but it would be up to xfs
folks to comment on the details. I'm not entirely comfortable with
these handlers assuming DAX, i.e. they should also one day be useful
for page cache memory failure notifications, but that support can come
later.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

