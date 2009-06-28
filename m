From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks
	data integrity
Date: Sun, 28 Jun 2009 10:34:17 +1000
Message-ID: <19014.47753.69063.510164@notabene.brown>
References: <20090521161317.GU1376@blitiri.com.ar>
	<87my91qsn4.fsf@frosties.localdomain>
	<20090525174630.GI1376@blitiri.com.ar>
	<8763fop31e.fsf@frosties.localdomain>
	<20090526125252.GL1376@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alberto Bertogli on Tuesday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Tuesday May 26, albertito@blitiri.com.ar wrote:
> On Tue, May 26, 2009 at 12:33:01PM +0200, Goswin von Brederlow wrote:
> > Alberto Bertogli <albertito@blitiri.com.ar> writes:
> > > On Mon, May 25, 2009 at 02:22:23PM +0200, Goswin von Brederlow wrote:
> > >> Alberto Bertogli <albertito@blitiri.com.ar> writes:
> > >> > I'm writing this device mapper target that stores checksums on writes and
> > >> > verifies them on reads.
> > >> 
> > >> How does that behave on crashes? Will checksums be out of sync with data?
> > >> Will pending blocks recalculate their checksum?
> > >
> > >    To guarantee consistency, two imd sectors (named M1 and M2) are kept for
> > >    every 62 data sectors, and the following procedure is used to update them
> > >    when a write to a given sector is required:
> > >
> > >     - Read both M1 and M2.
> > >     - Find out (using information stored in their headers) which one is newer.
> > >       Let's assume M1 is newer than M2.
> > >     - Update the M2 buffer to mark it's newer, and update the new data's CRC.
> > >     - Submit the write to M2, and then the write to the data, using a barrier
> > >       to make sure the metadata is updated _after_ the data.
> > 
> > Consider that the disk writes the data and then the system
> > crashes. Now you have the old checksum but the new data. The checksum
> > is out of sync.
> > 
> > Don't you mean that M2 is written _before_ the data? That way you have
> > the old checksum in M1 and the new in M2. One of them will match
> > depending on wether the data gets written before a crash or not. That
> > would be more consistent with your read operation below.
> 
> Yes, the comment is wrong, thanks for noticing. That is how it's implemented.
> 
> 
> > >    Accordingly, the read operations are handled as follows:
> > >
> > >     - Read both the data, M1 and M2.
> > >     - Find out which one is newer. Let's assume M1 is newer than M2.
> > >     - Calculate the data's CRC, and compare it to the one found in M1. If they
> > >       match, the reading is successful. If not, compare it to the one found in
> > >       M2. If they match, the reading is successful; otherwise, fail. If
> > >       the read involves multiple sectors, it is possible that some of the
> > >       correct CRCs are in M1 and some in M2.
> > >
> > >
> > > The barrier will be (it's not done yet) replaced with serialized writes for
> > > cases where the underlying block device does not support them, or when the
> > > integrity metadata resides on a different block device than the data.
> > >
> > >
> > > This scheme assumes writes to a single sector are atomic in the presence of
> > > normal crashes, which I'm not sure if it's something sane to assume in
> > > practise. If it's not, then the scheme can be modified to cope with that.
> > 
> > What happens if you have multiple writes to the same sector? (assuming
> > you ment "before" above)
> > 
> > - user writes to sector
> > - queue up write for M1 and data1
> > - M1 writes
> > - user writes to sector
> > - queue up writes for M2 and data2
> > - data1 is thrown away as data2 overwrites it
> > - M2 writes
> > - system crashes
> > 
> > Now both M1 and M2 have a different checksum than the old data left on
> > disk.
> > 
> > Can this happen?
> 
> No, parallel writes that affect the same metadata sectors will not be allowed.
> At the moment there is a rough lock which does not allow simultaneous updates
> at all, I plan to make that more fine-grained in the future.

Can I suggest a variation on the above which, I think, can cause a
problem.

 - user writes data-A' to sector-A (which currently contains data-A)
 - queue up write for M1 and data-A'
 - M1 is written correctly.
 - power fails (before data-A' is written)
reboot
 - read sector-A, find data-A which matches checksum on M2, so
   success.

So everything is working perfectly so far...

 - write sector-B (in same 62-sector range as sector-A).
 - queue up write for M2 and data-B
 - those writes complete
 - read sector-A.  find data-A, which doesn't match M1 (that has
   data-A') and doesn't match M2 (which is mostly a copy of M1),
   so the read fails.


i.e. you get a situation where writing one sector can cause another
sector to spontaneously fail.

NeilBrown

