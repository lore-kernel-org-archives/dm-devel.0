From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper changes for 4.19
Date: Fri, 17 Aug 2018 16:04:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808171546510.2385@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180816200431.GA31084@redhat.com>
	<CA+55aFzYtS99jCSx5Vp1Em3qZB_-32j+OE9MiY4nK71UErA9bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+55aFzYtS99jCSx5Vp1Em3qZB_-32j+OE9MiY4nK71UErA9bg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: djeffery@redhat.com, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, houtao1@huawei.com, Ilya Dryomov <idryomov@gmail.com>, Andy Grover <agrover@redhat.com>, jpittman@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 17 Aug 2018, Linus Torvalds wrote:

> This is only very weakly related to this pull request, but when I look
> at the diffstat, I note that outside of the Documentation changes, it
> looks like this:
> 
> On Thu, Aug 16, 2018 at 1:04 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >  drivers/md/dm-cache-metadata.c                    |  13 +-
> >  drivers/md/dm-cache-target.c                      |  35 +-
> >  drivers/md/dm-crypt.c                             |  66 ++-
> >  drivers/md/dm-delay.c                             | 249 +++++------
> >  drivers/md/dm-integrity.c                         | 501 ++++++++++++++++++----
> >  drivers/md/dm-kcopyd.c                            |  18 +-
> >  drivers/md/dm-raid1.c                             |  17 +-
> >  drivers/md/dm-snap.c                              |  41 +-
> >  drivers/md/dm-thin.c                              |  31 +-
> >  drivers/md/dm-writecache.c                        |   8 +-
> >  drivers/md/dm-zoned-reclaim.c                     |   6 +-
> >  include/linux/dm-kcopyd.h                         |  12 +-
> 
> and what stands out to me is that "include/linux/" file.
> 
> It turns out that I don't think it should be in include/linux/ at all,
> because it seems entirely internal to drivers/md.

dm-kcopyd.h (and dm-io.h and dm-bufio.h) are not restricted to device 
mapper. These subsystems were written by device mapper developers because 
they needed to reuse the same functionality in multiple dm targets, but 
these subsystems do not depend on device mapper functionality (with little 
changes, they could be compiled independently of dm) and could be used by 
any kernel code (for example filesystems).

I think that perhaps these files could be moved to some generic place like 
block/lib/, so that others could start using them too.

Mikulas
