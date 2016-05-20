From: 'Eric Wheeler' <bcache@lists.ewheeler.net>
Subject: RE: bcache gets stuck flushing writeback cache when used in combination
 with LUKS/dm-crypt and non-default bucket size
Date: Fri, 20 May 2016 14:37:35 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605201322530.26328@mx.ewheeler.net>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com> <5739F07A.5090608@buttersideup.com> <alpine.LRH.2.11.1605191618560.22436@mx.ewheeler.net> <02b101d1b265$2bc46fb0$834d4f10$@codenest.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <02b101d1b265$2bc46fb0$834d4f10$@codenest.com>
Sender: linux-bcache-owner@vger.kernel.org
To: James Johnston <johnstonj.public@codenest.com>
Cc: 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, 'Alasdair Kergon' <agk@redhat.com>, 'Mike Snitzer' <snitzer@redhat.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, dm-crypt@saout.de
List-Id: dm-devel.ids

On Fri, 20 May 2016, James Johnston wrote:

> > On Mon, 16 May 2016, Tim Small wrote:
> > 
> > > On 08/05/16 19:39, James Johnston wrote:
> > > > I've run into a problem where the bcache writeback cache can't be flushed to
> > > > disk when the backing device is a LUKS / dm-crypt device and the cache set has
> > > > a non-default bucket size.  Basically, only a few megabytes will be flushed to
> > > > disk, and then it gets stuck.  Stuck means that the bcache writeback task
> > > > thrashes the disk by constantly reading hundreds of MB/second from the cache set
> > > > in an infinite loop, while not actually progressing (dirty_data never decreases
> > > > beyond a certain point).
> > >
> > > > [...]
> > >
> > > > The situation is basically unrecoverable as far as I can tell: if you attempt
> > > > to detach the cache set then the cache set disk gets thrashed extra-hard
> > > > forever, and it's impossible to actually get the cache set detached.  The only
> > > > solution seems to be to back up the data and destroy the volume...
> > >
> > > You can boot an older kernel to flush the device without destroying it
> > > (I'm guessing that's because older kernels split down the big requests
> > > which are failing on the 4.4 kernel).  Once flushed you could put the
> > > cache into writethrough mode, or use a smaller bucket size.
> > 
> > Indeed, can someone test 4.1.y and see if the problem persists with a 2M
> > bucket size?  (If someone has already tested 4.1, then appologies as I've
> > not yet seen that report.)
> > 
> > If 4.1 works, then I think a bisect is in order.  Such a bisect would at
> > least highlight the problem and might indicate a (hopefully trivial) fix.
> 
> To help narrow this down, I tested the following generic pre-compiled mainline kernels
> on Ubuntu 15.10:
> 
>  * WORKS:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.6-wily/
>  * DOES NOT WORK:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4-rc1+cod1-wily/
> 
> I also tried the default & latest distribution-provided 4.2 kernel.  It worked.
> This one also worked:
> 
>  * WORKS:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.2.8-wily/
> 
> So it seems to me that it is a regression from 4.3.6 kernel to any 4.4 kernel.  That
> should help save time with bisection...

Below is the patchlist for md and block that might help with a place to 
start.  Are there any other places in the Linux tree where we should watch 
for changes?

I'm wondering if it might be in dm-4.4-changes since this is dm-crypt
related, but it could be ac322de which was quite large.

James or Tim,

Can you try building ac322de?  If that produces the problem, then there 
are only 3 more to try (unless this was actually a problem in 4.3 which 
was fixed in 4.3.y, but hopefully that isn't so). 

ccf21b6 is probably the next to test to rule out neil's big md patch, 
which Linus abreviated in the commit log so it must be quite long.  OTOH, 
if dm-4.4-changes works, then I'm not sure what commit might produce the 
problem because the rest are not obviously relevant to the issue that are 
more recent.  

-Eric

]# git log --oneline v4.3~1..v4.4-rc1 drivers/md/ block/ Makefile | egrep -v 'md-cluster|raid5|blk-mq'

 8005c49 Linux 4.4-rc1
 ccc2600 block: fix blk-core.c kernel-doc warning
 c34e6e0 Merge branch 'kbuild' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
 3419b45 Merge branch 'for-4.4/io-poll' of git://git.kernel.dk/linux-block
 3934bbc Merge tag 'md/4.4-rc0-fix' of git://neil.brown.name/md
 ad804a0 Merge branch 'akpm' (patches from Andrew)
 75021d2 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
 05229be block: add block polling support
 dece163 block: change ->make_request_fn() and users to return a queue cookie
 8639b46 pidns: fix set/getpriority and ioprio_set/get in PRIO_USER mode
 71baba4 mm, page_alloc: rename __GFP_WAIT to __GFP_RECLAIM
 d0164ad mm, page_alloc: distinguish between being unable to sleep, unwilling to sleep and avoiding waking kswapd
 8d090f4 bcache: Really show state of work pending bit
 933425fb Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
 5ebe0ee Merge tag 'docs-for-linus' of git://git.lwn.net/linux
 69234ac Merge branch 'for-4.4' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
 e0700ce Merge tag 'dm-4.4-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
 ac322de Merge tag 'md/4.4' of git://neil.brown.name/md
 ccf21b6 Merge branch 'for-4.4/reservations' of git://git.kernel.dk/linux-block
 527d152 Merge branch 'for-4.4/integrity' of git://git.kernel.dk/linux-block
 d9734e0 Merge branch 'for-4.4/core' of git://git.kernel.dk/linux-block
 6a13feb Linux 4.3


--
Eric Wheeler



> 
> James
> 
> 
> 
