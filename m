From: James Cassidy <jcassidy@qfire.net>
Subject: Re: RHEL 4.3 to Sun 6320 storage
Date: Wed, 28 Jun 2006 10:25:39 -0400
Message-ID: <44A29163.3000501@qfire.net>
References: <1151402657.4766.13.camel@x41ade> <44A1980B.6040208@qfire.net>
	<1151455104.7808.2.camel@x41ade>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1151455104.7808.2.camel@x41ade>
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

Andrew Elwell wrote:
>> You'll get a device not ready on the secondary/ghost path if you have
>> MPxIO enabled on the array.
> 
> Just to be awkward, one of our arrays (cab2a01) has mpxio (sun
> speakexplicit) just now, the other (cab5a01) has rw (sun speak implicit
> failover)

The 'rw' should work great with just multipath-tools patches, except
for the fact that you have to modify the patch to remove the hardware
handler from the table in libmultipath/hwtable.c if you don't want to
apply the kernel patches.   Currently there does not appear to be a way
to override the hardware handler in the configuration file :( At least
I could not find any.

Just replace the "1 sun_tx" in that file with DEFAULT_HWHANDLER.


> 
> as this array is only used by 2 linux clients, I'm prepared to give it a
> test...

thanks!


> 
>> The first patch is to add a hardware handler to the kernel so it
> ... OK - bearing in mind I'm using the RHEL (actually centos version)
> I'm still running on 2.6.9-34.107.plus.c4smp

There should not me much of a problem applying the patch I wrote since
it only adds a file and modify Kconfig to add the configuration option.
The bio-sense-data and dm-mpath-hw-handler-sense do modify existing
files.  I've only tested on Gentoo's vserver 2.6.16 and 2.6.17
sources so far.

> 
> 
>> The kernel patch requires the bio-sense-data.patch be applied first.
>> I would also recommend applying the dm-mpath-hw-handler-sense-data
>> patch also.
> 
> Hmm. Stupid Q - are these somewhere in the git tree? if so a pointer
> please.
> 

Not sure if it's in the git tree, but you can find the bio-sense-data
and dm-mpath-hw-handler-sense-data patches at:

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/


> ...
> 
> looks great! however... doesn't seem to set up the paths correctly -v3
> shows me (snipped to show single tray)
> 
> 
> 8:96 ownership set to cab5a01t1
> sdg: not found in pathvec
> sdg: mask = 0xc
> sdg: path checker = sun_tx (controler setting)
> sdg: state = 4
> sdg: getprio = /sbin/mpath_prio_sun_tx /dev/%n (controler setting)
> sdg: prio = 1
> 8:176 ownership set to cab5a01t1
> sdl: not found in pathvec
> sdl: mask = 0xc
> sdl: path checker = sun_tx (controler setting)
> sdl: state = 2
> sdl: getprio = /sbin/mpath_prio_sun_tx /dev/%n (controler setting)
> sdl: prio = 50
> cab5a01t1: pgfailover = -1 (internal default)
> cab5a01t1: pgpolicy = group_by_prio (controler setting)
> cab5a01t1: selector = round-robin 0 (controler setting)
> cab5a01t1: features = 0 (controler setting)
> cab5a01t1: hwhandler = 1 sun_tx (controler setting)
> cab5a01t1: rr_weight = 1 (controler setting)
> cab5a01t1: minio = 1000 (controler setting)
> cab5a01t1: no_path_retry = NONE (internal default)
> cab5a01t1: set ACT_CREATE (map does not exist)
> cab5a01t1: set ACT_CREATE (map does not exist)
> cab5a01t1: domap (0) failure for create/reload map
> 
> 
> it's that "domap (0) failure for create/reload map" that looks bad...
> 
> Have I  missed something ?

From looking at the source it appears to be normal to see that error
message after it prints the topology, as an example:

mpath64: pgfailback = -2 (config file default)
mpath64: pgpolicy = group_by_prio (controler setting)
mpath64: selector = round-robin 0 (controler setting)
mpath64: features = 0 (controler setting)
mpath64: hwhandler = 1 sun_tx (controler setting)
mpath64: rr_weight = 1 (controler setting)
mpath64: minio = 1000 (controler setting)
mpath64: no_path_retry = NONE (internal default)
mpath64: set ACT_CREATE (map does not exist)
mpath64: set ACT_CREATE (map does not exist)
create: mpath64 (360003ba4e80cb0004480275d00047195)
[size=40 MB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=100][undef]
 \_ 0:0:3:38 sde 8:64  [undef][ready]
 \_ 1:0:2:38 sdi 8:128 [undef][ready]
\_ round-robin 0 [prio=2][undef]
 \_ 0:0:2:38 sdc 8:32  [undef][ghost]
 \_ 1:0:3:38 sdk 8:160 [undef][ghost]
mpath64: domap (0) failure for create/reload map

What is a problem in your case is that the topology is not printed,
which I believe indicates the 'dm_addmap' function failed.

If you don't have the hardware handler in the kernel yet, that would
be my guess of why it is failing.  Although I don't fully understand
that piece of code yet to know for sure.

-- 
Jim
