Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 043ACC63709
	for <dm-devel@archiver.kernel.org>; Thu,  8 Dec 2022 02:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670468146;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dy7jZlFJA5S2CNmY8/bZltwezYWxl9eWzDsbVkIECKQ=;
	b=Nm1BMBvOznEnC1q8e5n01r/iT6rp9iKZY0QOygv6IyYErItN1GBQLOsT1SgmwJjeTBtoSL
	yILGvCA1ACR4Aq0F4XhqhurflsznTAr/9YmT4dihFNEvJOrt01gLSeFQ6QJXxf+5ojxOy9
	/zYt0xSaqjoRu9PjGD38l6HR47jWFNw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-C5inEaaIOUKwbNYBHvBmiw-1; Wed, 07 Dec 2022 21:55:43 -0500
X-MC-Unique: C5inEaaIOUKwbNYBHvBmiw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDF5E3C0CD50;
	Thu,  8 Dec 2022 02:55:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE391401C38;
	Thu,  8 Dec 2022 02:55:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 67ABA19465B9;
	Thu,  8 Dec 2022 02:55:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2792019465B1
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Dec 2022 02:55:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 146CB1401C30; Thu,  8 Dec 2022 02:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CD1C1401C37
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 02:55:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A13C1C068CC
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 02:55:36 +0000 (UTC)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-v-oC1Z2JMAeXSup4xAt5jA-1; Wed, 07 Dec 2022 21:55:34 -0500
X-MC-Unique: v-oC1Z2JMAeXSup4xAt5jA-1
Received: by mail-pg1-f172.google.com with SMTP id 6so131724pgm.6
 for <dm-devel@redhat.com>; Wed, 07 Dec 2022 18:55:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+YnwWLbC1k13FDuBmbkgFl4RERtAqz8Hk2l0zfW6u80=;
 b=PRzwd3uTFjx+2ygsuoATcTny/tjYwmrIuTBBy5lx+zD5cGpW0Mt3A0Hc1HMlGbBZCN
 AuqEcvAg6Xbtb9FtzAEDAdVtOOwMm05hQcbxCxbdLxX3nldKS60a1b623purJviPIATr
 +Evyk5J8MHgDMAvc2KVqfp/kPQj5bDHzCNUTVAdBdrXP8LQurGjPULdxDj+E78cDQ0EE
 LQ0KAKzt5sKzphAkXPAOovsy3yfhF/ck0oWgAYq5/kGqSJinhPHwoqUDrdSUhwfSUV2K
 MPaDg46s0C9MWKlNHXGuAlMZaDRiS7erLddvtp7r/ci03NJVEjPFEb3Ys7iNQdgE6PtR
 XorA==
X-Gm-Message-State: ANoB5pnrjgS5tQgdzm6iXzxpNAepB1jl68XjaG4971Q8jYM8zS3r2oxo
 aviv9+dfoKjoPK23tdhtqyatxQ==
X-Google-Smtp-Source: AA0mqf4GKdTwpvzKHdR+jWKD59yHhtQiQj6o4bMAawT3TKX0knE/TZzrpzeE/R5qCEqb2PjMIqK3qA==
X-Received: by 2002:a63:d151:0:b0:478:c28a:2f36 with SMTP id
 c17-20020a63d151000000b00478c28a2f36mr13058187pgj.182.1670468133285; 
 Wed, 07 Dec 2022 18:55:33 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 n13-20020a170903404d00b0016d773aae60sm15211981pla.19.2022.12.07.18.55.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 07 Dec 2022 18:55:32 -0800 (PST)
Message-ID: <4d118f20-9006-0af9-8d97-0d28d85a3585@kernel.dk>
Date: Wed, 7 Dec 2022 19:55:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Keith Busch <kbusch@kernel.org>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
 <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
 <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
 <Y5Exa1TV/2VLcEWR@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y5Exa1TV/2VLcEWR@kbusch-mbp>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [RFC for-6.2/block V2] block: Change the granularity
 of io ticks from ms to ns
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "song@kernel.org" <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
 "joe.jin@oracle.com" <joe.jin@oracle.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "ngupta@vflare.org" <ngupta@vflare.org>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 Gulam Mohamed <gulam.mohamed@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "colyli@suse.de" <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/7/22 5:35?PM, Keith Busch wrote:
> On Wed, Dec 07, 2022 at 11:17:12PM +0000, Chaitanya Kulkarni wrote:
>> On 12/7/22 15:08, Jens Axboe wrote:
>>>
>>> My default peak testing runs at 122M IOPS. That's also the peak IOPS of
>>> the devices combined, and with iostats disabled. If I enabled iostats,
>>> then the performance drops to 112M IOPS. It's no longer device limited,
>>> that's a drop of about 8.2%.
>>>
>>
>> Wow, clearly not acceptable that's exactly I asked for perf
>> numbers :).
> 
> For the record, we did say per-io ktime_get() has a measurable
> performance harm and should be aggregated.
> 
>   https://www.spinics.net/lists/linux-block/msg89937.html

Yes, I iterated that in the v1 posting as well, and mentioned it was the
reason the time batching was done. From the results I posted, if you
look at a profile of the run, here are the time related additions:

+   27.22%  io_uring  [kernel.vmlinux]  [k] read_tsc
+    4.37%  io_uring  [kernel.vmlinux]  [k] ktime_get

which are #1 and $4, respectively. That's a LOT of added overhead. Not
sure why people think time keeping is free, particularly high
granularity time keeping. It's definitely not, and adding 2-3 per IO is
very noticeable.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

