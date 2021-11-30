Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FCBC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 21:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638308898;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Cjqy0eiLNohAtl+vk50EcinXsSIcshQ+9V4RoIyrbEM=;
	b=RlJEToQTlPJB3qsTRvNX0N7UJm0cZ31uMjbu9+mlMqRk4phAKo0udjCGLZyztIGdxFscTg
	NWXp7AKDRToOfiTrNT42KeIy4udqGrLnvweHxfD9I1JcoAi/nW58SkZF2bEnqxmVhXTYVx
	9L1vECs5sbxaCxD5khlRG4k66HmiZ4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-DbuzAgzfO_aGWLxSi1mKkg-1; Tue, 30 Nov 2021 16:48:17 -0500
X-MC-Unique: DbuzAgzfO_aGWLxSi1mKkg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7710B1018721;
	Tue, 30 Nov 2021 21:48:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D15FB100EBAD;
	Tue, 30 Nov 2021 21:48:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D279E1809C89;
	Tue, 30 Nov 2021 21:48:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AULm8HL003823 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 16:48:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 49ED55F4E1; Tue, 30 Nov 2021 21:48:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E64E5D740;
	Tue, 30 Nov 2021 21:48:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AULlw0J031146; 
	Tue, 30 Nov 2021 15:47:59 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AULlw2j031145;
	Tue, 30 Nov 2021 15:47:58 -0600
Date: Tue, 30 Nov 2021 15:47:57 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211130214757.GO19591@octiron.msp.redhat.com>
References: <20211129200902.21817-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211129200902.21817-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 00/13] multipath-tools: improvements for
 pretty-printing code
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 29, 2021 at 09:08:49PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> this series attempts to improve the robustness of the code by making the lookup
> tables used for pretty printing and wildcard handling static const arrays.
> This requires getting rid of the variable "width" field in these arrays.
> I could have simply split of "width" into a separate global array variable,
> but as the field width are designed to change depending on the data being
> printed, it makes more sense to use local variables for it and pass them to
> the actual table-formatting code.
> 
> A couple of minor cleanups are done along the way.
> 
> Changes in v2:
> 
>  - 10/13: fix a compilation error with clang because of duplicate typedef
>    for fieldwidth_t
>  - whitespace fixes
>  - 12/13: new, fix a compile error with clang-13
>  - 13/13: new, fix an asan error reported by Lixiaokeng
> 
> As always, feedback welcome
> Martin
> 

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Martin Wilck (13):
>   libmultipath: make multipath_data etc. static
>   libmultipath: move path_data etc. to print.c
>   libmultipath: make pd_lookup() etc. return an index
>   libmultipath: use ARRAY_SIZE for iterating over wildcard arrays
>   libmultipath: drop padding code in _snprint_pathgroup()
>   libmultipath: snprint_foreign_topology(): split out lockless variant
>   multipathd: drop unnecessary path layout calls
>   libmultipath: add a cleanup function for unsigned char *
>   libmultipath: make sprint_path_marginal() static
>   libmultipath: introduce width argument for pretty-printing functions
>   libmultipath: change wildcard handler tables to static const
>   libmultipath: fix compilation error with clang 13
>   libmultipath: remove_map(): make sure orphaned paths aren't referenced
> 
>  libmultipath/foreign.c                   |  74 +++--
>  libmultipath/foreign.h                   |  23 +-
>  libmultipath/generic.h                   |   8 +
>  libmultipath/libmultipath.version        |   5 +-
>  libmultipath/print.c                     | 356 +++++++++++++----------
>  libmultipath/print.h                     |  58 ++--
>  libmultipath/prioritizers/weightedpath.c |   3 +-
>  libmultipath/structs_vec.c               |   4 +
>  libmultipath/util.c                      |   5 +
>  libmultipath/util.h                      |   1 +
>  multipath/main.c                         |   7 +-
>  multipathd/cli_handlers.c                |  75 +++--
>  12 files changed, 367 insertions(+), 252 deletions(-)
> 
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

