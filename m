Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0974C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Dec 2021 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638804410;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SXkIUS8jy8a/6sUn1+CWZJDxifsnmczuVqhj4Byg1gU=;
	b=Jxj61enFoBk4N0jTYFzDnuw4Jh7Hnu0+kPTct/zBnOoudWU82rRba5wcf/tyUPcEMEQte6
	b1RMK+f0C9vL5hg/dxMxpkYn2lYSnnenJ+yqvoL+O01Hxh01epIDYlDTUPAqC59HpcYII0
	o8/Zu76w4XoP2AhnmDaBO/FKYNEuTrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-j0sRC2BMOh2e1MkEul0p8w-1; Mon, 06 Dec 2021 10:26:47 -0500
X-MC-Unique: j0sRC2BMOh2e1MkEul0p8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08EDA81EE61;
	Mon,  6 Dec 2021 15:26:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F11919C59;
	Mon,  6 Dec 2021 15:26:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C9AE4BB7C;
	Mon,  6 Dec 2021 15:26:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B6FNH12028275 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Dec 2021 10:23:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 03C2245D63; Mon,  6 Dec 2021 15:23:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E33EB45D61;
	Mon,  6 Dec 2021 15:23:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1B6FNFBA006301; 
	Mon, 6 Dec 2021 09:23:15 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1B6FNEU9006300;
	Mon, 6 Dec 2021 09:23:14 -0600
Date: Mon, 6 Dec 2021 09:23:14 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211206152314.GX19591@octiron.msp.redhat.com>
References: <1638495252-15739-1-git-send-email-bmarzins@redhat.com>
	<1638495252-15739-2-git-send-email-bmarzins@redhat.com>
	<156c11a293ba2f59487dbeb7bdd959f49bf6de7d.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <156c11a293ba2f59487dbeb7bdd959f49bf6de7d.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/3] libmultipath: keep existing dm_info if
 you fail to get a new one
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 03, 2021 at 08:01:11AM +0000, Martin Wilck wrote:
> On Thu, 2021-12-02 at 19:34 -0600, Benjamin Marzinski wrote:
> > There are reasons that dm_get_info() can fail other than the
> > multipath
> > device not existing. If there is an existing dm_info structure and
> > the
> > call fails, don't free it.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> This is ok, but I think it'd be better to simply embed the dmi struct
> in struct multipath and thus avoid having allocate and free it
> separately. Either that, or just use a struct dm_info on stack  in
> dm_get_info() and just copy the properties we actually look at, i.e.
> read_only, major, minor, suspended, to respective fields in struct
> multipath. I'd prefer embedding the complete dmi, as it's not that
> large and contains other interesting fields, too (for example, we might
> be able to leverage the event_nr field to avoid duplicate work between
> uevent and dmevent handlers).
> 
> We would need to be able to figure out if the dmi is valid, but that's
> rather easy, we could simply set major = minor = 0.


Makes sense. I can change this.

-Ben

> 
> Regards
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

