Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50873C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:09:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B35C26101E
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B35C26101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-iV-Z1VpePQ-fgcgslr4PQA-1; Fri, 29 Oct 2021 16:09:16 -0400
X-MC-Unique: iV-Z1VpePQ-fgcgslr4PQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F30E19057A0;
	Fri, 29 Oct 2021 20:09:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 524DC79452;
	Fri, 29 Oct 2021 20:09:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 113144A703;
	Fri, 29 Oct 2021 20:09:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TK945a011394 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 16:09:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 997DC1121319; Fri, 29 Oct 2021 20:09:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 956A11121315
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 20:09:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C429811E81
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 20:09:01 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-478-iCL1_hX7MmmYcjt-XMAibg-1;
	Fri, 29 Oct 2021 16:08:59 -0400
X-MC-Unique: iCL1_hX7MmmYcjt-XMAibg-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04AFE6101E;
	Fri, 29 Oct 2021 20:08:57 +0000 (UTC)
Date: Fri, 29 Oct 2021 13:08:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <20211029200857.GD2237511@magnolia>
References: <YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia>
	<20211028225955.GA449541@dread.disaster.area>
	<22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
	<20211029165747.GC2237511@magnolia>
	<f3e14569-a399-f6da-fd3e-993b579eaf74@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f3e14569-a399-f6da-fd3e-993b579eaf74@gmail.com>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 29, 2021 at 08:23:53PM +0100, Pavel Begunkov wrote:
> On 10/29/21 17:57, Darrick J. Wong wrote:
> > On Fri, Oct 29, 2021 at 12:46:14PM +0100, Pavel Begunkov wrote:
> > > On 10/28/21 23:59, Dave Chinner wrote:
> > > [...]
> > > > > > Well, my point is doing recovery from bit errors is by definition not
> > > > > > the fast path.  Which is why I'd rather keep it away from the pmem
> > > > > > read/write fast path, which also happens to be the (much more important)
> > > > > > non-pmem read/write path.
> > > > > 
> > > > > The trouble is, we really /do/ want to be able to (re)write the failed
> > > > > area, and we probably want to try to read whatever we can.  Those are
> > > > > reads and writes, not {pre,f}allocation activities.  This is where Dave
> > > > > and I arrived at a month ago.
> > > > > 
> > > > > Unless you'd be ok with a second IO path for recovery where we're
> > > > > allowed to be slow?  That would probably have the same user interface
> > > > > flag, just a different path into the pmem driver.
> > > > 
> > > > I just don't see how 4 single line branches to propage RWF_RECOVERY
> > > > down to the hardware is in any way an imposition on the fast path.
> > > > It's no different for passing RWF_HIPRI down to the hardware *in the
> > > > fast path* so that the IO runs the hardware in polling mode because
> > > > it's faster for some hardware.
> > > 
> > > Not particularly about this flag, but it is expensive. Surely looks
> > > cheap when it's just one feature, but there are dozens of them with
> > > limited applicability, default config kernels are already sluggish
> > > when it comes to really fast devices and it's not getting better.
> > > Also, pretty often every of them will add a bunch of extra checks
> > > to fix something of whatever it would be.
> > 
> > So we can't have data recovery because moving fast the only goal?
> 
> That's not what was said and you missed the point, which was in
> the rest of the message.

...whatever point you were trying to make was so vague that it was
totally uninformative and I completely missed it.

What does "callbacks or bit masks" mean, then, specifically?  How
*exactly* would you solve the problem that Jane is seeking to solve by
using callbacks?

Actually, you know what?  I'm so fed up with every single DAX
conversation turning into a ****storm of people saying NO NO NO NO NO NO
NO NO to everything proposed that I'm actually going to respond to
whatever I think your point is, and you can defend whatever I come up
with.

> > 
> > That's so meta.
> > 
> > --D
> > 
> > > So let's add a bit of pragmatism to the picture, if there is just one
> > > user of a feature but it adds overhead for millions of machines that
> > > won't ever use it, it's expensive.

Errors are infrequent, and since everything is cloud-based and disposble
now, we can replace error handling with BUG_ON().  This will reduce code
complexity, which will reduce code size, and improve icache usage.  Win!

> > > This one doesn't spill yet into paths I care about,

...so you sail in and say 'no' even though you don't yet care...

> > > but in general
> > > it'd be great if we start thinking more about such stuff instead of
> > > throwing yet another if into the path, e.g. by shifting the overhead
> > > from linear to a constant for cases that don't use it, for instance
> > > with callbacks

Ok so after userspace calls into pread to access a DAX file, hits the
poisoned memory line and the machinecheck fires, what then?  I guess we
just have to figure out how to get from the MCA handler (assuming the
machine doesn't just reboot instantly) all the way back into memcpy?
Ok, you're in charge of figuring that out because I don't know how to do
that.

Notably, RWF_DATA_RECOVERY is the flag that we're calling *from* a
callback that happens after memory controller realizes it's lost
something, kicks a notification to the OS kernel through ACPI, and the
kernel signal userspace to do something about it.  Yeah, that's dumb
since spinning rust already does all this for us, but that's pmem.

> > > or bit masks.

WTF does this even mean?

--D

> > > 
> > > > IOWs, saying that we shouldn't implement RWF_RECOVERY because it
> > > > adds a handful of branches 	 the fast path is like saying that we
> > > > shouldn't implement RWF_HIPRI because it slows down the fast path
> > > > for non-polled IO....
> > > > 
> > > > Just factor the actual recovery operations out into a separate
> > > > function like:
> > > 
> > > -- 
> > > Pavel Begunkov
> 
> -- 
> Pavel Begunkov

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

