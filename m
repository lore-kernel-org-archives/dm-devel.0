From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: RHEL6.6 dm-cache and dm-era
Date: Tue, 23 Sep 2014 23:10:35 -0500
Message-ID: <6FC8490A-55CA-454E-83FE-061A33FDE8DE@redhat.com>
References: <54164DC0.3020907@gmail.com>
	<FBF1ED45-5B3E-4D0C-90B5-9A51D6EAE8F7@redhat.com>
	<541A977D.7010108@gmail.com>
	<CANoG8sVhN92jy559m4oLEvRhHWypMWeeU1TFe24CALs_Bw7Qbw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: multipart/mixed; boundary="===============7203817901123896731=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANoG8sVhN92jy559m4oLEvRhHWypMWeeU1TFe24CALs_Bw7Qbw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--===============7203817901123896731==
Content-Type: multipart/alternative; boundary=Apple-Mail-8--567061020


--Apple-Mail-8--567061020
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Sep 22, 2014, at 7:35 AM, Romu wrote:

> I tried the following command to set up my era target but the command =
immediately panics the system and the system reboots.
>=20
> # dmsetup create MyEra --table "0 41941903 era =
/dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV 4096"
>=20
> The metadata dev and the origin dev are all part of a LVM cache LV.  =
VG-CacheDataLV_cmeta is the cache metadata LV on the smaller and faster =
device, VG-OriginLV is the origin LV on the faster and slower device, =
41941903 is the total sector number of the device of OriginLV (the LV =
takes 100% space of the device), 4096 is the block size of OriginLV, I =
have run 'mkfs.ext4 /dev/mapper/VG-OriginLV' before running the dmsetup =
command.
>=20
> Below is the message in /var/log/messages after running the dmsetup =
comnmand:
>=20
> kernel: device-mapper: era: sb_check failed: magic 1623043: wanted =
2126579579
> kernel: device-mapper: block manager: superblock validator check =
failed for block 0
> kernel: device-mapper: era: couldn't read_lock superblock
>=20
>=20
> Any idea?
>=20

Sorry, I haven't used dm-era yet.  However, it does appear that you are =
perhaps specifying the wrong devices when creating the era device?  =
Looks like you might be allowing the era target and the cache target to =
use the same metadata area at the same time - causing them to corrupt =
each other's metadata area?

 brassow=

--Apple-Mail-8--567061020
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Sep 22, 2014, at 7:35 AM, Romu wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; ">I tried the =
following command to set up my era target but the command immediately =
panics the system and the system reboots.<div><br></div><div># dmsetup =
create MyEra --table "0 41941903&nbsp;era =
/dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV =
4096"<br></div><div><br></div><div>The metadata dev and the origin dev =
are all part of a LVM cache LV.&nbsp; VG-CacheDataLV_cmeta is =
the&nbsp;cache metadata LV on the smaller and faster device, VG-OriginLV =
is the origin LV on the faster and slower device, 41941903 is the total =
sector number of the device of OriginLV (the LV takes 100% space of the =
device), 4096 is the block size of OriginLV, I have run 'mkfs.ext4 =
/dev/mapper/VG-OriginLV' before running the dmsetup =
command.<br></div><div><br></div><div>Below is the message in =
/var/log/messages after running the dmsetup =
comnmand:</div><div><br></div><div>kernel: device-mapper: era: sb_check =
failed: magic 1623043: wanted 2126579579<br></div><div><div>kernel: =
device-mapper: block manager: superblock validator check failed for =
block 0</div><div>kernel: device-mapper: era: couldn't read_lock =
superblock</div></div><div><br></div><div><br></div><div>Any =
idea?</div></span><br =
class=3D"Apple-interchange-newline"></blockquote></div><br><div>Sorry, I =
haven't used dm-era yet. &nbsp;However, it does appear that you are =
perhaps specifying the wrong devices when creating the era device? =
&nbsp;Looks like you might be allowing the era target and the cache =
target to use the same metadata area at the same time - causing them to =
corrupt each other's metadata =
area?</div><div><br></div><div>&nbsp;brassow</div></body></html>=

--Apple-Mail-8--567061020--


--===============7203817901123896731==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7203817901123896731==--
