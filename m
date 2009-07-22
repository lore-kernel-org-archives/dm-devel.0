From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Tue, 21 Jul 2009 23:59:04 -0700
Message-ID: <20090721235904.42e6cd35.akpm@linux-foundation.org>
References: <19041.4714.686158.130252@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19041.4714.686158.130252@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, 18 Jul 2009 10:08:10 +1000 Neil Brown <neilb@suse.de> wrote:

>  It has recently come to by attention that Linux on a 32 bit host does
>  not handle devices beyond 16TB particularly well.
> 
>  In particular, any access that goes through the page cache for the
>  block device is limited to a pgoff_t number of pages.
>  As pgoff_t is "unsigned long" and hence 32bit, and as page size is
>  4096, this comes to 16TB total.

I expect that the VFS could be made to work with 64-bit pgoff_t fairly
easily.  The generated code will be pretty damn sad.

radix-trees use a ulong index, so we would need a new
lib/radix_tree64.c or some other means of fixing that up.

The bigger problem is filesystems - they'll each need to be checked,
tested, fixed and enabled.  It's probably not too bad for the
mainstream filesystems which mostly bounce their operations into VFS
libarary functions anyway.



There's perhaps a middle ground - support >16TB devices, but not >16TB
partitions.  That way everything remains 32-bit and we just have to get
the offsetting right (probably already the case).

So now /dev/sda1, /dev/sda2 etc are all <16TB.  The remaining problem
is that /dev/sda is >16TB.  I expect that we could arrange for the
kernel to error out if userspace tries to access /dev/sda beyond the
16TB point, and those very very few applications which want to touch
that part of the disk will need to be written using direct-io, (or
perhaps sgio) or run on 64-bit machines.
