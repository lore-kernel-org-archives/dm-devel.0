From: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Subject: Re: RHEL 4.3 to Sun 6320 storage
Date: Wed, 28 Jun 2006 01:38:23 +0100
Message-ID: <1151455104.7808.2.camel@x41ade>
References: <1151402657.4766.13.camel@x41ade>  <44A1980B.6040208@qfire.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44A1980B.6040208@qfire.net>
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


> You'll get a device not ready on the secondary/ghost path if you have
> MPxIO enabled on the array.

Just to be awkward, one of our arrays (cab2a01) has mpxio (sun
speakexplicit) just now, the other (cab5a01) has rw (sun speak implicit
failover)


> Nothing included with the standard kernel and multipath-tools will
> work if you have the 6320 array set in MPxIO mode.  You'll either
> have to set the array into 'rw' mode, which I would not recommend if
> you are sharing LUNs between hosts, or you can try the patches
> for the kernel and multipath-tools that I've been working on.

as this array is only used by 2 linux clients, I'm prepared to give it a
test...

> I've attached the patches.

Ta. 

> 
> The first patch is to add a hardware handler to the kernel so it
... OK - bearing in mind I'm using the RHEL (actually centos version)
I'm still running on 2.6.9-34.107.plus.c4smp


> The kernel patch requires the bio-sense-data.patch be applied first.
> I would also recommend applying the dm-mpath-hw-handler-sense-data
> patch also.

Hmm. Stupid Q - are these somewhere in the git tree? if so a pointer
please.



> The second patch is to the multipath-tools to add priority checker
> to make sure device-mapper uses the primary path if that is available.
> It also adds an entry to the hardware table so that it defaults are
> set correctly for a Sun T3/T4 array. There is also a path checker
> included, but readsector0 might also work too.
> 

This part was much more sucessful: well, apart from compiling up the
0.4.7 drivers over the device-mapper-multipath-0.4.5-12.0.RHEL4 RPM and
possibly confusing LVM2..
[root@bgldisk2 ~]# multipath -v2 -d
0:0:0:0: sg_io failed status 0x8 0x0 0x0 0x4
0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
error calling out /sbin/scsi_id -g -u -s /block/sda
create: mpath0 (0ATA_____Maxtor_6Y080M0__Linux_ATA-SCSI_simulator)
[size=74 GB][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][undef]
\_ 1:0:0:0 sdb 8:16  [undef][ready]
create: cab2a01t0 (360003baccb976000426f26d30004c45a)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:0:0 sdh 8:112 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:0:0 sdc 8:32  [undef][ghost]
create: cab2a01t1 (360003baccb976000426f27a00006ae93)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:0:1 sdi 8:128 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:0:1 sdd 8:48  [undef][ghost]
create: cab2a01t2 (360003baccb976000426f289000049adb)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 3:0:0:2 sde 8:64  [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 4:0:0:2 sdj 8:144 [undef][ghost]
create: cab5a01t0 (360003baccbbb3000426571c00005d3ad)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:1:0 sdk 8:160 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:1:0 sdf 8:80  [undef][ghost]
create: cab5a01t1 (360003baccbbb30004318746a000d7607)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:1:1 sdl 8:176 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:1:1 sdg 8:96  [undef][ghost]
create: cab2a01t0 (360003baccb976000426f26d30004c45a)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:0:0 sdh 8:112 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:0:0 sdc 8:32  [undef][ghost]
create: cab2a01t1 (360003baccb976000426f27a00006ae93)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:0:1 sdi 8:128 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:0:1 sdd 8:48  [undef][ghost]
create: cab2a01t2 (360003baccb976000426f289000049adb)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 3:0:0:2 sde 8:64  [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 4:0:0:2 sdj 8:144 [undef][ghost]
create: cab5a01t0 (360003baccbbb3000426571c00005d3ad)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:1:0 sdk 8:160 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:1:0 sdf 8:80  [undef][ghost]
create: cab5a01t1 (360003baccbbb30004318746a000d7607)
[size=1638 GB][features=0][hwhandler=1 sun_tx]
\_ round-robin 0 [prio=50][undef]
\_ 4:0:1:1 sdl 8:176 [undef][ready]
\_ round-robin 0 [prio=1][undef]
\_ 3:0:1:1 sdg 8:96  [undef][ghost]


looks great! however... doesn't seem to set up the paths correctly -v3
shows me (snipped to show single tray)


8:96 ownership set to cab5a01t1
sdg: not found in pathvec
sdg: mask = 0xc
sdg: path checker = sun_tx (controler setting)
sdg: state = 4
sdg: getprio = /sbin/mpath_prio_sun_tx /dev/%n (controler setting)
sdg: prio = 1
8:176 ownership set to cab5a01t1
sdl: not found in pathvec
sdl: mask = 0xc
sdl: path checker = sun_tx (controler setting)
sdl: state = 2
sdl: getprio = /sbin/mpath_prio_sun_tx /dev/%n (controler setting)
sdl: prio = 50
cab5a01t1: pgfailover = -1 (internal default)
cab5a01t1: pgpolicy = group_by_prio (controler setting)
cab5a01t1: selector = round-robin 0 (controler setting)
cab5a01t1: features = 0 (controler setting)
cab5a01t1: hwhandler = 1 sun_tx (controler setting)
cab5a01t1: rr_weight = 1 (controler setting)
cab5a01t1: minio = 1000 (controler setting)
cab5a01t1: no_path_retry = NONE (internal default)
cab5a01t1: set ACT_CREATE (map does not exist)
cab5a01t1: set ACT_CREATE (map does not exist)
cab5a01t1: domap (0) failure for create/reload map


it's that "domap (0) failure for create/reload map" that looks bad...

Have I  missed something ?

Andrew
