From: Brian Wong <bwong@pillardata.com>
Subject: Re: EMC CX LUN problem
Date: Tue, 24 Jan 2006 14:28:10 -0800
Message-ID: <1138141690.6009.8.camel@ca-bwong3.trans.corp>
References: <43D69CB0.8020402@theorematica.it>
Reply-To: bwong@pillardata.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43D69CB0.8020402@theorematica.it>
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

On Tue, 2006-01-24 at 22:31 +0100, Nicola Murino wrote:
> Hi,
> 
> I'm trying to configure a new emc cx storage, I have the following:
> 
> 2 server, each server has a qla2462 dual port hba
> each qla2462 is connected to a switch (only one switch)
> 1 emc cx storage with 4 path connected to the switch
> 
> I defined two lun on the storage however I'm able to see only one LUN
> 
> multipath -l show the following:
> 
> multipath -l
> mail (36006016086f01600e46f567adb8cda11)
> [size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
> \_ round-robin 0 [active]
>  \_ 1:0:1:0 sdd 8:48  [active][ready]
>  \_ 1:0:1:1 sde 8:64  [active][ready]
>  \_ 2:0:1:0 sdh 8:112 [active][ready]
>  \_ 2:0:1:1 sdi 8:128 [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 2:0:0:0 sdf 8:80  [active][ready]
>  \_ 1:0:0:0 sdb 8:16  [active][ready]
>  \_ 1:0:0:1 sdc 8:32  [active][ready]
>  \_ 2:0:0:1 sdg 8:96  [active][ready]
> 

i could be off in the weeds here, but this output looks wrong.  the
host:channel:target:lun numbers listed there suggest your cx is indeed
surfacing luns 0 and 1, but multipath is grouping them under a single
target ID.

i think emc engineers monitor this list; perhaps they can help.

also, look at this if you havent already (there's a section on clariion
cx's), and feel free to add your findings.

http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments

hope that helps,

brian
