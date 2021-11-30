Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54473C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 01:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638235584;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=h/oOUCVc9T0gSvcPz6H/8SSy6j9yMiru6e1ZPeoJEzQ=;
	b=EZ8AhU6qK6AwedRyUo6vknu93h+qpoO6DCXxXqFccgg+UtxpkjoUP21+KX9Uj1e1po1erj
	75fMZobj+epo7KbP0tOMKZUxwaSQRQ6SWTDz+NsSfgPUdJNKlJjjngrYb3dlldojBAeO6b
	ZgBmML+q1q3iOQgNbIbEwBCNFm6Ph58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-SdRKeAIxO0ihgtY-Vpcqgw-1; Mon, 29 Nov 2021 20:26:20 -0500
X-MC-Unique: SdRKeAIxO0ihgtY-Vpcqgw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAB371006AA0;
	Tue, 30 Nov 2021 01:26:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADC6E5C1C5;
	Tue, 30 Nov 2021 01:26:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 82DA21809C89;
	Tue, 30 Nov 2021 01:26:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AU1PTcE026826 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 20:25:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 033F25C25A; Tue, 30 Nov 2021 01:25:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDB1B5C1C5;
	Tue, 30 Nov 2021 01:25:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AU1PDiM023977; 
	Mon, 29 Nov 2021 19:25:14 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AU1PDwW023976;
	Mon, 29 Nov 2021 19:25:13 -0600
Date: Mon, 29 Nov 2021 19:25:13 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211130012513.GJ19591@octiron.msp.redhat.com>
References: <20211118231338.22358-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 00/21] multipath-tools: coverity fixes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 19, 2021 at 12:13:17AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> I have started a new attempt to fix defects reported by coverity.
> With this set (on top of the previously posted one), and a number
> of false positive classifications, I have been able to bring the
> defect count all the way down to zero.
> 
> Most of these patches fix defects reported by coverity. Some
> fix other things that occured to me while working on this.
> 

With the exception of 0005, 0007 and 0008,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Regards,
> Martin
> 
> Martin Wilck (21):
>   multipath tools: github workflows: add coverity workflow
>   multipathd (coverity): check atexit() return value
>   multipathd (coverity): terminate uxlsnr when polls allocation fails
>   libmultipath: strbuf: add __get_strbuf_buf()
>   libmultipath (coverity): improve input checking in parse_vpd_pg83
>   multipath-tools: add tests for broken VPD page 83
>   libmultipath: use strbuf in parse_vpd_pg83()
>   libmultipath (coverity): fix tainted values in alua_rtpg.c
>   multipath, multipathd: exit if bindings file is broken
>   libmultipath (coverity): silence unchecked return value warning
>   multipath: remove pointless code from getopt processing
>   libmultipath (coverity): set umask before mkstemp
>   multipathd (coverity): simplify set_oom_adj()
>   kpartx: open /dev/loop-control only once
>   kpartx: use opened loop device immediately
>   kpartx: find_unused_loop_device(): add newlines
>   multipathd (coverity): daemonize(): use dup2
>   libmultipath (coverity): avoid sleeping in dm_mapname()
>   libmultipath (coverity): Revert "setup_map: wait for pending path
>     checkers to finish"
>   libmultipath (coverity): check return values in dm_get_multipath()
>   libmultipath: update_pathvec_from_dm: don't force DI_WWID
> 
>  .github/workflows/coverity.yaml       |  51 ++++++
>  kpartx/kpartx.c                       |   4 +-
>  kpartx/lopart.c                       | 100 +++++-----
>  kpartx/lopart.h                       |   3 +-
>  libmultipath/alias.c                  |   4 +
>  libmultipath/configure.c              |  63 +------
>  libmultipath/devmapper.c              |  23 +--
>  libmultipath/discovery.c              | 252 ++++++++++++++------------
>  libmultipath/prioritizers/alua_rtpg.c |  13 +-
>  libmultipath/prioritizers/alua_spc3.h |  30 ++-
>  libmultipath/propsel.c                |   2 +-
>  libmultipath/strbuf.c                 |   5 +
>  libmultipath/strbuf.h                 |  14 ++
>  libmultipath/structs_vec.c            |   7 +-
>  multipath/main.c                      |  13 +-
>  multipathd/main.c                     |  91 ++++------
>  multipathd/uxlsnr.c                   |   1 +
>  tests/vpd.c                           | 108 +++++++++++
>  18 files changed, 456 insertions(+), 328 deletions(-)
>  create mode 100644 .github/workflows/coverity.yaml
> 
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

