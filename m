Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73140C7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 13:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685971864;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iD1+xH5hmLSdy83rzN/AD6ciYFJCtDLyJm1FirpT3fk=;
	b=L08YqcFeBO39J5fEdePTctaOXVkC6tuXldewYyNb9RyCYwWanlBWYEnd1tqGk/nbGob6Zm
	v/ttDT9vYI9EiwU7POlO/EIVBCsg3Y6atHCbcNVWjTHP2SU1S5L5fhF0UL2AE56/rPtQmM
	aQ+EECnPqyWrPCe/KtDPIjFom1ZzAbM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-ABD-8zwXNKWSfRUSBPw65Q-1; Mon, 05 Jun 2023 09:31:00 -0400
X-MC-Unique: ABD-8zwXNKWSfRUSBPw65Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9F87185A791;
	Mon,  5 Jun 2023 13:30:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DBC072166B25;
	Mon,  5 Jun 2023 13:30:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A469219465A2;
	Mon,  5 Jun 2023 13:30:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76BAE1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 13:30:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0CEAE9E72; Mon,  5 Jun 2023 13:30:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0528A9E90
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 13:30:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD7D83C025B9
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 13:30:39 +0000 (UTC)
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-p_yktfG6OFKdjOPXU2qpRQ-1; Mon, 05 Jun 2023 09:30:35 -0400
X-MC-Unique: p_yktfG6OFKdjOPXU2qpRQ-1
Received: from localhost (mdns.lwn.net [45.79.72.68])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ms.lwn.net (Postfix) with ESMTPSA id 01E27736;
 Mon,  5 Jun 2023 13:23:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 01E27736
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Russell Harmon <eatnumber1@gmail.com>
In-Reply-To: <ZH1TmkyVJbIlNUEE@debian.me>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-4-eatnumber1@gmail.com> <ZH1TmkyVJbIlNUEE@debian.me>
Date: Mon, 05 Jun 2023 07:23:34 -0600
Message-ID: <875y82yre1.fsf@meer.lwn.net>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3 3/4] Document dm-integrity default values.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lwn.net
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> On Sun, Jun 04, 2023 at 12:06:03PM -0700, Russell Harmon wrote:
>> Specifically:
>>   interleave_sectors = 32768
>>   buffer_sectors = 128
>>   block_size = 512
>>   journal_watermark = 50
>>   commit_time = 10000
>
> Your patch description duplicates the diff content below. Please write
> in a mood that evocates curiosity to read the diff (and make sure it is
> also imperative).

Bagas, this is a typo-fix patch.  It does not need to be nitpicked into
the ground.

Russell, Bagas is inadvertently teaching you another lesson about the
kernel development community; it includes a certain number of people who
like to push contributors around with authoritative-sounding messages.
These people do not always need to be listened to.

Thanks,

jon

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

