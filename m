From: Alex Sudakar <alex.sudakar@gmail.com>
Subject: dm-cache: Can I change policy without suspending the
	cache?
Date: Wed, 30 Dec 2015 09:41:10 +1000
Message-ID: <CALq2s-H258akmqsdFatfR4mK6nOOC0+2sPmNa0PogpnpnAWHCw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi.  I've set up my system - using a Linux 4.3.3 kernel - to use a
dm-cache as the 'physical volume' for most of the LVM logical volumes
in the system, including the root filesystem.  This seems to be
working fine in daily operation.

During the night I run a couple of jobs which do reads of many of the
files in the system (for example, I run 'tripwire', which computes
checksums of files to see if any unauthorized changes have been made).
Ideally I don't want these night 'batch jobs' to affect the cache's
'daytime performance profile'.  I'd like the cache to be primed for
typical day use and have the night-time scans run without promoting
blocks into the cache which never see the light of day.  I've got a
couple of questions related to how I might do this which I'd like to
ask.  I've googled but haven't been able to find any answers
elsewhere; I hope it's okay to ask here.

My cache is running in writeback mode with the default smq policy.  To
my delight it seems that the 'cleaner' policy does *exactly* what I
want; not only does it immediately flush dirty blocks, as per the
documentation; it also appears to 'turn off' the promotion/demotion of
blocks in the cache.  In my tests of a stand-alone cache I dumped the
metadevice using 'cache_dump'; created the cache in writeback mode
using the cleaner policy; read and wrote blocks through the cache;
removed the cache and did another dump of the metadevice; finding that
the mapped blocks hadn't changed at all.  Which is brilliant!

So my plan is to have my writeback dm-cache running through the day
with the default 'smq' policy and then switch to the 'cleaner' policy
between midnight and 6am, say, allowing my batch jobs to run without
impacting the daytime cache mappings in the slightest.

My first question is to confirm that the cleaner policy does do what
I've observed it to do - deliberately stop all promotions/demotions,
leaving the block map static, as well as immediately flush dirty
blocks to the origin device.  In all my reading I've seen the latter
characteristic mentioned as the prime purpose of the policy - to flush
all dirty blocks - but nothing about the former.  But it's that
'freezing' of block migration into the cache which is exactly what I
want.

If there's documentation on that aspect of the cleaner policy's
operation I'd very much appreciate a reference, or otherwise any other
information about it.  Is the cleaner policy guaranteed to continue
this behavior?  :)

My second question is how I can do this; switching policies for a
dm-cache on a live system where the cache is the backing device for
the root filesystem.  With my test cache I was easily able to perform
the sequence of steps that all of the documentation says must be
performed to change policies:

  -  'dmsetup suspend' the cache
  -  'dmsetup reload' a new table with a change to the cleaner policy
  -  'dmsetup resume' the cache
  -  'dmsetup wait'

This worked fine for my test cache, because only my test scripts had
the cache open.

But when I had a simple shell script execute the steps above, in
sequence, on my real cache ... the entire system hung after the
'suspend'.  Because my cache is the backing device acting as the LVM
physical device for most of my system's LVM volumes, including the
root filesystem volume.  And I/O to the cache would block while the
cache is suspended, I guess, which hung the script between separate
'dmsetup' commands.  :(

So my second question is - how can I switch policies on a live
dm-cache device when the running script/program doing the switch is
itself using I/O through the device?

It would be great if the dmsetup command could take multiple commands,
so I could execute the suspend/reload/resume all in one invocation.
Or if it could read a series of commands from standard input, say.
Anything to allow the dmsetup to do all three steps in the one
process.  But I can't see anything that allows this.

The kernel cache.txt documentation talks about using 'dmsetup message'
to send messages to the device mapper driver, but only in the context
of altering policy tuning variables; I didn't see anything about how
one could change the policy itself using a message.  Otherwise I could
have a single process fire off a string of policy-switch commands.

The only way I can currently see to switch policies on a live dm-cache
which is a backing store for the root filesystem is to run the
'switch' script from a chrooted filesystem that isn't connected to the
cache device.  I may very well end up using the same initrd image that
I use to shut down the system; adding a 'switch' script and then
unpacking the initrd image into a tmpfs filesystem and chrooting to
that to switch between smq and cleaner policies at midnight and 6am.

But it would be nice if there was an easier, more elegant way to do it.

Any (1) confirmation on the cleaner policy's behavior in 'freezing'
the cache block map and (2) advice on how to change policies on a live
cache which is backing the live root filesystem would be most
gratefully received.

Thanks!
