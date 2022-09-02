Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAC4C38145
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 23:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662163020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jrA9TBG12xxwpGuLhJrqp5qtsLW23eo8jymwpV4EC18=;
	b=a1po4oZ+HGmgUokFyeJAAxMHErjUhU46lyBZ8kcZ60A7cn1tzJSXY/6p3n1LyPnx87sCEF
	kgwMJuCCjDihdEBaydaMlS2PuAuufAGOsRMQ035SUshrkXMS0d/ExorL6jCKEFx3KPLgUZ
	oWU7UDOAc2LCYwXTr4UJbIHptzw3z7g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-R14tsrVXO3G_eJss1q_aaw-1; Fri, 02 Sep 2022 19:56:57 -0400
X-MC-Unique: R14tsrVXO3G_eJss1q_aaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B8792919ED2;
	Fri,  2 Sep 2022 23:56:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B5EB40B40C7;
	Fri,  2 Sep 2022 23:56:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 315B2194B966;
	Fri,  2 Sep 2022 23:56:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 972C9194B966
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 23:56:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D4722026D64; Fri,  2 Sep 2022 23:56:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5951F2026D4C;
 Fri,  2 Sep 2022 23:56:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 282Nunww021710;
 Fri, 2 Sep 2022 18:56:50 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 282Nun9L021709;
 Fri, 2 Sep 2022 18:56:49 -0500
Date: Fri, 2 Sep 2022 18:56:49 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220902235649.GQ31105@octiron.msp.redhat.com>
References: <20220901160952.2167-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220901160952.2167-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 00/16] multipath-tools: minor fixes and build
 improvements
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 01, 2022 at 06:09:36PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Ben, hi Christophe,
> 
> here's a set of minor fixes for multipath-tools.
For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Regards
> Martin
> 
> Martin Wilck (16):
>   multipath-tools: Makefile: remove useless .PHONY targets
>   multipath-tools: Makefile: fix install->all dependency
>   multipath-tools: Makefile: remove dependency test -> test-progs
>   multipath-tools: Makefile: run abidiff with --redundant flag
>   libdmmp: Makefile: create man3dir
>   tests/Makefile: use $(multipathdir)
>   tests/Makefile: add library dependencies
>   tests/Makefile: use symbolic links under tests/lib
>   tests/Makefile: redirect program output into output file
>   GitHub workflows: package shared objects in artifact
>   libmultipath: replace close_fd() with cleanup_fd_ptr()
>   libmultipath: cleanup_free_ptr(): avoid double free
>   multipath: find_multipaths_check_timeout(): no need for pthread
>     cleanup
>   multipathd: fix segfault in cli_list_map_fmt()
>   multipathd: fix broken pthread cleanup in
>     fpin_fabric_notification_receiver()
>   multipathd: Fix command completion in interactive mode
> 
>  .github/workflows/foreign.yaml    |  2 ++
>  Makefile                          |  8 ++++----
>  libdmmp/Makefile                  |  1 +
>  libmpathutil/libmpathutil.version |  6 +++++-
>  libmpathutil/util.c               | 19 +++++++++++++------
>  libmpathutil/util.h               |  2 +-
>  libmultipath/alias.c              |  4 ++--
>  libmultipath/foreign/nvme.c       |  4 ++--
>  libmultipath/sysfs.c              | 12 ++++++------
>  libmultipath/wwids.c              |  8 ++++----
>  multipath/main.c                  |  8 +++-----
>  multipathd/cli.c                  |  2 ++
>  multipathd/cli_handlers.c         |  2 +-
>  multipathd/fpin_handlers.c        |  9 +++++----
>  multipathd/main.c                 |  1 -
>  tests/Makefile                    | 26 +++++++++++++-------------
>  16 files changed, 64 insertions(+), 50 deletions(-)
> 
> -- 
> 2.37.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

