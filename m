From: Petr Vorel <petr.vorel@gmail.com>
Subject: Re: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
 solaris_x86_slice.s_start
Date: Wed, 2 Oct 2019 08:05:09 +0200
Message-ID: <20191002060508.GA16684@x230>
References: <20190708213551.26349-1-petr.vorel@gmail.com>
	<20190709024742.GA22293@infradead.org>
	<20190709080204.GA12875@dell5510>
	<20190709133436.GA2231@infradead.org>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190709133436.GA2231@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christoph,

> On Tue, Jul 09, 2019 at 10:02:05AM +0200, Petr Vorel wrote:

> > > What this really should use is fixed size types.
> > If it's not specific to __kernel_daddr_t nor daddr_t ("The type of a disk
> > address") and long is sufficient for all platforms, that's even better.

> > I'd be just for removing typedef int daddr_t comment.

> > BTW gpart also uses struct solaris_x86_slice, with daddr_t [1].
> > I've filed a PR [2], but I guess I'll change it to long.

> solaris_x86_slice is an on-disk format, defined for good old 32-bit
> x86 Solaris.  So the question is not if it is enough, but if it matches
> what Solaris does.  I don't have the Solaris source at the moment,
> but here is what the Linux kernel uses:

> struct solaris_x86_slice {
>         __le16 s_tag;           /* ID tag of partition */
>         __le16 s_flag;          /* permission flags */
>         __le32 s_start;         /* start sector no of partition */
>         __le32 s_size;          /* # of blocks in partition */
> };

I tried to search in [1], with not much success, I don't know the original name
of the struct and struct members are quite similar. Do you have a tip, where it
could be or would you dare to search?

Christophe already merged my patch as
129e6fe6 ("kpartx: Use __kernel_daddr_t for solaris_x86_slice.s_start")

But, according to your comments it looks to me better to use the exact structure
kernel uses. So, if we don't find anything, I'd be for using kernel struct.

Kind regards,
Petr

[1] https://grok.elemental.org/source/
