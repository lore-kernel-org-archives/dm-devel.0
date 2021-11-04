Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9B7C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 16:24:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 56E6D6121E
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 16:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 56E6D6121E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-8a7xvPGJN0CflF5c17C5Ig-1; Thu, 04 Nov 2021 12:24:38 -0400
X-MC-Unique: 8a7xvPGJN0CflF5c17C5Ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30F2A18414A1;
	Thu,  4 Nov 2021 16:24:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89C5F1B5B7;
	Thu,  4 Nov 2021 16:24:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DCBE1806D03;
	Thu,  4 Nov 2021 16:24:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4GOV5m026160 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 12:24:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 96EE32166B26; Thu,  4 Nov 2021 16:24:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A3B2166B25
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 16:24:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81FB5800883
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 16:24:28 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
	[209.85.214.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-476-tXe2F0YBOGiTtG_JHtqpZw-1; Thu, 04 Nov 2021 12:24:27 -0400
X-MC-Unique: tXe2F0YBOGiTtG_JHtqpZw-1
Received: by mail-pl1-f181.google.com with SMTP id v20so8061423plo.7
	for <dm-devel@redhat.com>; Thu, 04 Nov 2021 09:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=17E90qbU5W7/llxpq3Ci8EoglXdbUk5GXT8DWrgKv7g=;
	b=NEj7YyCfm3FjOovdmP4BOBquxB856X9mzZaUBTrTQgDG7Dyj68aYkyWClXTRPPy0WN
	KKlMMB8MH+ml/RLRe4kvDPPWwiTlpSqBirO2YNfBXAPkO/UZwZBAUIL2i/kBewLrZp8b
	unmW+Yzv19uzdYToRZIjb/GhmwS02nk/NE6B9yq2TY8Lt4dwLKdeisDVeNfFNGXgv6ci
	vRQZh9g2MtT/HV3SLauhobe5WZgc+UC+u/+1rJo+8FLeOE3FPI80jdxSafptJPgUo9BF
	JOhEzNlLA4y2w8KY6nDrxUKALbY/ISYb9KuPel2BzH6eibHU6SgfpkWXxTldf9SjSpFO
	Cgjg==
X-Gm-Message-State: AOAM5321RkOVdoX7lF0JVCIKHxtTWKV0T+WQllglnRAczt5uTPzwscj0
	CBDCFM8Dt9EBn+tGizhUwg5kP5TIaiidRMd61tM2AA==
X-Google-Smtp-Source: ABdhPJz79hh1l18OCSZbTUbHDcomJJsoh+bGEXb1lR6JlCXHe3pvv2Bi88QyyGqo6h13ZG3HRQJzFRzDQ7aERKx7/AU=
X-Received: by 2002:a17:90a:6c47:: with SMTP id
	x65mr6908694pjj.8.1636043065868; 
	Thu, 04 Nov 2021 09:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
	<YYK/tGfpG0CnVIO4@infradead.org>
	<CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
	<YYOaOBKgFQYzT/s/@infradead.org>
In-Reply-To: <YYOaOBKgFQYzT/s/@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 09:24:15 -0700
Message-ID: <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
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
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 4, 2021 at 1:30 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Nov 03, 2021 at 01:33:58PM -0700, Dan Williams wrote:
> > Is the exception table requirement not already fulfilled by:
> >
> > sigaction(SIGBUS, &act, 0);
> > ...
> > if (sigsetjmp(sj_env, 1)) {
> > ...
> >
> > ...but yes, that's awkward when all you want is an error return from a
> > copy operation.
>
> Yeah.  The nice thing about the kernel uaccess / _nofault helpers is
> that they allow normal error handling flows.
>
> > For _nofault I'll note that on the kernel side Linus was explicit
> > about not mixing fault handling and memory error exception handling in
> > the same accessor. That's why copy_mc_to_kernel() and
> > copy_{to,from}_kernel_nofault() are distinct.
>
> I've always wondered why we need all this mess.  But if the head
> penguin wants it..
>
> > I only say that to probe
> > deeper about what a "copy_mc()" looks like in userspace? Perhaps an
> > interface to suppress SIGBUS generation and register a ring buffer
> > that gets filled with error-event records encountered over a given
> > MMAP I/O code sequence?
>
> Well, the equivalent to the kernel uaccess model would be to register
> a SIGBUS handler that uses an exception table like the kernel, and then
> if you use the right helpers to load/store they can return errors.
>
> The other option would be something more like the Windows Structured
> Exception Handling:
>
> https://docs.microsoft.com/en-us/cpp/cpp/structured-exception-handling-c-cpp?view=msvc-160

Yes, try-catch blocks for PMEM is what is needed if it's not there
already from PMDK. Searching for SIGBUS in PMDK finds things like:

https://github.com/pmem/pmdk/blob/26449a51a86861db17feabdfefaa5ee4d5afabc9/src/libpmem2/mcsafe_ops_posix.c

>
>
> > > I think you misunderstood me.  I don't think pmem needs to be
> > > decoupled from the read/write path.  But I'm very skeptical of adding
> > > a new flag to the common read/write path for the special workaround
> > > that a plain old write will not actually clear errors unlike every
> > > other store interfac.
> >
> > Ah, ok, yes, I agree with you there that needing to redirect writes to
> > a platform firmware call to clear errors, and notify the device that
> > its error-list has changed is exceedingly awkward.
>
> Yes.  And that is the big difference to every other modern storage
> device.  SSDs always write out of place and will just not reuse bad
> blocks, and all drivers built in the last 25-30 years will also do
> internal bad block remapping.
>

No, the big difference with every other modern storage device is
access to byte-addressable storage. Storage devices get to "cheat"
with guaranteed minimum 512-byte accesses. So you can arrange for
writes to always be large enough to scrub the ECC bits along with the
data. For PMEM and byte-granularity DAX accesses the "sector size" is
a cacheline and it needed a new CPU instruction before software could
atomically update data + ECC. Otherwise, with sub-cacheline accesses,
a RMW cycle can't always be avoided. Such a cycle pulls poison from
the device on the read and pushes it back out to the media on the
cacheline writeback.

> > That said, even if
> > the device-side error-list auto-updated on write (like the promise of
> > MOVDIR64B) there's still the question about when to do management on
> > the software error lists in the driver and/or filesytem. I.e. given
> > that XFS at least wants to be aware of the error lists for block
> > allocation and "list errors" type features. More below...
>
> Well, the whole problem is that we should not have to manage this at
> all, and this is where I blame Intel.  There is no good reason to not
> slightly overprovision the nvdimms and just do internal bad page
> remapping like every other modern storage device.

I don't understand what overprovisioning has to do with better error
management? No other storage device has seen fit to be as transparent
with communicating the error list and offering ways to proactively
scrub it. Dave and Darrick rightly saw this and said "hey, the FS
could do a much better job for the user if it knew about this error
list". So I don't get what this argument about spare blocks has to do
with what XFS wants? I.e. an rmap facility to communicate files that
have been clobbered by cosmic rays and other calamities.

> > Hasn't this been a perennial topic at LSF/MM, i.e. how to get an
> > interface for the filesystem to request "try harder" to return data?
>
> Trying harder to _get_ data or to _store_ data?  All the discussion
> here seems to be able about actually writing data.
>
> > If the device has a recovery slow-path, or error tracking granularity
> > is smaller than the I/O size, then RWF_RECOVER_DATA gives the
> > device/driver leeway to do better than the typical fast path. For
> > writes though, I can only come up with the use case of this being a
> > signal to the driver to take the opportunity to do error-list
> > management relative to the incoming write data.
>
> Well, while devices have data recovery slow path they tend to use those
> automatically.  What I'm actually seeing in practice is flags in the
> storage interfaces to skip this slow path recovery because the higher
> level software would prefer to instead recover e.g. from remote copies.

Ok.

> > However, if signaling that "now is the time to update error-lists" is
> > the requirement, I imagine the @kaddr returned from
> > dax_direct_access() could be made to point to an unmapped address
> > representing the poisoned page. Then, arrange for a pmem-driver fault
> > handler to emulate the copy operation and do the slow path updates
> > that would otherwise have been gated by RWF_RECOVER_DATA.
>
> That does sound like a much better interface than most of what we've
> discussed so far.
>
> > Although, I'm not excited about teaching every PMEM arch's fault
> > handler about this new source of kernel faults. Other ideas?
> > RWF_RECOVER_DATA still seems the most viable / cleanest option, but
> > I'm willing to do what it takes to move this error management
> > capability forward.
>
> So far out of the low instrusiveness options Janes' previous series
> to automatically retry after calling a clear_poison operation seems
> like the best idea so far.  We just need to also think about what
> we want to do for direct users of ->direct_access that do not use
> the mcsafe iov_iter helpers.

Those exist? Even dm-writecache uses copy_mc_to_kernel().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

