From: Erich Eckner <device-mapper@eckner.net>
Subject: Re: ignore/update integrity checksums
Date: Fri, 22 Nov 2019 11:09:10 +0100 (CET)
Message-ID: <alpine.LNX.2.21.99999.375.1911221102150.1609868@nlopc43.ioq.uni-jena.de>
References: <alpine.LNX.2.21.99999.375.1911221006490.1609868@nlopc43.ioq.uni-jena.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LNX.2.21.99999.375.1911221006490.1609868@nlopc43.ioq.uni-jena.de>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Fri, 22 Nov 2019, Erich Eckner wrote:

> Hi,
>
> I have multiple disks with LUKS+integrity created by
>
> cryptsetup luksFormat /dev/sde --key-file /mnt/key/key --integrity=20
> hmac-sha256
>
> which are part of a raid6. Details of the device:
>
> /dev/mapper/leg0 is active.
>  type:    LUKS2
>  cipher:  aes-xts-plain64
>  keysize: 768 bits
>  key location: keyring
>  integrity: hmac(sha256)
>  integrity keysize: 256 bits
>  device:  /dev/sdb
>  sector size:  512
>  offset:  0 sectors
>  size:    11031354576 sectors
>  mode:    read/write
>
>
> Recently, I rebooted this box and apparently, I missed to cleanly sync th=
e=20
> disks, so they now report integrity errors, when mdadm probes (during=20
> assemble) for the raid superblock:
>
> device-mapper: crypt: dm-1: INTEGRITY AEAD ERROR, sector 11031354368
>
> There was no write activity on the raid before the reboot except for a=20
> running
>
> mdadm /dev/md0 --replace /dev/dm-0 --with /dev/dm-1
>
> which of course might have written a lot to all superblocks.
>
> Since I believe, the superblocks should be mostly in-sync (except for=20
> event-counters?): Is there a way to ignore or re-calculate the integrity=
=20
> checks?
>
> Also: What is the correct way to assure, that data has been synced to the=
=20
> disk(s) before switching off power? (If that matters, there is a=20
> raid-controller underneath: "06:00.0 RAID bus controller: Hewlett-Packard=
=20
> Company Smart Array G6 controllers (rev 01)" - but it
> does not actually handle the raid, it only feeds the disks through to the=
 os)=20
> I can execute any command after closing the luks-integrity device, my=20
> question aims at: what should I execute?
>
> regards,
> Erich
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

just a follow-up experimentation with the broken disks:

I noticed /sys/block/dm-0/integrity/read_verify and similar which should=20
manipulate verification upon read and updating upon write, according to

https://github.com/ibuildthecloud/ubuntu-kernel/blob/master/Documentation/b=
lock/data-integrity.txt#L169

However, changing /sys/block/dm-0/integrity/read_verify to 0 (it was at 1=
=20
before) does not change the behaviour: `mdadm --examine` still generates=20
read errors and cannot find its superblock for the corresponding crypt=20
device.

Oh, I just see, that I forgot all the details of my system in the first=20
email - sry! - here it comes:

This box is running arch linux with up-to-date packages.

# uname -a
Linux backup 5.3.12-arch1-1 #1 SMP PREEMPT Wed, 20 Nov 2019 19:45:16 +0000=
=20
x86_64 GNU/Linux

# pacman -Q cryptsetup mdadm
cryptsetup 2.2.2-1
mdadm 4.1-2

regards,
Erich


-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE3p92iMrPBP64GmxZCu7JB1Xae1oFAl3Xs8gACgkQCu7JB1Xa
e1qykQ//cTcBJ1NGt2R3Cs23AGwdsUzsqyrf3ahPPWryFvN53GbYT6LOrjCqpF8n
DWNFQ/xBqDwpuQh3l3MatEoaIewGMgkjt2gcpG1aVPnZWJo1hgJDhpXW8locBpN+
h/q8bxcD9nOkMApDwu9bQxLIJcqBZISTgE8QmAvKvXFiPSuh22Gbth6NtSki2G3U
95TPvNbdMJCSG32SEQ1F3/4nky20CMkd31sam44pL//Mr9a6sSeKeaUeQ9rX13Oe
58kmkKp3d8ZIp89ruWgca2wEE5SZA3qdewWs5dfkCnLxzIs8tjL9jfrp1wR+yKNb
DiDj2i203IPxxIgcwu+aDPxboCrJDu3zEE1OcQf6ZDd7nGqsdaf2aGp/F/SkqQ9s
d20+DZSi+2NSQ8n782/zXuroVmy1of4eDn2flFSZFOKfuqgtWcQFnN+JZsZT/bIQ
xNKuD8eIY5lvO58Rpkg38JjIMfVuQiGdjfh1CK/ZUeYOXC6YnGgmOaZqdIWMH4ya
JknY7oXkCluGRNKn3wObufRMa3LkAjoRTmHRw4JpLWJgBxXaj7vsc/thrWy+Uw+3
cmwTMQBR3YttEAYsMRp+s6QNvN6ny3FlNAupnrSTiujjSnO7RZKTV5VeBOcAeoL4
4dTi0FTpehWWA6U3UlmUOafyZjGCHuXDVHKAbVUHiHjQJIpSztw=3D
=3D9Xhi
-----END PGP SIGNATURE-----
