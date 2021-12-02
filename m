Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34311C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638470338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IKuX44V93xj7xHhUuPf41GjtvoN5kAEz9dsC3m4kIZY=;
	b=dpav0nsCi0mGP5uPmH/L1RzLcbgbWGNSPQPO60tQCHzic0yP86D3JsLEPtg7Md4YyJStXZ
	jkvb4sEPQXjR0d2WG3eVj1WyhB0Nv8AEYQ7tv5y5jMe4WFzGXgkwJZIEs/Oou14DV0DLvP
	vR/jR8gofWkNF1lH5/Ti45FUnvMVZ2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-c1_EtfQjOEOGY0890EEe3A-1; Thu, 02 Dec 2021 13:38:54 -0500
X-MC-Unique: c1_EtfQjOEOGY0890EEe3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EF30192D786;
	Thu,  2 Dec 2021 18:38:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D7F6694BF;
	Thu,  2 Dec 2021 18:38:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5919B4BB7C;
	Thu,  2 Dec 2021 18:38:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2IZ7Vw021260 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 13:35:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2839E19D9F; Thu,  2 Dec 2021 18:35:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 122BE19C46;
	Thu,  2 Dec 2021 18:35:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1B2IZ4bR013911; 
	Thu, 2 Dec 2021 12:35:05 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1B2IZ4du013910;
	Thu, 2 Dec 2021 12:35:04 -0600
Date: Thu, 2 Dec 2021 12:35:04 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211202183504.GV19591@octiron.msp.redhat.com>
References: <20211202160652.4576-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211202160652.4576-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 00/11] Last-minute patches for multipath-tools
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 02, 2021 at 05:06:40PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> here are some last-minute fixes that I'd like to have added to
> the currently pending multipath-tools update. None of them touches
> any real functionality, except the first one, which I already sent
> earlier today. Patch 3,4,5 were already included in my github PR
> (which I'm going to rebase to match this submission). Patch 2 supersedes
> "multipath-tools: generate abi without version script" from the first
> version of the Github PR. The rest is new, tidy-up work for
> libmultipath.version.
> 
> Regards
> Martin
> 
> Martin Wilck (11):
>   multipathd.service: add dependency on systemd-udevd-kernel.socket
>   multipath-tools: generate abi with dummy version script
>   multipath-tools: github abi workflow: don't fail on reference branch
>   multipath-tools: github workflows: rebuild containers for rolling
>     distros
>   multipath tools: github workflows: add coverity workflow
>   multipath-tools: .mailmap: add some more entries
>   libmultipath: make orphan_paths() static
>   libmultipath: make update_pathvec_from_dm() static
>   libmultipath: remove recv_packet_from_client()
>   libmultipath.version: drop some unused symbols
>   libmultipath.version: sort symbols
> 
>  .github/workflows/abi.yaml        |  2 +-
>  .github/workflows/coverity.yaml   | 51 +++++++++++++++++
>  .github/workflows/native.yaml     | 62 +++++++++++++++++++-
>  .mailmap                          |  7 +++
>  Makefile.inc                      |  1 +
>  libdmmp/Makefile                  |  2 +-
>  libmpathcmd/Makefile              | 13 ++++-
>  libmpathpersist/Makefile          | 15 ++++-
>  libmpathvalid/Makefile            | 16 +++++-
>  libmultipath/Makefile             | 13 ++++-
>  libmultipath/libmultipath.version | 95 ++++++++++---------------------
>  libmultipath/structs_vec.c        |  4 +-
>  libmultipath/structs_vec.h        |  4 --
>  libmultipath/uxsock.c             |  5 --
>  libmultipath/uxsock.h             |  6 --
>  multipathd/multipathd.service     |  2 +
>  16 files changed, 203 insertions(+), 95 deletions(-)
>  create mode 100644 .github/workflows/coverity.yaml
> 
> -- 
> 2.34.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

