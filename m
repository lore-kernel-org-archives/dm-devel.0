Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9818BC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:20:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-87ZnOFVBNkqEp99KjN9EdA-1; Fri, 04 Feb 2022 00:20:34 -0500
X-MC-Unique: 87ZnOFVBNkqEp99KjN9EdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C22639382;
	Fri,  4 Feb 2022 05:20:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A654B5DB91;
	Fri,  4 Feb 2022 05:20:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B5C8C4CA93;
	Fri,  4 Feb 2022 05:20:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2145HR7c023484 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 00:17:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AB061120AB3; Fri,  4 Feb 2022 05:17:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 063591121334
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:17:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DD93802317
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:17:23 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
	[209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-392-cgiHNNNINnaxIKi7lWUaRg-1; Fri, 04 Feb 2022 00:17:21 -0500
X-MC-Unique: cgiHNNNINnaxIKi7lWUaRg-1
Received: by mail-pj1-f47.google.com with SMTP id
	z10-20020a17090acb0a00b001b520826011so12059046pjt.5
	for <dm-devel@redhat.com>; Thu, 03 Feb 2022 21:17:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ADbV2ue0euhPpU9doft99rslDDTP7SctadFXHagiPcw=;
	b=SCIPGa5KhzGg+s9Fg5RAw7+j7Z5ZZ9CnDQb7zx3aRDL+YgluuBfXu/Qly9C7rQG035
	G592E/2aR+wI4K2ck7c5Vw6nZFGBy9Y/lspb+5o8bYBZzUCf6mHYn/SV+fLPTumvQZWE
	3mScamTs6KAA1DT/cH+cOPPLc1FjJGEfUm7OPO6pgRc7kP5lXux29oxZTO+lRNT41QNt
	5kJrAaJ4/YwXdvOS80KNkthKWUWSPZzbdomVgAmKpYOlSp6Crvl7//TJ+8jalKRbBO3o
	HOrBBio3Cl6WJmT0kUtEG0Ao+jov/BNrznYYJxuzhd6pXe0Foz+AuFK0VWB3hy4kyRRq
	Uq/Q==
X-Gm-Message-State: AOAM533kVqe+iS9b56XpdGdpHRpVc3jb3UCbFHjUEZKpyB5ERPKF6wdF
	eAqSwe9+zrpouJuIfW8XxYRNe5sq/7MUE7HmaMU47A==
X-Google-Smtp-Source: ABdhPJxe0WhiE5t6uv14wKW/F80lHdFsDU+VqJ0ecIJJh7mLBCyPclSFFi4XvO8Vld3qiSEwvpeHFisH+3f0GowxwMU=
X-Received: by 2002:a17:902:b20a:: with SMTP id
	t10mr1357273plr.132.1643951840594; 
	Thu, 03 Feb 2022 21:17:20 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-3-jane.chu@oracle.com>
	<YfqFuUsvuUUUWKfu@infradead.org>
	<45b4a944-1fb1-73e2-b1f8-213e60e27a72@oracle.com>
	<Yfvb6l/8AJJhRXKs@infradead.org>
In-Reply-To: <Yfvb6l/8AJJhRXKs@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 21:17:08 -0800
Message-ID: <CAPcyv4i99BhF+JndtanBuOWRc3eh1C=-CyswhvLDeDSeTHSUZw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 3, 2022 at 5:43 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Feb 02, 2022 at 09:27:42PM +0000, Jane Chu wrote:
> > Yeah, I see.  Would you suggest a way to pass the indication from
> > dax_iomap_iter to dax_direct_access that the caller intends the
> > callee to ignore poison in the range because the caller intends
> > to do recovery_write? We tried adding a flag to dax_direct_access, and
> > that wasn't liked if I recall.
>
> To me a flag seems cleaner than this magic, but let's wait for Dan to
> chime in.

So back in November I suggested modifying the kaddr, mainly to avoid
touching all the dax_direct_access() call sites [1]. However, now
seeing the code and Chrisoph's comment I think this either wants type
safety (e.g. 'dax_addr_t *'), or just add a new flag. Given both of
those options involve touching all dax_direct_access() call sites and
a @flags operation is more extensible if any other scenarios arrive
lets go ahead and plumb a flag and skip the magic.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

