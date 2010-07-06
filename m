From: Bart Coninckx <bart.coninckx@telenet.be>
Subject: Re: understanding of multipathing and speed
Date: Tue, 6 Jul 2010 06:16:55 +0200
Message-ID: <201007060616.55657.bart.coninckx@telenet.be>
References: <201007052037.39362.bart.coninckx@telenet.be>
	<1278356310.30539.606.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1278356310.30539.606.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

On Monday 05 July 2010 20:58:30 Christophe Varoqui wrote:
> On lun., 2010-07-05 at 20:37 +0200, Bart Coninckx wrote:
> > Hi,
> >
> > I would like to run my ideas by this list about multipathing and the
> > results as far as storage speed is concerned.
> >
> > I'm using multipathing to two iSCSI targets pointing to the same storage.
> > It was my understanding that this provides for network path redundancy
> > (and it does, I tested this) but also for added speed.
> > I did some tests with Bonnie++ however while both paths were active and
> > one path was down and the results are basically the same.
> >
> > Am I assuming wrong things? Or have I configured things wrong?
> 
> can you also include a 'multipath -l' output and sketch the
> hba/switch/controller physical connections ?
> 
> thanks,
> 

Sure,

xen3:~ # multipath -l
lx03 (1494554000000000000000000010000000000000002000000) dm-3 IET,VIRTUAL-DISK
[size=10G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=-2][active]
 \_ 2:0:0:0 sdc 8:32  [active][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]
ws033 (1494554000000000000000000010000000100000002000000) dm-2 IET,VIRTUAL-
DISK
[size=15G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=-2][active]
 \_ 2:0:0:1 sde 8:64  [active][undef]
 \_ 1:0:0:1 sdd 8:48  [active][undef]
ms01 (1494554000000000000000000010000000200000002000000) dm-1 IET,VIRTUAL-DISK
[size=40G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=-2][active]
 \_ 1:0:0:2 sdf 8:80  [active][undef]
 \_ 2:0:0:2 sdg 8:96  [active][undef]

I have two Gigabit NICs in this server each running over a separate switch to 
a separate gigabit NIC with a unique IP address on the storage IET iSCSI 
target.

Is this sufficient info?

Thx,

Bart
