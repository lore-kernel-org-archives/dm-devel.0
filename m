From: Mike Snitzer <snitzer@redhat.com>
Subject: dm-lc code/design [was: Re: dm-lc.c: fix for a potential
 NULL pointer dereference]
Date: Wed, 31 Jul 2013 11:57:17 -0400
Message-ID: <20130731155717.GD17352@redhat.com>
References: <1375272568-2730-1-git-send-email-gmate.amit@gmail.com>
	<51F90B49.60708@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <51F90B49.60708@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: Kumar Amit Mehta <gmate.amit@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 31 2013 at  9:04am -0400,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Thanks, Kumar.
> Your patch is applied.
> 
> resume_cache,
> a routine to build in-memory data structures
> by reading metadata on cache device,
> is so complicated in the code and the logic
> to thoroughly implement the error checks.
> 
> I am wondering how I should face this problem.
> Only caring about lines
> that allocates large-sized memories
> and forget about anything else
> is what I am thinking now.
> But it is clear that
> it is not a way kernel module should be.
> 
> Do you guys have some thoughts on this problem?

I had a quick look at "resume_cache".  I was thinking you were referring
to the .resume method of the target.  The .resume method must not
allocate _any_ memory (DM convention requires all memory allocations to
be done in terms of preallocated memory or more commonly as part of the
DM table load, via .ctr)... anyway ignoring that for now.

I was very surprised to see that you're managing devices in terms of DM
messages like "resume_cache" (which I assume your dm-lc userspace tools
initiate).  This seems wrong -- I'm also not seeing proper locking in
the code either (which you get for free if with DM if you use the
traditional DM hooks via target_type ops).  But I haven't been able to
do a proper review.

DM device creation and deletion are done in terms of load (.ctr) and
remove (.dtr).

And all these sysfs files are excessive too.  You'll notice that DM devices
don't expose discrete sysfs files on a per device basis.  All per-device
info is exposed via .status

We _could_ take steps to establish a per-DM-device sysfs namespace; but
that would need to be something wired up to the DM core.  So I'd prefer
dm-lc use traditional .status (info and table).

All said, I'll try to make time for a more formal review in the coming
weeks.  Please feel free to ask more questions in the mean time.

Thanks,
Mike
