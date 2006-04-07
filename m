From: URZ- AG <arsene.gschwind@unibas.ch>
Subject: multipath disk size
Date: Fri, 07 Apr 2006 10:47:27 +0200
Message-ID: <4436271F.1090509@unibas.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
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

Hi,

I'm posting my question again, i would really appreciate if someone=20
could give me a hint why this happen.


I'm trying to setup a FC Storage (Adaptec SANBloc 2Gb) using multipath
(Kernel 2.6.15 - multipath-tool-0.4.7 on Fedora Core 5 )
Everything seem to run right, but the disk created by multipath does not
reflect the physical one.
I do have a physical volume that is about 67GB big, when multipath
creates the dm device it is at least 1GB.
Here is the output of multipath -v3:
----------------------------------------------------
dm-0: blacklisted
dm-1: blacklisted
dm-2: blacklisted
dm-4: blacklisted
dm-5: blacklisted
fd0: blacklisted
hdd: blacklisted
md0: blacklisted
ram0: blacklisted
ram10: blacklisted
ram11: blacklisted
ram12: blacklisted
ram13: blacklisted
ram14: blacklisted
ram15: blacklisted
ram1: blacklisted
ram2: blacklisted
ram3: blacklisted
ram4: blacklisted
ram5: blacklisted
ram6: blacklisted
ram7: blacklisted
ram8: blacklisted
ram9: blacklisted
sda: not found in pathvec
sda: mask =3D 0x1f
sda: bus =3D 1
sda: dev_t =3D 8:0
sda: size =3D 71553024
sda: vendor =3D LSILOGIC
sda: product =3D 1030          IM
sda: rev =3D 1000
sda: h:b:t:l =3D 0:0:1:0
sda: serial =3D
sda: path checker =3D readsector0 (config file default)
sda: state =3D 2
sda: getprio =3D /bin/true (config file default)
sda: prio =3D 0
sda: getuid =3D /sbin/scsi_id -g -u -s /block/%n (config file default)
error calling out /sbin/scsi_id -g -u -s /block/sda
sdb: not found in pathvec
sdb: mask =3D 0x1f
sdb: bus =3D 1
sdb: dev_t =3D 8:16
sdb: size =3D 142114816
sdb: vendor =3D EUROLOGC
sdb: product =3D FC2502
sdb: rev =3D 7902
sdb: h:b:t:l =3D 2:0:0:0
sdb: tgt_node_name =3D 0x20000080e512dc77
sdb: serial =3D 0000dc7720000080e512dc770000000000000000
sdb: path checker =3D readsector0 (controler setting)
sdb: state =3D 2
sdb: getprio =3D /bin/true (config file default)
sdb: prio =3D 0
sdb: getuid =3D /sbin/scsi_id -g -u -p 0x80 -s /block/%n (controler setti=
ng)
sdb: uid =3D SEUROLOGCFC2502_0000dc7720000080e512dc770000000000000000
(callout)
sdc: not found in pathvec
sdc: mask =3D 0x1f
sdc: bus =3D 1
sdc: dev_t =3D 8:32
sdc: size =3D 142114816
sdc: vendor =3D EUROLOGC
sdc: product =3D FC2502
sdc: rev =3D 7902
sdc: h:b:t:l =3D 2:0:1:0
sdc: tgt_node_name =3D 0x20000080e512dc77
sdc: serial =3D 0000dc7720000080e512dc770000000000000000
sdc: path checker =3D readsector0 (controler setting)
sdc: state =3D 2
sdc: getprio =3D /bin/true (config file default)
sdc: prio =3D 0
sdc: getuid =3D /sbin/scsi_id -g -u -p 0x80 -s /block/%n (controler setti=
ng)
sdc: uid =3D SEUROLOGCFC2502_0000dc7720000080e512dc770000000000000000
(callout)
=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D
uuid                                                     hcil    dev
dev_t pri
                                                         0:0:1:0 sda 8:0 =
  0
SEUROLOGCFC2502_0000dc7720000080e512dc770000000000000000 2:0:0:0 sdb 8:16=
  0
SEUROLOGCFC2502_0000dc7720000080e512dc770000000000000000 2:0:1:0 sdc 8:32=
  0
8:16 ownership set to hdmail
sdb: not found in pathvec
sdb: mask =3D 0xc
sdb: state =3D 2
sdb: prio =3D 0
8:32 ownership set to hdmail
sdc: not found in pathvec
sdc: mask =3D 0xc
sdc: state =3D 2
sdc: prio =3D 0
hdmail: pgfailback =3D -2 (config file default)
hdmail: pgpolicy =3D failover (controler setting)
hdmail: selector =3D round-robin 0 (controler setting)
hdmail: features =3D 0 (internal default)
hdmail: hwhandler =3D 0 (internal default)
hdmail: rr_weight =3D 2 (config file default)
hdmail: minio =3D 100 (config file default)
hdmail: no_path_retry =3D -1 (config file default)
hdmail: set ACT_CREATE (map does not exist)
hdmail: set ACT_CREATE (map does not exist)
create: hdmail (SEUROLOGCFC2502_0000dc7720000080e512dc770000000000000000)
[size=3D1 GB][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][undef]
\_ 2:0:0:0 sdb 8:16  [undef][ready]
\_ round-robin 0 [prio=3D0][undef]
\_ 2:0:1:0 sdc 8:32  [undef][ready]
----------------------------------------------------
When you look at the disk size, it return the correct value but when it
creates the dm device it does it too small.

When I do create the multipath device using dmsetup it creates it with=20
the right size, but as soon as I do runf multipath again it resize the=20
device.

Thanks a lot for your work and your help

Regards,
Ars=E8ne
