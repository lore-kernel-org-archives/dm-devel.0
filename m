From: Thiago Padilha <tpadilha84@gmail.com>
Subject: Any device mapper target that stores data in files?
Date: Mon, 17 Aug 2015 04:55:59 +0000
Message-ID: <CAAq2XdoSv34qGewtGKRxUo064dG8mFudxZtw4A_nEUace3KQXQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7521963001293674815=="
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

--===============7521963001293674815==
Content-Type: multipart/alternative; boundary=001a1133b4a4aaead9051d7a9eda

--001a1133b4a4aaead9051d7a9eda
Content-Type: text/plain; charset=UTF-8

Hi

First of all, I'm very new on the subject(kernel programming/device
mappers/block devices), so forgive if I say anything stupid.

I need a device mapper target that stores data in files of fixed sizes,
probably defined when the virtual device is first created. For the sake of
explanation, lets call this target as "dirdm" and assume there's an
userspace tool of the same name that can be used to manage such virtual
devices. Now let's say I have an empty directory "/dirdm" and want to
create a virtual device with 4k "block size" on top of it:

    dirdm create --size 10G --block-size 4k /dirdm

After this command is executed, there's a new file with 4k size at
/dirdm/0. This file will be used to store the first block of the device.
Here are the filenames that represent some blocks of this virtual device:

- block 0: 0
- block 1: 4096
- block 2 8192
- block 3: 12288
- block 4: 16384

That is, each block is stored in a file named after the first byte on the
block. Querying a block that has no data written will simply return 0(block
files are also initialized with 0), so it behaves like a sparse block
device.

Is there any device mapper implementation that manages data in a similar
manner? Note that these details about filenames or directory structure are
not important, all I care about is that the dm target splits data in
relatively small files on a directory.

The reason for these requirements is to be able to efficiently store
arbitrary block devices in a cloud storage service such a google
drive/onedrive without syncing a big loop device on every modification(Only
files representing affected blocks are modified). One useful application
would be to create a big device(such as 100g size) and add luks/ext4 on top
of it, which would be a great way to store private data.

If there are no existing dm targets matching these requirements, what would
be a recommended reading/documentation to get started on implementing this
on my own?

--001a1133b4a4aaead9051d7a9eda
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div>Hi<br><br></div><div>First o=
f all, I&#39;m very new on the subject(kernel programming/device mappers/bl=
ock devices), so forgive if I say anything stupid.<br><br></div>I need a de=
vice mapper target that stores data in files of fixed sizes, probably defin=
ed when the virtual device is first created. For the sake of explanation, l=
ets call this target as &quot;dirdm&quot; and assume there&#39;s an userspa=
ce tool of the same name that can be used to manage such virtual devices. N=
ow let&#39;s say I have an empty directory &quot;/dirdm&quot; and want to c=
reate a virtual device with 4k &quot;block size&quot; on top of it:<br><br>=
</div>=C2=A0=C2=A0=C2=A0 dirdm create --size 10G --block-size 4k /dirdm<br>=
<br></div>After this command is executed, there&#39;s a new file with 4k si=
ze at /dirdm/0. This file will be used to store the first block of the devi=
ce. Here are the filenames that represent some blocks of this virtual devic=
e:<br><br></div>- block 0: 0<br></div>- block 1: 4096<br></div>- block 2 81=
92<br><div><div><div><div>- block 3: 12288<br></div><div>- block 4: 16384<b=
r><br></div><div>That is, each block is stored in a file named after the fi=
rst byte on the block. Querying a block that has no data written will simpl=
y return 0(block files are also initialized with 0), so it behaves like a s=
parse block device.<br><br></div><div>Is there any device mapper implementa=
tion that manages data in a similar manner? Note that these details about f=
ilenames or directory structure are not important, all I care about is that=
 the dm target splits data in relatively small files on a directory.<br><br=
></div><div>The reason for these requirements is to be able to efficiently =
store arbitrary block devices in a cloud storage service such a google driv=
e/onedrive without syncing a big loop device on every modification(Only fil=
es representing affected blocks are modified). One useful application would=
 be to create a big device(such as 100g size) and add luks/ext4 on top of i=
t, which would be a great way to store private data.<br></div><div><br></di=
v><div>If there are no existing dm targets matching these requirements, wha=
t would be a recommended reading/documentation to get started on implementi=
ng this on my own?<br></div><div></div><div><br></div></div></div></div></d=
iv>

--001a1133b4a4aaead9051d7a9eda--


--===============7521963001293674815==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7521963001293674815==--
