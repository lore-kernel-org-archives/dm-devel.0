From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Fri, 20 Mar 2009 06:01:23 -0400
Message-ID: <1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
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
List-Id: dm-devel.ids

On Thu, 2009-03-19 at 22:11 -0700, Christopher Chen wrote:
> On Thu, Mar 19, 2009 at 4:04 AM, John A. Sullivan III
> <jsullivan@opensourcedevel.com> wrote:
> > On Wed, 2009-03-18 at 15:57 -0700, Christopher Chen wrote:
> >> Hello, running Centos 5.2 here--
> >>
> >> The multipathd daemon is very unhappy with any arbritrary script I
> >> provide for determining priorities. I see some fuzz in the syslog
> >> about ramfs and static binaries.
> >>
> >> How do I use shell scripts or arbitrary programs for multipathd? I
> >> compiled a simple program that spits out "1" and it seems to return
> >> appropriately.
> >>
> >> Also, why does multipath -ll return the appropriate data, namely
> >> prio=1 (when using my custom statically compiled callout) and
> >> multipath -l always returns prio=0? Is this an indication of a broken
> >> configuration or something else?
> >>
> >> Cheers
> >>
> >> cc
> >>
> > I had the exact same problem and someone kindly explained it on this
> > list so thanks to them.
> >
> > If I understand it correctly, multipathd must be prepared to function if
> > it loses access to disk.  Therefore, it is designed to not read from
> > disk but caches everything it needs in memory.  Apparently, it can only
> > cache binaries.
> >
> > To use a shell script, call it via the shell, i.e., rather than
> > shell.script call sh shell.script.
> >
> > That worked perfectly fine for me.  However, I do not know if multipathd
> > actually caches shell.script or if it still must read it from disk when
> > invoking sh and hence remains vulnerable to loss of disk access.  Does
> > anyone know? Thanks - John
> 
> John:
> 
> Thanks for the reply.
> 
> I ended up writing a small C program to do the priority computation for me.
> 
> I have two sets of FC-AL shelves attached to two dual-channel Qlogic
> cards. That gives me two paths to each disk. I have about 56 spindles
> in the current configuration, and am tying them together with md
> software raid.
> 
> Now, even though each disk says it handles concurrent I/O on each
> port, my testing indicates that throughput suffers when using multibus
> by about 1/2 (from ~60 MB/sec sustained I/O with failover to 35 MB/sec
> when using multibus).
> 
> However, with failover, I am effectively using only one channel on
> each card. With my custom priority callout, I more or less match the
> disks with even numbers to the even numbered scsi channels with a
> higher priority. Same with the odd numbered disks and odd numbered
> channels. The odds are 2ndary on even and vice versa. It seems to work
> rather well, and appears to spread the load nicely.
> 
> Thanks again for your help!
> 
I'm really glad you brought up the performance problem. I had posted
about it a few days ago but it seems to have gotten lost.  We are really
struggling with performance issues when attempting to combine multiple
paths (in the case of multipath to one big target) or targets (in the
case of software RAID0 across several targets) rather than using, in
effect, JBODs.  In our case, we are using iSCSI.

Like you, we found that using multibus caused almost a linear drop in
performance.  Round robin across two paths was half as much as aggregate
throughput to two separate disks, four paths, one fourth.

We also tried striping across the targets with software RAID0 combined
with failover multipath - roughly the same effect.

We really don't want to be forced to treated SAN attached disks as
JDOBs.  Has anyone cracked this problem of using them in either multibus
or RAID0 so we can present them as a single device to the OS and still
load balance multiple paths.  This is a HUGE problem for us so any help
is greatly appreciated.  Thanks- John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
