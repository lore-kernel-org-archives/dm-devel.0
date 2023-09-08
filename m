Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D86EEE7FE1
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694175188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0wYkuydh2U+ve5aUWsj6wZJJ/DOJLXX9B5cTsNFmQdM=;
	b=FVzDcbmWTnWJ1lAkmEQTgsywhEt7c6MAC4PMdZW6nTVoDQu0MrNa4q7OhY0Ahy9fgNVipd
	H+wj3vdV0H5TyExkuRUTLHyVhsfL0u/3FSJ4BctLBjIsBcfs+dm1FM560JJ7ULi60VAwNi
	GewKxzLl/mbrgGLcx3jXqK0xZSmzqcM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-nHbNLM3nOX6B_ppvDfmUlA-1; Fri, 08 Sep 2023 08:13:05 -0400
X-MC-Unique: nHbNLM3nOX6B_ppvDfmUlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D7FF9176EA;
	Fri,  8 Sep 2023 12:13:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4B2D83B9B;
	Fri,  8 Sep 2023 12:13:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B0AA194658F;
	Fri,  8 Sep 2023 12:13:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 12EEA194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 12:12:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD34B40C6CCC; Fri,  8 Sep 2023 12:12:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B629A412F2CE
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:12:59 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9899B1817929
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:12:59 +0000 (UTC)
Received: from ciao.gmane.io (ciao.gmane.io [116.202.254.214]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-297-9-W-LFu2MGOtMlrI3Cg0Hg-1; Fri,
 08 Sep 2023 08:12:58 -0400
X-MC-Unique: 9-W-LFu2MGOtMlrI3Cg0Hg-1
Received: from list by ciao.gmane.io with local (Exim 4.92)
 (envelope-from <glkdd-dm-devel@m.gmane-mx.org>) id 1qeaH6-0000Cr-IV
 for dm-devel@redhat.com; Fri, 08 Sep 2023 14:07:48 +0200
X-Injected-Via-Gmane: http://gmane.org/
To: dm-devel@redhat.com
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date: Fri, 8 Sep 2023 14:07:40 +0200
Message-ID: <4a0952f8-32b1-46fc-a9f2-4be58ee41ace@gmail.com>
References: <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
 <20230908073244.wyriwwxahd3im2rw@quack3>
 <86235d7a-a7ea-49da-968e-c5810cbf4a7b@redhat.com>
 <20230908102014.xgtcf5wth2l2cwup@quack3>
 <15c62097-d58f-4e66-bdf5-e0edb1306b2f@redhat.com>
 <20230908-bergwacht-bannen-1855c8afe518@brauner>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
In-Reply-To: <20230908-bergwacht-bannen-1855c8afe518@brauner>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] fix writing to the filesystem after unmount
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
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US, cs
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Message-ID: <20230908120740.6maqekIrb-E51XA5MrNk8QvzxRwkFFGG93hNsFPb0yA@z>

Dne 08. 09. 23 v 13:32 Christian Brauner napsal(a):
>> I'd say there are several options and we should aim towards the variant
>> which is most usable by normal users.
> 
> None of the options is sufficiently satisfying to risk intricate
> behavioral changes with unknown consequences for existing workloads as
> far as I'm concerned.
> 

I'm not convinced anyone has the 'fsfreeze' + 'unmount' as a regular workload. 
  Thus solving this unusual race case shouldn't be breaking anyones else 
existing workload.

ATM there is no good solution for this particular case.

So can you please elaborate which new risks are we going to introduce by 
fixing this resource hole ?


Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

