Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47663C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:46:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CE91660FC4
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE91660FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-jLscErM2NTq4-tjHsIu7ug-1; Mon, 01 Nov 2021 04:45:55 -0400
X-MC-Unique: jLscErM2NTq4-tjHsIu7ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F67018880AA;
	Mon,  1 Nov 2021 08:45:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 603745C1C5;
	Mon,  1 Nov 2021 08:45:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 341BB4EA2A;
	Mon,  1 Nov 2021 08:45:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19VDUMpR030538 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 31 Oct 2021 09:30:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7916B40CFD10; Sun, 31 Oct 2021 13:30:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7301140CFD0F
	for <dm-devel@redhat.com>; Sun, 31 Oct 2021 13:30:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58AEC800883
	for <dm-devel@redhat.com>; Sun, 31 Oct 2021 13:30:22 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
	[209.85.221.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-151-QqttKZtANt6V3sEy1nxM_Q-1; Sun, 31 Oct 2021 09:30:20 -0400
X-MC-Unique: QqttKZtANt6V3sEy1nxM_Q-1
Received: by mail-wr1-f49.google.com with SMTP id m22so24352594wrb.0;
	Sun, 31 Oct 2021 06:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=h+YIJYU/CGpYORXj2rCNOHj6NcB2hgHRFq3Y9666r90=;
	b=GXiXdPv/pOwi4J1yGuoWA/ZMXE3rkCi0TqPlZW5i0njuItya9e3Rw1tqUeI0zULAbp
	ep/CmUuxnpPhqb5EJpQ70Iwwm+MZJ85Kwl3U89Ynz/E0WeaqCplZuKGHqdEl4M5lsDxR
	6+ZjilfwhXL90X/zC1aE0tMjKKuaeV+q5087mybNDkoIfY9S7o7MQ67ZhWG9+kjVgyYu
	pQBSS31lfDIdnaG3ZXlC852LF1Ku7sjSY5NxuTfIEfRzzaIR3crnxv+gyzqI2vdeUQKA
	koX2+8t+kOrFqUTCCl4mTLRIa29SHxdnItJHmJtVpiaXQ9luUVjvied8/8bZJ/JFoMy1
	27lQ==
X-Gm-Message-State: AOAM532yMdwX8FOcndDtA78na/F++gzBri+Wd6thoBU+e6ntG/bjGNUC
	/TjXrOrsHeius/cU8dy7D5NBdevSgNY=
X-Google-Smtp-Source: ABdhPJyMAWA1Sez2ro/vxgbmSjihRwHdwamFfBYiCrFoLhmm0D7ZUE8z8CTE6ZXwZnPzfddj0lZYow==
X-Received: by 2002:a5d:5287:: with SMTP id c7mr31452951wrv.236.1635687018879; 
	Sun, 31 Oct 2021 06:30:18 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.29])
	by smtp.gmail.com with ESMTPSA id n9sm10326016wmq.6.2021.10.31.06.30.17
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 31 Oct 2021 06:30:18 -0700 (PDT)
Message-ID: <5f295bd5-8440-267e-f2e8-01572eddbbd6@gmail.com>
Date: Sun, 31 Oct 2021 13:27:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: "Darrick J. Wong" <djwong@kernel.org>
References: <YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<20211028225955.GA449541@dread.disaster.area>
	<22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
	<20211029165747.GC2237511@magnolia>
	<f3e14569-a399-f6da-fd3e-993b579eaf74@gmail.com>
	<20211029200857.GD2237511@magnolia>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029200857.GD2237511@magnolia>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 01 Nov 2021 04:45:25 -0400
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/29/21 21:08, Darrick J. Wong wrote:
> On Fri, Oct 29, 2021 at 08:23:53PM +0100, Pavel Begunkov wrote:
>> On 10/29/21 17:57, Darrick J. Wong wrote:
>>> On Fri, Oct 29, 2021 at 12:46:14PM +0100, Pavel Begunkov wrote:
>>>> On 10/28/21 23:59, Dave Chinner wrote:
>>>> [...]
>>>>>>> Well, my point is doing recovery from bit errors is by definition not
>>>>>>> the fast path.  Which is why I'd rather keep it away from the pmem
>>>>>>> read/write fast path, which also happens to be the (much more important)
>>>>>>> non-pmem read/write path.
>>>>>>
>>>>>> The trouble is, we really /do/ want to be able to (re)write the failed
>>>>>> area, and we probably want to try to read whatever we can.  Those are
>>>>>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>>>>>> and I arrived at a month ago.
>>>>>>
>>>>>> Unless you'd be ok with a second IO path for recovery where we're
>>>>>> allowed to be slow?  That would probably have the same user interface
>>>>>> flag, just a different path into the pmem driver.
>>>>>
>>>>> I just don't see how 4 single line branches to propage RWF_RECOVERY
>>>>> down to the hardware is in any way an imposition on the fast path.
>>>>> It's no different for passing RWF_HIPRI down to the hardware *in the
>>>>> fast path* so that the IO runs the hardware in polling mode because
>>>>> it's faster for some hardware.
>>>>
>>>> Not particularly about this flag, but it is expensive. Surely looks
>>>> cheap when it's just one feature, but there are dozens of them with
>>>> limited applicability, default config kernels are already sluggish
>>>> when it comes to really fast devices and it's not getting better.
>>>> Also, pretty often every of them will add a bunch of extra checks
>>>> to fix something of whatever it would be.
>>>
>>> So we can't have data recovery because moving fast the only goal?
>>
>> That's not what was said and you missed the point, which was in
>> the rest of the message.
> 
> ...whatever point you were trying to make was so vague that it was
> totally uninformative and I completely missed it.
> 
> What does "callbacks or bit masks" mean, then, specifically?  How
> *exactly* would you solve the problem that Jane is seeking to solve by
> using callbacks?
> 
> Actually, you know what?  I'm so fed up with every single DAX
> conversation turning into a ****storm of people saying NO NO NO NO NO NO
> NO NO to everything proposed that I'm actually going to respond to
> whatever I think your point is, and you can defend whatever I come up
> with.

Interesting, I don't want to break it to you but nobody is going to
defend against yours made up out of thin air interpretations. I think
there is one thing we can relate, I wonder as well what the bloody
hell that opus of yours was


> 
>>>
>>> That's so meta.
>>>
>>> --D
>>>
>>>> So let's add a bit of pragmatism to the picture, if there is just one
>>>> user of a feature but it adds overhead for millions of machines that
>>>> won't ever use it, it's expensive.
> 
> Errors are infrequent, and since everything is cloud-based and disposble
> now, we can replace error handling with BUG_ON().  This will reduce code
> complexity, which will reduce code size, and improve icache usage.  Win!
> 
>>>> This one doesn't spill yet into paths I care about,
> 
> ...so you sail in and say 'no' even though you don't yet care...
> 
>>>> but in general
>>>> it'd be great if we start thinking more about such stuff instead of
>>>> throwing yet another if into the path, e.g. by shifting the overhead
>>>> from linear to a constant for cases that don't use it, for instance
>>>> with callbacks
> 
> Ok so after userspace calls into pread to access a DAX file, hits the
> poisoned memory line and the machinecheck fires, what then?  I guess we
> just have to figure out how to get from the MCA handler (assuming the
> machine doesn't just reboot instantly) all the way back into memcpy?
> Ok, you're in charge of figuring that out because I don't know how to do
> that.
> 
> Notably, RWF_DATA_RECOVERY is the flag that we're calling *from* a
> callback that happens after memory controller realizes it's lost
> something, kicks a notification to the OS kernel through ACPI, and the
> kernel signal userspace to do something about it.  Yeah, that's dumb
> since spinning rust already does all this for us, but that's pmem.
> 
>>>> or bit masks.
> 
> WTF does this even mean?
> 
> --D
> 
>>>>
>>>>> IOWs, saying that we shouldn't implement RWF_RECOVERY because it
>>>>> adds a handful of branches 	 the fast path is like saying that we
>>>>> shouldn't implement RWF_HIPRI because it slows down the fast path
>>>>> for non-polled IO....
>>>>>
>>>>> Just factor the actual recovery operations out into a separate
>>>>> function like:

-- 
Pavel Begunkov

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

