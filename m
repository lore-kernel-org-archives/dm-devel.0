Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535EEC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07AF760F92
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07AF760F92
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631515219;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2fNW4iBri5WqKXxlRaRHroTki+WJ5n6QYUq42MkWpcA=;
	b=Mc3Ej44kroTvqBX42/RLXDUJiskphjA/dntRJkCxAGXuLdB/Ql1wOCIXIvPMzSoIIkrKY/
	x0yRoXLKNXM+ow+pin3f5HGKQx/XmInwbeTglUfJH5SWWb1VKYfZYBGRPnHA8L0VORi6/5
	VqJ14sjluSzUVGXifj2qub64OqZrkTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-oyxf1i0iP8ijb6pXnq2Hlw-1; Mon, 13 Sep 2021 02:40:17 -0400
X-MC-Unique: oyxf1i0iP8ijb6pXnq2Hlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A8B7800FF3;
	Mon, 13 Sep 2021 06:40:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6E356D985;
	Mon, 13 Sep 2021 06:40:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BED861806D03;
	Mon, 13 Sep 2021 06:40:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 188FdlXp007586 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Sep 2021 11:39:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8816B77F30; Wed,  8 Sep 2021 15:39:47 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.236])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4456E77F29;
	Wed,  8 Sep 2021 15:39:31 +0000 (UTC)
From: Steve Grubb <sgrubb@redhat.com>
To: =?ISO-8859-1?Q?Wei=DF=2C?= Michael <michael.weiss@aisec.fraunhofer.de>,
	Richard Guy Briggs <rgb@redhat.com>
Date: Wed, 08 Sep 2021 11:39:02 -0400
Message-ID: <4344604.LvFx2qVVIh@x2>
Organization: Red Hat
In-Reply-To: <20210908131616.GK490529@madcap2.tricolour.ca>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
	<9ca855cb19097b6fa98f2b3419864fd8ddadf065.camel@aisec.fraunhofer.de>
	<20210908131616.GK490529@madcap2.tricolour.ca>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 13 Sep 2021 02:39:51 -0400
Cc: "paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"casey@schaufler-ca.com" <casey@schaufler-ca.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 0/3] dm: audit event logging
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wednesday, September 8, 2021 9:16:16 AM EDT Richard Guy Briggs wrote:
>  Another minor oddity is the double "=" for the subj
> 
> > > field, which doesn't appear to be a bug in your code, but still
> > > puzzling.
> > 
> > In the test setup, I had Apparmor enabled and set as default security
> > module. This behavior occurs in any audit_log message.
> > Seems that this is coming from the label handling there. Having a quick
> > look at the code there is that they use '=' in the label to provide a
> > root view as part of their policy virtualization. The corresponding
> > commit is sitting there since 2017:
> > "26b7899510ae243e392960704ebdba52d05fbb13"
> 
> Interesting...  Thanks for tracking down that cause.  I don't know how
> much pain that will cause the userspace parsing tools.  I've added Steve
> Grubb to the Cc: to get his input, but this should not derail this patch
> set.

It likely breaks any parser. I would even say that it's a malformed event 
that should be corrected. There's been a published a specification for audit 
events  for at least 5 years. Latest copy is here:

https://github.com/linux-audit/audit-documentation/wiki/SPEC-Writing-Good-Events

-Steve



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

