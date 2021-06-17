Return-Path: <SRS0=ZDE9=LL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46F8C2B9F4
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 07:04:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 523A361369
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 07:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 523A361369
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-8AzuMcw7N3S5Lwp1UqBCTg-1; Thu, 17 Jun 2021 03:04:44 -0400
X-MC-Unique: 8AzuMcw7N3S5Lwp1UqBCTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E8DB9126F;
	Thu, 17 Jun 2021 07:04:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C58D05D9E2;
	Thu, 17 Jun 2021 07:04:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6369446F81;
	Thu, 17 Jun 2021 07:04:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15H74XbS031993 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 03:04:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 982C110F05B; Thu, 17 Jun 2021 07:04:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93984113B46
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 07:04:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8234F1857F1E
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 07:04:28 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
	[209.85.215.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-31-uOXKVuNiPnOnUpGx39dALA-1; Thu, 17 Jun 2021 03:04:26 -0400
X-MC-Unique: uOXKVuNiPnOnUpGx39dALA-1
Received: by mail-pg1-f170.google.com with SMTP id t9so4175275pgn.4
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 00:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=LDO+ysM0sZT13J4jvjx62XJsQjzELPOWU0d8eft8zqE=;
	b=BM1GP+pSLT4woMtssXW3go6ICmDA5RDnk0ioYKofsogiSDYGZYfKF/oZri401tc2io
	RGTtUDy7BnMiPTxck8MK9Akp2I1mPo21sRGXtCB03DbGQ99xKqQY3skSZ1XM57fbkp72
	kGKIKNCI08zNTz37c/Ihidjj6OTpmaNY6Q0T/Mo4leeqiFOu2N0bs4yuOf7nth8m1k8u
	z/GHzrHO0iXydAJzcrl6F3VDL/AdAr9RwsB0vyRURy6cbvFfuk3YSwfWO6++Gw2H6mxS
	j711Nt7LNTPrLuO+mk6SuAQj/aeRzy59eBtW7l6GWMHfkZqacdFyqy/xcmx0HMRrCLaw
	GB4Q==
X-Gm-Message-State: AOAM533xuu5MHpHsLJ+4zQwG6CeuPxrtx//ecSUu2SHbDOo7vgu27bB1
	i4g0CjRhrbo8CaUGiu4jT6hY+fzpZ49AT/+NW9S7qA==
X-Google-Smtp-Source: ABdhPJytJXCfpu88GCMpLd2JmLVLvndI0iUm974A4Uf+gWPRlWE3qUqN/z2XXe284KMMKTo0F5nBS9HRMjP/H8ccbSA=
X-Received: by 2002:a62:768c:0:b029:2ff:2002:d3d0 with SMTP id
	r134-20020a62768c0000b02902ff2002d3d0mr324838pfc.70.1623913464979;
	Thu, 17 Jun 2021 00:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
	<CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
	<OSBPR01MB29203DC17C538F7B1B1C9224F40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB29203DC17C538F7B1B1C9224F40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Jun 2021 00:04:14 -0700
Message-ID: <CAPcyv4ihuErfVWHL0F1OExQashutJjBdaLn5X5oPm44OkQ+a_A@mail.gmail.com>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15H74XbS031993
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 03/10] fs: Introduce ->corrupted_range()
	for superblock
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 16, 2021 at 11:51 PM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
>
> > -----Original Message-----
> > From: Dan Williams <dan.j.williams@intel.com>
> > Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
> >
> > [ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]
> >
> > On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> > >
> > > Memory failure occurs in fsdax mode will finally be handled in
> > > filesystem.  We introduce this interface to find out files or metadata
> > > affected by the corrupted range, and try to recover the corrupted data
> > > if possiable.
> > >
> > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > > ---
> > >  include/linux/fs.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h index
> > > c3c88fdb9b2a..92af36c4225f 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2176,6 +2176,8 @@ struct super_operations {
> > >                                   struct shrink_control *);
> > >         long (*free_cached_objects)(struct super_block *,
> > >                                     struct shrink_control *);
> > > +       int (*corrupted_range)(struct super_block *sb, struct block_device
> > *bdev,
> > > +                              loff_t offset, size_t len, void *data);
> >
> > Why does the superblock need a new operation? Wouldn't whatever function is
> > specified here just be specified to the dax_dev as the
> > ->notify_failure() holder callback?
>
> Because we need to find out which file is effected by the given poison page so that memory-failure code can do collect_procs() and kill_procs() jobs.  And it needs filesystem to use its rmap feature to search the file from a given offset.  So, we need this implemented by the specified filesystem and called by dax_device's holder.
>
> This is the call trace I described in cover letter:
> memory_failure()
>  * fsdax case
>  pgmap->ops->memory_failure()      => pmem_pgmap_memory_failure()
>   dax_device->holder_ops->corrupted_range() =>
>                                       - fs_dax_corrupted_range()
>                                       - md_dax_corrupted_range()
>    sb->s_ops->currupted_range()    => xfs_fs_corrupted_range()  <== **HERE**
>     xfs_rmap_query_range()
>      xfs_currupt_helper()
>       * corrupted on metadata
>           try to recover data, call xfs_force_shutdown()
>       * corrupted on file data
>           try to recover data, call mf_dax_kill_procs()
>  * normal case
>  mf_generic_kill_procs()
>
> As you can see, this new added operation is an important for the whole progress.

I don't think you need either fs_dax_corrupted_range() nor
sb->s_ops->corrupted_range(). In fact that fs_dax_corrupted_range()
looks broken because the filesystem may not even be mounted on the
device associated with the error. The holder_data and holder_op should
be sufficient from communicating the stack of notifications:

pgmap->notify_memory_failure() => pmem_pgmap_notify_failure()
pmem_dax_dev->holder_ops->notify_failure(pmem_dax_dev) =>
md_dax_notify_failure()
md_dax_dev->holder_ops->notify_failure() => xfs_notify_failure()

I.e. the entire chain just walks dax_dev holder ops.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

