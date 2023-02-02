Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455BFC61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675363156;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4rrdG+j/4FjTW16TTDtZuiHlAi68ZikP9RyBcLGoc8I=;
	b=goJk8lTZVZvrHgsQZKOuTSRNuHz8XJSb2JpG5zPuphmaFT/rn3/dNSAJDUoAfI6pZi7uxG
	LqzRqXYTDOSKJnVvVh78YPygygK15EGbDvP3WzCz5CSbJY3gTd5yBrPcp7KAMzXKGxy8l4
	MHm+nlz3TjMkaDFfWrZGEY28PE1U1tI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-qgda7vNENI6OeleUsnsfwQ-1; Thu, 02 Feb 2023 13:39:14 -0500
X-MC-Unique: qgda7vNENI6OeleUsnsfwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1349D1C05B0C;
	Thu,  2 Feb 2023 18:39:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A30122026D76;
	Thu,  2 Feb 2023 18:39:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B208194658C;
	Thu,  2 Feb 2023 18:39:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 700851946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 18:39:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DFDF951FF; Thu,  2 Feb 2023 18:39:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7B8051E5
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:39:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B629C857F40
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:39:09 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-52e2JJ5ZPYWGAnhA6OQ05g-1; Thu, 02 Feb 2023 13:39:08 -0500
X-MC-Unique: 52e2JJ5ZPYWGAnhA6OQ05g-1
Received: by mail-pl1-f182.google.com with SMTP id m2so2789379plg.4;
 Thu, 02 Feb 2023 10:39:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=44Tbffij6x8u6hWa9nzBypn4C/WCHwZ/yEGRnTnWNXY=;
 b=1ma/cFgEmn+ioh7NirxorT3JmLePdWOojHLP4okxekaA/tV/87Z6qF7jBG4IHaY+ws
 Fe6XgxEtirM2RXX32Nd+5jTXJgSgF9rccenrzPzSE/th59xk3TBhwnIEEug3tVqb0E9W
 wwQhgs1+zTxkPu7sxHdI+HOyNKQef4gjmWas0UhjEScNCHeeNqfiIA3ouhHqOlvaeIDG
 Ynu6dsyMiLq5zdZTYNXQOyO/Aiz1DcohB2+AkpFMnDWQu1Ja64VIGnwj855/zdtIWHqn
 0JjeM7IQEqKUWWaXcfqJnNkRkQymFJVEsnHRS5fZ1dHcYpcACPvpKh19Y2O9uDH/d42J
 WoKw==
X-Gm-Message-State: AO0yUKWZAjTbk4t/h+3eK4x+GhBcSUeo6IKtmkY0+fS7huVbxNgE9Vfo
 9J9LdVONZklex/KGRQl0bHg=
X-Google-Smtp-Source: AK7set8fNbiiFYW7OdcSiJFzCCcd6PnkVskd+HRqyruGtnlqpt0Vn1V/D3WSUtrSKyM8at7NMHKKxw==
X-Received: by 2002:a17:902:c403:b0:196:6599:3538 with SMTP id
 k3-20020a170902c40300b0019665993538mr8710126plk.22.1675363146577; 
 Thu, 02 Feb 2023 10:39:06 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bf7f:37aa:6a01:bf09?
 ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
 by smtp.gmail.com with ESMTPSA id
 l2-20020a170902ec0200b00198a96c6b7csm4082247pld.305.2023.02.02.10.39.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Feb 2023 10:39:05 -0800 (PST)
Message-ID: <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
Date: Thu, 2 Feb 2023 10:39:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>,
 Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 dmaengine@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Vinod Koul <vkoul@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2/2/23 10:33, Randy Dunlap wrote:
> On 2/2/23 10:09, Jonathan Corbet wrote:
>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>>   [PATCH 7/9] Documentation: scsi: correct spelling
>>
>> I've left these for the SCSI folks for now.  Do we *really* want to be
>> fixing spelling in ChangeLog files from almost 20 years ago?
> 
> That's why I made it a separate patch -- so the SCSI folks can decide that...

How about removing the Documentation/scsi/ChangeLog.* files? I'm not 
sure these changelogs are still useful since these duplicate information 
that is already available in the output of git log ${driver_directory}.

Thanks,

Bart.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

