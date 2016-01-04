From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache: Can I change policy without suspending the
 cache?
Date: Mon, 4 Jan 2016 15:50:10 +0000
Message-ID: <20160104155009.GA3007@rh-vpn>
References: <CALq2s-H258akmqsdFatfR4mK6nOOC0+2sPmNa0PogpnpnAWHCw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALq2s-H258akmqsdFatfR4mK6nOOC0+2sPmNa0PogpnpnAWHCw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 30, 2015 at 09:41:10AM +1000, Alex Sudakar wrote:
> Hi.  I've set up my system - using a Linux 4.3.3 kernel - to use a
> dm-cache as the 'physical volume' for most of the LVM logical volumes
> in the system, including the root filesystem.  This seems to be
> working fine in daily operation.
> 
> During the night I run a couple of jobs which do reads of many of the
> files in the system (for example, I run 'tripwire', which computes
> checksums of files to see if any unauthorized changes have been made).
> Ideally I don't want these night 'batch jobs' to affect the cache's
> 'daytime performance profile'.  I'd like the cache to be primed for
> typical day use and have the night-time scans run without promoting
> blocks into the cache which never see the light of day.  I've got a
> couple of questions related to how I might do this which I'd like to
> ask.  I've googled but haven't been able to find any answers
> elsewhere; I hope it's okay to ask here.
> 
> My cache is running in writeback mode with the default smq policy.  To
> my delight it seems that the 'cleaner' policy does *exactly* what I
> want; not only does it immediately flush dirty blocks, as per the
> documentation; it also appears to 'turn off' the promotion/demotion of
> blocks in the cache.

The smq policy is pretty reticent about promoting blocks to the fast
device unless there's evidence that those blocks are being hit more
frequently than those in the cache.  I suggest you do some experiments
to double check your batch jobs really are causing churn in the cache.

> So my plan is to have my writeback dm-cache running through the day
> with the default 'smq' policy and then switch to the 'cleaner' policy
> between midnight and 6am, say, allowing my batch jobs to run without
> impacting the daytime cache mappings in the slightest.

There is another option, which is to just turn the
'migration_threshold' tunable for smq down to zero.  Which will
practically stop any migrations.

> My first question is to confirm that the cleaner policy does do what
> I've observed it to do - deliberately stop all promotions/demotions,
> leaving the block map static, as well as immediately flush dirty
> blocks to the origin device.

Yes.  But it's pretty agressive about writing the dirty data back,
which may impact performance.

> My second question is how I can do this; switching policies for a
> dm-cache on a live system where the cache is the backing device for
> the root filesystem.  With my test cache I was easily able to perform
> the sequence of steps that all of the documentation says must be
> performed to change policies:
> 
>   -  'dmsetup suspend' the cache
>   -  'dmsetup reload' a new table with a change to the cleaner policy
>   -  'dmsetup resume' the cache
>   -  'dmsetup wait'
> 
> This worked fine for my test cache, because only my test scripts had
> the cache open.
> 
> But when I had a simple shell script execute the steps above, in
> sequence, on my real cache ... the entire system hung after the
> 'suspend'.  Because my cache is the backing device acting as the LVM
> physical device for most of my system's LVM volumes, including the
> root filesystem volume.  And I/O to the cache would block while the
> cache is suspended, I guess, which hung the script between separate
> 'dmsetup' commands.  :(

Yes, this is always going to be a problem.  If dmsetup is paged out,
you better hope it's not on one of the suspended devices.  LVM2
memlocks itself to avoid being paged out.  I think you have a few
options, in order of complexity:

- You don't have to suspend before you load the new table.  I think
  the sequence ...

  dmsetup load
  dmsetup resume  # implicit suspend, swap table, resume

  ... will do what you want, and may well avoid the hang.

- Put dmsetup and associated libraries somewhere where the IO is
  guaranteed to complete even though the root dev etc are
  suspended. (eg, a little ram disk).

- Switch from using dmsetup to use the new zodcache tool that was
  posted here last month.  If zodcache doesn't memlock, we'll patch to
  make sure it does.

> It would be great if the dmsetup command could take multiple commands,
> so I could execute the suspend/reload/resume all in one invocation.

See zodcache.

> Or if it could read a series of commands from standard input, say.
> Anything to allow the dmsetup to do all three steps in the one
> process.  But I can't see anything that allows this.

Yes, this has been talked about before.  I spent a bit of time
experimenting with a tool I called dmexec.  This implemented a little
stack based language that you could use to build your own sequence of
device mapper operations.  For example:

https://github.com/jthornber/dmexec/blob/master/language-tests/table-tests.dm

I really think something like this is the way forward, though possibly
with a less opaque language.  Volume managers would then be
implemented as a mix of low level dmexec libraries, and high level
calls into dmexec.

> The kernel cache.txt documentation talks about using 'dmsetup message'
> to send messages to the device mapper driver, but only in the context
> of altering policy tuning variables; I didn't see anything about how
> one could change the policy itself using a message.  Otherwise I could
> have a single process fire off a string of policy-switch commands.

You have to load the new table.

- Joe
