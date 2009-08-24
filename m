From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 20:55:29 +0200
Message-ID: <20090824205529.6b78aa3a@pc-jsosic.srce.hr>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824174834.35a7038f@pc-jsosic.srce.hr>
	<20090824180058.7cc4edcb@pc-jsosic.srce.hr>
	<1251139098.24406.1.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251139098.24406.1.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 24 Aug 2009 11:38:18 -0700
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> 
> You need to have a stanza similar to following one for your device
> in /etc/multipath.conf
> --------------------
> devices {
>         device {
>                 vendor                  "IBM"
>                 product                 "1815"
>                 path_grouping_policy    group_by_prio
>                 hardware_handler        "1 rdac"
>                 path_checker            rdac
>                 failback                immediate
>                 no_path_retry           queue
>                 prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>         }
> }
> ---------------------

Hi!

Yes, I've added that section, and still I get these:

Aug 24 20:47:38 node03 multipathd: 8:16: reinstated 
Aug 24 20:47:38 node03 multipathd: 8:64: reinstated 
Aug 24 20:47:38 node03 multipathd: qd: remaining active paths: 2 
Aug 24 20:47:38 node03 multipathd: qd: switch to path group #2 
Aug 24 20:47:38 node03 multipathd: qd: switch to path group #2 
Aug 24 20:47:38 node03 multipathd: dm-0: add map (uevent) 
Aug 24 20:47:38 node03 multipathd: dm-0: devmap already registered 
Aug 24 20:47:47 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
Aug 24 20:47:48 node03 openais[5236]: [CMAN ] lost contact with quorum
device
Aug 24 20:47:58 node03 multipathd: dm-0: add map (uevent) 
Aug 24 20:47:58 node03 multipathd: dm-0: devmap already registered 
Aug 24 20:47:58 node03 multipathd: 8:64: mark as failed 
Aug 24 20:47:58 node03 kernel: end_request: I/O error, dev sde, sector 8
Aug 24 20:47:58 node03 multipathd: qd: remaining active paths: 1 
Aug 24 20:47:58 node03 kernel: device-mapper: multipath: Failing path
8:64.
Aug 24 20:47:58 node03 kernel: sd 1:0:0:0: queueing MODE_SELECT
command.
Aug 24 20:48:07 node03 multipathd: 8:64: reinstated
Aug 24 20:48:07 node03 multipathd: qd: remaining active paths: 2
Aug 24 20:48:07 node03 multipathd: qd: switch to path group #2
Aug 24 20:48:07 node03 multipathd: qd: switch to path group #2
Aug 24 20:48:07 node03 multipathd: dm-0: add map (uevent)
Aug 24 20:48:07 node03 multipathd: dm-0: devmap already registered
Aug 24 20:48:07 node03 kernel: sd 1:0:1:0: queueing MODE_SELECT command.
Aug 24 20:48:17 node03 multipathd: 8:64: reinstated 




So it does not work ok :(

So far I've tried:

1. defaults with initiators set to "Linux"
   one path constantly failed
2. AVT with initiators set to "Solaris (with Veritas DMP or other)"
   multipath flopping constantly - every 20 minutes there is enter in
   main log about path failing
3. RDAC with initiators set to "Linux"
   logs filled with messages like these show up in the message,
   constantly flip/flopping

I haven't patch scsi_dh_rdac because I don't know how to add support
for "SUN"/"LCSM100_S", and although I could figure it out, I'm not
really a fan of compiling the kernel if it is not absolutely necessary.


-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
