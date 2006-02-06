From: Dan Smith <danms@us.ibm.com>
Subject: Re: [RFC] Userspace-Controlled CoW Device
Date: Mon, 06 Feb 2006 08:25:09 -0800
Message-ID: <87zml41ml6.fsf@caffeine.beaverton.ibm.com>
References: <87fyn03x2n.fsf@caffeine.beaverton.ibm.com>
	<62b0912f0602060252s46dff71ao6a82ee8ae2bed9d1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


MB> 1.)  Is there any technically convincing reason why the qcow thing
MB> must be an integral part of the CoW target?

No, there isn't.  That's why I propose that all the qcow-related logic
be in userspace, instead of part of the target.  The dm-cow target
would be a generic enabler for any kind of CoW implementation, which
would be implemented in userspace.

It is possible that other CoW algorithms or strategies would provide
different benefits to certain situations.  The idea is to provide a
generic enabler and the ability to implement such algorithms in
userspace, not just to support qcow.

MB> I'm thinking that it's possibly cleaner to implement a
MB> device-mapper target that presents a block device of a custom size
MB> to upper layers, while actually storing data in a qcow file,
MB> regular sparse file, or what not.  For the sake of discussion,
MB> let's call this dm extension 'dm-autogrow'.

MB> What you're trying to do could then be accomplished by layering
MB> dm-snapshot on top of dm-autogrow.  It requires a bit more
MB> scripting magic, but in the end the implementation might turn out
MB> to be simpler, and you get to reuse dm-snapshot.

I'm confused.  Assuming the qcow case, how could dm-snapshot be
reused, when the allocation of a CoW block must be done in accordance
with the qcow algorithm?  And how would scripting magic be cleaner?

MB> That said, I feel that 'qcow' is a bit of a misnomer.  It's not
MB> like QEMU is actually copying any blocks anywhere is it?  It's a
MB> file that grows automatically, but AFAIK QEMU has absolutely no
MB> snapshot / CoW support.

Yes, it does.  QEMU has a disk format called 'qcow' which compliments
an existing base image.  The qcow disk image must be used in
conjunction with the base image.  See this page:

  http://fabrice.bellard.free.fr/qemu/qemu-doc.html#SEC18

MB> With the above in mind, and assuming that you want the qcow image
MB> as the write target, I'm unsure why it would even be useful to use
MB> a qcow image in particular.  It's not like qemu will be able to
MB> make any sense of the qcow file afterwards, since it will only
MB> contain half a filesystem... or am I completely wrong here?

I think you misunderstood my intent.  I want the qcow image (along
with the base image) to remain valid while using it, so that it could
be later re-used with QEMU.

-- 
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
