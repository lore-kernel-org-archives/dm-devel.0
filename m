Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48126C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC43E60F36
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC43E60F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-qj0Vifm2Mw64mkXZv914SQ-1; Mon, 01 Nov 2021 04:45:34 -0400
X-MC-Unique: qj0Vifm2Mw64mkXZv914SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6201B18880A2;
	Mon,  1 Nov 2021 08:45:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BBFD19C59;
	Mon,  1 Nov 2021 08:45:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 036904E58F;
	Mon,  1 Nov 2021 08:45:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TBkx4U031493 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 07:46:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 55E4F2026D67; Fri, 29 Oct 2021 11:46:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 500712026D5D
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 11:46:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EFB0899EC4
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 11:46:47 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
	[209.85.221.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-264-C9hF0i90Nx6TfEIk_gOypg-1; Fri, 29 Oct 2021 07:46:38 -0400
X-MC-Unique: C9hF0i90Nx6TfEIk_gOypg-1
Received: by mail-wr1-f46.google.com with SMTP id u18so15780826wrg.5;
	Fri, 29 Oct 2021 04:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=4USXpy4HYDd4725dd4VPkkRl2D3ibOF+yr4vsPBEkE8=;
	b=heWdaXhRDaznox8F6dh/MWeStbXb2KU+zUdAXJSW/4F9TAU1YOV2PmOvQJhBVfX1zw
	8CSAo6MEdavL3sEEF5wzdzMyYuKXZMxYD67l144TzXE93mkC1HUIDPsZF6tCQBTjZmiu
	0rZ2a10PwiB0MiYZ/hVzHJSNSzjt9uLwK0PGMOs4Gj20Ho1avUb2BiniN/G6PlXpgVtq
	NBH41gcnSl67zK7+EWZABF2KHAwNwBr1ADWFrTLUaYccGhR07o61dlbllSIbG1H1Muv8
	xpxt3Gpk3PU58qtx7mZlowaz3JbKVczs5/x4wbFa3LJjSPvD8sD3ErNDtRFrpUg+t2jc
	kcMQ==
X-Gm-Message-State: AOAM531mMBTc+Lw0aLJMkjQJAItKVUSqObBRn0QplvWqiiOebW6Gx6KL
	V4b41eHKNqjFULbEBLt3TqI=
X-Google-Smtp-Source: ABdhPJzTlT2UpuaMBC4cfEXRAY32D5GvOd2OdG1plI8jXT/MbOD36lk+nBoDgi4LlwWwjWLI0IcMbA==
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr13567924wrb.336.1635507996210; 
	Fri, 29 Oct 2021 04:46:36 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
	by smtp.gmail.com with ESMTPSA id s3sm8421482wmh.30.2021.10.29.04.46.35
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 29 Oct 2021 04:46:35 -0700 (PDT)
Message-ID: <22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
Date: Fri, 29 Oct 2021 12:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<20211028225955.GA449541@dread.disaster.area>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211028225955.GA449541@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 01 Nov 2021 04:45:25 -0400
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/28/21 23:59, Dave Chinner wrote:
[...]
>>> Well, my point is doing recovery from bit errors is by definition not
>>> the fast path.  Which is why I'd rather keep it away from the pmem
>>> read/write fast path, which also happens to be the (much more important)
>>> non-pmem read/write path.
>>
>> The trouble is, we really /do/ want to be able to (re)write the failed
>> area, and we probably want to try to read whatever we can.  Those are
>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>> and I arrived at a month ago.
>>
>> Unless you'd be ok with a second IO path for recovery where we're
>> allowed to be slow?  That would probably have the same user interface
>> flag, just a different path into the pmem driver.
> 
> I just don't see how 4 single line branches to propage RWF_RECOVERY
> down to the hardware is in any way an imposition on the fast path.
> It's no different for passing RWF_HIPRI down to the hardware *in the
> fast path* so that the IO runs the hardware in polling mode because
> it's faster for some hardware.

Not particularly about this flag, but it is expensive. Surely looks
cheap when it's just one feature, but there are dozens of them with
limited applicability, default config kernels are already sluggish
when it comes to really fast devices and it's not getting better.
Also, pretty often every of them will add a bunch of extra checks
to fix something of whatever it would be.

So let's add a bit of pragmatism to the picture, if there is just one
user of a feature but it adds overhead for millions of machines that
won't ever use it, it's expensive.

This one doesn't spill yet into paths I care about, but in general
it'd be great if we start thinking more about such stuff instead of
throwing yet another if into the path, e.g. by shifting the overhead
from linear to a constant for cases that don't use it, for instance
with callbacks or bit masks.

> IOWs, saying that we shouldn't implement RWF_RECOVERY because it
> adds a handful of branches 	 the fast path is like saying that we
> shouldn't implement RWF_HIPRI because it slows down the fast path
> for non-polled IO....
> 
> Just factor the actual recovery operations out into a separate
> function like:

-- 
Pavel Begunkov

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

