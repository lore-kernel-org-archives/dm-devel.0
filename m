Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E2AE7D0D2
	for <dm-devel@archiver.kernel.org>; Fri, 22 Sep 2023 06:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695365729;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FOglpSRTulOhY2zSyFggWA4VMGqjwEo0KJFm80jqWug=;
	b=BU2HnsnCtS4PSs3sf6T7s+DPmS+fGHr27wvapj28o1AnRdbmsr3q8GmZy7hw54t8khu0tR
	+naX4dh2Wi7FJj7IMWgVFpoqeABQnE2EHhh1Wx9CtHvzfUQ6Cp+9PeJEwTjuCsAZku50pr
	MgdHO4MzVIWdBRznLN5lLQ+O5+KycbY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-689-LMRaa91NOFiPANelleCzIQ-1; Fri, 22 Sep 2023 02:55:26 -0400
X-MC-Unique: LMRaa91NOFiPANelleCzIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9178A3C11C67;
	Fri, 22 Sep 2023 06:55:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6257840C6EBF;
	Fri, 22 Sep 2023 06:55:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A6261946588;
	Fri, 22 Sep 2023 06:55:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E022C1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Sep 2023 22:12:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A53AF711282; Thu, 21 Sep 2023 22:12:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DA82711286
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 22:12:46 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80867101A53B
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 22:12:46 +0000 (UTC)
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-JgZqGvWfPaiOeo1h6v1Ndw-1; Thu,
 21 Sep 2023 18:12:44 -0400
X-MC-Unique: JgZqGvWfPaiOeo1h6v1Ndw-1
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
 by len.romanrm.net (Postfix) with SMTP id 4D3F740652;
 Thu, 21 Sep 2023 22:03:50 +0000 (UTC)
Date: Fri, 22 Sep 2023 03:03:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-raid@vger.kernel.org
Message-ID: <20230922030340.2eaa46bc@nvm>
In-Reply-To: <ZQy5dClooWaZoS/N@redhat.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 22 Sep 2023 06:55:21 +0000
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: Kirill Kirilenko <kirill@ultracoder.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, heinzm@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: romanrm.net
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 21 Sep 2023 17:45:24 -0400
Mike Snitzer <snitzer@kernel.org> wrote:

> I just verified that 6.5.0 does have this DM core fix (needed to
> prevent excessive splitting of discard IO.. which could cause fstrim
> to take longer for a DM device), but again 6.5.0 has this fix so it
> isn't relevant:
> be04c14a1bd2 dm: use op specific max_sectors when splitting abnormal io
> 
> Given your use of 'writemostly' I'm inferring you're using lvm2's
> raid1 that uses MD raid1 code in terms of the dm-raid target.
> 
> Discards (more generic term for fstrim) are considered writes, so
> writemostly really shouldn't matter... but I know that there have been
> issues with MD's writemostly code (identified by others relatively
> recently).
> 
> All said: hopefully someone more MD oriented can review your report
> and help you further.
> 
> Mike  

I've reported that write-mostly TRIM gets split into 1MB pieces, which can be
an order of magnitude slower on some SSDs: https://www.spinics.net/lists/raid/msg72471.html

Nobody cared to reply, investigate or fix.

Maybe your system hasn't frozen too, just taking its time in processing all
the tiny split requests.

-- 
With respect,
Roman

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

