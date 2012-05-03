From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Thu, 3 May 2012 10:14:29 +0100
Message-ID: <20120503091428.GB5351@ubuntu>
References: <4F9FDCC2.2080905@shiftmail.org> <20120501141023.GA20313@ubuntu>
	<4FA006CD.3050204@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4FA006CD.3050204@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Spelic <spelic@shiftmail.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, May 01, 2012 at 05:52:45PM +0200, Spelic wrote:
> I'm looking at it right now
> Well, I was thinking at a parent snapshot and child snapshot (or
> anyway an older and a more recent snapshot of the same device) so
> I'm not sure that's the feature I needed... probably I'm missing
> something and need to study more

I'm not really following you here.  You can have arbitrary depth of
snapshots (snaps of snaps) if that helps.

> I'm not sure I have understood the full nomenclature of dm-thin yet
> :-) ... "dm-thin blocks" would be the same thing as so called "pool
> blocksize" as talked in the thread " Re: [PATCH 2/2] dm thin:
> support for non power of 2 pool blocksize" right? so that's
> customizable now and not necessarily in power of 2...
> 
> But those are anyway quite big, default is what, 64 megabytes?
> (which is in fact a good thing for preventing excessive
> fragmentation...)

Yes, this is the pool block size, it's the atomic unit used for
provisioning and copy-on-write.  I think the LVM2 tools default this
to be 512 _k_.  You'd only set it to 64M if you had little interest in
snapshot performance.

> Now an obvious question:
> If userspace sends multiple smaller discards eventually covering the
> whole block, the block will still be unmapped correctly, right?

No, I don't track anything smaller than a block.  (Note, blocks are
typically much smaller than you've been envisioning.)

> If yes: so you do preserve the information of what part of the block
> is has already been discarded, and what part is not... so it would
> be possible to return zeroes if the unmapped sub-part of the block
> is being read... right?

No, but the underlying device may do ...

> >then the mappings will be removed.  Any future io to that block will
> >trigger the block to be reprovisioned.
> 
> (note: here we are talking of a full block now unmapped, different
> situation from above)
> Ok, supposing I do *not* write, so it does not get reprovisioned,
> what does reading from there return; does it return zeroes, or it
> returns nonzero data coming from the parent snapshot at the same
> offset?

zeroes.

> >...
> >As for identifying empty blocks from userland: there is an inherant
> >race here.  What would you do with the info?
> 
> You are right , I would definitely need to take a snapshot prior to
> reading that... so consider my question related to reading a
> snapshot of a device which has been partially discarded...

Y, I'll provide tools to let you do this.  If you wish to help with
writing a replicator please email me.  It's a project I'm keen to get
going.

- Joe
