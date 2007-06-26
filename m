From: Johannes Berg <johannes@sipsolutions.net>
Subject: Oops in dm-crypt
Date: Tue, 26 Jun 2007 13:10:42 +0200
Message-ID: <1182856242.3703.4.camel@johannes.berg>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0222753073=="
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


--===============0222753073==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-f2+YA64Hsel3vo4Eakjh"


--=-f2+YA64Hsel3vo4Eakjh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just got the following... Doesn't happen all the time though. My
kernel's at revision 7d59453a9dbe50dc9bab846c410e39f8d5b10c83 which is
from wireless-dev, but there are only the commits
ed45666271f4fafa95b9d8ad44050e9a9bd2376e and
af03b8e4e81c3789e597632268940edd11ffe870 to drivers/md since then.

The partition in question is a LUKS partition and I was using cryptsetup
but I'm not sure I entered the right key, might very well (likely
actually) have been the wrong key.


Jun 26 12:55:15 johannes kernel: [ 6183.450288] Unable to handle kernel pag=
ing request for data at address 0x00000004
Jun 26 12:55:15 johannes kernel: [ 6183.450397] Faulting instruction addres=
s: 0xc006a524
Jun 26 12:55:15 johannes kernel: [ 6183.450438] Oops: Kernel access of bad =
area, sig: 11 [#1]
Jun 26 12:55:15 johannes kernel: [ 6183.450443] PREEMPT PowerMac
Jun 26 12:55:15 johannes kernel: [ 6183.450448] Modules linked in:
sd_mod usb_storage scsi_mod af_packet radeon drm binfmt_misc hci_usb
rfcomm
 l2cap bluetooth snd_powermac configfs nls_utf8 hfsplus nls_base fuse
dm_snapshot dm_mirror sha256 snd_aoa_codec_tas snd_aoa_fabric_layout joy
dev snd_aoa appletouch usbhid firewire_ohci firewire_core crc_itu_t
bcm43xx ieee80211softmac ieee80211 ieee80211_crypt arc4 rc80211_simple
snd
_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc
snd soundcore ohci1394 ieee1394 snd_aoa_soundbus bcm43xx_mac80211 ehci_
hcd ssb pcmcia firmware_class mac80211 cfg80211 yenta_socket
rsrc_nonstatic ohci_hcd usbcore uninorth_agp pcmcia_core agpgart evdev
unix
Jun 26 12:55:15 johannes kernel: [ 6183.450542] NIP: c006a524 LR: c02412b0 =
CTR: c0239010
Jun 26 12:55:15 johannes kernel: [ 6183.450549] REGS: cfd09e10 TRAP: 0300  =
 Not tainted  (2.6.22-rc4-g7d59453a-dirty)
Jun 26 12:55:15 johannes kernel: [ 6183.450555] MSR: 00009032 <EE,ME,IR,DR>=
  CR: 24002082  XER: 20000000
Jun 26 12:55:15 johannes kernel: [ 6183.450569] DAR: 00000004, DSISR: 40000=
000
Jun 26 12:55:15 johannes kernel: [ 6183.450575] TASK =3D cfd4b990[209] 'kcr=
yptd/0' THREAD: cfd08000
Jun 26 12:55:15 johannes kernel: [ 6183.450580] GPR00: c02412b0 cfd09ec0 cf=
d4b990 ec4d9b40 00000000 00000001 00000000 00000000=20
Jun 26 12:55:15 johannes kernel: [ 6183.450594] GPR08: 2d050d00 00000000 10=
000000 cfd08000 00000000 00000000 01744880 0175b730=20
Jun 26 12:55:15 johannes kernel: [ 6183.450609] GPR16: 00240e68 00240e1c 00=
240e20 0174499c 01745768 017454e0 01745454 c0349480=20
Jun 26 12:55:15 johannes kernel: [ 6183.450624] GPR24: c0349448 ec4d9b40 cf=
d4bb28 cfd4b990 ec4d9b40 cfd09ef8 00000000 ec4d9b40=20
Jun 26 12:55:15 johannes kernel: [ 6183.450641] NIP [c006a524] mempool_free=
+0x18/0xf4
Jun 26 12:55:15 johannes kernel: [ 6183.450657] LR [c02412b0] dec_pending+0=
x5c/0x78
Jun 26 12:55:15 johannes kernel: [ 6183.450669] Call Trace:
Jun 26 12:55:15 johannes kernel: [ 6183.450674] [cfd09ec0] [cfd09ef8] 0xcfd=
09ef8 (unreliable)
Jun 26 12:55:15 johannes kernel: [ 6183.450688] [cfd09ee0] [c02412b0] dec_p=
ending+0x5c/0x78
Jun 26 12:55:15 johannes kernel: [ 6183.450698] [cfd09ef0] [c024187c] kcryp=
td_do_work+0x2c8/0x39c
Jun 26 12:55:15 johannes kernel: [ 6183.450708] [cfd09f60] [c0040444] run_w=
orkqueue+0xf4/0x1c8
Jun 26 12:55:15 johannes kernel: [ 6183.450722] [cfd09f90] [c0040b14] worke=
r_thread+0x9c/0x120
Jun 26 12:55:15 johannes kernel: [ 6183.450732] [cfd09fd0] [c0044f78] kthre=
ad+0x48/0x84
Jun 26 12:55:15 johannes kernel: [ 6183.450744] [cfd09ff0] [c00125f4] kerne=
l_thread+0x44/0x60
Jun 26 12:55:15 johannes kernel: [ 6183.450759] Instruction dump:
Jun 26 12:55:15 johannes kernel: [ 6183.450765] 7fe3fb78 3bc00000 48022959 =
4bffffbc 38e0ffff 4bfffedc 9421ffe0 7c0802a6=20
Jun 26 12:55:15 johannes kernel: [ 6183.450780] bf810010 7c7c1b78 7c9e2378 =
90010024 <80040004> 81240000 7f804800 409c00a0=20


--=-f2+YA64Hsel3vo4Eakjh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBGgPQy/ETPhpq3jKURAnmcAJ0Sn7fH0h5QdV+6XacjqDdTqMQ2aACUCrp+
zFVbKam9LqhJ7DWyqKok3g==
=0Psj
-----END PGP SIGNATURE-----

--=-f2+YA64Hsel3vo4Eakjh--


--===============0222753073==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0222753073==--
