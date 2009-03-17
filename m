From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device-mapper fixes for 2.6.29
Date: Tue, 17 Mar 2009 09:25:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903170920000.26754@hs20-bc2-1.build.redhat.com>
References: <20090316190642.GH5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090316190642.GH5098@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, 16 Mar 2009, Alasdair G Kergon wrote:

> Please pull from:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> 
> to get the following device-mapper fixes for 2.6.29:
> 
> Huang Ying (1):
>       dm crypt: fix kcryptd_async_done parameter
> 
> Mikulas Patocka (2):
>       dm table: rework reference counting fix
>       dm io: respect BIO_MAX_PAGES limit

Hi

Also look at:

dm-io crashes when signal is sent:
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-dmio-fix-signal-crash.patch

that partial-read dm-raid1 + dm-multipath crash:
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-record-bio-vector.patch
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-raid1-read-record-slab.patch

crash or data corruption in snapshots (callbacks are called concurrently 
and shouldn't be):
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-kcopyd-fix.patch

failure to check pending exception after we dropped a lock:
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-snap-break-__find_pending_exception.patch
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-snap-move-allocation-to-the-caller.patch
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-snap-check-complete-exceptions.patch

--- all the patches fix crashes or data corruptions.

--- all these patches except the first one were already committed to RHEL 
4.8, so you should put them upstream, at least for testing.

Mikulas


> Milan Broz (2):
>       dm ioctl: validate name length when renaming
>       dm crypt: wait for endio to complete before destruction
> 
>  drivers/md/dm-crypt.c |   43 +++++++++++++++++++++++++++++++------------
>  drivers/md/dm-io.c    |    2 ++
>  drivers/md/dm-ioctl.c |    7 ++++---
>  drivers/md/dm.c       |   32 +++++++++++++++++++-------------
>  4 files changed, 56 insertions(+), 28 deletions(-)
> 
> Thanks,
> Alasdair
> -- 
> agk@redhat.com
