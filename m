From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper changes for 4.19
Date: Fri, 17 Aug 2018 14:13:40 -0400
Message-ID: <20180817181340.GA4422@redhat.com>
References: <20180816200431.GA31084@redhat.com>
	<CA+55aFzYtS99jCSx5Vp1Em3qZB_-32j+OE9MiY4nK71UErA9bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: djeffery@redhat.com, Kees Cook <keescook@chromium.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, houtao1@huawei.com, Ilya Dryomov <idryomov@gmail.com>, Andy Grover <agrover@redhat.com>, jpittman@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 17 2018 at  1:01pm -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

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
> 
> A quick grep shows that nothing outside of drivers/md/ includes that
> header file.
> 
> So I wonder if you would mind just moving that header file to
> drivers/md/, and changing the
> 
>    #include <linux/dm-kcopyd.h>
> 
> into just
> 
>    #include "dm-kopyd.h"
> 
> instead?

Sure.

> The reason I care (weakly) is just that I end up looking at diffstats
> a lot during the merge window, and it's always nice for me when I see
> "this pull request only changes things internal to that particular
> subsystem". Then I don't need to  worry as much about any interactions
> with any other pulls.

I'll review all DM headers in include/linux/ and move accordingly.

Only thing that made restrict some movement is concern for 3rd party DM
modules that aren't upstream (yet).  But I may just need to be the
bearer of bad news for those.

I should be able to get these tested changes to you early next week.
I'll defer to you on whether to take them for 4.19 or wait.

Thanks,
Mike
