From: Sanjana <sanjana.linux@gmail.com>
Subject: Cannot mount underlying block device after creating dm
	device.
Date: Thu, 3 Nov 2011 08:48:43 +0530
Message-ID: <CABMcfaMi_FpOhG2g2vjxCOA8e89Bd+8UGSq0mCb0e+mfeocLeQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8361166021746322104=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8361166021746322104==
Content-Type: multipart/alternative; boundary=bcaec548a81bc36ab404b0cc0bad

--bcaec548a81bc36ab404b0cc0bad
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I am testing a mirror target for dmsetup. After creating the dm device I
cannot the underlying block device.

[root@bladelinux01 ~]# dumpe2fs /dev/loop0 | head
dumpe2fs 1.41.12 (17-May-2010)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          9c0f4d5c-55d9-4332-b0e7-f48a19333174
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype sparse_super
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
[root@bladelinux01 ~]# dumpe2fs /dev/loop1 | head
dumpe2fs 1.41.12 (17-May-2010)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          c16fcae4-2271-4701-a91e-6694962935d0
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype sparse_super
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue


[root@bladelinux01 ~]# mount /dev/loop0 /mnt/ ; mount | grep loop0
/dev/loop0 on /mnt type ext3 (rw)
[root@bladelinux01 ~]# umount /mnt/

[root@bladelinux01 ~]# mount /dev/loop1 /mnt/ ; mount | grep loop1
/dev/loop1 on /mnt type ext3 (rw)
[root@bladelinux01 ~]# umount /mnt/

[root@bladelinux01 ~]# dmsetup create raid1 --table "0 204800 mirror core 1
128 2 7:0 0 7:1 0"

[root@bladelinux01 ~]# dmsetup table raid1
0 204800 mirror core 1 128 2 7:0 0 7:1 0
[root@bladelinux01 ~]# dmsetup info raid1
Name:              raid1
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      1
Major, minor:      253, 6
Number of targets: 1

[root@bladelinux01 ~]# dmsetup info -c raid1
Name             Maj Min Stat Open Targ Event  UUID
x                253   6 L--w    0    1      1
[root@bladelinux01 ~]# dmsetup deps raid1
2 dependencies  : (7, 1) (7, 0)

[root@bladelinux01 ~]# dmsetup status /dev/mapper/raid1
0 204800 mirror 2 7:0 7:1 1600/1600 1 AA 1 core

I have mounted the newly created dm device and copied some data to it.
[root@bladelinux01 ~]# mount /dev/mapper/raid1 /mnt/ ; mount | grep raid1
/dev/mapper/raid1 on /mnt type ext3 (rw)

[root@bladelinux01 ~]# cp /var/log/messages /mnt/
[root@bladelinux01 ~]# ls -l /mnt/
total 51
drwx------. 2 root root 12288 Nov  2 22:32 lost+found
-rw-------. 1 root root 37417 Nov  2 22:38 messages

I have now unmounted the dm device to test if the daya is written to the
underlying block device.
[root@bladelinux01 ~]# umount /mnt/

[root@bladelinux01 ~]# dmsetup info raid1
Name:              raid1
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      1
Major, minor:      253, 6
Number of targets: 1

Here the open count is "ZERO", but still I cannot mount the underlying
block device.

[root@bladelinux01 ~]# mount /dev/loop0 /mnt/
mount: /dev/loop0 already mounted or /mnt/ busy
[root@bladelinux01 ~]# mount /dev/loop1 /mnt/
mount: /dev/loop1 already mounted or /mnt/ busy

But if I remove the dm device created and try to mount the underlying
block-device, I can mount both the device which took part in mirroring and
I can access the data in both the disk.
[root@bladelinux01 ~]# dmsetup remove raid1
[root@bladelinux01 ~]# mount /dev/loop0 /mnt/
[root@bladelinux01 ~]# ls -l /mnt/
total 51
drwx------. 2 root root 12288 Nov  2 22:32 lost+found
-rw-------. 1 root root 37417 Nov  2 22:38 messages

[root@bladelinux01 ~]# umount /mnt/
[root@bladelinux01 ~]# mount /dev/loop1 /mnt/
[root@bladelinux01 ~]# ls -l /mnt/
total 51
drwx------. 2 root root 12288 Nov  2 22:32 lost+found
-rw-------. 1 root root 37417 Nov  2 22:38 messages

Why is this behavior. any explanation, please....

-- sanjana

--bcaec548a81bc36ab404b0cc0bad
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I am testing a mirror target for dmsetup. After creating the dm =
device I cannot the underlying block device.<br><br style=3D"font-family: c=
ourier new,monospace;"><span style=3D"font-family: courier new,monospace;">=
[root@bladelinux01 ~]# dumpe2fs /dev/loop0 | head</span><br style=3D"font-f=
amily: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">dumpe2fs 1.41.12 (17-Ma=
y-2010)</span><br style=3D"font-family: courier new,monospace;"><span style=
=3D"font-family: courier new,monospace;">Filesystem volume name:=A0=A0 &lt;=
none&gt;</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Last mounted on:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &lt;not available&gt;</span><br style=3D"font-family:=
 courier new,monospace;"><span style=3D"font-family: courier new,monospace;=
">Filesystem UUID:=A0=A0=A0=A0=A0=A0=A0=A0=A0 9c0f4d5c-55d9-4332-b0e7-f48a1=
9333174</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Filesystem magic number=
:=A0 0xEF53</span><br style=3D"font-family: courier new,monospace;"><span s=
tyle=3D"font-family: courier new,monospace;">Filesystem revision #:=A0=A0=
=A0 1 (dynamic)</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Filesystem features:=A0=
=A0=A0=A0=A0 has_journal ext_attr resize_inode dir_index filetype sparse_su=
per</span><br style=3D"font-family: courier new,monospace;"><span style=3D"=
font-family: courier new,monospace;">Filesystem flags:=A0=A0=A0=A0=A0=A0=A0=
=A0 signed_directory_hash</span><br style=3D"font-family: courier new,monos=
pace;">
<span style=3D"font-family: courier new,monospace;">Default mount options:=
=A0=A0=A0 (none)</span><br style=3D"font-family: courier new,monospace;"><s=
pan style=3D"font-family: courier new,monospace;">Filesystem state:=A0=A0=
=A0=A0=A0=A0=A0=A0 clean</span><br style=3D"font-family: courier new,monosp=
ace;">
<span style=3D"font-family: courier new,monospace;">Errors behavior:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 Continue</span><br style=3D"font-family: courier new,=
monospace;"><span style=3D"font-family: courier new,monospace;">[root@blade=
linux01 ~]# dumpe2fs /dev/loop1 | head</span><br style=3D"font-family: cour=
ier new,monospace;">
<span style=3D"font-family: courier new,monospace;">dumpe2fs 1.41.12 (17-Ma=
y-2010)</span><br style=3D"font-family: courier new,monospace;"><span style=
=3D"font-family: courier new,monospace;">Filesystem volume name:=A0=A0 &lt;=
none&gt;</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Last mounted on:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &lt;not available&gt;</span><br style=3D"font-family:=
 courier new,monospace;"><span style=3D"font-family: courier new,monospace;=
">Filesystem UUID:=A0=A0=A0=A0=A0=A0=A0=A0=A0 c16fcae4-2271-4701-a91e-66949=
62935d0</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Filesystem magic number=
:=A0 0xEF53</span><br style=3D"font-family: courier new,monospace;"><span s=
tyle=3D"font-family: courier new,monospace;">Filesystem revision #:=A0=A0=
=A0 1 (dynamic)</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Filesystem features:=A0=
=A0=A0=A0=A0 has_journal ext_attr resize_inode dir_index filetype sparse_su=
per</span><br style=3D"font-family: courier new,monospace;"><span style=3D"=
font-family: courier new,monospace;">Filesystem flags:=A0=A0=A0=A0=A0=A0=A0=
=A0 signed_directory_hash</span><br style=3D"font-family: courier new,monos=
pace;">
<span style=3D"font-family: courier new,monospace;">Default mount options:=
=A0=A0=A0 (none)</span><br style=3D"font-family: courier new,monospace;"><s=
pan style=3D"font-family: courier new,monospace;">Filesystem state:=A0=A0=
=A0=A0=A0=A0=A0=A0 clean</span><br style=3D"font-family: courier new,monosp=
ace;">
<span style=3D"font-family: courier new,monospace;">Errors behavior:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 Continue</span><br style=3D"font-family: courier new,=
monospace;"><br style=3D"font-family: courier new,monospace;"><br style=3D"=
font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
mount /dev/loop0 /mnt/ ; mount | grep loop0</span><br style=3D"font-family:=
 courier new,monospace;"><span style=3D"font-family: courier new,monospace;=
">/dev/loop0 on /mnt type ext3 (rw)</span><br style=3D"font-family: courier=
 new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
umount /mnt/</span><br style=3D"font-family: courier new,monospace;"><br st=
yle=3D"font-family: courier new,monospace;"><span style=3D"font-family: cou=
rier new,monospace;">[root@bladelinux01 ~]# mount /dev/loop1 /mnt/ ; mount =
| grep loop1</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">/dev/loop1 on /mnt type=
 ext3 (rw)</span><br style=3D"font-family: courier new,monospace;"><span st=
yle=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# umount /=
mnt/</span><br style=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">[root@bladelinux01 ~]# dmsetup create raid1 --ta=
ble &quot;0 204800 mirror core 1 128 2 7:0 0 7:1 0&quot;</span><br style=3D=
"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">[root@bladelinux01 ~]# dmsetup table raid1</span=
><br style=3D"font-family: courier new,monospace;"><span style=3D"font-fami=
ly: courier new,monospace;">0 204800 mirror core 1 128 2 7:0 0 7:1 0</span>=
<br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
dmsetup info raid1</span><br style=3D"font-family: courier new,monospace;">=
<span style=3D"font-family: courier new,monospace;">Name:=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 raid1</span><br style=3D"font-family: courier new,mon=
ospace;">
<span style=3D"font-family: courier new,monospace;">State:=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ACTIVE</span><br style=3D"font-family: courier new,mo=
nospace;"><span style=3D"font-family: courier new,monospace;">Read Ahead:=
=A0=A0=A0=A0=A0=A0=A0 256</span><br style=3D"font-family: courier new,monos=
pace;">
<span style=3D"font-family: courier new,monospace;">Tables present:=A0=A0=
=A0 LIVE</span><br style=3D"font-family: courier new,monospace;"><span styl=
e=3D"font-family: courier new,monospace;">Open count:=A0=A0=A0=A0=A0=A0=A0 =
0</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Event number:=A0=A0=A0=
=A0=A0 1</span><br style=3D"font-family: courier new,monospace;"><span styl=
e=3D"font-family: courier new,monospace;">Major, minor:=A0=A0=A0=A0=A0 253,=
 6</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Number of targets: 1</s=
pan><br style=3D"font-family: courier new,monospace;"><br style=3D"font-fam=
ily: courier new,monospace;"><span style=3D"font-family: courier new,monosp=
ace;">[root@bladelinux01 ~]# dmsetup info -c raid1</span><br style=3D"font-=
family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Name=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 Maj Min Stat Open Targ Event=A0 UUID</span><br style=3D"=
font-family: courier new,monospace;"><span style=3D"font-family: courier ne=
w,monospace;">x=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 253=A0=A0 6 L-=
-w=A0=A0=A0 0=A0=A0=A0 1=A0=A0=A0=A0=A0 1</span><br style=3D"font-family: c=
ourier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
dmsetup deps raid1</span><br style=3D"font-family: courier new,monospace;">=
<span style=3D"font-family: courier new,monospace;">2 dependencies=A0 : (7,=
 1) (7, 0)</span><br style=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">[root@bladelinux01 ~]# dmsetup status /dev/mappe=
r/raid1</span><br style=3D"font-family: courier new,monospace;"><span style=
=3D"font-family: courier new,monospace;">0 204800 mirror 2 7:0 7:1 1600/160=
0 1 AA 1 core</span><br style=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">I have mounted the newly created dm device and c=
opied some data to it. </span><br style=3D"font-family: courier new,monospa=
ce;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
mount /dev/mapper/raid1 /mnt/ ; mount | grep raid1</span><br style=3D"font-=
family: courier new,monospace;"><span style=3D"font-family: courier new,mon=
ospace;">/dev/mapper/raid1 on /mnt type ext3 (rw)</span><br style=3D"font-f=
amily: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">[root@bladelinux01 ~]# cp /var/log/messages /mnt=
/</span><br style=3D"font-family: courier new,monospace;"><span style=3D"fo=
nt-family: courier new,monospace;">[root@bladelinux01 ~]# ls -l /mnt/</span=
><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">total 51</span><br styl=
e=3D"font-family: courier new,monospace;"><span style=3D"font-family: couri=
er new,monospace;">drwx------. 2 root root 12288 Nov=A0 2 22:32 lost+found<=
/span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">-rw-------. 1 root root=
 37417 Nov=A0 2 22:38 messages</span><br style=3D"font-family: courier new,=
monospace;"><br style=3D"font-family: courier new,monospace;"><span style=
=3D"font-family: courier new,monospace;">I have now unmounted the dm device=
 to test if the daya is written to the underlying block device.</span><br s=
tyle=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
umount /mnt/</span><br style=3D"font-family: courier new,monospace;"><br st=
yle=3D"font-family: courier new,monospace;"><span style=3D"font-family: cou=
rier new,monospace;">[root@bladelinux01 ~]# dmsetup info raid1</span><br st=
yle=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Name:=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 raid1</span><br style=3D"font-family: courier new,mon=
ospace;"><span style=3D"font-family: courier new,monospace;">State:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE</span><br style=3D"font-family: couri=
er new,monospace;">
<span style=3D"font-family: courier new,monospace;">Read Ahead:=A0=A0=A0=A0=
=A0=A0=A0 256</span><br style=3D"font-family: courier new,monospace;"><span=
 style=3D"font-family: courier new,monospace;">Tables present:=A0=A0=A0 LIV=
E</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Open count:=A0=A0=A0=A0=
=A0=A0=A0 0</span><br style=3D"font-family: courier new,monospace;"><span s=
tyle=3D"font-family: courier new,monospace;">Event number:=A0=A0=A0=A0=A0 1=
</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">Major, minor:=A0=A0=A0=
=A0=A0 253, 6</span><br style=3D"font-family: courier new,monospace;"><span=
 style=3D"font-family: courier new,monospace;">Number of targets: 1</span><=
br style=3D"font-family: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">Here the open count is &quot;ZERO&quot;, but sti=
ll I cannot mount the underlying block device.</span><br style=3D"font-fami=
ly: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">[root@bladelinux01 ~]# mount /dev/loop0 /mnt/</s=
pan><br style=3D"font-family: courier new,monospace;"><span style=3D"font-f=
amily: courier new,monospace;">mount: /dev/loop0 already mounted or /mnt/ b=
usy</span><br style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
mount /dev/loop1 /mnt/</span><br style=3D"font-family: courier new,monospac=
e;"><span style=3D"font-family: courier new,monospace;">mount: /dev/loop1 a=
lready mounted or /mnt/ busy</span><br style=3D"font-family: courier new,mo=
nospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">But if I remove the dm device created and try to=
 mount the underlying block-device, I can mount both the device which took =
part in mirroring and I can access the data in both the disk.</span><br sty=
le=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
dmsetup remove raid1</span><br style=3D"font-family: courier new,monospace;=
"><span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]=
# mount /dev/loop0 /mnt/</span><br style=3D"font-family: courier new,monosp=
ace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
ls -l /mnt/</span><br style=3D"font-family: courier new,monospace;"><span s=
tyle=3D"font-family: courier new,monospace;">total 51</span><br style=3D"fo=
nt-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">drwx------. 2 root root=
 12288 Nov=A0 2 22:32 lost+found</span><br style=3D"font-family: courier ne=
w,monospace;"><span style=3D"font-family: courier new,monospace;">-rw------=
-. 1 root root 37417 Nov=A0 2 22:38 messages</span><br style=3D"font-family=
: courier new,monospace;">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">[root@bladelinux01 ~]# umount /mnt/</span><br st=
yle=3D"font-family: courier new,monospace;"><span style=3D"font-family: cou=
rier new,monospace;">[root@bladelinux01 ~]# mount /dev/loop1 /mnt/</span><b=
r style=3D"font-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">[root@bladelinux01 ~]# =
ls -l /mnt/</span><br style=3D"font-family: courier new,monospace;"><span s=
tyle=3D"font-family: courier new,monospace;">total 51</span><br style=3D"fo=
nt-family: courier new,monospace;">
<span style=3D"font-family: courier new,monospace;">drwx------. 2 root root=
 12288 Nov=A0 2 22:32 lost+found</span><br style=3D"font-family: courier ne=
w,monospace;"><span style=3D"font-family: courier new,monospace;">-rw------=
-. 1 root root 37417 Nov=A0 2 22:38 messages</span><br style=3D"font-family=
: courier new,monospace;" clear=3D"all">
<br style=3D"font-family: courier new,monospace;"><span style=3D"font-famil=
y: courier new,monospace;">Why is this behavior. any explanation, please...=
.</span><br>=A0<br><span style=3D"font-family:courier new,monospace">-- san=
jana</span><br>
<br>

--bcaec548a81bc36ab404b0cc0bad--


--===============8361166021746322104==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8361166021746322104==--
