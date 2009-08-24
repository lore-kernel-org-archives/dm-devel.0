From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 13:57:31 -0700
Message-ID: <1251147451.24406.28.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
	<1251145497.24406.18.camel@chandra-ubuntu>
	<20090824223627.6e1a918c@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090824223627.6e1a918c@pc-jsosic.srce.hr>
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


On Mon, 2009-08-24 at 22:36 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 13:24:57 -0700
> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> 
> > Have you verified there is no physical issues with the path ?
> 
> Yes, because both paths are flopping, and other LUN's on the same
> path's are not flopping as much - but are not written as much. This is
> a quorum disk for RHEL cluster that is flopping constantly.
> 
> Aug 24 20:47:38 node03 multipathd: 8:16: reinstated 
> Aug 24 20:47:38 node03 multipathd: 8:64: reinstated 
> Aug 24 20:47:38 node03 multipathd: qd: remaining active paths: 2 
> Aug 24 20:47:38 node03 multipathd: qd: switch to path group #2 
> Aug 24 20:47:38 node03 multipathd: qd: switch to path group #2 
> Aug 24 20:47:38 node03 multipathd: dm-0: add map (uevent) 
> Aug 24 20:47:38 node03 multipathd: dm-0: devmap already registered 
> Aug 24 20:47:47 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
> Aug 24 20:47:48 node03 openais[5236]: [CMAN ] lost contact with quorum device
> Aug 24 20:47:58 node03 multipathd: dm-0: add map (uevent) 
> Aug 24 20:47:58 node03 multipathd: dm-0: devmap already registered 
> Aug 24 20:47:58 node03 multipathd: 8:64: mark as failed 
> Aug 24 20:47:58 node03 kernel: end_request: I/O error, dev sde, sector 8

This does mean that the IO had really failed in that path....

> Aug 24 20:47:58 node03 multipathd: qd: remaining active paths: 1 
> Aug 24 20:47:58 node03 kernel: device-mapper: multipath: Failing path 8:64.

... based on which the kernel failed the path....

> Aug 24 20:47:58 node03 kernel: sd 1:0:0:0: queueing MODE_SELECT command.
> Aug 24 20:48:07 node03 multipathd: 8:64: reinstated

... only after 10 seconds the path is back.

If you are up for debugging, we can try putting some debug to see if we
are getting any sense information along with the IO failure.

> Aug 24 20:48:07 node03 multipathd: qd: remaining active paths: 2
> Aug 24 20:48:07 node03 multipathd: qd: switch to path group #2
> Aug 24 20:48:07 node03 multipathd: qd: switch to path group #2
> Aug 24 20:48:07 node03 multipathd: dm-0: add map (uevent)
> Aug 24 20:48:07 node03 multipathd: dm-0: devmap already registered
> Aug 24 20:48:07 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
> Aug 24 20:48:17 node03 multipathd: 8:64: reinstated 
> 
