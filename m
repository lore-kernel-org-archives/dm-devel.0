Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB10C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 07:53:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-0vDBx1ZuMKiYhjhiNb9i6A-1; Mon, 09 May 2022 03:53:30 -0400
X-MC-Unique: 0vDBx1ZuMKiYhjhiNb9i6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A212186B8A2;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16731400E899;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39F3C1947062;
	Mon,  9 May 2022 07:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 56E711947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 20:22:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DEEB40CF917; Fri,  6 May 2022 20:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 090F440CF8E8
 for <dm-devel@redhat.com>; Fri,  6 May 2022 20:22:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E557E8002B2
 for <dm-devel@redhat.com>; Fri,  6 May 2022 20:22:13 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-654-BG4BRDIROqKE6mPgo6sdmw-1; Fri,
 06 May 2022 16:22:03 -0400
X-MC-Unique: BG4BRDIROqKE6mPgo6sdmw-1
Received: from [10.137.112.111] (unknown [131.107.147.111])
 by linux.microsoft.com (Postfix) with ESMTPSA id 44E9C20EB6C4;
 Fri,  6 May 2022 13:16:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 44E9C20EB6C4
Message-ID: <9fefc681-c8dd-0312-2d6b-ffe3fec05dcf@linux.microsoft.com>
Date: Fri, 6 May 2022 13:16:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Thore Sommer <public@thson.de>, dm-devel@redhat.com, agk@redhat.com,
 snitzer@redhat.com
References: <20220106203436.281629-1-public@thson.de>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
In-Reply-To: <20220106203436.281629-1-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Mon, 09 May 2022 07:53:25 +0000
Subject: Re: [dm-devel] [RFC PATCH 0/3] dm ima: allow targets to remeasure
 their state
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
Cc: tusharsu@linux.microsoft.com, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Thore,

On 1/6/2022 12:34 PM, Thore Sommer wrote:
> The current DM IMA events do not cover the case where a device changes
> their attributes to indicate a state change. 
It would be good to state here what issue(s) are caused, if any, or what 
data\event we might be missing as a result of not measuring the device 
attribute changes. And, then state the benefits of the changes you have 
implemented in this patch series.

This adds a new event
> (dm_target_update) which allows targets to remeasure their table entries.
> The event includes the dm version, device metadata and the target data.
> 
> Currently only verity supports this event to ensure that device corruption
> can be detected using IMA which is useful for remote attestation.
Using the term "currently" in this context seems to indicate that this 
is the current state (existing behavior) in the Linux kernel 
implementation. You could instead reword it to indicate that your 
proposed measurement change is used by verity to add support for 
detecting device corruption.

> 
> The current implementation does not update the active table hash because
> it would require to rehash the entire table on every target change.
Similar to the above comment - could be reworded to indicate this is the 
proposed change and not the existing behavior.

thanks,
  -lakshmi

> 
> Thore Sommer (3):
>    dm ima: allow targets to remeasure their table entry
>    dm verity: add support for IMA target update event
>    dm ima: add documentation target update event
> 
>   .../admin-guide/device-mapper/dm-ima.rst      | 33 ++++++++
>   drivers/md/dm-ima.c                           | 76 +++++++++++++++++++
>   drivers/md/dm-ima.h                           |  2 +
>   drivers/md/dm-verity-target.c                 |  6 ++
>   4 files changed, 117 insertions(+)
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

