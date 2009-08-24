From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 11:48:36 -0700
Message-ID: <1251139716.24406.4.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090824202915.27815959@pc-jsosic.srce.hr>
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

This is the expected behavior, when IOs on the active path fails, the
hardware handler will activate the passive path and make it active and
start sending IOs thru that newly activated path.

Send MODE_SELECT is how the hardware handler makes the passive path
active. 
On Mon, 2009-08-24 at 20:29 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 11:41:34 -0400 (EDT)
> Charlie Brady <charlieb-dm-devel@budge.apana.org.au> wrote:
> 
> > I know that other people here will know more detail, but I think you
> > have another alternative which might be superior.
> > 
> > Instead of changing the initiator configuration to use AVT, you
> > should tune the device mapper to use RDAC.
> > 
> > To do that, I think you will need to adjust both the multipathd 
> > configuration and recompile the scsi_dh_rdac kernel module after
> > adding support for "SUN"/"LCSM100_S".
> > 
> > Here's the RDAC multipath.conf I am using with a StorageTek 2510:
> > 
> > http://www.linux-archive.org/device-mapper-development/323661-multipathd-configuration-sun-storagetek-2510-a.html
> 
> Aug 24 20:25:55 node03 kernel: device-mapper: multipath: Failing path
> 8:16.
> Aug 24 20:25:55 node03 multipathd: 8:16: mark as failed 
> Aug 24 20:25:55 node03 multipathd: qd: remaining active paths: 1 
> Aug 24 20:25:55 node03 multipathd: dm-0: add map (uevent) 
> Aug 24 20:25:55 node03 multipathd: dm-0: devmap already registered 
> Aug 24 20:25:55 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
> Aug 24 20:25:56 node03 qdiskd[5325]: <notice> Score sufficient for
> master operation (1/1; required=1); upgrading
> Aug 24 20:26:02 node03 multipathd: 8:16: reinstated
> Aug 24 20:26:02 node03 multipathd: qd: remaining active paths: 2
> Aug 24 20:26:02 node03 multipathd: qd: switch to path group #1
> Aug 24 20:26:02 node03 multipathd: qd: switch to path group #1
> Aug 24 20:26:02 node03 multipathd: dm-0: add map (uevent)
> Aug 24 20:26:02 node03 multipathd: dm-0: devmap already registered
> Aug 24 20:26:05 node03 kernel: device-mapper: multipath: Failing path
> 8:16.
> Aug 24 20:26:05 node03 multipathd: 8:16: mark as failed
> Aug 24 20:26:05 node03 multipathd: qd: remaining active paths: 1
> Aug 24 20:26:05 node03 multipathd: dm-0: add map (uevent)
> Aug 24 20:26:05 node03 multipathd: dm-0: devmap already registered
> Aug 24 20:26:05 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
> Aug 24 20:26:12 node03 multipathd: 8:16: reinstated
> Aug 24 20:26:12 node03 multipathd: qd: remaining active paths: 2
> Aug 24 20:26:12 node03 multipathd: qd: switch to path group #1
> Aug 24 20:26:12 node03 multipathd: qd: switch to path group #1
> Aug 24 20:26:12 node03 multipathd: dm-0: add map (uevent)
> Aug 24 20:26:12 node03 multipathd: dm-0: devmap already registered
> Aug 24 20:26:15 node03 kernel: device-mapper: multipath: Failing path
> 8:16.
> Aug 24 20:26:15 node03 multipathd: 8:16: mark as failed
> Aug 24 20:26:15 node03 multipathd: qd: remaining active paths: 1
> Aug 24 20:26:15 node03 multipathd: dm-0: add map (uevent)
> Aug 24 20:26:15 node03 multipathd: dm-0: devmap already registered
> Aug 24 20:26:15 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
> 
> 
> So, your configuration fills my logs too :( I don't know if this is
> supposed to behave this way or not...
> 
> I'm lost now :(
> 
> 
