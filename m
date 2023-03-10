Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA94C64EC4
	for <dm-devel@archiver.kernel.org>; Fri, 10 Mar 2023 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678462153;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nMM1p8GhlHdq+UPVAhKOL0hm1Si7fgoTBBfPcnUDEkM=;
	b=O8KFE+YgzMf8+6OJLqQlwOBdTUf48YCc6FcdTJzRVU7bX7GMWLvH1CgIuliOd4PBZAMNCm
	po2U0IdVIDhjzJK6MTjYqAyoTt27LQTCMhc6QXrVh94wDTMwhVLW+mreW+Udod6yRtyW9P
	CRjWYRrMzoFEVFiFAaRGWuSOwnWkBFk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-yBwa4wdmPeihMww0K9eIVA-1; Fri, 10 Mar 2023 10:29:10 -0500
X-MC-Unique: yBwa4wdmPeihMww0K9eIVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBC5C1C075A6;
	Fri, 10 Mar 2023 15:29:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97486C15BA0;
	Fri, 10 Mar 2023 15:29:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5602819466DF;
	Fri, 10 Mar 2023 15:29:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6FA1F1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Mar 2023 15:29:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FA9D492B00; Fri, 10 Mar 2023 15:29:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4855F492C3E
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 15:29:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2388B3801F58
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 15:29:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-0ExR6v23PviGjnLA0LJIYw-1; Fri,
 10 Mar 2023 10:29:02 -0500
X-MC-Unique: 0ExR6v23PviGjnLA0LJIYw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 4CB4D2065B;
 Fri, 10 Mar 2023 15:29:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2328113592;
 Fri, 10 Mar 2023 15:29:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id IMHnBrxMC2StBAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 10 Mar 2023 15:29:00 +0000
Message-ID: <604a1f788186cd90e6f0404dfbcfa1f2c4b45463.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Date: Fri, 10 Mar 2023 16:28:59 +0100
In-Reply-To: <88E8FF76-774E-4204-B0D9-F17B0BFBA2D7@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
 <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
 <20230306190413.GL17327@octiron.msp.redhat.com>
 <eab31c43c11e5acfc750ee1d5e21df4e92641c31.camel@suse.com>
 <C4BBD0E1-F806-4EE8-8C4A-0EEA3E0C433A@purestorage.com>
 <555883fb00fa0769ef37a96e99095b2778ee8467.camel@suse.com>
 <A1AAA90F-3F7E-4C37-B23B-178022361884@purestorage.com>
 <8569f8c6c9d16ecaf255056dd91cb46b5a813add.camel@suse.com>
 <88E8FF76-774E-4204-B0D9-F17B0BFBA2D7@purestorage.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2023-03-09 at 14:11 -0800, Brian Bunker wrote:
> 
> > On Mar 9, 2023, at 1:50 PM, Martin Wilck <mwilck@suse.com> wrote:
> > 
> > Brian,
> > 
> > On Thu, 2023-03-09 at 13:40 -0800, Brian Bunker wrote:
> > > 
> > > Martin,
> > > 
> > > Sorry I bounce between kernel versions a lot since most of the
> > > problems which find their way to us are released Linux versions
> > > whose kernels are quite a bit older than upstream.I got a chance
> > > to try the proposed solutions. The PATH_GHOST above does what
> > > I am looking for which is not to have the path checker fail the
> > > path.
> > > 
> > > This also works as your earlier comments suggest. This does seem
> > > clearer as to what is happening on the path:
> > > 
> > 
> > I apologize for being slow, but I don't quite understand this
> > response.
> > Have you tested Ben's patch set? Does it work for you? Is the patch
> > below meant to be applied on top of Ben's work?
> > 
> > Martin
> Martin,
> 
> This is just a patch I made instead of the original patch to verify
> using PATH_PENDING would work in our case, and it does. It has
> no relationship to anything Ben was doing.

Thanks for the clarification.
Please, if you have time, give Ben's set a test.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

