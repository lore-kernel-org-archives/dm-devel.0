From: Roman I Khimov <rik@osrc.info>
Subject: Re: Oops by dmsetup in 2.6.13-rc2-mm2
Date: Tue, 26 Jul 2005 11:23:37 +0400
Message-ID: <1122362617.7935.1.camel@rik-note.loc>
References: <1122316523.7027.298.camel@rik-note.loc>
Reply-To: rik@osrc.info,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1071578113=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1122316523.7027.298.camel@rik-note.loc>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


--===============1071578113==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-H6EPkIBWQeg+GfRgE/5I"


--=-H6EPkIBWQeg+GfRgE/5I
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello.

I've tried 2.6.12, 2.6.13-rc2 and 2.6.13-rc3 and all this works just
fine, still 2.6.13-rc2-mm2 gives me an Oops.

=D0=92 =D0=9F=D0=BD=D0=B4, 25.07.2005, =D0=B2 22:35, Roman I Khimov =D0=BF=
=D0=B8=D1=88=D0=B5=D1=82:
> Hello.
>=20
> While trying
>=20
> /usr/sbin/cryptsetup -c aes -s 32 create cryptochain /dev/loop7
>=20
> on my fresh 2.6.13-rc2-mm2 I've got this:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
088
>  printing eip:
> cf84a985
> *pde =3D 00000000
> Oops: 0000 [#1]
> PREEMPT
> last sysfs file:
> Modules linked in: aes_i586 dm_crypt loop usb_storage snd_via82xx snd_ac9=
7_codec snd_pcm snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device s=
g st sd_mod sr_mod scsi_mod nvram usbserial parport_pc lp parport fan butto=
n battery ac ohci1394 ieee1394 via_ircc irda crc_ccitt via_agp agpgart af_p=
acket evdev ipt_TCPMSS ipt_TOS ipt_state ipt_LOG ppp_generic slhc pcmcia fi=
rmware_class yenta_socket rsrc_nonstatic pcmcia_core via_rhine ipt_REJECT i=
ptable_mangle iptable_filter ip_nat_ftp iptable_nat ip_conntrack_ftp ip_con=
ntrack ip_tables ide_cd cdrom uhci_hcd ehci_hcd dm_mod
> CPU:    0
> EIP:    0060:[<cf84a985>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.13-rc2-mm2-puerh1)
> EIP is at suspend_targets+0x5/0x60 [dm_mod]
> eax: 00000000   ebx: c895d0a0   ecx: 00000000   edx: 00000000
> esi: c3ade000   edi: 00000000   ebp: 00000000   esp: c3adfec0
> ds: 007b   es: 007b   ss: 0068
> Process dmsetup (pid: 9963, threadinfo=3Dc3ade000 task=3Dcd29e560)
> Stack: c895d0a0 c3ade000 ffffffea cf84929d 00000000 00000000 cd29e560 c01=
1a7b0
>        00000000 00000000 00000000 00000000 00000000 00000000 cd29e560 c01=
1a7b0
>        00000000 00000000 00000000 00000000 cf84b7fb c8b03b80 c895d0a0 cf8=
53900
> Call Trace:
>  [<cf84929d>] dm_suspend+0x7d/0x190 [dm_mod]
>  [<c011a7b0>] default_wake_function+0x0/0x10
>  [<c011a7b0>] default_wake_function+0x0/0x10
>  [<cf84b7fb>] __get_name_cell+0xb/0x60 [dm_mod]
>  [<cf84c7ae>] do_resume+0x15e/0x1c0 [dm_mod]
>  [<cf84d8dd>] ctl_ioctl+0xdd/0x130 [dm_mod]
>  [<cf84c810>] dev_suspend+0x0/0x20 [dm_mod]
>  [<c0170e7a>] do_ioctl+0x6a/0xa0
>  [<c0171048>] vfs_ioctl+0x68/0x1f0
>  [<c017120d>] sys_ioctl+0x3d/0x70
>  [<c01031ab>] sysenter_past_esp+0x54/0x75
> Code: bc 27 00 00 00 00 05 9c 00 00 00 c3 8d 76 00 8d bc 27 00 00 00 00 8=
b 80 98 00 00 00 c3 89 f6 8d bc 27 00 00 00 00 57 89 d7 56 53 <8b> b0 88 00=
 00 00 8b 98 94 00 00 00 4e 83 fe ff 75 1c eb 37 8d
>  <4>device-mapper: device doesn't appear to be in the dev hash table.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I've tried rebooting and it's 100% reproducible. 2.6.12-rc5-mm1 worked
> fine, I can also test 2.6.12, 2.6.13-rc2 and 2.6.13-rc3 if needed - just
> ask. Unfortunately I'm unable to test 2.6.13-rc3-mm1 now.=20
>=20
> Also, this might be useful:
>=20
> rik@rik-note:/usr/src> sudo /sbin/dmsetup --version
> Password:
> Library version:   1.00.09-ioctl (2004-03-31)
> Driver version:    4.4.0
--=20
                            Roman
 ,---------------------------. ,--------------------------.
/     http://www.3os.ru/      V    http://www.osrc.info/   \         .o.
\    mailto: rik@3os.ru       ^   mailto: rik@osrc.info    /         ..o
 `---------------------------' `--------------------------'          ooo
gpg --recv-keys 0xE5E055C3 --keyserver hkp://subkeys.pgp.net

--=-H6EPkIBWQeg+GfRgE/5I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?koi8-r?Q?=FC=D4=C1?= =?koi8-r?Q?_=DE=C1=D3=D4=D8?=
	=?koi8-r?Q?_=D3=CF=CF=C2=DD=C5=CE=C9=D1?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=C1=CE=C1?=
	=?koi8-r?Q?_=C3=C9=C6=D2=CF=D7=CF=CA?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=D8=C0?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBC5eT5XJ70z+XgVcMRAj5WAKCC+h6wDDIc1IJ29OTcMi9nhMYtvgCdE0fc
c9QTaxncCEzNyQpY3xsyYUM=
=NbBr
-----END PGP SIGNATURE-----

--=-H6EPkIBWQeg+GfRgE/5I--


--===============1071578113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1071578113==--
