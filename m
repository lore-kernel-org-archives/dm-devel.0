Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E396C433E7
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 20:01:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B0305222B8
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 20:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWR5JHI5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0305222B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603137698;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1JNf26D1uIYSfp19n8n4GjolenxTFnkj4KURRbGrTuQ=;
	b=UWR5JHI5hG7YBsICllJU5aA7+zVPTHKwMOZBw2J0g3cDHpw0/UdzjvjgNJZH4RQ35EEfle
	lownweFdzfEFcKZz7IzWQDuuijEdT25aYjOVq3v0zrDzxpUeYZ2JhMvhPoqFY1Oey46A0h
	rHmog5TA/pXV4o2GF6GfLfvnUnqgF70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-f7IOsFSaPXuKhJ6bG39TpA-1; Mon, 19 Oct 2020 16:01:36 -0400
X-MC-Unique: f7IOsFSaPXuKhJ6bG39TpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 061A58049CA;
	Mon, 19 Oct 2020 20:01:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAE255D9D2;
	Mon, 19 Oct 2020 20:01:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 28DC0181A06B;
	Mon, 19 Oct 2020 20:01:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JK1Tol028743 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 16:01:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 04FF45D9D2; Mon, 19 Oct 2020 20:01:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6261C5D9EF;
	Mon, 19 Oct 2020 20:01:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09JK1NeM014134; 
	Mon, 19 Oct 2020 15:01:24 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09JK1NmW014133;
	Mon, 19 Oct 2020 15:01:23 -0500
Date: Mon, 19 Oct 2020 15:01:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201019200123.GF3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-24-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104501.8700-24-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 23/29] multipath-tools: mpath-tools.supp:
 file with valgrind suppressions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:44:55PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> These leaks are caused by other libraries (libsystemd, glibc,
> libgcrypt) and should be ignored when debugging with valgrind
> 
> Usage example:
> 
> valgrind --suppressions=mpath-tools.supp \
>     --leak-check=full --show-leak-kinds=all $COMMAND
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  third-party/valgrind/mpath-tools.supp | 32 +++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 third-party/valgrind/mpath-tools.supp
> 
> diff --git a/third-party/valgrind/mpath-tools.supp b/third-party/valgrind/mpath-tools.supp
> new file mode 100644
> index 0000000..0537fd5
> --- /dev/null
> +++ b/third-party/valgrind/mpath-tools.supp
> @@ -0,0 +1,32 @@
> +{
> +   glibc _dlerror_run leak: https://stackoverflow.com/questions/1542457/memory-leak-reported-by-valgrind-in-dlopen
> +   Memcheck:Leak
> +   match-leak-kinds: reachable
> +   fun:calloc
> +   fun:_dlerror_run
> +   fun:dlopen*
> +}
> +
> +{
> +   systemd mempools are never freed: https://bugzilla.redhat.com/show_bug.cgi?id=1215670
> +   Memcheck:Leak
> +   match-leak-kinds: reachable
> +   fun:malloc
> +   fun:mempool_alloc_tile
> +   fun:mempool_alloc0_tile
> +   fun:hashmap_base_new
> +   fun:hashmap_base_ensure_allocated
> +}
> +
> +{
> +   libgcrypt library initialization
> +   Memcheck:Leak
> +   match-leak-kinds: reachable
> +   fun:malloc
> +   ...
> +   fun:_gcry_xmalloc
> +   ...
> +   fun:global_init.*
> +   ...
> +   fun:_dl_init
> +}
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

