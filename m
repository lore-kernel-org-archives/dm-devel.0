From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: multipath modules on RHAS4 up5 cause oops
Date: Thu, 24 Jan 2008 10:59:12 -0800
Message-ID: <20080124185912.GA7774@linux.vnet.ibm.com>
References: <4798501C.5000208@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4798501C.5000208@Voltaire.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Erez Zilber <erezz@Voltaire.COM> wrote:
> Starting open-iscsi:
> 
> [root@DBD6 ~]# /etc/init.d/iscsi start
> Starting iSCSI initiator service:                          [  OK  ]
> Setting up iSCSI targets: Login session [192.168.60.224:3260
> iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005]
> Login session [192.168.60.223:3260
> iqn.2000-03.com.falconstor-ipstor.fiona.D2-3]
> Login session [192.168.60.223:3260
> iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4]
>                                                            [  OK  ]
> Starting multipath:
> 
> [root@DBD6 ~]# /etc/init.d/multipathd start
> Starting multipathd daemon:                                [  OK  ]
> 
> Now, we have some iSCSI sessions:
> 
> [root@DBD6 ~]# iscsiadm -m session
> iser: [1] 192.168.60.224:3260,0
> iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005
> iser: [2] 192.168.60.223:3260,0 iqn.2000-03.com.falconstor-ipstor.fiona.D2-3
> iser: [3] 192.168.60.223:3260,0
> iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4
> 
> Stopping multipath:
> 
> [root@DBD6 ~]# /etc/init.d/multipathd stop
> Stopping multipathd daemon:                                [  OK  ]
> 

Stopping multipathd will result in no listener for events to cleanup the
multipath tables if devices are removed. If you leave multipathd running
and just start and stop iscsi do things work correctly?

> Stopping open-iscsi:
> 
> [root@DBD6 ~]# /etc/init.d/iscsi stop
> Stopping iSCSI initiator service: Logout session [1][192.168.60.224:3260
> iqn.2000-03.com.falconstor-ipstor.sr4g.Everyone-iSCSI-10005]
> Logout session [2][192.168.60.223:3260
> iqn.2000-03.com.falconstor-ipstor.fiona.D2-3]
> Logout session [3][192.168.60.223:3260
> iqn.2000-03.com.falconstor-ipstor.fiona.Everyone-iSCSI-4]
>                                                            [  OK  ]
> 
> Now, the multipath module is still running (I'm not sure if that's a
> problem):
> 

No, the modules being loaded in the kernel is ok even if you have no
multipath tables loaded.

> [root@DBD6 ~]# lsmod|grep mul
> dm_multipath           22865  2 dm_round_robin
> dm_mod                 74153  10 dm_mirror,dm_multipath
> 
> Looking at the multipath devices returns strange results (since the
> iSCSI devices are already gone):
> 

The strange status below is the result of the devices being in the process
of being removed, but the multipath table still contain entries for these
devices.

> [root@DBD6 ~]# multipath -l
> mpath1 (3600d02300063ccc6000000018031a702)
> [size=21 GB][features="1 queue_if_no_path"][hwhandler="0"]
> \_ round-robin 0 [active]
>  \_ #:#:#:#  -   8:32 [active]
> 
> mpath0 (3600d02300063ccc6000000018031a701)
> [size=20 GB][features="1 queue_if_no_path"][hwhandler="0"]
> \_ round-robin 0 [enabled]
>  \_ #:#:#:#  -   8:48 [active]
> \_ round-robin 0 [enabled]
>  \_ #:#:#:#  -   8:16 [active]
> 
> .. snip ..
> 
> Now, some questions:
> 
>    1. Is it a known bug
>    2. If yes, is there any workaround?

If you leave multipathd running it should effect your error case in a
postive way.

>    3. Is there a newer version of dm that works ok on RHAS4 up5? Which
>       version?
>    4. In RHEL5, this test seems to work ok, but I see that after running
>       /etc/init.d/multipath stop, the dm modules are still running. Why?
>    5. IN RHEL5, if I do the following:
>          1. start open-iscsi
>          2. start multipath
>          3. stop multipath
>          4. stop open-iscsi
>          5. start open-iscsi - now running 'multipath -l' shows the
>             multipath devices althoguh the multipath service is stopped.
>             Why?

Previously I had run some experiments with FC removal and multipath
devices. The version are not a direct match to your test case, but show
that event processing does work.

Here is a url to the old email.
http://permalink.gmane.org/gmane.linux.scsi/36165

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
