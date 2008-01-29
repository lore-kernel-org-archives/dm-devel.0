From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: Problem using dm-multipath on first of 2 LUNs on system
Date: Tue, 29 Jan 2008 10:57:03 -0800
Message-ID: <1201633023.2634.88.camel@linuxchandra>
References: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
	<008b01c86298$3c1a3280$0602a8c0@sams>
	<08F3F42DB42FBF4E87512A3AB4596D4A03F72CC0@HERSHEY.aeo.ae.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CC0@HERSHEY.aeo.ae.com>
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

Hi,

Do you use LVM in this machine ? If yes, that would clarify why dm-0
thru dm-5 is used.

Can you send the o/p of "dmsetup ls" and "dmsetup table".

regards,

chandra
On Tue, 2008-01-29 at 12:17 -0500, LittleJ@AE.com wrote:
> I am not specifically blacklisting the /dev/dm-X devices.  The
> 5 /dev/dm-X devices on my system correspond to the 5 device special
> files in /dev/mapper on the second LUN that dm-multipath is currently
> managing.
>=20
> =20
>=20
> [root@svwdcvispay01 ~]# cd /dev/mapper
>=20
> [root@svwdcvispay01 mapper]# ls -la
>=20
> total 0
>=20
> drwxr-xr-x  2 root root     160 Jan 29 11:47 .
>=20
> drwxr-xr-x  9 root root    4900 Jan 29 11:44 ..
>=20
> crw-------  1 root root  10, 63 Jan 29 11:44 control
>=20
> brw-rw----  1 root disk 253,  0 Jan 29 11:44 mpath1
>=20
> brw-rw----  1 root disk 253,  1 Jan 29 11:44 mpath1p1
>=20
> brw-rw----  1 root disk 253,  2 Jan 29 11:44 mpath1p2
>=20
> brw-rw----  1 root disk 253,  3 Jan 29 11:44 mpath1p3
>=20
> brw-rw----  1 root disk 253,  4 Jan 29 11:44 mpath1p5
>=20
> [root@svwdcvispay01 mapper]# ls -la /dev/dm*
>=20
> brw-r-----  1 root root 253, 0 Jan 29 11:44 /dev/dm-0
>=20
> brw-r-----  1 root root 253, 1 Jan 29 11:44 /dev/dm-1
>=20
> brw-r-----  1 root root 253, 2 Jan 29 11:44 /dev/dm-2
>=20
> brw-r-----  1 root root 253, 3 Jan 29 11:44 /dev/dm-3
>=20
> brw-r-----  1 root root 253, 4 Jan 29 11:44 /dev/dm-4
>=20
> [root@svwdcvispay01 mapper]#
>=20
> =20
>=20
> I believe that dm-multipath is internally blacklisting those devices.
> Notice if I execute `dmsetup remove_all` which removes all
> the /dev/mapper/mpath1* files and then recreate them that dm-multipath
> creates 5 new /dev/dm-* files:
>=20
> =20
>=20
> [root@svwdcvispay01 mapper]# dmsetup remove_all
>=20
> [root@svwdcvispay01 mapper]# ls -la
>=20
> total 0
>=20
> drwxr-xr-x  2 root root     60 Jan 29 12:09 .
>=20
> drwxr-xr-x  9 root root   4900 Jan 29 11:44 ..
>=20
> crw-------  1 root root 10, 63 Jan 29 11:44 control
>=20
> =20
>=20
> [root@svwdcvispay01 mapper]# ls -la /dev/dm*
>=20
> brw-r-----  1 root root 253, 0 Jan 29 11:44 /dev/dm-0
>=20
> brw-r-----  1 root root 253, 1 Jan 29 11:44 /dev/dm-1
>=20
> brw-r-----  1 root root 253, 2 Jan 29 11:44 /dev/dm-2
>=20
> brw-r-----  1 root root 253, 3 Jan 29 11:44 /dev/dm-3
>=20
> brw-r-----  1 root root 253, 4 Jan 29 11:44 /dev/dm-4
>=20
> =20
>=20
> [root@svwdcvispay01 mapper]# multipath
>=20
> create: mpath1 (36005076801810085c8000000000001a2)
>=20
> [size=3D50 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [prio=3D50]
>=20
>  \_ 1:0:1:1 sdd 8:48 [ready]
>=20
> \_ round-robin 0 [prio=3D10]
>=20
>  \_ 1:0:0:1 sdb 8:16 [ready]
>=20
> =20
>=20
> [root@svwdcvispay01 mapper]# ls -la
>=20
> total 0
>=20
> drwxr-xr-x  2 root root     160 Jan 29 12:09 .
>=20
> drwxr-xr-x  9 root root    5000 Jan 29 12:09 ..
>=20
> crw-------  1 root root  10, 63 Jan 29 11:44 control
>=20
> brw-rw----  1 root disk 253,  5 Jan 29 12:09 mpath1
>=20
> brw-rw----  1 root disk 253,  6 Jan 29 12:09 mpath1p1
>=20
> brw-rw----  1 root disk 253,  7 Jan 29 12:09 mpath1p2
>=20
> brw-rw----  1 root disk 253,  8 Jan 29 12:09 mpath1p3
>=20
> brw-rw----  1 root disk 253,  9 Jan 29 12:09 mpath1p5
>=20
> =20
>=20
> [root@svwdcvispay01 mapper]# ls -la /dev/dm*
>=20
> brw-r-----  1 root root 253, 0 Jan 29 11:44 /dev/dm-0
>=20
> brw-r-----  1 root root 253, 1 Jan 29 11:44 /dev/dm-1
>=20
> brw-r-----  1 root root 253, 2 Jan 29 11:44 /dev/dm-2
>=20
> brw-r-----  1 root root 253, 3 Jan 29 11:44 /dev/dm-3
>=20
> brw-r-----  1 root root 253, 4 Jan 29 11:44 /dev/dm-4
>=20
> brw-r-----  1 root root 253, 5 Jan 29 12:09 /dev/dm-5
>=20
> brw-r-----  1 root root 253, 6 Jan 29 12:09 /dev/dm-6
>=20
> brw-r-----  1 root root 253, 7 Jan 29 12:09 /dev/dm-7
>=20
> brw-r-----  1 root root 253, 8 Jan 29 12:09 /dev/dm-8
>=20
> brw-r-----  1 root root 253, 9 Jan 29 12:09 /dev/dm-9
>=20
> [root@svwdcvispay01 mapper]#=20
>=20
> =20
>=20
> Notice also that the blacklist has been automatically extended to
> cover the 5 new /dev/dm-X devices:
>=20
> =20
>=20
> [root@svwdcvispay01 mapper]# multipath -v3 | more
>=20
> load path identifiers cache
>=20
> #
>=20
> # all paths in cache :
>=20
> #
>=20
> 36005076801810085c800000000000194  1:0:0:0 sda 8:0   IBM     /2145
>=20
> 36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10 [active]
> IBM     /2145
>=20
> 36005076801810085c800000000000194  1:0:1:0 sdc 8:32   IBM     /2145
>=20
> 36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50 [active]
> IBM     /2145
>=20
> dm-0 blacklisted
>=20
> dm-1 blacklisted
>=20
> dm-2 blacklisted
>=20
> dm-3 blacklisted
>=20
> dm-4 blacklisted
>=20
> dm-5 blacklisted
>=20
> dm-6 blacklisted
>=20
> dm-7 blacklisted
>=20
> dm-8 blacklisted
>=20
> dm-9 blacklisted
>=20
> =E2=80=A6
>=20
> =20
>=20
> When I reboot the server dm-5 through dm-9 are gone and it is again
> using dm-0 through dm-4.
>=20
> =20
>=20
> Joe Little
>=20
> littlej@ae.com
>=20
> =20
>=20
> =20
>=20
> =20
>=20
> =20
>=20
>                                   =20
> ______________________________________________________________________
>=20
> From:dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Gerald Nowitzky
> Sent: Tuesday, January 29, 2008 11:59 AM
> To: device-mapper development
> Subject: Re: [dm-devel] Problem using dm-multipath on first of 2 LUNs
> on system
>=20
>=20
> =20
>=20
> try and remove dm-0 to dm-4 from the blacklist. The devices
> in /dev/mapper are links to /dev/dm-x
>=20
>=20
> (Gerald)
>=20
>=20
>         ----- Original Message -----=20
>        =20
>        =20
>         From: LittleJ@AE.com=20
>        =20
>        =20
>         To: dm-devel@redhat.com=20
>        =20
>        =20
>         Sent: Tuesday, January 29, 2008 4:42 PM
>        =20
>        =20
>         Subject: [dm-devel] Problem using dm-multipath on first of 2
>         LUNs on system
>        =20
>        =20
>         =20
>        =20
>        =20
>         I am attempting to implement dm-multipath on a RHEL4U6 server
>         and I have been successful in enabling it on the second of 2
>         LUNs on the server but for whatever reason it will not create
>         the device special files in /dev/mapper for the fist LUN.
>         `multipath =E2=80=93d` shows that it identifies the first LUN a=
nd
>         wants to create the mpath0 files:
>        =20
>         =20
>        =20
>         [root@svwdcvispay01 etc]# multipath -d
>        =20
>         create: mpath0 (36005076801810085c800000000000194)
>        =20
>         [size=3D12 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"=
]
>        =20
>         \_ round-robin 0 [prio=3D50]
>        =20
>          \_ 1:0:0:0 sda 8:0  [ready]
>        =20
>         \_ round-robin 0 [prio=3D10]
>        =20
>          \_ 1:0:1:0 sdc 8:32 [ready]
>        =20
>         =20
>        =20
>         switchpg: mpath1 (36005076801810085c8000000000001a2)
>        =20
>         [size=3D50 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"=
]
>        =20
>         \_ round-robin 0 [prio=3D50]
>        =20
>          \_ 1:0:1:1 sdd 8:48 [active][ready]
>        =20
>         \_ round-robin 0 [prio=3D10]
>        =20
>          \_ 1:0:0:1 sdb 8:16 [active][ready]
>        =20
>         =20
>        =20
>         [root@svwdcvispay01 etc]#
>        =20
>         =20
>        =20
>         =20
>        =20
>         However `multipath =E2=80=93v3` generates a =E2=80=9Cset ACT_CR=
EATE: map does
>         not exists=E2=80=9D error in the mpath0 section:
>        =20
>         =20
>        =20
>         [root@svwdcvispay01 etc]# multipath -v3
>        =20
>         load path identifiers cache
>        =20
>         #
>        =20
>         # all paths in cache :
>        =20
>         #
>        =20
>         36005076801810085c800000000000194  1:0:0:0 sda 8:0
>         IBM     /2145
>        =20
>         36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10
>         [active] IBM     /2145
>        =20
>         36005076801810085c800000000000194  1:0:1:0 sdc 8:32
>         IBM     /2145
>        =20
>         36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50
>         [active] IBM     /2145
>        =20
>         dm-0 blacklisted
>        =20
>         dm-1 blacklisted
>        =20
>         dm-2 blacklisted
>        =20
>         dm-3 blacklisted
>        =20
>         dm-4 blacklisted
>        =20
>         md0 blacklisted
>        =20
>         ram0 blacklisted
>        =20
>         ram10 blacklisted
>        =20
>         ram11 blacklisted
>        =20
>         ram12 blacklisted
>        =20
>         ram13 blacklisted
>        =20
>         ram14 blacklisted
>        =20
>         ram15 blacklisted
>        =20
>         ram1 blacklisted
>        =20
>         ram2 blacklisted
>        =20
>         ram3 blacklisted
>        =20
>         ram4 blacklisted
>        =20
>         ram5 blacklisted
>        =20
>         ram6 blacklisted
>        =20
>         ram7 blacklisted
>        =20
>         ram8 blacklisted
>        =20
>         ram9 blacklisted
>        =20
>         =3D=3D=3D=3D=3D path info sda (mask 0x1f) =3D=3D=3D=3D=3D
>        =20
>         bus =3D 1
>        =20
>         dev_t =3D 8:0
>        =20
>         size =3D 25165824
>        =20
>         vendor =3D IBM
>        =20
>         product =3D 2145
>        =20
>         rev =3D 0000
>        =20
>         h:b:t:l =3D 1:0:0:0
>        =20
>         tgt_node_name =3D 0x50050768010010b9
>        =20
>         serial =3D 020060402172XX00
>        =20
>         path checker =3D tur (controler setting)
>        =20
>         state =3D 2
>        =20
>         getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)
>        =20
>         prio =3D 50
>        =20
>         uid =3D 36005076801810085c800000000000194 (cache)
>        =20
>         =3D=3D=3D=3D=3D path info sdb (mask 0x1f) =3D=3D=3D=3D=3D
>        =20
>         bus =3D 1
>        =20
>         dev_t =3D 8:16
>        =20
>         size =3D 104857600
>        =20
>         vendor =3D IBM
>        =20
>         product =3D 2145
>        =20
>         rev =3D 0000
>        =20
>         h:b:t:l =3D 1:0:0:1
>        =20
>         tgt_node_name =3D 0x50050768010010b9
>        =20
>         serial =3D 020060402172XX00
>        =20
>         path checker =3D tur (controler setting)
>        =20
>         state =3D 2
>        =20
>         getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)
>        =20
>         prio =3D 10
>        =20
>         uid =3D 36005076801810085c8000000000001a2 (cache)
>        =20
>         =3D=3D=3D=3D=3D path info sdc (mask 0x1f) =3D=3D=3D=3D=3D
>        =20
>         bus =3D 1
>        =20
>         dev_t =3D 8:32
>        =20
>         size =3D 25165824
>        =20
>         vendor =3D IBM
>        =20
>         product =3D 2145
>        =20
>         rev =3D 0000
>        =20
>         h:b:t:l =3D 1:0:1:0
>        =20
>         tgt_node_name =3D 0x5005076801001082
>        =20
>         serial =3D 020060402172XX00
>        =20
>         path checker =3D tur (controler setting)
>        =20
>         state =3D 2
>        =20
>         getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)
>        =20
>         prio =3D 10
>        =20
>         uid =3D 36005076801810085c800000000000194 (cache)
>        =20
>         =3D=3D=3D=3D=3D path info sdd (mask 0x1f) =3D=3D=3D=3D=3D
>        =20
>         bus =3D 1
>        =20
>         dev_t =3D 8:48
>        =20
>         size =3D 104857600
>        =20
>         vendor =3D IBM
>        =20
>         product =3D 2145
>        =20
>         rev =3D 0000
>        =20
>         h:b:t:l =3D 1:0:1:1
>        =20
>         tgt_node_name =3D 0x5005076801001082
>        =20
>         serial =3D 020060402172XX00
>        =20
>         path checker =3D tur (controler setting)
>        =20
>         state =3D 2
>        =20
>         getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)
>        =20
>         prio =3D 50
>        =20
>         uid =3D 36005076801810085c8000000000001a2 (cache)
>        =20
>         #
>        =20
>         # all paths :
>        =20
>         #
>        =20
>         36005076801810085c800000000000194  1:0:0:0 sda 8:0 50 [ready]
>         IBM     /2145
>        =20
>         36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10
>         [active][ready] IBM
>        =20
>         36005076801810085c800000000000194  1:0:1:0 sdc 8:32 10 [ready]
>         IBM     /2145
>        =20
>         36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50
>         [active][ready] IBM
>        =20
>         params =3D 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 1000
>         round-robin 0 1 1 8:16 1000
>        =20
>         status =3D 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 8:16 A 0
>        =20
>         Found matching wwid [36005076801810085c800000000000194] in
>         bindings file.
>        =20
>         Setting alias to mpath0
>        =20
>         pgpolicy =3D group_by_prio (controler setting)
>        =20
>         selector =3D round-robin 0 (internal default)
>        =20
>         features =3D 1 queue_if_no_path (controler setting)
>        =20
>         hwhandler =3D 0 (controler setting)
>        =20
>         rr_weight =3D 1 (internal default)
>        =20
>         rr_min_io =3D 1000 (config file default)
>        =20
>         no_path_retry =3D NONE (internal default)
>        =20
>         pg_timeout =3D NONE (internal default)
>        =20
>         0 25165824 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1
>         1 8:0 1000 round-robin 0 1 1 8:32 1000
>        =20
>         set ACT_CREATE: map does not exists
>        =20
>         Found matching wwid [36005076801810085c8000000000001a2] in
>         bindings file.
>        =20
>         Setting alias to mpath1
>        =20
>         pgpolicy =3D group_by_prio (controler setting)
>        =20
>         selector =3D round-robin 0 (internal default)
>        =20
>         features =3D 1 queue_if_no_path (controler setting)
>        =20
>         hwhandler =3D 0 (controler setting)
>        =20
>         rr_weight =3D 1 (internal default)
>        =20
>         rr_min_io =3D 1000 (config file default)
>        =20
>         no_path_retry =3D NONE (internal default)
>        =20
>         pg_timeout =3D NONE (internal default)
>        =20
>         0 104857600 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1
>         1 8:48 1000 round-robin 0 1 1 8:16 1000
>        =20
>         set ACT_NOTHING: map unchanged
>        =20
>         [root@svwdcvispay01 etc]#
>        =20
>         =20
>        =20
>         =20
>        =20
>         And notice that no /dev/mapper/mpath0 device special files
>         were created:
>        =20
>         =20
>        =20
>         [root@svwdcvispay01 etc]# ls -la /dev/mapper
>        =20
>         total 0
>        =20
>         drwxr-xr-x  2 root root     160 Jan 29 09:53 .
>        =20
>         drwxr-xr-x  9 root root    4900 Jan 29 09:51 ..
>        =20
>         crw-------  1 root root  10, 63 Jan 21 16:15 control
>        =20
>         brw-rw----  1 root disk 253,  0 Jan 21 16:15 mpath1
>        =20
>         brw-rw----  1 root disk 253,  1 Jan 21 16:15 mpath1p1
>        =20
>         brw-rw----  1 root disk 253,  2 Jan 21 16:15 mpath1p2
>        =20
>         brw-rw----  1 root disk 253,  3 Jan 21 16:15 mpath1p3
>        =20
>         brw-rw----  1 root disk 253,  4 Jan 21 16:15 mpath1p5
>        =20
>         [root@svwdcvispay01 etc]#
>        =20
>         =20
>        =20
>         My /etc/multipath.conf file is basic but I have tried creating =
an alias entry that looks like =E2=80=9Cmultipaths {multipath {wwid   360=
05076801810085c800000000000194 alias os}}=E2=80=9D for the first LUN but =
the results are the same, it still won=E2=80=99t create any device specia=
l files for the first LUN.
>        =20
>         =20
>        =20
>         [root@svwdcvispay01 mapper]# cat /etc/multipath.conf | grep -v
>         "#"
>        =20
>         =20
>        =20
>         defaults {
>        =20
>                 user_friendly_names yes
>        =20
>         }
>        =20
>         =20
>        =20
>         [root@svwdcvispay01 mapper]#
>        =20
>         =20
>        =20
>         I have been working this issue for over a week with IBM and
>         RedHat tech support and they have been unhelpful.  I need to
>         get this functional because the server in question has been
>         unstable using a single path to the SAN due to stability
>         issues we have had periodically with one of the SAN Volume
>         Controllers.  If additional information is needed to
>         troubleshoot this please let me know.
>        =20
>         =20
>        =20
>         Joe little
>        =20
>         littlej@ae.com
>        =20
>         =20
>        =20
>                                       =20
>         ______________________________________________________________
>        =20
>         --
>         dm-devel mailing list
>         dm-devel@redhat.com
>         https://www.redhat.com/mailman/listinfo/dm-devel
>        =20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
