From: Gigi W <gigitekwork@gmail.com>
Subject: Integrity checking fails with Atmel SHA hw accelerator
	enabled
Date: Fri, 23 Feb 2018 10:30:37 +0200
Message-ID: <CAAm399SnigNFoHgNL4v4q167K3NheyYHzRp76Lxi9xpu6W0YPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5458733244386947817=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============5458733244386947817==
Content-Type: multipart/alternative; boundary="001a113f983a9a7c530565dcf957"

--001a113f983a9a7c530565dcf957
Content-Type: text/plain; charset="UTF-8"

Hi

I'm having some trouble using dm-verity for a squashfs root file system
that seems to be related to the
Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATMEL_SHA

Some info about my setup:
* I'm using a board with a SAMA5D4 CPU.
* I'm using Yocto rocko for building an image for that device.

The idea is that Using the 4.14.14 Kernel, Integrity checking using Kernel
crypto fails with Atmel SHA hw accelerator enabled in kernel.
By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=n`, and using the software
sha256 algo, integrity checking works as expected.
This is my kernel config [3]

Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled, everything was
ok.

This is what triggers the error during verified boot:

status=`veritysetup create vroot $root_dev $verity_dev --hash-offset
$hashoffset $root_hash`

    mount /dev/mapper/vroot /mnt/
    mount_ok=`cat /proc/mounts | grep mnt`
    if [ -z "$mount_ok" ] ; then
        echo "Failed to mount $root_dev on mnt/"
    else
        echo "Switch rootfs"
        exec switch_root -c /dev/console /mnt /sbin/init
    fi

The mount operation fails:

device-mapper: verity: 179:4: metadata block 2 is corrupted
EXT4-fs (dm-0): unable to read superblock
device-mapper: verity: 179:4: metadata block 2 is corrupted
EXT4-fs (dm-0): unable to read superblock
device-mapper: verity: 179:4: metadata block 2 is corrupted
EXT4-fs (dm-0): unable to read superblock
device-mapper: verity: 179:4: metadata block 2 is corrupted
SQUASHFS error: squashfs_read_data failed to read block 0x0
squashfs: SQUASHFS error: unable to read squashfs_super_block
device-mapper: verity: 179:4: metadata block 2 is corrupted
FAT-fs (dm-0): unable to read boot sector
mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output error
Failed to mount /dev/mmcblk0p4 on mnt/
reboot: Restarting system
Reboot failed -- System halted

Using veritysetup to verify the integrity against the hashes is successful,
as it's not using the kernel for that ...

So it looks like it something changed from 4.8.4 to 4.14.14.
Using the 4.14.14 kernel, I removed the patches that were applied on the
atmel-sha.c file in the kernel, one by one, until I got the version from
the 4.8.4
Basically I reverted the changes from here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/log/drivers/crypto/atmel-sha.c?h=v4.14.14
until I got this:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/log/drivers/crypto/atmel-sha.c?h=v4.8.4

It still didn't work. I assumed something there broke the hashing, not the
case. It was still not working with all those commits reverted.

Furthermore, using the Cryptodev-linux module [1], and the sample [2],
adapted to use sha256, I tested the output hashes, with
CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then disabled.

I got the same results in both cases, hardware and software algorithm. So
it doesn't look like the SHA hw accelerator is broken.


Any help is appreciated !

Thanks in advanced and have a nice day.

[1] http://cryptodev-linux.org/documentation.html
[2] https://github.com/nmav/cryptodev-linux/blob/master/examples/sha.c
[3]
https://gist.githubusercontent.com/gmircea/6e1cc029ef5ed7a16b0fedb8b9524f66/raw/eece8a8faadd2de9373e150ef1daf3cf25f4135c/.config

--001a113f983a9a7c530565dcf957
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi <br>
    <div class=3D"gmail-moz-forward-container"> <br>
      I&#39;m having some trouble using dm-verity for a squashfs root file
      system that seems to be related to the <br>
      Atmel SHA hw accelerator in the kernel,
      CONFIG_CRYPTO_DEV_ATMEL_SHA<br>
      <br>
      Some info about my setup: <br>
      * I&#39;m using a board with a SAMA5D4 CPU.<br>
      * I&#39;m using Yocto rocko for building an image for that device.<br=
>
      <br>
      The idea is that Using the 4.14.14 Kernel, Integrity checking
      using Kernel crypto fails with Atmel SHA hw accelerator enabled in
      kernel.<br>
      By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=3Dn`, and using the
      software sha256 algo, integrity checking works as expected.<br>
      This is my kernel config [3] <br>
      <br>
      Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled,
      everything was ok.<br>
      <p>This is what triggers the error during verified boot:</p>
      <p>status=3D`veritysetup create vroot $root_dev $verity_dev
        --hash-offset $hashoffset $root_hash`<br>
        <br>
        =C2=A0=C2=A0=C2=A0 mount /dev/mapper/vroot /mnt/<br>
        =C2=A0=C2=A0=C2=A0 mount_ok=3D`cat /proc/mounts | grep mnt`<br>
        =C2=A0=C2=A0=C2=A0 if [ -z &quot;$mount_ok&quot; ] ; then<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 echo &quot;Failed to mount $r=
oot_dev on mnt/&quot;<br>
        =C2=A0=C2=A0=C2=A0 else<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 echo &quot;Switch rootfs&quot=
;<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 exec switch_root -c /dev/cons=
ole /mnt /sbin/init<br>
        =C2=A0=C2=A0=C2=A0 fi<br>
      </p>
      <p>The mount operation fails:</p>
      <p>device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
        EXT4-fs (dm-0): unable to read superblock<br>
        device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
        EXT4-fs (dm-0): unable to read superblock<br>
        device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
        EXT4-fs (dm-0): unable to read superblock<br>
        device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
        SQUASHFS error: squashfs_read_data failed to read block 0x0<br>
        squashfs: SQUASHFS error: unable to read squashfs_super_block<br>
        device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
        FAT-fs (dm-0): unable to read boot sector<br>
        mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output
        error<br>
        Failed to mount /dev/mmcblk0p4 on mnt/<br>
        reboot: Restarting system<br>
        Reboot failed -- System halted<br>
      </p>
      <p>Using veritysetup to verify the integrity against the hashes is
        successful, as it&#39;s not using the kernel for that ...</p><br>
      So it looks like it something changed from 4.8.4 to 4.14.14.
      <br>Using the  4.14.14 kernel, I removed the patches that were applie=
d on the atmel-sha.c file in the kernel, one by one, until I got the versio=
n from the 4.8.4 <br></div><div class=3D"gmail-moz-forward-container">Basic=
ally I reverted the changes from here:<a href=3D"https://git.kernel.org/pub=
/scm/linux/kernel/git/stable/linux-stable.git/log/drivers/crypto/atmel-sha.=
c?h=3Dv4.14.14" class=3D"external-link" rel=3D"nofollow" title=3D"Follow li=
nk">https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git=
/log/drivers/crypto/atmel-sha.c?h=3Dv4.14.14</a><br></div><div class=3D"gma=
il-moz-forward-container">until I got this:<a href=3D"https://git.kernel.or=
g/pub/scm/linux/kernel/git/stable/linux-stable.git/log/drivers/crypto/atmel=
-sha.c?h=3Dv4.8.4" class=3D"external-link" rel=3D"nofollow" title=3D"Follow=
 link"> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git/log/drivers/crypto/atmel-sha.c?h=3Dv4.8.4</a></div><div class=3D"gmail=
-moz-forward-container">
      <p>It still didn&#39;t work. I assumed something there broke the hash=
ing, not the case. It was still not working with all those commits reverted=
.<br></p><p>Furthermore, using the Cryptodev-linux module [1], and the samp=
le [2], adapted to use sha256, I tested the output hashes, with CONFIG_CRYP=
TO_DEV_ATMEL_SHA enabled and then disabled.<br></p><p>I got the same result=
s in both cases, hardware and software algorithm. So it doesn&#39;t look li=
ke the SHA hw accelerator is broken.<br></p><p></p><br><p>Any help is appre=
ciated !</p>
      <p>Thanks in advanced and have a nice day.</p>
      </div><br>[1] <a href=3D"http://cryptodev-linux.org/documentation.htm=
l">http://cryptodev-linux.org/documentation.html</a><br>[2] <a href=3D"http=
s://github.com/nmav/cryptodev-linux/blob/master/examples/sha.c">https://git=
hub.com/nmav/cryptodev-linux/blob/master/examples/sha.c</a><br>[3] <a class=
=3D"gmail-moz-txt-link-freetext" href=3D"https://gist.githubusercontent.com=
/gmircea/6e1cc029ef5ed7a16b0fedb8b9524f66/raw/eece8a8faadd2de9373e150ef1daf=
3cf25f4135c/.config">https://gist.githubusercontent.com/gmircea/6e1cc029ef5=
ed7a16b0fedb8b9524f66/raw/eece8a8faadd2de9373e150ef1daf3cf25f4135c/.config<=
/a><br><br></div>

--001a113f983a9a7c530565dcf957--


--===============5458733244386947817==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5458733244386947817==--
