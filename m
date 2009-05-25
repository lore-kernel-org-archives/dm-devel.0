From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks
	data integrity
Date: Mon, 25 May 2009 14:46:30 -0300
Message-ID: <20090525174630.GI1376@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar> <87my91qsn4.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87my91qsn4.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Mon, May 25, 2009 at 02:22:23PM +0200, Goswin von Brederlow wrote:
> Alberto Bertogli <albertito@blitiri.com.ar> writes:
> > I'm writing this device mapper target that stores checksums on writes and
> > verifies them on reads.
> 
> How does that behave on crashes? Will checksums be out of sync with data?
> Will pending blocks recalculate their checksum?

It should behave well on crashes, the checksums should be in sync (see below),
and there is no concept of "pending blocks".

Quoting from the docs (included at the beginning of the patch):

   It stores an 8-byte "integrity metadata" ("imd", from now on) structure for
   each 512-byte data sector. imd structures are clustered in groups of 62
   plus a small header, so they fit a sector (referred to as an "imd sector").
   Every imd sector has a "brother", another adjacent imd sector, for
   consistency purposes (explained below). That means we devote two sectors to
   imd storage for every 62 data sectors.

   [...]

   To guarantee consistency, two imd sectors (named M1 and M2) are kept for
   every 62 data sectors, and the following procedure is used to update them
   when a write to a given sector is required:

    - Read both M1 and M2.
    - Find out (using information stored in their headers) which one is newer.
      Let's assume M1 is newer than M2.
    - Update the M2 buffer to mark it's newer, and update the new data's CRC.
    - Submit the write to M2, and then the write to the data, using a barrier
      to make sure the metadata is updated _after_ the data.

   Accordingly, the read operations are handled as follows:

    - Read both the data, M1 and M2.
    - Find out which one is newer. Let's assume M1 is newer than M2.
    - Calculate the data's CRC, and compare it to the one found in M1. If they
      match, the reading is successful. If not, compare it to the one found in
      M2. If they match, the reading is successful; otherwise, fail. If
      the read involves multiple sectors, it is possible that some of the
      correct CRCs are in M1 and some in M2.


The barrier will be (it's not done yet) replaced with serialized writes for
cases where the underlying block device does not support them, or when the
integrity metadata resides on a different block device than the data.


This scheme assumes writes to a single sector are atomic in the presence of
normal crashes, which I'm not sure if it's something sane to assume in
practise. If it's not, then the scheme can be modified to cope with that.


Thanks a lot,
		Alberto

