From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [RFC] Userspace-Controlled CoW Device
Date: Mon, 6 Feb 2006 11:52:13 +0100
Message-ID: <62b0912f0602060252s46dff71ao6a82ee8ae2bed9d1@mail.gmail.com>
References: <87fyn03x2n.fsf@caffeine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87fyn03x2n.fsf@caffeine.beaverton.ibm.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: danms@us.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Dan Smith wrote:
> Comments?

1.)
Is there any technically convincing reason why the qcow thing must be
an integral part of the CoW target?

I'm thinking that it's possibly cleaner to implement a device-mapper
target that presents a block device of a custom size to upper layers,
while actually storing data in a qcow file, regular sparse file, or
what not.  For the sake of discussion, let's call this dm extension
'dm-autogrow'.

What you're trying to do could then be accomplished by layering
dm-snapshot on top of dm-autogrow.  It requires a bit more scripting
magic, but in the end the implementation might turn out to be simpler,
and you get to reuse dm-snapshot.

A dm-autogrow target is potentially useful for other things.  There
are various applications that would like to read a qcow file as a
block device, for example.  Perhaps the QEMU folks would be helpful
wrt. the implementation stuff, since QEMU could potentially use it
too.

That said, I feel that 'qcow' is a bit of a misnomer.  It's not like
QEMU is actually copying any blocks anywhere is it?  It's a file that
grows automatically, but AFAIK QEMU has absolutely no snapshot / CoW
support.

With the above in mind, and assuming that you want the qcow image as
the write target, I'm unsure why it would even be useful to use a qcow
image in particular.  It's not like qemu will be able to make any
sense of the qcow file afterwards, since it will only contain half a
filesystem... or am I completely wrong here?


2.)
A couple of things I would personally like to see wrt. Xen and CoW.

 a.)  Avoid write reordering (=3D avoid breaking journal filesystems in X=
en vms).

 b.)  When an entire block of zeros is written, nuke it from the qcow
image or "sparsify" the block in the underlying sparse file.

Point b) requires a patch to guest domains so that the filesystem zero
released blocks, but that already exists for ext3, I think.

(An alternative approach to that would be to make a target in between
the guest and the CoW device that understands the ext3 filesystem.  It
could catch when ext3 writes to the list of free filesystem blocks and
zero those blocks..)

... too tired to come up with anything else right now :-).
