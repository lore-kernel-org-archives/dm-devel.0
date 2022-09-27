Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E88C6FA83
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664296807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dvhP/JlhqqEISuJfsD9WnZB3ASnDMg02Ba7kHzlqIyU=;
	b=Csd4EUrHVIKl07NMIlSP2u5t1QCVCSMX+/dFrZuIy5SAKoZHrWkTzvoO+QfpWXAX+1q5FL
	cwG+hKLHYfAHDUnXJzyg10MKuceOqi0AG0fdKwpxYQ22Y8+Y2hNv3FR7W+1KAMKsr36mx4
	Xxm6/2LAgIj4014ihE6eHGlC9IrrJNQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-Ol88AC49PtSAMRndf0o9_Q-1; Tue, 27 Sep 2022 12:40:04 -0400
X-MC-Unique: Ol88AC49PtSAMRndf0o9_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90B7E1C07585;
	Tue, 27 Sep 2022 16:40:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C7F62166B2A;
	Tue, 27 Sep 2022 16:40:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C83119465B1;
	Tue, 27 Sep 2022 16:40:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 175071946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 16:39:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7964492CA4; Tue, 27 Sep 2022 16:39:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D09F0492CA2
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 16:39:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6474101A528
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 16:39:58 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-vW9D89h8NNGRLH7Z8mhL0A-1; Tue, 27 Sep 2022 12:39:53 -0400
X-MC-Unique: vW9D89h8NNGRLH7Z8mhL0A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3C976B81C67;
 Tue, 27 Sep 2022 16:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896D2C433B5;
 Tue, 27 Sep 2022 16:39:48 +0000 (UTC)
Date: Tue, 27 Sep 2022 18:39:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YzMnUvz+eirBpRVi@kroah.com>
References: <alpine.LRH.2.02.2209260418360.16612@file01.intranet.prod.int.rdu2.redhat.com>
 <YzGYFBv0pdt+DQg+@kroah.com>
 <alpine.LRH.2.02.2209271206240.5208@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209271206240.5208@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] kernfs: fix a crash when two processes
 delete the same directory
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
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Christoph Lameter <cl@linux.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 27, 2022 at 12:09:19PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 26 Sep 2022, Greg Kroah-Hartman wrote:
> 
> > Can you see if 4abc99652812 ("kernfs: fix use-after-free in
> > __kernfs_remove") in linux-next fixes this for you or not?  It seems to
> > be the same issue, as was also reported at:
> > 	https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp
> > 
> > thanks,
> > 
> > greg k-h
> 
> I'm running the test with the patch 4abc99652812 for 3 hours, no crash, so 
> it's probably ok.
> 
> Tested-by: Mikulas Patocka <mpatocka@redhat.com>

Wonderful, thanks!

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

