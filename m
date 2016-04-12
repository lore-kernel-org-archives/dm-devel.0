From: Alex Sudakar <alex.sudakar@gmail.com>
Subject: Re: dm-cache: Can I change policy without suspending the
	cache?
Date: Tue, 12 Apr 2016 13:30:29 +1000
Message-ID: <CALq2s-F5uyjX2gaH358YGcdGLAjy9fR7M-BGc3+cDEVfY18qgQ@mail.gmail.com>
References: <CALq2s-H258akmqsdFatfR4mK6nOOC0+2sPmNa0PogpnpnAWHCw@mail.gmail.com>
	<20160104155009.GA3007@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160104155009.GA3007@rh-vpn>
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
Cc: Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 5, 2016 at 1:50 AM, Joe Thornber <thornber@redhat.com> wrote:
>
> On Wed, Dec 30, 2015 at 09:41:10AM +1000, Alex Sudakar wrote:
>>
>> My cache is running in writeback mode with the default smq policy.  To
>> my delight it seems that the 'cleaner' policy does *exactly* what I
>> want; not only does it immediately flush dirty blocks, as per the
>> documentation; it also appears to 'turn off' the promotion/demotion of
>> blocks in the cache.
>
> The smq policy is pretty reticent about promoting blocks to the fast
> device unless there's evidence that those blocks are being hit more
> frequently than those in the cache.  I suggest you do some experiments
> to double check your batch jobs really are causing churn in the cache.

Thank you for that advice.  I've since seen other messages here
mentioning the 'reticence' of the smq policy.  I admit it was just my
assumption that a complete single pass through the entire filesystem,
once a day, would thrown the cache statistics out of whack.  Maybe
merited/formed with the old 'mq' policy?

>> So my plan is to have my writeback dm-cache running through the day
>> with the default 'smq' policy and then switch to the 'cleaner' policy
>> between midnight and 6am, say, allowing my batch jobs to run without
>> impacting the daytime cache mappings in the slightest.
>
> There is another option, which is to just turn the
> 'migration_threshold' tunable for smq down to zero.  Which will
> practically stop any migrations.

I didn't think of that option at all, and it would be so easy to do on
the fly!  Thank you!

>> But when I had a simple shell script execute the steps above, in
>> sequence, on my real cache ... the entire system hung after the
>> 'suspend'.  Because my cache is the backing device acting as the LVM
>> physical device for most of my system's LVM volumes, including the
>> root filesystem volume.  And I/O to the cache would block while the
>> cache is suspended, I guess, which hung the script between separate
>> 'dmsetup' commands.  :(
>
> Yes, this is always going to be a problem.  If dmsetup is paged out,
> you better hope it's not on one of the suspended devices.  LVM2
> memlocks itself to avoid being paged out.  I think you have a few
> options, in order of complexity:
>
> - You don't have to suspend before you load the new table.  I think
>   the sequence ...
>
>   dmsetup load
>   dmsetup resume  # implicit suspend, swap table, resume
>
>   ... will do what you want, and may well avoid the hang.

This is brilliant suggestion #2.  :-)

From reading dmsetup(8) I just *assumed* that a 'resume' had to be on
the other side of a 'suspend', given that the first sentence of the
description for the command reads 'un-suspends a device'.  I'm sort of
stunned that a 'suspend' isn't necessary for a 'resume' to do what I
need and load a new table.  By just commenting out the 'suspend' in my
script everything worked exactly as I wanted.  *Thank you* for this
nugget of dmsetup wisdom.

> - Put dmsetup and associated libraries somewhere where the IO is
>   guaranteed to complete even though the root dev etc are
>   suspended. (eg, a little ram disk).

Yes, I was thinking of setting up a ram disk - using the dracut
module/commands which does exactly this for a system shutdown - if I
had to keep going down the path of doing a 'suspend'.

>> Or if it could read a series of commands from standard input, say.
>> Anything to allow the dmsetup to do all three steps in the one
>> process.  But I can't see anything that allows this.
>
> Yes, this has been talked about before.  I spent a bit of time
> experimenting with a tool I called dmexec.  This implemented a little
> stack based language that you could use to build your own sequence of
> device mapper operations.  For example:
>
> https://github.com/jthornber/dmexec/blob/master/language-tests/table-tests.dm
>
> I really think something like this is the way forward, though possibly
> with a less opaque language.  Volume managers would then be
> implemented as a mix of low level dmexec libraries, and high level
> calls into dmexec.

I had a shot at doing a cruder form of this; I hacked a copy of
dmsetup to read multiple commands from *argv[], each prefaced by a
number telling the 'command loop' how many values of *argv[] to use
for the next command; very basic stuff.  After finding one or two
global variables which were expected to be in their initial
program-load state this hacked version of dmsetup worked fine; on a
test standalone dm-cache device it would suspend, load, resume
perfectly.

But it still hung on doing it on my live dm-cache which provides the
LVM PV for the root and other filesystems.

My PC has 16GB of memory, and about 14GB of that was free.  Swap
wasn't being used at all.

My interest is only academic - you've solved my problem entirely with
your brilliant suggestions #1 & #2 above :-) - but I wouldn't mind
knowing why a resume on a dm-cache underpinning the root filesystem
still hung the executing hacked dmsetup program from doing a table
load and resume.  Memory of an executing process won't be swapped out
if there is a lot of RAM free, right?  Maybe dmsetup does something
else as part of a suspend which triggers these hangs.  Or the resume
needs something from the root filesystem.  Or something.  :-)

> - Switch from using dmsetup to use the new zodcache tool that was
>   posted here last month.  If zodcache doesn't memlock, we'll patch to
>   make sure it does.
>
> ...
>
>> It would be great if the dmsetup command could take multiple commands,
>> so I could execute the suspend/reload/resume all in one invocation.
>
> See zodcache.

I've looked at zodcache ... and wished I'd known about it earlier.
Instead of huffing and puffing and doing all my scripting of dracut
modules to pick up customised kernel directives as to the identity of
the devices to use for my dm-cache, and then building same, I see how
zodcache does a much more elegant job by leveraging the functionality
of udev together with using superblocks to identify the component
devices automatically.  Very nice; I think I've learned something just
by perusing its readme.pdf.  :-)  I'll definitely use zodcache next
time.

(The LVM cache seemed a bit cumbersome and overengineered for me,
which is why I decided to build my own more flexible and
direct/simpler dm-cache underpinning my various PVs and LVs.)

> - Joe

Joe, thank you very much for your advice, which saved the day two or
three different ways!  Your detailed response, and the time you spent
writing it, is much appreciated.
