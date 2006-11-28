From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Wed, 29 Nov 2006 03:26:35 +0900
Message-ID: <20061129032635J.fujita.tomonori@lab.ntt.co.jp>
References: <20061025194412J.fujita.tomonori@lab.ntt.co.jp>
	<m31wotsvqy.fsf@guaranine.beaverton.ibm.com>
	<200610271436.k9REaVOC020547@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200610271436.k9REaVOC020547@r-dd.iij4u.or.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: danms@us.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hey Dan,

Has there been any progress on this?

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [dm-devel] [PATCH 1/2] dm-userspace: use ring buffer instead	of	system call
Date: Fri, 27 Oct 2006 23:36:31 +0900

> From: Dan Smith <danms@us.ibm.com>
> Subject: Re: [dm-devel] [PATCH 1/2] dm-userspace: use ring buffer instead of	system call
> Date: Fri, 27 Oct 2006 07:01:41 -0700
> 
> > FT> It's against on the top of the following patches:
> > 
> > Would you mind sending a patch against a vanilla tree?  I'm having a
> > hard time getting the patches (old and new) to apply cleanly and in
> > the right order.
> 
> No problem. Here's the patch against 2.6.18
> 
> 
> > FT> In my experiments, the ring buffer interface provides 10% better
> > FT> write performance with disktest benchmark, though dbench gives
> > FT> comparable performances (about 340 MB/s).
> > 
> > This is good to hear.  I am interested in testing it in some of my
> > real-life situations where performance is slower due to the high
> > latency.  This mostly affects the boot time of Xen guests.
> > 
> > I have added kernel caching back into my local version (which only
> > adds 200 lines).  It improves Xen guest boot performance
> > significantly, but does not affect dbench performance.  I will be
> > interested to see what kind of performance I can get from your
> > ringbuffer version, as well as possibly a combination of the two.
> 
> I see. I'm looking forward to the results. Then I'll send some other
> patches.
