From: Trevor Astrope <astrope@tabbweb.com>
Subject: Multipath with Hitachi DF600F
Date: Fri, 13 Jul 2007 10:27:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0707131007240.11794@jimi.tabbweb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
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

Hello,

I would like to use device mapper multipath with our Hitachi DF600F under 
rhel5 to avoid having to use Storage Foundation, as it is the only other 
multipath option available, since hdlm isn't yet supported under rhel5.

I spoke with my Hitachi rep who said that dm multipath also isn't 
supported by Hitachi and that there are known issues with it where the 
multipath fail over does not always work. I'm wondering if anyone could 
tell me what these issues are and if anyone is using dm multipath in a 
production environment and what their experiences are, both good and bad.

We are using rhel5 x86_64 on a Sunfire X4600 machine with Emulex 
LPE11000-S hba's that are directly attached to the DF600f. I am using 
pp_hds_modular v1.14 that our Hitachi rep sent me instead of the 
mpath_prio_hds_modular driver that came with the device-mapper-multipath 
package, since it is only v1.12.

Everything works fine when I disconnect one of the cables to an hba. The 
lun is detected as faulty and the other path is used. The path switches 
back when the cable is reconnected. The Hitachi rep is coming in next week 
to do a microcode update, so I will see if it works then. He says he has 
customers that use dm multipath that had problems when he did a microcode 
update...

One thing I did notice is that when the devices were marked as faulty, 
multipath -ll still showed that path as being enabled. Shouldn't it 
display the other path as enabled when a device is faulty?

Here is the output:

# multipath -ll
sdb: checker msg is "readsector0 checker reports path is down"
sdc: checker msg is "readsector0 checker reports path is down"
sdd: checker msg is "readsector0 checker reports path is down"
sde: checker msg is "readsector0 checker reports path is down"
1HITACHI_D60052410002dm-2 HITACHI,DF600F
[size=166G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
  \_ 2:0:0:2 sdg 8:96  [active][ready]
\_ round-robin 0 [prio=0][enabled]
  \_ 1:0:0:2 sdc 8:32  [failed][faulty]
1HITACHI_D60052410001dm-1 HITACHI,DF600F
[size=166G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
  \_ 1:0:0:1 sdb 8:16  [failed][faulty]
\_ round-robin 0 [prio=0][enabled]
  \_ 2:0:0:1 sdf 8:80  [active][ready]
1HITACHI_D60052410004dm-4 HITACHI,DF600F
[size=166G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
  \_ 2:0:0:4 sdi 8:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
  \_ 1:0:0:4 sde 8:64  [failed][faulty]
1HITACHI_D60052410003dm-3 HITACHI,DF600F
[size=166G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
  \_ 1:0:0:3 sdd 8:48  [failed][faulty]
\_ round-robin 0 [prio=0][enabled]
  \_ 2:0:0:3 sdh 8:112 [active][ready]


Any info or advice is appreciated.

Thanks,

Trevor
