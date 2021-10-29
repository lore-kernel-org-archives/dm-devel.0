Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF1FC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F98660F58
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1F98660F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-jpfGLfh-PO-UuBROwMM2hA-1; Mon, 01 Nov 2021 04:45:52 -0400
X-MC-Unique: jpfGLfh-PO-UuBROwMM2hA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C803680A5C3;
	Mon,  1 Nov 2021 08:45:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD13E5DAA5;
	Mon,  1 Nov 2021 08:45:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8196B180BAD2;
	Mon,  1 Nov 2021 08:45:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TJP6XM009054 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 15:25:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 600692144B23; Fri, 29 Oct 2021 19:25:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AC552144B22
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 19:25:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D6E31066559
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 19:25:03 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
	[209.85.221.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-195-xWEIbuAoOEmqBIXURKIn2g-1; Fri, 29 Oct 2021 15:25:01 -0400
X-MC-Unique: xWEIbuAoOEmqBIXURKIn2g-1
Received: by mail-wr1-f50.google.com with SMTP id d13so18025125wrf.11;
	Fri, 29 Oct 2021 12:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=Tvo7OsKnZiYhW/CIzL+toK1Ob0iQFZhcf7j3OyPg3VI=;
	b=17i0M6LmhCR55PiYvTqDbD5TBFDqSy2RWD+vLoZ9ISTcPuBW4D7lUFPFGH1KU6lKtN
	dUwb0SNc7VkWQr7b2mZQLOtnB/h8XKwQtUrTNi3Gbn8MC0CV2uMfc5yBSjj+EulrjKd5
	CZr8Mvjy32Heak6sbI33inzIIujwjU55GDBc/5baWLYYmboIXTtsKsStZaAMnSkoWDiw
	Z8zDldf0e68NxU4ObFZCTiRYzzWablm6EQxPiCn+gEakHWkhrfoqmWVwue704OnCZSN9
	LxZ1sg9Wr/eKjL5xmGI9HY+aL04oi4iEQQ3QKL5vBVfntuu362/f0RPEqPSz+g0cAndk
	lDRw==
X-Gm-Message-State: AOAM530PS2/IQduX02KqO1HeBMN2SecOJx9DsQnx+ypgNT3jiLC0EHqk
	EErvb2yYoIjZHVnuoJJOfvQ=
X-Google-Smtp-Source: ABdhPJwJT6TiYb3/JIfjJ6JLlOKjZCQT2hYhBeN/ZIZiycBjCWzDjHwZ0BUCh015OF6O6jcWdT+TvA==
X-Received: by 2002:a5d:6da7:: with SMTP id u7mr16031755wrs.322.1635535499887; 
	Fri, 29 Oct 2021 12:24:59 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
	by smtp.gmail.com with ESMTPSA id
	j20sm5407595wmp.27.2021.10.29.12.24.58
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 29 Oct 2021 12:24:59 -0700 (PDT)
Message-ID: <f3e14569-a399-f6da-fd3e-993b579eaf74@gmail.com>
Date: Fri, 29 Oct 2021 20:23:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: "Darrick J. Wong" <djwong@kernel.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<20211028225955.GA449541@dread.disaster.area>
	<22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
	<20211029165747.GC2237511@magnolia>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029165747.GC2237511@magnolia>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/29/21 17:57, Darrick J. Wong wrote:
> On Fri, Oct 29, 2021 at 12:46:14PM +0100, Pavel Begunkov wrote:
>> On 10/28/21 23:59, Dave Chinner wrote:
>> [...]
>>>>> Well, my point is doing recovery from bit errors is by definition not
>>>>> the fast path.  Which is why I'd rather keep it away from the pmem
>>>>> read/write fast path, which also happens to be the (much more important)
>>>>> non-pmem read/write path.
>>>>
>>>> The trouble is, we really /do/ want to be able to (re)write the failed
>>>> area, and we probably want to try to read whatever we can.  Those are
>>>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>>>> and I arrived at a month ago.
>>>>
>>>> Unless you'd be ok with a second IO path for recovery where we're
>>>> allowed to be slow?  That would probably have the same user interface
>>>> flag, just a different path into the pmem driver.
>>>
>>> I just don't see how 4 single line branches to propage RWF_RECOVERY
>>> down to the hardware is in any way an imposition on the fast path.
>>> It's no different for passing RWF_HIPRI down to the hardware *in the
>>> fast path* so that the IO runs the hardware in polling mode because
>>> it's faster for some hardware.
>>
>> Not particularly about this flag, but it is expensive. Surely looks
>> cheap when it's just one feature, but there are dozens of them with
>> limited applicability, default config kernels are already sluggish
>> when it comes to really fast devices and it's not getting better.
>> Also, pretty often every of them will add a bunch of extra checks
>> to fix something of whatever it would be.
> 
> So we can't have data recovery because moving fast the only goal?

That's not what was said and you missed the point, which was in
the rest of the message.

> 
> That's so meta.
> 
> --D
> 
>> So let's add a bit of pragmatism to the picture, if there is just one
>> user of a feature but it adds overhead for millions of machines that
>> won't ever use it, it's expensive.
>>
>> This one doesn't spill yet into paths I care about, but in general
>> it'd be great if we start thinking more about such stuff instead of
>> throwing yet another if into the path, e.g. by shifting the overhead
>> from linear to a constant for cases that don't use it, for instance
>> with callbacks or bit masks.
>>
>>> IOWs, saying that we shouldn't implement RWF_RECOVERY because it
>>> adds a handful of branches 	 the fast path is like saying that we
>>> shouldn't implement RWF_HIPRI because it slows down the fast path
>>> for non-polled IO....
>>>
>>> Just factor the actual recovery operations out into a separate
>>> function like:
>>
>> -- 
>> Pavel Begunkov

-- 
Pavel Begunkov

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

