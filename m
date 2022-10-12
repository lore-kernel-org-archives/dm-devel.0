Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E415C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 12 Oct 2022 22:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665614852;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ccF59jSM9d2V0gLeZdWLNSuCR8AENcoj2WyKXo55yhU=;
	b=hKpY4Hq/OqMyZF/jOeSnCQhJJvSQePJjNPHQ6+8UNGNIO5Z/9gBFjPUua/jCFYA8Rj1cTR
	+H6QGdUP3b4gmipnouHGqzplFBZbfBrZUGhKlhnNqCRASqGoBKz6QY2YKeqdBbd7MuKpsX
	lwFMUfm2dTJj3ukxqKvvX1xIKuumsxE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-wFxk-BlKNjqRa_Feu4dKRg-1; Wed, 12 Oct 2022 18:47:29 -0400
X-MC-Unique: wFxk-BlKNjqRa_Feu4dKRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85D07185A792;
	Wed, 12 Oct 2022 22:47:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0356C112D17B;
	Wed, 12 Oct 2022 22:47:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA13C1946589;
	Wed, 12 Oct 2022 22:47:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 332CF1946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Oct 2022 22:47:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 975BE112D17C; Wed, 12 Oct 2022 22:47:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DB23112D17B;
 Wed, 12 Oct 2022 22:47:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29CMlLUn027872;
 Wed, 12 Oct 2022 17:47:21 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29CMlLBs027871;
 Wed, 12 Oct 2022 17:47:21 -0500
Date: Wed, 12 Oct 2022 17:47:20 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Lidong Zhong <lidong.zhong@suse.com>
Message-ID: <20221012224720.GB3410@octiron.msp.redhat.com>
References: <20221012072316.19124-1-lidong.zhong@suse.com>
MIME-Version: 1.0
In-Reply-To: <20221012072316.19124-1-lidong.zhong@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath: add option -D to manpage
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 12, 2022 at 03:23:16PM +0800, Lidong Zhong wrote:
> commit(5adb0a15 multipath: add option to skip multipathd delegation)
> added a new option -D to multipath without updating the manpage.
> 
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.8 | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index 4c7e9885..93b6d763 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -223,6 +223,10 @@ The verbosity level also controls the level of log and debug messages printed to
>  Dry run, do not create or update devmaps.
>  .
>  .TP
> +.B \-D
> +Allow users to skip delegating commands to multipathd.
> +.
> +.TP
>  .B \-e
>  Enable all foreign libraries. This overrides the
>  .I enable_foreign
> -- 
> 2.35.3
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

