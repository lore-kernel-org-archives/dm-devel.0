Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1264FEC8748
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 12:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694174874;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0wYkuydh2U+ve5aUWsj6wZJJ/DOJLXX9B5cTsNFmQdM=;
	b=SsgMa6OV7jWq+FCxhpmD9AnoFf2pcNVBfYNsYv0wqWR8ihiEPe5EqeKQ8zUwWpH147kFBd
	B9tuswQQ2wqe5M7u0KNfjTmbjVQ0wYzhL9noa0iHiudBcUyjqo8no0jwMkXrI2fNgORY1b
	hjuyoVNtc+X0xA+AIr6xIx1EPgyib1w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-RTPRso5eMJeTIRP_crSliQ-1; Fri, 08 Sep 2023 08:07:50 -0400
X-MC-Unique: RTPRso5eMJeTIRP_crSliQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B5BF1817930;
	Fri,  8 Sep 2023 12:07:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9FE340ED780;
	Fri,  8 Sep 2023 12:07:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96EB4194658F;
	Fri,  8 Sep 2023 12:07:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 44024194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 12:07:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 30630493112; Fri,  8 Sep 2023 12:07:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2873C493110
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:07:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 081DF8E7460
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 12:07:46 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-6kEUzhmUPdeOTI7ASphmxw-1; Fri, 08 Sep 2023 08:07:44 -0400
X-MC-Unique: 6kEUzhmUPdeOTI7ASphmxw-1
Received: by mail-wm1-f48.google.com with SMTP id
 5b1f17b1804b1-400a087b0bfso20892675e9.2; 
 Fri, 08 Sep 2023 05:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694174862; x=1694779662;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:newsgroups:cc:to:subject:user-agent:mime-version:date
 :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=c0BAeFuaE3UP1EYT6gPTFY3nFreECTYzpkSaiTl/irI=;
 b=VnQNFip/eCbdvEdXbtZJoAhr872TYZuGJvPD+CEna04nRjibVUg3ilJGd5tXCkxTP0
 +OFZJA/EcQENNQ5hGdqj6ig9Y96tiGqs1se0QY/xmuVu0/t3fBPIQ4EGBN0RA4WEDgR7
 0WwWxDE53utpNV8axL7YvQ5eQWwCOx/tZ1LOQUc4uz+C0/bnb3Yb3vnOYH3zna5VVb/p
 Rv7wh8HprVZqFHgQxZ8kNwgSiJ8sxlbqTe+rHzdiW0G8JnSHi3UQci1TX5FrXp0FIb3R
 0PBmmyAhOT/EF++1dr0bqJ6+sFjHf/TdNetV9uzu9doJyA3NyTUWtAkp6PSF0YcBXET3
 J1vg==
X-Gm-Message-State: AOJu0YygS0dmMnn4INtpVnQet8u4lt7bmExeNMvUHBOGvJBfMjTSDy1N
 7FCosgYv3Ht8oItNCxFwVXnAG9Vn0nkJuZ5r
X-Google-Smtp-Source: AGHT+IGFPze7uqlGuOkxsqG+tOAOEeIw5h1YgkB0yA7TBv3BViY4t1LSgTZsQfXKgp2HC1PCvJ8dQg==
X-Received: by 2002:a1c:7707:0:b0:401:5443:55a1 with SMTP id
 t7-20020a1c7707000000b00401544355a1mr1913379wmi.3.1694174862320; 
 Fri, 08 Sep 2023 05:07:42 -0700 (PDT)
Received: from [10.43.17.103] (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id
 n8-20020a7bcbc8000000b003fe29f6b61bsm1816111wmi.46.2023.09.08.05.07.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 08 Sep 2023 05:07:41 -0700 (PDT)
Message-ID: <4a0952f8-32b1-46fc-a9f2-4be58ee41ace@gmail.com>
Date: Fri, 8 Sep 2023 14:07:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Christian Brauner <brauner@kernel.org>,
 Zdenek Kabelac <zkabelac@redhat.com>
Newsgroups: gmane.linux.file-systems, gmane.linux.kernel,
 gmane.linux.kernel.device-mapper.devel
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
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <20230908-bergwacht-bannen-1855c8afe518@brauner>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US, cs
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

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

