From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft
	RAID under Linux
Date: Tue, 9 Jun 2009 09:32:55 +1000
Message-ID: <18989.40871.865610.422540@notabene.brown>
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
	<18981.62579.171350.910761@notabene.brown>
	<1244040123.6938.19.camel@o>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Heinz Mauelshagen on Wednesday June 3
Sender: linux-fsdevel-owner@vger.kernel.org
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>
List-Id: dm-devel.ids

On Wednesday June 3, heinzm@redhat.com wrote:
> > 
> > I haven't spoken to them, no (except for a couple of barely-related
> > chats with Alasdair).
> > By and large, they live in their little walled garden, and I/we live
> > in ours.
> 
> Maybe we are about to change that? ;-)

Maybe ... what should we talk about?

Two areas where I think we might be able to have productive
discussion:

 1/ Making md personalities available as dm targets.
    In one sense this is trivial as an block device can be a DM
    target, and any md personality can be a block device.
    However it might be more attractive if the md personality
    responded to dm ioctls.
    Considering specifically raid5, some aspects of plugging
    md/raid5 underneath dm would be trivial - e.g. assembling the
    array at the start.
    However others are not so straight forward.
    In particular, when a drive fails in a raid5, you need to update
    the metadata before allowing any writes which depend on that drive
    to complete.  Given that metadata is managed in user-space, this
    means signalling user-space and waiting for a response.
    md does this via a file in sysfs.  I cannot see any similar
    mechanism in dm, but I haven't looked very hard.

    Would it be useful to pursue this do you think?


 2/ It might be useful to have a common view how virtual devices in
    general should be managed in Linux.  Then we could independently
    migrated md and dm towards this goal.

    I imagine a block-layer level function which allows a blank
    virtual device to be created, with an arbitrary major/minor
    allocated.
    e.g.
         echo foo > /sys/block/.new
    causes
         /sys/devices/virtual/block/foo/
    to be created.
    Then a similar mechanism associates that with a particular driver.
    That causes more attributes to appear in  ../block/foo/ which
    can be used to flesh out the details of the device.

    There would be library code that a driver could use to:
      - accept subordinate devices
      - manage the state of those devices
      - maintain a write-intent bitmap
    etc.

    There would also need to be a block-layer function to 
    suspend/resume or similar so that a block device can be changed
    underneath a filesystem.

    We currently have three structures for a block device:
      struct block_device -> struct gendisk -> struct request_queue

    I imagine allow either the "struct gendisk" or  the "struct
    request_queue" to be swapped between two "struct block_device".
    I'm not sure which, and the rest of the details are even more
    fuzzy.

    That sort of infrastructure would allow interesting migrations
    without being limited to "just with dm" or "just within md".

    Thoughts?

NeilBrown
