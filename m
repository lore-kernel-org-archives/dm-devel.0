Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B0C1B142D
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 23:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768864244; cv=none; b=TV+kHYk5kKKMKYn28JicTlx5eT3BFQ9TlbzuvjSkscbdMxxVWUA3ORP1rGN8IOAFyNIN8B8SedEe3toUcDonyTPu/3RcwkF07bgAgdZvWDlLBW4/buWLK1W5FMzYFCyZAgJbgHslZzHWlTH4DQr+OaGrMITZiT78/lqFCEDhh0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768864244; c=relaxed/simple;
	bh=29rZS/DtLSFv0QZjOoWXMIUwOehqyLW2h0XLqX1jUUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=naofj8YVpjQ8lWGBQfmverajJcWBc/h8x7vswXT/2tWWaWfHAVosxMC6AAUxOvsaU20ZMiGedkg/l7A9AUUC12PcOSq70EBAGXZAJ4gyYsl6YVPCEm8X19H0DRkzxKKbmsBWheW/sBKFRbqtLfe//mB8PRYwOc8HdfEdB2NUu0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gocYvcKb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gocYvcKb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768864242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1w4D2S9T/5IGj+ILu9tdOdpnF1xJAw3AiNIOueE0VQ=;
	b=gocYvcKb6Sz9QkyakX1zkXIou81GZfk4gnYEIMgeCfyd6N+XIHIExxpAzM03/O9h87dKJ4
	dDn+63cBjyH5mDZKqxVhr9HtXYrWRJnDNNXsLoQM4dvZA5qMlmtiboBzgotzlCoWcyKr0v
	wkS+dxoQhjTF1hRbh8v6HIzkiVKsD+w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-hn33BWBsPzqRIOpvDaRgrQ-1; Mon,
 19 Jan 2026 18:10:40 -0500
X-MC-Unique: hn33BWBsPzqRIOpvDaRgrQ-1
X-Mimecast-MFC-AGG-ID: hn33BWBsPzqRIOpvDaRgrQ_1768864239
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42FD2180045C;
	Mon, 19 Jan 2026 23:10:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D26F830001A2;
	Mon, 19 Jan 2026 23:10:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60JNAbuG3865608
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 18:10:37 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60JNAbM53865607;
	Mon, 19 Jan 2026 18:10:37 -0500
Date: Mon, 19 Jan 2026 18:10:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/5] multipath-tools: minor fixes in preparation of 0.14.0
Message-ID: <aW657VlAeQs0F0SM@redhat.com>
References: <20260116113042.140719-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260116113042.140719-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aZB7-ooTvT-BkPB0C52MDwkZ2wTy1Vjs0ephJ0N69Ds_1768864239
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2026 at 12:30:37PM +0100, Martin Wilck wrote:
> This series fixes the double-free in kpartx introduced in 8c39e60 ("kpartx:
> fix some memory leaks"), removes the long-obsolete "hotplug" mode of
> kpartx, fixing another potential memory leak in the process, fixes a
> false positive compiler warning, and adds two developer convenience
> options to the Makefiles.

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Martin Wilck (5):
>   kpartx: avoid double-free of mapname
>   kpartx: remove "hotplug" mode
>   multipathd: fix an uninitialized variable warning
>   Makefiles: add "ASAN=1" make parameter for AddressSanitizer
>   Makefiles: add "OPT=" make parameter
> 
>  .github/actions/spelling/expect.txt |  3 +
>  Makefile.inc                        | 12 +++-
>  README.md                           |  9 +++
>  kpartx/kpartx.c                     | 94 ++++-------------------------
>  multipathd/main.c                   |  2 +-
>  5 files changed, 35 insertions(+), 85 deletions(-)
> 
> -- 
> 2.52.0

