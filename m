From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Wed, 03 Jan 2007 01:19:25 +0900
Message-ID: <20070103011925K.fujita.tomonori@lab.ntt.co.jp>
References: <m3y7pi1fhx.fsf@guaranine.beaverton.ibm.com>
	<20061214193615W.fujita.tomonori@lab.ntt.co.jp>
	<m3mz51jtvr.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3mz51jtvr.fsf@guaranine.beaverton.ibm.com>
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
Date: Tue, 02 Jan 2007 08:06:16 -0800

> FT> include/linux/dm-userspace.h is included by libdevmapper. So does
> FT> it need to be released under LGPL, doesn't it?
> 
> Actually, I think that include/linux/dm-userspace.h *must* be GPL'd to
> be included in the kernel.  Am I wrong?

include/linux/device-maper.h and include/linux/dm-ioctl.h are released
under the LGPL (so both libdevmapper and the kernel code can use them).


> I imagine that since libdevmapper is LGPL, dm-userspace.h will need to
> be replicated in the libdevmapper tree.  Maybe someone with more
> experience in this area could chime in.
> 
> -- 
> Dan Smith
> IBM Linux Technology Center
> Open Hypervisor Team
> email: danms@us.ibm.com
