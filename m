Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89122C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 21 Dec 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640052608;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TLeCYRKC6E4cDEbd7ovX6h3iXIV7CrlopkU9wtsZhkE=;
	b=HdyrvfbEuAa1k0ByMlmqvHqik5D9tMc6Vw3Lxj2xjmwL8FNtfVW3m6W2q5gK3eYx79uFDD
	WUdTpTVOF7w7sUfpsAJy48Kl2tPvcRyDL8Vy72n6CdyentpEIw46p9IfDrncEVoxsNv6Ww
	nF8PKSF/AkKebJg5WIYJYADxa22J/Lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-0xSw9ZB8PqemK3Ui6Mgebw-1; Mon, 20 Dec 2021 21:10:05 -0500
X-MC-Unique: 0xSw9ZB8PqemK3Ui6Mgebw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4636E10151E2;
	Tue, 21 Dec 2021 02:10:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C181059592;
	Tue, 21 Dec 2021 02:09:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8ABD31809CB8;
	Tue, 21 Dec 2021 02:09:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BL29qQ4019270 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 20 Dec 2021 21:09:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4363B78AA7; Tue, 21 Dec 2021 02:09:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 351FA78A8F;
	Tue, 21 Dec 2021 02:09:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BL29kvk017922; 
	Mon, 20 Dec 2021 20:09:46 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BL29j2l017921;
	Mon, 20 Dec 2021 20:09:45 -0600
Date: Mon, 20 Dec 2021 20:09:44 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211221020944.GA17665@octiron.msp.redhat.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
	<f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
	<b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 07, 2021 at 09:11:55AM +0000, Martin Wilck wrote:
> On Tue, 2021-12-07 at 09:19 +1000, Erwin van Londen wrote:
> 
> Moreover, the existing marginal paths handler has two different modes
> of operation, the "classical" one that disables reinstate, and the 
> more modern one that uses marginal pathgroups. I am wondering whether
> we need the first mode in the long run. In particular if we want to
> generalize this feature, we may want to get rind of the "classical"
> mode altogether. I'm not aware of any distinct advantages of that
> algorithm compared to marginal path groups.
> 
> @Ben, Muneendra, what do you think?

Sorry I missed this. I'm fine with deprecating the old style of handling
marginal paths.
 
> One word of caution here: we must be careful not to over-engineer.
> As long as no other mechanism like FPIN for other transports is
> conceivable, generalizing the concept makes only so much sense.
> Therefore we shouldn't hold back the FPIN patches until we have
> conceived of a generic mechanism, which may take a lot of time to
> develop. If another mechanism becomes available, we could still try to
> generalize the concept, if we keep the current additions clean and
> well-separated from the core multipathd code.
> 
> However I am really thrilled by the prospect of generalizing event
> handling and reusing the uevent threads for FPIN. That would reduce
> complexity a lot, which is a good thing IMO.
> 
> @Ben, Muneendra, again, your opinions?

I don't have a problem with that. Doing this does entwine a chunk of
code that may not get frequently used to a chunk of code that is
essential for multipathd to run correctly.  But I guess if there are
corner cases in the fpin code that cause issues for the rest of
multipath, then either the fpin code gets used a lot and they are found
quickly, or it doesn't, and they rarely cause problems. 

-Ben

> Best
> Martin
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

