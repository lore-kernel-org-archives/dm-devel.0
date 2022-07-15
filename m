Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0592CC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657877781;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CCiCh+13g+Blq7Tw2UTq+UT5HU0cnzZE9LujE3s6XtY=;
	b=IQlV2rKmh9+VotnKBiCjQY7Wy9WTV3zDxflsC73Ihczgvv+wKZGj5y0+pZg3DgpP6Fjz5u
	bCj0gLjEF/9yB9H6aH3WCiMc2los3lrRC5g2bpJlvLxxQsBYhpixlkpoI3JlorFp+9eXLy
	y2rA7oymYR8NADf0BTB2xiaz0QFvlmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-fRfkX7I0O0eZixPs1QFn7A-1; Fri, 15 Jul 2022 05:36:18 -0400
X-MC-Unique: fRfkX7I0O0eZixPs1QFn7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AC2C800124;
	Fri, 15 Jul 2022 09:36:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 134692026D07;
	Fri, 15 Jul 2022 09:36:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D447D1947041;
	Fri, 15 Jul 2022 09:36:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9909819466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 09:36:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78F1E2026D2D; Fri, 15 Jul 2022 09:36:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ACF12026D64;
 Fri, 15 Jul 2022 09:36:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26F9aCks005568; Fri, 15 Jul 2022 05:36:12 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26F9aCSN005565; Fri, 15 Jul 2022 05:36:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Fri, 15 Jul 2022 05:36:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Daniil Lunev <dlunev@chromium.org>
In-Reply-To: <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Brian Geffon <bgeffon@google.com>, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 15 Jul 2022, Daniil Lunev wrote:

> Hi Mike,
> Thank you for your response. I should have probably added more context
> to the commit message that I specified in the cover letter. The idea is to
> prohibit access of all userspace, including the root. The main concern here
> is potential system applications' vulnerabilities that can trick the system to
> operate on non-intended files with elevated permissions. While those could
> also be exploited to get more access to the regular file systems, those firstly
> has to be useable by userspace for normal system operation (e.g. to store
> user data), secondly, never contain plain text secrets. Swap content is a
> different story - access to it can leak very sensitive information, which
> otherwise is never available as plaintext on any persistent media - e.g. raw
> user secrets, raw disk encryption keys etc, other security related tokens.
> Thus we propose a mechanism to enable such a lockdown after necessary
> configuration has been done to the device at boot time.
> --Daniil

If someone gains root, he can do anything on the system.

I'm quite skeptical about these attempts; protecting the system from the 
root user is never-ending whack-a-mole game.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

