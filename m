From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Fri, 08 Dec 2006 09:59:39 +0900
Message-ID: <20061208095939I.fujita.tomonori@lab.ntt.co.jp>
References: <200610271436.k9REaVOC020547@r-dd.iij4u.or.jp>
	<20061129032635J.fujita.tomonori@lab.ntt.co.jp>
	<m3lklj2u81.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3lklj2u81.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/2] dm-userspace: use ring buffer instead	of	system call
Date: Thu, 07 Dec 2006 14:53:50 -0800

> FT> Has there been any progress on this?
> 
> Ok, I just got around to testing your patch and running some tests.  I
> merged your patch with my latest version of dm-userspace, which has
> optional kernel caching of mappings (as pushed by userspace).  I also
> updated the libdevmapper interface to support the ringbuffer
> transport, and thus was able to test with my cow daemon.

Thanks for lots of tests.


> I tested with dbench and disktest.  I'm not familiar with disktest, so
> I'm not sure I was doing the right thing because the numbers are very
> small.
>
> I tested with the example program backed by an LVM (and then directly
> against the LVM).  I used this command line:
> 
>   disktest -D30:70 -K2 -B4096 -T 180 -pR -PT -Ibd

You did random I/O with direct I/O, I think. So the numbers are small.


> I'd be happy to post a patch of my merged kernel changes as well as
> the updated library interface if you're interested.  I tend to think
> that the performance of the two is close enough that it's worth moving
> to the ringbuffer version and working to improve performance from
> that.

Of course I'm interested. Please post a patch. I still have some other
stuff that I want to do for dmu.

You might use a common infrastructure for ring buffer in the
future. The scsi target framework uses ring buffer, which has been
merged into Linus git tree. Probably, kevent and bsg would use ring
buffer too and they will be merged into mainline.

So using ring buffer makes sense for me.


> I would also still like to test the ringbuffer version in some other
> environments, like a Xen domU boot to see if it reduces latency
> further, which will help responsiveness.

I see.
