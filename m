From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: RFC: I/O bandwidth controller (was Re: Too many I/O controller
 patches)
Date: Mon, 11 Aug 2008 22:52:25 +0200
Message-ID: <48A0A689.40908@gmail.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>	 <1217870433.20260.101.camel@nimitz>	 <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>	 <489AA83F.1040306@gmail.com> <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
Reply-To: righi.andrea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758031AbYHKUwn@vger.kernel.org>
In-Reply-To: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= <fernando@oss.ntt.co.jp>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Ryo Tsuruta <ryov@valinux.co.jp>, yoshikawa.takuya@oss.ntt.co.jp, taka@valinux.co.jp, uchida@ap.jp.nec.com, ngupta@google.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, agk@sourceware.org
List-Id: dm-devel.ids

=46ernando Luis V=C3=A1zquez Cao wrote:
>>> This seems to be the easiest part, but the current cgroups
>>> infrastructure has some limitations when it comes to dealing with b=
lock
>>> devices: impossibility of creating/removing certain control structu=
res
>>> dynamically and hardcoding of subsystems (i.e. resource controllers=
).
>>> This makes it difficult to handle block devices that can be hotplug=
ged
>>> and go away at any time (this applies not only to usb storage but a=
lso
>>> to some SATA and SCSI devices). To cope with this situation properl=
y we
>>> would need hotplug support in cgroups, but, as suggested before and
>>> discussed in the past (see (0) below), there are some limitations.
>>>
>>> Even in the non-hotplug case it would be nice if we could treat eac=
h
>>> block I/O device as an independent resource, which means we could d=
o
>>> things like allocating I/O bandwidth on a per-device basis. As long=
 as
>>> performance is not compromised too much, adding some kind of basic
>>> hotplug support to cgroups is probably worth it.
>>>
>>> (0) http://lkml.org/lkml/2008/5/21/12
>> What about using major,minor numbers to identify each device and acc=
ount
>> IO statistics? If a device is unplugged we could reset IO statistics
>> and/or remove IO limitations for that device from userspace (i.e. by=
 a
>> deamon), but pluggin/unplugging the device would not be blocked/affe=
cted
>> in any case. Or am I oversimplifying the problem?
> If a resource we want to control (a block device in this case) is
> hot-plugged/unplugged the corresponding cgroup-related structures ins=
ide
> the kernel need to be allocated/freed dynamically, respectively. The
> problem is that this is not always possible. For example, with the
> current implementation of cgroups it is not possible to treat each bl=
ock
> device as a different cgroup subsytem/resource controlled, because
> subsystems are created at compile time.

The whole subsystem is created at compile time, but controller data
structures are allocated dynamically (i.e. see struct mem_cgroup for
memory controller). So, identifying each device with a name, or a key
like major,minor, instead of a reference/pointer to a struct could help
to handle this in userspace. I mean, if a device is unplugged a
userspace daemon can just handle the event and delete the controller
data structures allocated for this device, asynchronously, via
userspace->kernel interface. And without holding a reference to that
particular block device in the kernel. Anyway, implementing a generic
interface that would allow to define hooks for hot-pluggable devices (o=
r
similar events) in cgroups would be interesting.

>>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspects
>>>
>>> The implementation of an I/O scheduling algorithm is to a certain e=
xtent
>>> influenced by what we are trying to achieve in terms of I/O bandwid=
th
>>> shaping, but, as discussed below, the required accuracy can determi=
ne
>>> the layer where the I/O controller has to reside. Off the top of my
>>> head, there are three basic operations we may want perform:
>>>   - I/O nice prioritization: ionice-like approach.
>>>   - Proportional bandwidth scheduling: each process/group of proces=
ses
>>> has a weight that determines the share of bandwidth they receive.
>>>   - I/O limiting: set an upper limit to the bandwidth a group of ta=
sks
>>> can use.
>> Use a deadline-based IO scheduling could be an interesting path to b=
e
>> explored as well, IMHO, to try to guarantee per-cgroup minimum bandw=
idth
>> requirements.
> Please note that the only thing we can do is to guarantee minimum
> bandwidth requirement when there is contention for an IO resource, wh=
ich
> is precisely what a proportional bandwidth scheduler does. An I missi=
ng
> something?

Correct. Proportional bandwidth automatically allows to guarantee min
requirements (instead of IO limiting approach, that needs additional
mechanisms to achive this).

In any case there's no guarantee for a cgroup/application to sustain
i.e. 10MB/s on a certain device, but this is a hard problem anyway, and
the best we can do is to try to satisfy "soft" constraints.

-Andrea
