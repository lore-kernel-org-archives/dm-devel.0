Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D86C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 17 Dec 2021 18:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639764291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TdcnNw3A5FaOrAUVevEHuONNxeEFMscLCBqQcNvMVSs=;
	b=a/G8NNnvvb4u14PrmLaiexR4dQl3BYi/ybThPvlNhx5uQaoAV4ukTla+t0V703G3uTYtkv
	R/PBgmJ+6bAAOWxRzslNLSPSazVDuGzPSbuCyiWIqxewRuz+kx2/BXgnZhMHmV71j9pCEG
	m07Mo7AZDTIR+52B0KwPdgTVNP8Rmw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-eq01roLdO06Hcqnyxtiuow-1; Fri, 17 Dec 2021 13:04:48 -0500
X-MC-Unique: eq01roLdO06Hcqnyxtiuow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29ACF102C84E;
	Fri, 17 Dec 2021 18:04:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E3A35BE26;
	Fri, 17 Dec 2021 18:04:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A222F1809CB9;
	Fri, 17 Dec 2021 18:04:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BHI4Iqj008656 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 17 Dec 2021 13:04:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 19EF1908B; Fri, 17 Dec 2021 18:04:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC0ED49A7;
	Fri, 17 Dec 2021 18:04:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BHI46kh027490; 
	Fri, 17 Dec 2021 12:04:06 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BHI459t027489;
	Fri, 17 Dec 2021 12:04:05 -0600
Date: Fri, 17 Dec 2021 12:04:05 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211217180405.GE19591@octiron.msp.redhat.com>
References: <20211216125502.15867-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211216125502.15867-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/5] libmpathpersist: cleanup ABI and headers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 16, 2021 at 01:54:57PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> when reviewing Ben's last patch set, I noticed that the change
> of struct multipath would formally change the ABI of libmpathpersist,
> even though the public API as defined by mpath_persist.h doesn't
> reference this struct.
> 
> This set cleans this up by splitting the libmpathpersist code into a
> public part, a semi-private part (used by other multipath-tools components)
> and a private part (used by libmpathpersist alone). In the future,
> the abi check tools will detect an ABI change in cases like this, but it'll
> be easy to check whether the public or private part of the ABI is affected.
> 
> A minor version bump of the libmpathpersist version is required to reflect
> the fact that symbols have been removed from the LIBMPATHPERSIST versioned
> ABI.
> 
> The set also contains some other minor header file cleanups. No actual code
> flow is changed, only code shuffled around.
> 
> Regards
> Martin

For the set
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Martin Wilck (5):
>   libmpathpersist: split public and internal API
>   multipathd: remove duplicate definitions from main.h
>   libmpathpersist/multipathd: remove duplicate definition
>   libmpathpersist: remove __STDC_FORMAT_MACROS
>   libmpathpersist: cleanup mpathpr.h
> 
>  libmpathpersist/Makefile                |   2 +-
>  libmpathpersist/libmpathpersist.version |  27 +-
>  libmpathpersist/mpath_persist.c         | 776 +----------------------
>  libmpathpersist/mpath_persist_int.c     | 792 ++++++++++++++++++++++++
>  libmpathpersist/mpath_persist_int.h     |  25 +
>  libmpathpersist/mpath_pr_ioctl.c        |   3 +-
>  libmpathpersist/mpathpr.h               |  49 +-
>  mpathpersist/main.c                     |   1 +
>  multipathd/main.c                       |   5 +-
>  multipathd/main.h                       |  15 +-
>  10 files changed, 848 insertions(+), 847 deletions(-)
>  create mode 100644 libmpathpersist/mpath_persist_int.c
>  create mode 100644 libmpathpersist/mpath_persist_int.h
> 
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

