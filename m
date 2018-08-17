From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.19
Date: Fri, 17 Aug 2018 10:01:18 -0700
Message-ID: <CA+55aFzYtS99jCSx5Vp1Em3qZB_-32j+OE9MiY4nK71UErA9bg@mail.gmail.com>
References: <20180816200431.GA31084@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180816200431.GA31084@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: djeffery@redhat.com, Kees Cook <keescook@chromium.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, houtao1@huawei.com, Ilya Dryomov <idryomov@gmail.com>, Andy Grover <agrover@redhat.com>, jpittman@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is only very weakly related to this pull request, but when I look
at the diffstat, I note that outside of the Documentation changes, it
looks like this:

On Thu, Aug 16, 2018 at 1:04 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
>  drivers/md/dm-cache-metadata.c                    |  13 +-
>  drivers/md/dm-cache-target.c                      |  35 +-
>  drivers/md/dm-crypt.c                             |  66 ++-
>  drivers/md/dm-delay.c                             | 249 +++++------
>  drivers/md/dm-integrity.c                         | 501 ++++++++++++++++++----
>  drivers/md/dm-kcopyd.c                            |  18 +-
>  drivers/md/dm-raid1.c                             |  17 +-
>  drivers/md/dm-snap.c                              |  41 +-
>  drivers/md/dm-thin.c                              |  31 +-
>  drivers/md/dm-writecache.c                        |   8 +-
>  drivers/md/dm-zoned-reclaim.c                     |   6 +-
>  include/linux/dm-kcopyd.h                         |  12 +-

and what stands out to me is that "include/linux/" file.

It turns out that I don't think it should be in include/linux/ at all,
because it seems entirely internal to drivers/md.

A quick grep shows that nothing outside of drivers/md/ includes that
header file.

So I wonder if you would mind just moving that header file to
drivers/md/, and changing the

   #include <linux/dm-kcopyd.h>

into just

   #include "dm-kopyd.h"

instead?

The reason I care (weakly) is just that I end up looking at diffstats
a lot during the merge window, and it's always nice for me when I see
"this pull request only changes things internal to that particular
subsystem". Then I don't need to  worry as much about any interactions
with any other pulls.

And immediately when there are changes to the main include directory,
that changes, and I start going "ok, who else includes this that I
need to make sure wasn't impacted?"

Right now it's noticeable mainly because I happen to be on my laptop,
so a full "make allmodconfig" takes an hour. Instead, I ended up
checking manually whether rthat include file update could affect
anybody else, and just did the drivers/md/ subdirectory build.

Stupid reason, I know, but I thought I'd spend a couple of minutes
writing an email and maybe next time around I'll have one less thing
to check..

               Linus
