Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E66EB64DD
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jul 2023 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689946552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+2xVfPW/nEdkPuYX3csJ5q2ufDHNyBD4mw29QpacHFI=;
	b=Gbn4PHszz6nOZ5ExEkGXqoTr9H2TVWxODU9YzLn5KYZpc3xAxpPBO+zJ9MQP6uldCZ05hy
	o/U3w+sgG7WdRbrGFyQ7aF7L8hdmE/osvboqcmg9TlRFcGcCJeETKyurJek8d9v1j+AMrP
	kycvAOoqqGdr14pu1vOG2j0nMAst9KY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-IIEwXDIiPsStMOix_hjtrA-1; Fri, 21 Jul 2023 09:35:49 -0400
X-MC-Unique: IIEwXDIiPsStMOix_hjtrA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 284BB8F1841;
	Fri, 21 Jul 2023 13:35:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61201492C13;
	Fri, 21 Jul 2023 13:35:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D3CB1946A43;
	Fri, 21 Jul 2023 13:35:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E29A21946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Jul 2023 13:35:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB751C585A1; Fri, 21 Jul 2023 13:35:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3F59C585A0
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 13:35:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98C998F184A
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 13:35:41 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-x9K5NHxsP_qpX187s2jRRA-1; Fri, 21 Jul 2023 09:35:36 -0400
X-MC-Unique: x9K5NHxsP_qpX187s2jRRA-1
Received: from cwcc.thunk.org (pool-173-48-116-181.bstnma.fios.verizon.net
 [173.48.116.181]) (authenticated bits=0)
 (User authenticated as tytso@ATHENA.MIT.EDU)
 by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36LDZQFo003755
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 21 Jul 2023 09:35:27 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
 id 8CD6A15C04D6; Fri, 21 Jul 2023 09:35:26 -0400 (EDT)
Date: Fri, 21 Jul 2023 09:35:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <martin@lichtvoll.de>
Message-ID: <20230721133526.GF5764@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <4835096.GXAFRqVoOG@lichtvoll.de> <20230720042034.GA5764@mit.edu>
 <38426448.10thIPus4b@lichtvoll.de>
MIME-Version: 1.0
In-Reply-To: <38426448.10thIPus4b@lichtvoll.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] Nobarrier mount option (was: Re: File system
 robustness)
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
Cc: linux-embedded@vger.kernel.org, dm-devel@redhat.com,
 Kai Tomerius <kai@tomerius.de>,
 =?iso-8859-1?Q?Bj=F8rn?= Forsman <bjorn.forsman@gmail.com>,
 Ext4 Developers List <linux-ext4@vger.kernel.org>,
 "Alan C. Assis" <acassis@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: mit.edu
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 20, 2023 at 09:55:22AM +0200, Martin Steigerwald wrote:
> 
> I thought that nowadays a cache flush would be (almost) a no-op in the 
> case the storage receiving it is backed by such reliability measures. 
> I.e. that the hardware just says "I am ready" when having the I/O 
> request in stable storage whatever that would be, even in case that 
> would be battery backed NVRAM and/or temporary flash.

That *can* be true if the storage subsystem has the reliability
measures.  For example, if have a $$$ EMC storage array, then sure, it
has an internal UPS backup and it will know that it can ignore that
CACHE FLUSH request.

However, if you have *building* a storage system, the storage device
might be a HDD who has no idea that that it doesn't need to worry
about power drops.  Consider if you will, a rack of servers, each with
a dozen or more HDD's.  There is a rack-level battery backup, and the
rack is located in a data center with diesel generators with enough
fuel supply to keep the entire data center, plus cooling, going for
days.  The rack of servers is part of a cluster file system.  So when
a file write to a cluster file system is performed, the cluster file
system will pick three servers, each in a different rack, and each
rack is in a different power distribution domain.  That way, even the
entry-level switch on the rack dies, or the Power Distribution Unit
(PDU) servicing a group of racks blows up, the data will be available
on the other two servers.

> At least that is what I thought was the background for not doing the 
> "nobarrier" thing anymore: Let the storage below decide whether it is 
> safe to basically ignore cache flushes by answering them (almost) 
> immediately.

The problem is that the storage below (e.g., the HDD) has no idea that
all of this redundancy exists.  Only the system adminsitrator who is
configuring the file sysetm will know.  And if you are runninig a
hyper-scale cloud system, this kind of custom made system will be
much, MUCH, cheaper than buying a huge number of $$$ EMC storage
arrays.

Cheers,

					- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

