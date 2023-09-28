Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B4BCE7B05
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 08:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695889111;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dZjor0OBppk2+4wbyPPFGOxqEUraA/kxKmbCRBk6g4M=;
	b=LmTFRl6xT1ijvLZYNxg97c2CbQNM+gHKDQDcvOtX7cDAzW/rj60ZOOa9uJwhFbpgFX8oF/
	A1BNqsdYYRVkwQoeePr/TE5mktWhKU//DgeU5KXhUesJ+3Y0aumMRBC9dC9Z6nOaksqytr
	3hs6Qf62vQOyn22C03QeRKiHAni1j5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-S2jvZ7P7MBKP_baCYorTfw-1; Thu, 28 Sep 2023 04:18:28 -0400
X-MC-Unique: S2jvZ7P7MBKP_baCYorTfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D38C7101B045;
	Thu, 28 Sep 2023 08:18:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A05AF2026D4B;
	Thu, 28 Sep 2023 08:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 360C0194658D;
	Thu, 28 Sep 2023 08:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4091F1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 07:50:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F7A2215670B; Thu, 28 Sep 2023 07:50:08 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B67B32156702;
 Thu, 28 Sep 2023 07:50:07 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id A104730C1C0A; Thu, 28 Sep 2023 07:50:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 981B63FD4B; Thu, 28 Sep 2023 09:50:07 +0200 (CEST)
Date: Thu, 28 Sep 2023 09:50:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3c25ec6f-cd33-9445-a76f-6ec2c30755f5@redhat.com>
Message-ID: <86e7f97a-ac6b-873d-93b2-1121a464989a@redhat.com>
References: <20230315113133.11326-1-kirill.shutemov@linux.intel.com>
 <3c25ec6f-cd33-9445-a76f-6ec2c30755f5@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 00/10] Fix confusion around MAX_ORDER
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
Cc: linux-arch@vger.kernel.org, quic_jhugo@quicinc.com,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm <dm-devel@redhat.com>,
 Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 27 Sep 2023, Paolo Bonzini wrote:

> On 3/15/23 12:31, Kirill A. Shutemov wrote:
> > MAX_ORDER currently defined as number of orders page allocator supports:
> > user can ask buddy allocator for page order between 0 and MAX_ORDER-1.
> > 
> > This definition is counter-intuitive and lead to number of bugs all over
> > the kernel.
> > 
> > Fix the bugs and then change the definition of MAX_ORDER to be
> > inclusive: the range of orders user can ask from buddy allocator is
> > 0..MAX_ORDER now.

I think that exclusive MAX_ORDER is more intuitive in the C language - 
i.e. if you write "for (i = 0; i < MAX_ORDER; i++)", you are supposed to 
loop over all allowed values. If you declare an array "void 
*array[MAX_ORDER];" you are supposed to hold a value for each allowed 
order.

Pascal has for loops and array dimensions with inclusive ranges - and it 
is more prone to off-by-one errors.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

