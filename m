From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 11:38:18 -0700
Message-ID: <1251139098.24406.1.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824174834.35a7038f@pc-jsosic.srce.hr>
	<20090824180058.7cc4edcb@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090824180058.7cc4edcb@pc-jsosic.srce.hr>
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


You need to have a stanza similar to following one for your device
in /etc/multipath.conf
--------------------
devices {
        device {
                vendor                  "IBM"
                product                 "1815"
                path_grouping_policy    group_by_prio
                hardware_handler        "1 rdac"
                path_checker            rdac
                failback                immediate
                no_path_retry           queue
                prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
        }
}
---------------------

On Mon, 2009-08-24 at 18:00 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 17:48:34 +0200
> Jakov Sosic <jakov.sosic@srce.hr> wrote:
> 
> I have this occuring in logs, I presume it is ok?
> 
> Aug 24 17:58:43 node01 multipathd: sdc: readsector0 checker reports
> path is down
> Aug 24 17:58:43 node01 multipathd: checker failed path 8:32 in map
> sas-mysql
> Aug 24 17:58:43 node01 multipathd: sas-mysql: remaining active paths: 1
> Aug 24 17:58:43 node01 kernel: device-mapper: multipath: Failing path
> 8:32.
> Aug 24 17:58:43 node01 multipathd: dm-1: add map (uevent)
> Aug 24 17:58:43 node01 multipathd: dm-1: devmap already registered
> Aug 24 17:58:53 node01 multipathd: sdc: readsector0 checker reports
> path is up
> Aug 24 17:58:53 node01 multipathd: 8:32: reinstated
> Aug 24 17:58:53 node01 multipathd: sas-mysql: remaining active paths: 2
> Aug 24 17:58:53 node01 multipathd: dm-1: add map (uevent)
> Aug 24 17:58:53 node01 multipathd: dm-1: devmap already registered 
> 
> 
> Because multipath -ll says:
> 
> # multipath -ll sas-mysql
> sas-mysql (3600a0b80003abc5c00000b654a916617) dm-1 SUN,LCSM100_S
> [size=115G][features=0][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 1:0:0:1  sdc 8:32  [active][ready]
>  \_ 1:0:1:1  sdf 8:80  [active][ready]
> 
> 
> 
> 
