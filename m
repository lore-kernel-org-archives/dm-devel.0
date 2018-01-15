From: none none <neolorry@gmail.com>
Subject: mkfs.ext3 on dm thin-vol uses more space than expected
Date: Mon, 15 Jan 2018 18:57:48 +0800
Message-ID: <CAHEnfeG1RxXz1JH773Jj=DjQ7L-LZS6r_nEQf4gs9jchTPJECQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5120454077820538393=="
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

--===============5120454077820538393==
Content-Type: multipart/alternative; boundary="94eb2c0418fc1cd8cf0562ce7c63"

--94eb2c0418fc1cd8cf0562ce7c63
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm a newbie to dm, and i'm not sure if it's the right place to ask the
following question. Please correct me if not, and thanks for any reply.

In short, I did mkfs.ext3 on a dm thin-vol, and it looks consumed much more
data space than on a loop image. As a result, mkfs failed due to inadequate
space.

---
[root@vm ~]# dd if=/dev/zero of=10G_1.img bs=1 count=0
seek=10G
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000102011 s, 0.0 kB/s
[root@vm ~]# /usr/sbin/mkfs -t ext3 -- -F -b 1024 10G_1.img
mke2fs 1.42.9 (28-Dec-2013)
Discarding device blocks: done
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
655360 inodes, 10485760 blocks
524288 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=77594624
1280 block groups
8192 blocks per group, 8192 fragments per group
512 inodes per group
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553,
        1024001, 1990657, 2809857, 5120001, 5971969

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

[root@vm ~]# du -sh 10G_1.img
199M    10G_1.img
---
As shown above, mks.ext3 on a 10G loop image should use 199M space. In the
following test, i'll create a dm thin-vol with 10G virtual size and 500m
backing size, and i expect 500m is adequate for mkfs.ext3.
---
[root@vm ~]# dd if=/dev/zero of=10G.img bs=1 count=0 seek=10G
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000125097 s, 0.0 kB/s
[root@vm ~]# losetup /dev/loop0 /root/10G.img
[root@vm ~]# /usr/sbin/dmsetup create thin-meta --table '0 48000 linear
/dev/loop0 10240'
[root@vm ~]# /usr/sbin/dmsetup create thin-data --table '0 1024000 linear
/dev/loop0 58240'
[root@vm ~]# /usr/sbin/dmsetup create thin-pool --table '0 1024000
thin-pool /dev/mapper/thin-meta /dev/mapper/thin-data 1024 200'
[root@vm ~]# /usr/sbin/dmsetup message /dev/mapper/thin-pool 0 'create_thin
17021'
[root@vm ~]# /usr/sbin/dmsetup create thin-vol --table '0 10240000 thin
/dev/mapper/thin-pool 17021'
[root@vm ~]# dmsetup status | grep pool
thin-pool: 0 1024000 thin-pool 0 10/6000 0/1000 - rw discard_passdown
queue_if_no_space -
[root@vm ~]# /usr/sbin/mkfs -t ext3 -- -F -b 1024 /dev/mapper/thin-vol
mke2fs 1.42.9 (28-Dec-2013)
Discarding device blocks: done
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=64 blocks, Stripe width=512 blocks
320000 inodes, 5120000 blocks
256000 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=72351744
625 block groups
8192 blocks per group, 8192 fragments per group
512 inodes per group
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553,
        1024001, 1990657, 2809857

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information:
Warning, had trouble writing out superblocks.
[root@vm ~]# echo $?
5
[root@vm ~]# dmsetup status | grep pool
thin-pool: 0 1024000 thin-pool 0 17/6000 1000/1000 - out_of_data_space
discard_passdown error_if_no_space -
[root@vm ~]# journalctl -k
Jan 15 18:15:38 vm kernel: device-mapper: thin: 253:8: switching pool to
write mode
Jan 15 18:15:38 vm kernel: device-mapper: thin: 253:8: switching pool to
out-of-data-space (queue IO) mode
Jan 15 18:16:39 vm kernel: device-mapper: thin: 253:8: switching pool to
out-of-data-space (error IO) mode
Jan 15 18:16:39 vm kernel: buffer_io_error: 25590 callbacks suppressed
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
988832, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
989184, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
990896, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
991232, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
992960, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
993280, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
995024, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
995328, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
997088, lost async page write
Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block
997376, lost async page write
---
In another test, mkfs succeeds with creating a 2500m virtual size thin-vol
instead of 5000m:
/usr/sbin/dmsetup create thin-vol --table '0 5120000 thin
/dev/mapper/thin-pool 17021'

I think the failure is due to mkfs runs out of space on dm thin-vol, but
why is it?

Thanks,
Young

--94eb2c0418fc1cd8cf0562ce7c63
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi,<br><br></div>I&#39;m a newbie to dm, and i&#=
39;m not sure if it&#39;s the right place to ask the following question. Pl=
ease correct me if not, and thanks for any reply.<br><br></div><div>In shor=
t, I did mkfs.ext3 on a dm thin-vol, and it looks consumed much more data s=
pace than on a loop image. As a result, mkfs failed due to inadequate space=
.<br><br>---<br>[root@vm ~]# dd if=3D/dev/zero of=3D10G_1.img bs=3D1 count=
=3D0 seek=3D10G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <br>0+0 records in<br>0+0 records out<=
br>0 bytes (0 B) copied, 0.000102011 s, 0.0 kB/s<br>[root@vm ~]# /usr/sbin/=
mkfs -t ext3 -- -F -b 1024 10G_1.img <br>mke2fs 1.42.9 (28-Dec-2013)<br>Dis=
carding device blocks: done=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <br>Filesystem label=3D<br>OS type:=
 Linux<br>Block size=3D1024 (log=3D0)<br>Fragment size=3D1024 (log=3D0)<br>=
Stride=3D0 blocks, Stripe width=3D0 blocks<br>655360 inodes, 10485760 block=
s<br>524288 blocks (5.00%) reserved for the super user<br>First data block=
=3D1<br>Maximum filesystem blocks=3D77594624<br>1280 block groups<br>8192 b=
locks per group, 8192 fragments per group<br>512 inodes per group<br>Superb=
lock backups stored on blocks: <br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553, <br>=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1024001, 1990657, 2809857, 51200=
01, 5971969<br><br>Allocating group tables: done=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <br>Writing in=
ode tables: done=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <br>Creating journal (32768 blocks): done<br=
>Writing superblocks and filesystem accounting information: done=C2=A0=C2=
=A0=C2=A0=C2=A0 <br><br>[root@vm ~]# du -sh 10G_1.img <br>199M=C2=A0=C2=A0=
=C2=A0 10G_1.img<br>---<br></div><div>As shown above, mks.ext3 on a 10G loo=
p image should use 199M space. In the following test, i&#39;ll create a dm =
thin-vol with 10G virtual size and 500m backing size, and i expect 500m is =
adequate for mkfs.ext3.<br>---<br>[root@vm ~]# dd if=3D/dev/zero of=3D10G.i=
mg bs=3D1 count=3D0 seek=3D10G<br>0+0 records in<br>0+0 records out<br>0 by=
tes (0 B) copied, 0.000125097 s, 0.0 kB/s<br>[root@vm ~]# losetup /dev/loop=
0 /root/10G.img<br>[root@vm ~]# /usr/sbin/dmsetup create thin-meta --table =
&#39;0 48000 linear /dev/loop0 10240&#39;<br>[root@vm ~]# /usr/sbin/dmsetup=
 create thin-data --table &#39;0 1024000 linear /dev/loop0 58240&#39;<br>[r=
oot@vm ~]# /usr/sbin/dmsetup create thin-pool --table &#39;0 1024000 thin-p=
ool /dev/mapper/thin-meta /dev/mapper/thin-data 1024 200&#39;<br>[root@vm ~=
]# /usr/sbin/dmsetup message /dev/mapper/thin-pool 0 &#39;create_thin 17021=
&#39;<br>[root@vm ~]# /usr/sbin/dmsetup create thin-vol --table &#39;0 1024=
0000 thin /dev/mapper/thin-pool 17021&#39;<br>[root@vm ~]# dmsetup status |=
 grep pool<br>thin-pool: 0 1024000 thin-pool 0 10/6000 0/1000 - rw discard_=
passdown queue_if_no_space -<br>[root@vm ~]# /usr/sbin/mkfs -t ext3 -- -F -=
b 1024 /dev/mapper/thin-vol<br>mke2fs 1.42.9 (28-Dec-2013)<br>Discarding de=
vice blocks: done=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <br>Filesystem label=3D<br>OS type: Linux<br=
>Block size=3D1024 (log=3D0)<br>Fragment size=3D1024 (log=3D0)<br>Stride=3D=
64 blocks, Stripe width=3D512 blocks<br>320000 inodes, 5120000 blocks<br>25=
6000 blocks (5.00%) reserved for the super user<br>First data block=3D1<br>=
Maximum filesystem blocks=3D72351744<br>625 block groups<br>8192 blocks per=
 group, 8192 fragments per group<br>512 inodes per group<br>Superblock back=
ups stored on blocks: <br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8193, =
24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553, <br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1024001, 1990657, 2809857<br><br>Allocati=
ng group tables: done=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <br>Writing inode tables: done=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 <br>Creating journal (32768 blocks): done<br>Writing superblocks and fi=
lesystem accounting information:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
<br>Warning, had trouble writing out superblocks.<br>[root@vm ~]# echo $?<b=
r>5<br>[root@vm ~]# dmsetup status | grep pool<br>thin-pool: 0 1024000 thin=
-pool 0 17/6000 1000/1000 - out_of_data_space discard_passdown error_if_no_=
space -<br>[root@vm ~]# journalctl -k<br>Jan 15 18:15:38 vm kernel: device-=
mapper: thin: 253:8: switching pool to write mode<br>Jan 15 18:15:38 vm ker=
nel: device-mapper: thin: 253:8: switching pool to out-of-data-space (queue=
 IO) mode<br>Jan 15 18:16:39 vm kernel: device-mapper: thin: 253:8: switchi=
ng pool to out-of-data-space (error IO) mode<br>Jan 15 18:16:39 vm kernel: =
buffer_io_error: 25590 callbacks suppressed<br>Jan 15 18:16:39 vm kernel: B=
uffer I/O error on dev dm-9, logical block 988832, lost async page write<br=
>Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block 989=
184, lost async page write<br>Jan 15 18:16:39 vm kernel: Buffer I/O error o=
n dev dm-9, logical block 990896, lost async page write<br>Jan 15 18:16:39 =
vm kernel: Buffer I/O error on dev dm-9, logical block 991232, lost async p=
age write<br>Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logic=
al block 992960, lost async page write<br>Jan 15 18:16:39 vm kernel: Buffer=
 I/O error on dev dm-9, logical block 993280, lost async page write<br>Jan =
15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical block 995024, =
lost async page write<br>Jan 15 18:16:39 vm kernel: Buffer I/O error on dev=
 dm-9, logical block 995328, lost async page write<br>Jan 15 18:16:39 vm ke=
rnel: Buffer I/O error on dev dm-9, logical block 997088, lost async page w=
rite<br>Jan 15 18:16:39 vm kernel: Buffer I/O error on dev dm-9, logical bl=
ock 997376, lost async page write<br>---<br></div><div>In another test, mkf=
s succeeds with creating a 2500m virtual size thin-vol instead of 5000m:<br=
>/usr/sbin/dmsetup create thin-vol --table &#39;0 5120000 thin /dev/mapper/=
thin-pool 17021&#39;<br><br></div><div>I think the failure is due to mkfs r=
uns out of space on dm thin-vol, but why is it?<br><br></div><div>Thanks,<b=
r></div><div>Young<br></div><div><br><br></div></div>

--94eb2c0418fc1cd8cf0562ce7c63--


--===============5120454077820538393==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5120454077820538393==--
