From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: [Bug 164617] extracting tar image causes paths state
	change to[ready][failed]
Date: Fri, 29 Jul 2005 18:20:27 +0200
Message-ID: <1122654027.9191.7.camel@zezette>
References: <3456F611E9329441B12FBB24447B3FA00261D741@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3456F611E9329441B12FBB24447B3FA00261D741@bgeexc01.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Do you reproduce with "selinux=0" kernel boot-time param ?
Also you can try resolving why /bin/true doesn't work in your system.

If your objective is to help upstream development, you really should
upgrade to latest dev snapshot. On the other hand, if you want to
qualify RHEL with your hardware, you should use their package and make
that clear in your bug report, which is not the case here :

<quote>
"Version-Release number of selected component (if applicable):
kernel - 2.6.9-6.37.ELsmp, multipath tools-0.4.4,
device-mapper-1.01.00-3.RHEL4"
</quote>

Regards,
cvaroqui

On ven, 2005-07-29 at 20:46 +0530, Murthy, Narasimha Doraswamy (STSD)
wrote:
> Yes, the daemon was running. Attached is the /var/log/messages output.
> 
> The DM block device status before extracting the tar ball:
> 
> [root@lxeagle mnt]# multipath -ll mp1
> mp1
> [size=4 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 12:0:0:2 sdb  8:16    [ready ][active]
>   \_ 13:0:0:2 sdn  8:208   [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 12:0:1:2 sde  8:64    [ready ][active]
>   \_ 13:0:1:2 sdq  65:0    [ready ][active]
> 
> 
> 
> After invoking the extract using "tar -xvf"
> 
> [root@lxeagle mnt]# multipath -ll mp1
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> error calling out /bin/true
> mp1
> [size=4 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 12:0:0:2 sdb  8:16    [ready ][failed]
>   \_ 13:0:0:2 sdn  8:208   [ready ][failed]
> \_ round-robin 0 [enabled]
>   \_ 12:0:1:2 sde  8:64    [ready ][failed]
>   \_ 13:0:1:2 sdq  65:0    [ready ][failed]
> 
> 
> The same test passes with ext3 filesystem. 
> 
> Thanks and regards
> -Murthy
> 
> 
> 
> -----Original Message-----
> From: christophe varoqui [mailto:christophe.varoqui@free.fr] 
> Sent: Friday, July 29, 2005 7:05 PM
> To: Murthy, Narasimha Doraswamy (STSD)
> Cc: device-mapper development
> Subject: [Bug 164617] extracting tar image causes paths state change
> to[ready][failed]
> 
> Will provide the following additional info :
> 
> Was the daemon runing ?
> If so paste a verbose daemon log.
> Paste a dmesg too.
> 
> Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
