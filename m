From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staging: Add dm-writeboost
Date: Mon, 16 Sep 2013 17:53:57 -0400
Message-ID: <20130916215357.GA5015@redhat.com>
References: <5223208D.4000008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <5223208D.4000008@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, cesarb@cesarb.net, m.chehab@samsung.com
List-Id: dm-devel.ids

On Sun, Sep 01 2013 at  7:10am -0400,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> This patch introduces dm-writeboost to staging tree.
> 
> dm-writeboost is a log-structured caching software.
> It batches in-coming random-writes to a big sequential write
> to a cache device.
> 
> Unlike other block caching softwares like dm-cache and bcache,
> dm-writeboost focuses on bursty writes.
> Since the implementation is optimized on writes,
> the benchmark using fio indicates that
> it performs 259MB/s random writes with
> SSD with 266MB/s sequential write throughput
> which is only 3% loss.
> 
> Furthermore,
> because it uses SSD cache device sequentially,
> the lifetime of the device is maximized.
> 
> The merit of putting this software in staging tree is
> to make it more possible to get feedback from users
> and thus polish the code.
> 
> Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
> ---
>  MAINTAINERS                                     |    7 +
>  drivers/staging/Kconfig                         |    2 +
>  drivers/staging/Makefile                        |    1 +
>  drivers/staging/dm-writeboost/Kconfig           |    8 +
>  drivers/staging/dm-writeboost/Makefile          |    1 +
>  drivers/staging/dm-writeboost/TODO              |   11 +
>  drivers/staging/dm-writeboost/dm-writeboost.c   | 3445 +++++++++++++++++++++++
>  drivers/staging/dm-writeboost/dm-writeboost.txt |  133 +
>  8 files changed, 3608 insertions(+)
>  create mode 100644 drivers/staging/dm-writeboost/Kconfig
>  create mode 100644 drivers/staging/dm-writeboost/Makefile
>  create mode 100644 drivers/staging/dm-writeboost/TODO
>  create mode 100644 drivers/staging/dm-writeboost/dm-writeboost.c
>  create mode 100644 drivers/staging/dm-writeboost/dm-writeboost.txt

Hi Akira,

Sorry for not getting back to you sooner.  I'll make an effort to be
more responsive from now on.

Here is a list of things I noticed during the first _partial_ pass in
reviewing the code:

- the various typedefs aren't needed (e.g. device_id, cache_id,
  cache_nr)

- variable names need to be a bit more verbose (arr => array)

- really not convinced we need WB{ERR,WARN,INFO} -- may have been useful
  for early development but production code shouldn't be emitting
  messages with line numbers

- all the code in one file is too cumbersome; would like to see it split
  into multiple files.. not clear on what that split would look like yet

- any chance the log-structured IO could be abstracted to a new class in
  drivers/md/persistent-data/ ?  At least factor out a library with the
  interface that drives the IO.

- really dislike the use of an intermediate "writeboost-mgr" target to
  administer the writeboost devices.  There is no need for this.  Just
  have a normal DM target whose .ctr takes care of validation and
  determines whether a device needs formatting, etc.  Otherwise I cannot
  see how you can properly stack DM devices on writeboost devices
  (suspend+resume become tediously different)

- shouldn't need to worry about managing your own sysfs hierarchy;
  when a dm-writeboost .ctr takes a reference on a backing or cache
  device it will establish a proper hierarchy (see: dm_get_device).  What
  advantages are you seeing from having/managing this sysfs tree?

- I haven't had time to review the migration daemon post you made today;
  but it concerns me that dm-writeboost ever required this extra service
  for normal function.  I'll take a closer look at what you're asking
  and respond tomorrow.

But in short this code really isn't even suitable for inclusion via
staging.  There are far too many things, on a fundamental interface
level, that we need to sort out.

Probably best for you to publish the dm-writeboost code a git repo on
github.com or the like.  I just don't see what benefit there is to
putting code like this in staging.  Users already need considerable
userspace tools and infrastructure will also be changing in the
near-term (e.g. the migration daemon).

Regards,
Mike
