From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH v2 1/1] dm-raid45
Date: Wed, 09 Dec 2009 18:47:20 +0100
Message-ID: <1260380840.9639.99.camel@o>
References: <1259243112-28175-1-git-send-email-heinzm@redhat.com>
	<e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, 2009-12-08 at 17:38 -0700, Dan Williams wrote:
> On Thu, Nov 26, 2009 at 6:45 AM,  <heinzm@redhat.com> wrote:
> > From: Heinz Mauelshagen <heinzm@redhat.com>
> >
> > Neil et al.,
> >
> > finally got around to creating a followup (interim) patch, which allows
> > for changing the xor algorithn at runtime via the message interface,
> > hence allowing to test if the xor unrole optimization around the
> > supported algorithms is performing better than the assembler
> > optimized one in the kernel.
> 
> Now that perf is available it would be good to get some comparative
> cache utilization statistics on the two approaches.

I'd appreciate it.
Do you have any time to spend on this comparison ?

>  The assembly
> routines make an attempt to avoid polluting L2 (however the memcpy's
> into the cache do not).
> 
> > If we can prove my findings rigth, we could move those into
> > the crypto subsystem xor.
> >
> > Syntax:
> > -------
> > dmsetup message $MappedDevice 0 xor $Algorithm $Chunks
> >
> > $MappedDevice = whatever name you picked during creation
> > $Algorithm = { "xor_8", "xor_16", "xor_32", "xor_64", "xor_blocks" }
> > $Chunks = 2..N # N being the amount of stripes (eg. 5 with 5 disks)
> >
> > Patch applies to clean mainline git 2.6.32-rc8.
> >
> > Regards,
> > Heinz
> >
> > Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> > ---
> >  drivers/md/Kconfig             |    9 +
> >  drivers/md/Makefile            |    2 +
> >  drivers/md/dm-memcache.c       |  301 +++
> >  drivers/md/dm-memcache.h       |   68 +
> >  drivers/md/dm-raid45.c         | 4720 ++++++++++++++++++++++++++++++++++++++++
> 
> Where did the investigation of reusing md/raid5.c [1] end up?  This
> would simultaneously enable hardware accelerated raid6 for dmraid.

Not far. Got distracted by other activities and haven't heard back from
Neil after submitting this dm-raid45 patch (which makes it simple to
test various parameter sets w/o reloading mappings).

Heinz

> 
> --
> Dan
> 
> [1] http://marc.info/?l=dm-devel&m=124567352518676&w=2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
