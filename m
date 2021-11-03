Return-Path: <SRS0=e/dp=PW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051D4C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 20:34:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9863F61156
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 20:34:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9863F61156
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-C5RlHhL1MnCcL2nnHsEG1Q-1; Wed, 03 Nov 2021 16:34:25 -0400
X-MC-Unique: C5RlHhL1MnCcL2nnHsEG1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C12DE18125C0;
	Wed,  3 Nov 2021 20:34:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C61F1B5C2;
	Wed,  3 Nov 2021 20:34:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C6061800B9E;
	Wed,  3 Nov 2021 20:34:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A3KYExm017436 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Nov 2021 16:34:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2B56E1121315; Wed,  3 Nov 2021 20:34:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 270081121314
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 20:34:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F61C811E7F
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 20:34:11 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
	[209.85.214.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-461-ZAWLhbRYN2ikCEhzQFl7OA-1; Wed, 03 Nov 2021 16:34:09 -0400
X-MC-Unique: ZAWLhbRYN2ikCEhzQFl7OA-1
Received: by mail-pl1-f170.google.com with SMTP id t21so3514661plr.6
	for <dm-devel@redhat.com>; Wed, 03 Nov 2021 13:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=yInAWWmX6IbmZJ/wlq7G3j0MiE3+bSNug2mSaBSOXp8=;
	b=LSMdlii7wTJMn/NVBed6B2GJYlObEPc3lGNYOaC67YqnQMjaDjSDv1modeFeGmuugj
	Wd6Jw+kH7oWax2JtC7T0HZ7gl47k88fEl4VmCdsPaBVEjbMXoT3kmlxcJrSkwnwMFxBz
	fiqN5ZafcJRRIkhmYuzfQ0ggj17mN043WiDfmPlte5NiDR5IHHGtJFNvvFqRPDi7ec2e
	XvMVB4JXOQ/VbeMkWGZLKgMBJix/QnDoH9rOU4/AmAOZJdus3CFu9ItPKcy74xrj5t0o
	I/fbspiJd2g7hiZYrAugdozgXsufH/scFeYYbZ9Q6ERvKGB2MUAbuvHqUNoaO4Xhwk1S
	E6JQ==
X-Gm-Message-State: AOAM531nt6bdWbCGi2IrxeSw+Yppyh6sD+AAGK4TD+KavhNQWqMyzSBN
	vvjXmYKg/FnvTzR1BGkg+0eAo3mH4mJljANjQ5gvFQ==
X-Google-Smtp-Source: ABdhPJzd7Z8lZ96OuyBaVsmPkzvXvAiMBjG+8ylo9BgB66C56AZdzDtCJhUvR3LVHaBpBpz3Mis5HNJMl34JvAiOnPA=
X-Received: by 2002:a17:90b:350f:: with SMTP id
	ls15mr17053980pjb.220.1635971648063; 
	Wed, 03 Nov 2021 13:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia> <YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
	<YYK/tGfpG0CnVIO4@infradead.org>
In-Reply-To: <YYK/tGfpG0CnVIO4@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Nov 2021 13:33:58 -0700
Message-ID: <CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

On Wed, Nov 3, 2021 at 9:58 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Nov 02, 2021 at 12:57:10PM -0700, Dan Williams wrote:
> > This goes back to one of the original DAX concerns of wanting a kernel
> > library for coordinating PMEM mmap I/O vs leaving userspace to wrap
> > PMEM semantics on top of a DAX mapping. The problem is that mmap-I/O
> > has this error-handling-API issue whether it is a DAX mapping or not.
>
> Semantics of writes through shared mmaps are a nightmare.  Agreed,
> including agreeing that this is neither new nor pmem specific.  But
> it also has absolutely nothing to do with the new RWF_ flag.

Ok.

> > CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE implies that processes will
> > receive SIGBUS + BUS_MCEERR_A{R,O} when memory failure is signalled
> > and then rely on readv(2)/writev(2) to recover. Do you see a readily
> > available way to improve upon that model without CPU instruction
> > changes? Even with CPU instructions changes, do you think it could
> > improve much upon the model of interrupting the process when a load
> > instruction aborts?
>
> The "only" think we need is something like the exception table we
> use in the kernel for the uaccess helpers (and the new _nofault
> kernel access helper).  But I suspect refitting that into userspace
> environments is probably non-trivial.

Is the exception table requirement not already fulfilled by:

sigaction(SIGBUS, &act, 0);
...
if (sigsetjmp(sj_env, 1)) {
...

...but yes, that's awkward when all you want is an error return from a
copy operation.

For _nofault I'll note that on the kernel side Linus was explicit
about not mixing fault handling and memory error exception handling in
the same accessor. That's why copy_mc_to_kernel() and
copy_{to,from}_kernel_nofault() are distinct. I only say that to probe
deeper about what a "copy_mc()" looks like in userspace? Perhaps an
interface to suppress SIGBUS generation and register a ring buffer
that gets filled with error-event records encountered over a given
MMAP I/O code sequence?

> > I do agree with you that DAX needs to separate itself from block, but
> > I don't think it follows that DAX also needs to separate itself from
> > readv/writev for when a kernel slow-path needs to get involved because
> > mmap I/O (just CPU instructions) does not have the proper semantics.
> > Even if you got one of the ARCH_SUPPORTS_MEMORY_FAILURE to implement
> > those semantics in new / augmented CPU instructions you will likely
> > not get all of them to move and certainly not in any near term
> > timeframe, so the kernel path will be around indefinitely.
>
> I think you misunderstood me.  I don't think pmem needs to be
> decoupled from the read/write path.  But I'm very skeptical of adding
> a new flag to the common read/write path for the special workaround
> that a plain old write will not actually clear errors unlike every
> other store interfac.

Ah, ok, yes, I agree with you there that needing to redirect writes to
a platform firmware call to clear errors, and notify the device that
its error-list has changed is exceedingly awkward. That said, even if
the device-side error-list auto-updated on write (like the promise of
MOVDIR64B) there's still the question about when to do management on
the software error lists in the driver and/or filesytem. I.e. given
that XFS at least wants to be aware of the error lists for block
allocation and "list errors" type features. More below...

> > Meanwhile, I think RWF_RECOVER_DATA is generically useful for other
> > storage besides PMEM and helps storage-drivers do better than large
> > blast radius "I/O error" completions with no other recourse.
>
> How?

Hasn't this been a perennial topic at LSF/MM, i.e. how to get an
interface for the filesystem to request "try harder" to return data?
If the device has a recovery slow-path, or error tracking granularity
is smaller than the I/O size, then RWF_RECOVER_DATA gives the
device/driver leeway to do better than the typical fast path. For
writes though, I can only come up with the use case of this being a
signal to the driver to take the opportunity to do error-list
management relative to the incoming write data.

However, if signaling that "now is the time to update error-lists" is
the requirement, I imagine the @kaddr returned from
dax_direct_access() could be made to point to an unmapped address
representing the poisoned page. Then, arrange for a pmem-driver fault
handler to emulate the copy operation and do the slow path updates
that would otherwise have been gated by RWF_RECOVER_DATA.

Although, I'm not excited about teaching every PMEM arch's fault
handler about this new source of kernel faults. Other ideas?
RWF_RECOVER_DATA still seems the most viable / cleanest option, but
I'm willing to do what it takes to move this error management
capability forward.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

