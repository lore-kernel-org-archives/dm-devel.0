Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605C9E7F144
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 23:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695770090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=++FUHUKYAozsTzLWqGvO6WdaoBWO639eQ/2Z/fmvhTk=;
	b=KFo0wB6FfAkpnXeFpJMJ6rzCxxhE65rCZuBsNvpupWyTfQOBAdPNJfCCDWNVNxZ3E119cA
	lN0G7W5KSV95+vGPZqJARKz/RlM5s1yXM9QI95uyC+ZXybdkf5U5D2Q4hDu2wpRthupJ0H
	DgFBrkJWUeqZvpSMzfAqVrkXZWZJP4o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-GJhkZLtoOUSAC0lB7uJbaQ-1; Tue, 26 Sep 2023 19:14:47 -0400
X-MC-Unique: GJhkZLtoOUSAC0lB7uJbaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B42781859199;
	Tue, 26 Sep 2023 23:14:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3831004058;
	Tue, 26 Sep 2023 23:14:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC8EA1946589;
	Tue, 26 Sep 2023 23:14:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACEB41946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 22:53:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 974B140C6E76; Tue, 26 Sep 2023 22:53:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9096240C6EA8
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 22:53:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70FB73C23FD5
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 22:53:39 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-GHpTnFRyMDmwqwxjhu2inQ-1; Tue,
 26 Sep 2023 18:53:37 -0400
X-MC-Unique: GHpTnFRyMDmwqwxjhu2inQ-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1qlGvt-00AJIA-LU; Tue, 26 Sep 2023 22:53:33 +0000
Date: Tue, 26 Sep 2023 23:53:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Message-ID: <ZRNg7ctL4cx75RVh@casper.infradead.org>
References: <ZRNWRyc7xPY17fvt@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZRNWRyc7xPY17fvt@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] Sleeping function called from invalid context
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 26, 2023 at 11:08:07PM +0100, Matthew Wilcox wrote:
> Got this in linux-next 20230926, and I don't think it's due to my
> patches on top (it may be, will verify):

Confirmed not my patches;

git bisect start
# status: waiting for both good and bad commits
# good: [6465e260f48790807eef06b583b38ca9789b6072] Linux 6.6-rc3
git bisect good 6465e260f48790807eef06b583b38ca9789b6072
# status: waiting for bad commit, 1 good commit known
# bad: [4ae73bba62a367f2314f6ce69e3085a941983d8b] Add linux-next specific files for 20230926
git bisect bad 4ae73bba62a367f2314f6ce69e3085a941983d8b
# good: [cc2f2a99c4be7c44a3441dd8f4b9e475d30800c3] Merge branch 'for-next' of https://evilpiepirate.org/git/bcachefs.git
git bisect good cc2f2a99c4be7c44a3441dd8f4b9e475d30800c3
# good: [5a3bc5b9e4e9744f372692a88fd70750ee4851b3] Merge branch 'for-linux-next' of git://anongit.freedesktop.org/drm/drm-misc
git bisect good 5a3bc5b9e4e9744f372692a88fd70750ee4851b3

I'm going to sleep now instead of running the last 10 steps of the
bisect.  If nobody's found this when I wake up, I'll finish it then.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

