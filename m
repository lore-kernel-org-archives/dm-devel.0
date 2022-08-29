Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E68B6ECAAA2
	for <dm-devel@archiver.kernel.org>; Mon, 29 Aug 2022 17:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661794953;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dsw/ubWqW97EGT8+Qx0BXH/pYmtoGwpiiAIAH6ifK3w=;
	b=D/BzJacZjIFioRKF8D7a13pWBaB6zxQsD6wTZCVf7wbz0pKeEVbcs0X8anB9P0cx/r2IvE
	ZTh9RkSVk6Y4RrMI2eTsO6A8XnruLErlsMBTXrk4AfbEMPcKCgGBlWxSHpC+PArxrHAIQz
	0U/Mc06NoSnLn68j2TlDZrmlkk/N638=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-4V56f9TSPcujDBjW_0pznQ-1; Mon, 29 Aug 2022 13:42:30 -0400
X-MC-Unique: 4V56f9TSPcujDBjW_0pznQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92F3F382ECC9;
	Mon, 29 Aug 2022 17:42:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF35D2166B26;
	Mon, 29 Aug 2022 17:42:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CC501946A45;
	Mon, 29 Aug 2022 17:42:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F0E2C1946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 Aug 2022 17:42:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0A441121319; Mon, 29 Aug 2022 17:42:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE6491121314;
 Mon, 29 Aug 2022 17:42:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27THgOht025814;
 Mon, 29 Aug 2022 12:42:24 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27THgN16025813;
 Mon, 29 Aug 2022 12:42:23 -0500
Date: Mon, 29 Aug 2022 12:42:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220829174223.GG16874@octiron.msp.redhat.com>
References: <20220826180552.25470-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220826180552.25470-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 0/5] multipath: optimizations for large
 mptable
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Aug 26, 2022 at 08:05:51PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> We observe that multipath operations take a long time if the multipaths
> section in multipath.conf contains a lot of alias settings
> (10000+ in our case). This hurts in particular in udev rules, when
> multipath -u or multipath -U is invoked, but also for command line
> invocations like "multipath -ll".
> 
> This series provides a few optimizations for this use case. It speeds
> up simple multipath operations in the test case by a factor of 20.
> 
> Changes v3->v4:
> 
>  02: more compilation fixes for msort.c to make it pass CI
>      (only re-posting this patch)
> 
> Changes v2->v3, after discussion with Benjamin Marzinski:
> 
>  01, 02: added msort.c from glibc and adapted to our needs.
>          Numbering changes accordingly.
>  03, 04: (was 01, 02): remove pointer comparisons from v2 again, this was a
>          dumb idea. Use the stable msort algorithm instead.
> 
> Changes wrt v1, after suggestions from Benjamin Marzinski:
> 
>  01, 02: Use pointer comparisons to achieve stable sorting with qsort
>  02:  Fix return without popping the cleanup handler. The way I fixed this
>       leaves the possibility that some memory won't be freed if a thread is
>       killed while executing vector_convert(). I think this is acceptible;
>       avoiding it would complicate the code, with very small benefit.
>  02: Remove unnecessary checks and break loop if alias==NULL is encountered.
> 
> Martin Wilck (5):
>   libmultipath: add msort.c from glibc
>   libmultipath: modifications for msort.c
>   libmultipath: merge_mptable(): sort table by wwid
>   libmultipath: check_alias_settings(): pre-sort mptable by alias
>   multipath: optimize program startup for frequent invocations
> 
>  libmultipath/Makefile |   2 +-
>  libmultipath/alias.c  |  37 +++++-
>  libmultipath/config.c |  15 ++-
>  libmultipath/msort.c  | 271 ++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/msort.h  |   6 +
>  libmultipath/vector.c |   9 ++
>  libmultipath/vector.h |   1 +
>  multipath/main.c      |  33 ++---
>  8 files changed, 352 insertions(+), 22 deletions(-)
>  create mode 100644 libmultipath/msort.c
>  create mode 100644 libmultipath/msort.h
> 
> -- 
> 2.37.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

