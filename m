From: Markus <dieoma@gmail.com>
Subject: Multipath only round-robin
Date: Mon, 11 Sep 2006 11:56:57 +0200
Message-ID: <e9cb6ff40609110256v12ffeba5ud77127450c9ce566@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello together,

I set up a testenviroment with 2xQLA2342 and have a active-active
capable Disk. I see the LUN 4 times which is fine and multipathed it
successfully to one. Failover works fine but writing is a bit "fuzzy"
since he only uses one path for 3sec or so and then the other path for
3 seconds - so a clearly "round-robin" bevaviour. As you can see in my
multipath.conf it should use multibus - so why is he doing this? I
think i saw an option in the multipath.conf but i don=B4t know which
value is "sensefull"...
Also i=B4am not sure why multipath says [undef] ?

Here some details:

linux-m8u1:/mnt # multipath -l
myisecondmultipath (36000d7700000030644cb1a8097fc3936) FALCON,IPSTOR DISK
[size=3D19G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 2:0:0:1 sdc 8:32  [active][undef]
 \_ 2:0:1:1 sde 8:64  [active][undef]
 \_ 3:0:0:1 sdg 8:96  [active][undef]
 \_ 3:0:1:1 sdi 8:128 [active][undef]
myfirstmultipath (36000d77e00001e9a50d21a80a0506232) FALCON,IPSTOR DISK
[size=3D2G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 2:0:0:0 sdb 8:16  [active][undef]
 \_ 2:0:1:0 sdd 8:48  [active][undef]
 \_ 3:0:0:0 sdf 8:80  [active][undef]
 \_ 3:0:1:0 sdh 8:112 [active][undef]

why does he say [undef] ???

Here the multipath.conf:

defaults {
        multipath_tool  "/sbin/multipath"
        # udev_dir      /dev
        # polling_interval 10
        # Pfadpr=C3=BCfinterval
        polling_interval 5

        # Queue IO for 36*5=3D180 Seconds=3D3min
(retries*polling_interval) then fail IO
        # 3 min=3Ddefault dynapath timeout
        no_path_retry 36

        # default_selector round-robin
        # default_selector_args 0

        default_path_grouping_policy    multibus
        # default_getuid_callout        "/sbin/scsi_id -g -u -s /block/%n=
"
        #default_prio_callout    "/etc/multipath_get_prio %n"
        #default_prio_callout    "/bin/false"
}

#
# name    : multipaths
# scope   : multipath & multipathd
# desc    : list of multipaths finest-grained settings

multipaths {
        multipath {
                wwid                    36000d77e00001e9a50d21a80a0506232
                alias                   myfirstmultipath
        }
        multipath {
                wwid                    36000d7700000030644cb1a8097fc3936
                alias                   myisecondmultipath
        }
}

uname -a
Linux linux-m8u1 2.6.16.21-0.8-smp #1 SMP Mon Jul 3 18:25:39 UTC 2006
i686 i686 i386 GNU/Linux

Hopefully someone could shine some light on that...

Thanks in advance
Markus
