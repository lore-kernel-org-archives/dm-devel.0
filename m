From: Mailing Lists <mailing-lists@racitup.com>
Subject: dm-lazymirror advice
Date: Fri, 12 Feb 2016 16:48:07 +0000
Message-ID: <CAP9mscA9FYyJzKvPcVe-T4=wc6qZOTHg1wVidmNK43ge4BqSZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5780909043347240242=="
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

--===============5780909043347240242==
Content-Type: multipart/alternative; boundary=94eb2c060c1679ff6f052b956e42

--94eb2c060c1679ff6f052b956e42
Content-Type: text/plain; charset=UTF-8

Hi all,

I have recently been writing a blog article on hard disk recovery, and
think I have found an approach that would lend itself to a device mapper.

The idea is this:
Most tools currently try and copy the whole hard disk as best they can
using an approach like ddrescue, this seems inefficient and risky if your
disk is only partially used and you think it is about to fail (you've just
replaced the heads for example).
Really what you want to recover first are the users' most important files,
but to get to those first you need to read the partition table and
filesystem(s) of which there are many to choose from. Of course you can
access the filesystems using any number of tools like testdisk, fdisk,
fsck, etc, but you don't get a copy. I think it would be most efficient to
copy every disk access on the origin device to a backup device just in case
the origin disk fails, but in a filesystem-agnostic way. Of course I'm
talking of reads mostly, but also maybe writes if for example testdisk has
been able to repair the partition table.

Having had a good search for a method of doing this, the closest available
seems to be *dm-cache*. Having set the sequential_threshold and
random_threshold both to 0, I assume dm-cache will copy all origin accesses
to the cache device, and keep a record of the blocks in the cache and their
physical location on the origin in the metadata device. This is very close,
but to be able to restore the backup copy I need to be able to parse the
metadata and reconstruct the copy in userspace.

Questions:

   1. Does this seem to be a good match for a device mapper or is there a
   better way of doing this?
   2. Would this be best placed as a new device-mapper target or could this
   be implemented as a new operating mode or policy of an existing dm target?
   3. Are there any userspace tools planned for the dm-cache metadata (like
   thin-provisioning-tools), and if not which kernel files would I look in as
   a start to writing a parser?

In 'cache.txt' it states: "The target reuses the metadata library used in
the thin-provisioning library." but I tried those tools and they didn't
appear to work, failing with "bad checksum in superblock".

I would be interested in writing some kernel code since I do know C, but
having never written any kernel code before I feel this might be a rather
steep learning curve. I rather feel that my skills might be best placed
writing a parser instead. I think at first I should at least prove the
concept!

Many thanks in advance, and keep up the excellent work. I'm a long-time
Linux user, since Redhat 5.2 I think!
Regards,
Richard

--94eb2c060c1679ff6f052b956e42
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div><br></div><div>I have recently been writing a =
blog article on hard disk recovery, and think I have found an approach that=
 would lend itself to a device mapper.</div><div><br></div><div>The idea is=
 this:</div><div>Most tools currently try and copy the whole hard disk as b=
est they can using an approach like ddrescue, this seems inefficient and ri=
sky if your disk is only partially used and you think it is about to fail (=
you&#39;ve just replaced the heads for example).</div><div>Really what you =
want to recover first are the users&#39; most important files, but to get t=
o those first you need to read the partition table and filesystem(s) of whi=
ch there are many to choose from. Of course you can access the filesystems =
using any number of tools like testdisk, fdisk, fsck, etc, but you don&#39;=
t get a copy. I think it would be most efficient to copy every disk access =
on the origin device to a backup device just in case the origin disk fails,=
 but in a filesystem-agnostic way. Of course I&#39;m talking of reads mostl=
y, but also maybe writes if for example testdisk has been able to repair th=
e partition table.</div><div><br></div><div>Having had a good search for a =
method of doing this, the closest available seems to be <b>dm-cache</b>. Ha=
ving set the sequential_threshold and random_threshold both to 0, I assume =
dm-cache will copy all origin accesses to the cache device, and keep a reco=
rd of the blocks in the cache and their physical location on the origin in =
the metadata device. This is very close, but to be able to restore the back=
up copy I need to be able to parse the metadata and reconstruct the copy in=
 userspace.</div><div><br></div><div>Questions:</div><div><ol><li>Does this=
 seem to be a good match for a device mapper or is there a better way of do=
ing this?<br></li><li>Would this be best placed as a new device-mapper targ=
et or could this be implemented as a new operating mode or policy of an exi=
sting dm target?<br></li><li>Are there any userspace tools planned for the =
dm-cache metadata (like thin-provisioning-tools), and if not which kernel f=
iles would I look in as a start to writing a parser?<br></li></ol><div>In &=
#39;cache.txt&#39; it states: &quot;<span style=3D"color:rgb(0,0,0);white-s=
pace:pre-wrap">The target reuses the metadata library used in the thin-prov=
isioning </span><span style=3D"color:rgb(0,0,0);white-space:pre-wrap">libra=
ry.</span>&quot; but I tried those tools and they didn&#39;t appear to work=
, failing with &quot;bad checksum in superblock&quot;.</div></div><div><br>=
</div><div>I would be interested in writing some kernel code since I do kno=
w C, but having never written any kernel code before I feel this might be a=
 rather steep learning curve. I rather feel that my skills might be best pl=
aced writing a parser instead. I think at first I should at least prove the=
 concept!</div><div><br></div><div>Many thanks in advance, and keep up the =
excellent work. I&#39;m a long-time Linux user, since Redhat 5.2 I think!</=
div><div>Regards,</div><div>Richard</div></div>

--94eb2c060c1679ff6f052b956e42--


--===============5780909043347240242==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5780909043347240242==--
