Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37658C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  7 Jun 2022 22:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654641170;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j4GgKdU82bBEzrNk/10qD1zb7JWH+EHUcm+Pdkhg1tA=;
	b=QrMz+zTuWR9DZkgm55ewkXv7K4A5KviIQtrwWmmKeX7x2tdHkbO9Z2rKQLQH5d+3vQLPPd
	3wEp5cjCtj6Hz1vwL76oXCpTPEGheysyzEPB2G3Wta4oftQAu2t8wy9ku38R9d2lKI15U+
	dxw2jeOtDMEq7giIzjLmLIctcHXYxZ8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-Qk7oan3PPxuDlKgg-KCiJw-1; Tue, 07 Jun 2022 18:32:47 -0400
X-MC-Unique: Qk7oan3PPxuDlKgg-KCiJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857D929ABA09;
	Tue,  7 Jun 2022 22:32:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73FE71121319;
	Tue,  7 Jun 2022 22:32:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18EB41947042;
	Tue,  7 Jun 2022 22:32:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BFE211947042
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Jun 2022 22:32:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B13FE1121315; Tue,  7 Jun 2022 22:32:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D20D1121314;
 Tue,  7 Jun 2022 22:32:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 257MWfuw011953;
 Tue, 7 Jun 2022 17:32:42 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 257MWfSr011952;
 Tue, 7 Jun 2022 17:32:41 -0500
Date: Tue, 7 Jun 2022 17:32:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220607223240.GV5254@octiron.msp.redhat.com>
References: <20220531203905.28702-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220531203905.28702-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath.conf(5): add disclaimer about
 vendor support
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com,
 Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 31, 2022 at 10:39:05PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Add a disclaimer to clarify that entries in the hwtable don't imply any
> obligations on the vendor's part.
> ---
>  multipath/multipath.conf.5 | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index d57c810..c2d34f1 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -1490,6 +1490,18 @@ section:
>  .SH "devices section"
>  .\" ----------------------------------------------------------------------------
>  .
> +.TP 4
> +.B Important:
> +The built-in hardware device table of
> +.I multipath-tools
> +is created by members of the Linux community in the hope that it will be useful.
> +The existence of an entry for a given storage product in the hardware table
> +.B does not imply
> +that the product vendor supports, or has tested, the product with
> +.I multipath-tools
> +in any way.
> +.B Always consult the vendor\(aqs official documentation for support-related information.
> +.PP
>  \fImultipath-tools\fR have a built-in device table with reasonable defaults
>  for more than 100 known multipath-capable storage devices. The devices section
>  can be used to override these settings. If there are multiple matches for a
> -- 
> 2.36.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

