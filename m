Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E252C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:34:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-i9qIGb4oNAaw-WNb2d4kKA-1; Fri, 04 Feb 2022 00:34:07 -0500
X-MC-Unique: i9qIGb4oNAaw-WNb2d4kKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE429100C61C;
	Fri,  4 Feb 2022 05:34:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5929A55F56;
	Fri,  4 Feb 2022 05:34:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CFE874BB7C;
	Fri,  4 Feb 2022 05:34:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2145WpNI024563 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 00:32:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EF4052166BA9; Fri,  4 Feb 2022 05:32:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA0A02166B1E
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:32:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B57C2B16868
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:32:44 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
	[209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-383-5JM9O3C3PBm7LGm1IZbjpQ-1; Fri, 04 Feb 2022 00:32:41 -0500
X-MC-Unique: 5JM9O3C3PBm7LGm1IZbjpQ-1
Received: by mail-pl1-f174.google.com with SMTP id c9so4206131plg.11
	for <dm-devel@redhat.com>; Thu, 03 Feb 2022 21:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=vN8r1693du3PiFHORoF+6XkBaejut5sZwHBBBXAp4b4=;
	b=p58tysRcIP86pMU+fIrFggFhbkMPZPfSLUnseGn44I1lE7bmPRe8GTbrerqfpUL0Eq
	7fOeIlDK3+nlay8unZeIxmcZIhoGamiyZTIhrLXFG1ba5vi50ri2S6hFGtoKIMw690eQ
	5IXEIbRolYscYeU6+EvL6WoYX/Ga6n644Tc65e6BojA0sFth8EHGh9O3wJ+gEV70ljiR
	pq2vKKSXBsLwosyfzWPnXtIo27oYs2CU9t4F8Uoj2PcMEAotVReZLBqGZqK96pZ3s6OE
	oDsT301oUAAdL1/CGPXSaeEDJ0VvLIL1NnxS6QnjNEdL4Xd/NmTyKm1ynFgfvlrr1Bau
	IhuQ==
X-Gm-Message-State: AOAM530Mp7RsQDh0wrPdbO7Qil6tehyKYh+4ixD3nWmj0ZuJZNQYmlw8
	hvfltMVOFNhETFlqQ4DDqkWyZFGEMDgZKfUl/vn+1A==
X-Google-Smtp-Source: ABdhPJy9vypHCuWdO84lJf8sfhFb1AduhbIgpw26gq3zk7IXjR/nY4UR+40JWc/1sOTHJTqjh/dzaGGVoJ8T2er+1UQ=
X-Received: by 2002:a17:90b:3ece:: with SMTP id
	rm14mr1346519pjb.220.1643952759933; 
	Thu, 03 Feb 2022 21:32:39 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-3-jane.chu@oracle.com>
	<YfqFuUsvuUUUWKfu@infradead.org>
	<45b4a944-1fb1-73e2-b1f8-213e60e27a72@oracle.com>
	<Yfvb6l/8AJJhRXKs@infradead.org>
	<CAPcyv4i99BhF+JndtanBuOWRc3eh1C=-CyswhvLDeDSeTHSUZw@mail.gmail.com>
In-Reply-To: <CAPcyv4i99BhF+JndtanBuOWRc3eh1C=-CyswhvLDeDSeTHSUZw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 21:32:27 -0800
Message-ID: <CAPcyv4hCf0WpRyNx4vo0_+-w1ABX0cJTyLozPYEqiqR0i_H1_Q@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 2/7] dax: introduce dax device flag
	DAXDEV_RECOVERY
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

On Thu, Feb 3, 2022 at 9:17 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Feb 3, 2022 at 5:43 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Wed, Feb 02, 2022 at 09:27:42PM +0000, Jane Chu wrote:
> > > Yeah, I see.  Would you suggest a way to pass the indication from
> > > dax_iomap_iter to dax_direct_access that the caller intends the
> > > callee to ignore poison in the range because the caller intends
> > > to do recovery_write? We tried adding a flag to dax_direct_access, and
> > > that wasn't liked if I recall.
> >
> > To me a flag seems cleaner than this magic, but let's wait for Dan to
> > chime in.
>
> So back in November I suggested modifying the kaddr, mainly to avoid
> touching all the dax_direct_access() call sites [1]. However, now
> seeing the code and Chrisoph's comment I think this either wants type
> safety (e.g. 'dax_addr_t *'), or just add a new flag. Given both of
> those options involve touching all dax_direct_access() call sites and
> a @flags operation is more extensible if any other scenarios arrive
> lets go ahead and plumb a flag and skip the magic.

Just to be clear we are talking about a flow like:

        flags = 0;
        rc = dax_direct_access(..., &kaddr, flags, ...);
        if (unlikely(rc)) {
                flags |= DAX_RECOVERY;
                dax_direct_access(..., &kaddr, flags, ...);
                return dax_recovery_{read,write}(..., kaddr, ...);
        }
        return copy_{mc_to_iter,from_iter_flushcache}(...);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

