Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235D5C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648145272;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1sLENV9zxeeWJ+WAV7/oGfd+fpGfGSvd9+n07IvgTxE=;
	b=RRz83oTHyU6dT1CuZ5nRjO5xlfkFv7/uH5sL9ulx4vM6bLANtG7S4r50YBuC7szFwNKo/i
	SC+vSFcV2/M4pZ4qY2xWiY4MfBdbfdtOa2jByivFEbh/FfbtHCcJ2bZmB/qYoGLr5s6yUR
	k1PZA0NVleRJzRcCZ+NlvQUYW0KY6tk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-Y2U1DhNCMH6yZhqj2eElBQ-1; Thu, 24 Mar 2022 14:07:48 -0400
X-MC-Unique: Y2U1DhNCMH6yZhqj2eElBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C0E43C00127;
	Thu, 24 Mar 2022 18:07:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2353400E132;
	Thu, 24 Mar 2022 18:07:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 73603194034B;
	Thu, 24 Mar 2022 18:07:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8B211940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 18:07:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96F2DC15E60; Thu, 24 Mar 2022 18:07:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 83465C15D7C;
 Thu, 24 Mar 2022 18:07:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22OI7hVA026228;
 Thu, 24 Mar 2022 13:07:43 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22OI7gcU026227;
 Thu, 24 Mar 2022 13:07:42 -0500
Date: Thu, 24 Mar 2022 13:07:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Uday Shankar <ushankar@purestorage.com>
Message-ID: <20220324180742.GM24684@octiron.msp.redhat.com>
References: <20220309200325.2490463-1-ushankar@purestorage.com>
 <20220323231023.GL24684@octiron.msp.redhat.com>
 <3fdc891239f9c45f8b4c034eae9ded9572f2a0ad.camel@suse.com>
 <20220324170809.GA2213089@dev-ushankar.dev.purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20220324170809.GA2213089@dev-ushankar.dev.purestorage.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] multipath-tools: update mpp->force_readonly
 in ev_add_path
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 24, 2022 at 11:08:09AM -0600, Uday Shankar wrote:
> Thanks to Benjamin for the review and to Martin for taking the patch.
> 
> > https://github.com/openSUSE/multipath-tools/tree/queue
> Benjamin, does RedHat take patches from this repo? The
> device-mapper-multipath spec file seems to point to git.opensvc.com

Oops. I should cleanup that comment. RHEL pulls from
https://github.com/opensvc/multipath-tools

RHEL-8 is some releases behind upstream, but this fix will be backported
to RHEL-8.7 (via bugzilla #2065468).

-Ben

> (which is dead), and the upstream URL christophe.varoqui.free.fr refers
> to github.com/opensvc/multipath-tools. Will patches committed to the
> above openSUSE repo will make their way to the opensvc one (since
> openSUSE forks opensvc)?
>  
> > (Please set me on CC next time to speed up review).
> Sure, is there a list of maintainers and email addresses somewhere?
> Everywhere I look I only see Christophe Varoqui listed.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

