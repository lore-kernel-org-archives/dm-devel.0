Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9CDC19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 04:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659501056;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Iy+Ri6u3RC7+jolVTz9cnyArCG5Oejqu7rI20jaOtdU=;
	b=SoWQtekKbOZ6WMkNE7tdUfk8GJlQ3ze5K5Htiv+OzJF1OgRHtgolyUibBdGMqoD4Ysixqx
	Os+Iu8KdpkMeI1ikCrtq7s+Sug1XfFBRSRaQbP3mIc38G6KCR5bL/xQOQuTB5MJxkFok3r
	N6fOBEnaZ9Ka/7WGVorr1zpfgd6N4vA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-RFjX1K9dOve76c6Xnp2zdg-1; Wed, 03 Aug 2022 00:30:53 -0400
X-MC-Unique: RFjX1K9dOve76c6Xnp2zdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73D12811E75;
	Wed,  3 Aug 2022 04:30:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62FE1400DFD7;
	Wed,  3 Aug 2022 04:30:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D23A1946A50;
	Wed,  3 Aug 2022 04:30:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B13711946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 04:30:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66CCD141510F; Wed,  3 Aug 2022 04:30:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 634BA1410F38
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 04:30:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 499808032F1
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 04:30:49 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-8EG6ci5jPsKDj4ERheZmeA-1; Wed, 03 Aug 2022 00:30:47 -0400
X-MC-Unique: 8EG6ci5jPsKDj4ERheZmeA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A2A0A612BF;
 Wed,  3 Aug 2022 04:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ADBC433C1;
 Wed,  3 Aug 2022 04:23:09 +0000 (UTC)
Date: Tue, 2 Aug 2022 21:23:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniil Lunev <dlunev@chromium.org>
Message-ID: <Yun4LH+StcuBXRtO@sol.localdomain>
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
 <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
 <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: Brian Geffon <bgeffon@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 03, 2022 at 02:12:26PM +1000, Daniil Lunev wrote:
> Hello all
> To signal boost here. What can we do to advance the discussion on this
> topic? Can we move forward with the approach or are there any
> alternative suggestions how the desired behaviour can be achieved?
> Thanks,
> --Daniil
> 
> On Tue, Jul 19, 2022 at 9:42 AM Daniil Lunev <dlunev@chromium.org> wrote:
> >
> > We understand that if someone acquires root it is a game over. The intent of
> > this mechanism is to reduce the attack surface. The exposure might be a
> > certain system daemon that is exploited into accessing a wrong node in
> > the filesystem. And exposing modifiable system memory is a pathway for
> > further escalation and leaks of secrets. This is a defense in depth mechanism,
> > that is intended to make attackers' lives harder even if they find an
> > exploitable
> > vulnerability.
> > We understand that in regular situations people may not want the behaviour,
> > that is why the mechanism is controlled via a side channel - if a message is
> > never sent - the behaviour is not altered.
> > --Daniil

This seems like an access control policy, which the Linux kernel already has a
lot of mechanisms for.  Chrome OS already uses SELinux.  Couldn't this be solved
by giving the device node an SELinux label that no one has permission to open?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

