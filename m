From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm-integrity: Prevent RMW for full metadata buffer
 writes
Date: Tue, 24 Mar 2020 15:11:49 -0400
Message-ID: <20200324191148.GA2921@redhat.com>
References: <20200227142601.61f3cd54@luklap>
 <20200324171821.GA2444@redhat.com>
 <20200324195912.518dc87c@luklap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200324195912.518dc87c@luklap>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Straub <lukasstraub2@web.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 24 2020 at  2:59pm -0400,
Lukas Straub <lukasstraub2@web.de> wrote:

> On Tue, 24 Mar 2020 13:18:22 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Thu, Feb 27 2020 at  8:26am -0500,
> > Lukas Straub <lukasstraub2@web.de> wrote:
> > 
> > > If a full metadata buffer is being written, don't read it first. This
> > > prevents a read-modify-write cycle and increases performance on HDDs
> > > considerably.
> > > 
> > > To do this we now calculate the checksums for all sectors in the bio in one
> > > go in integrity_metadata and then pass the result to dm_integrity_rw_tag,
> > > which now checks if we overwrite the whole buffer.
> > > 
> > > Benchmarking with a 5400RPM HDD with bitmap mode:
> > > integritysetup format --no-wipe --batch-mode --interleave-sectors $((64*1024)) -t 4 -s 512 -I crc32c -B /dev/sdc
> > > integritysetup open --buffer-sectors=1 -I crc32c -B /dev/sdc hdda_integ
> > > dd if=/dev/zero of=/dev/mapper/hdda_integ bs=64K count=$((16*1024*4)) conv=fsync oflag=direct status=progress
> > > 
> > > Without patch:
> > > 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 400.326 s, 10.7 MB/s
> > > 
> > > With patch:
> > > 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.2057 s, 104 MB/s
> > > 
> > > Signed-off-by: Lukas Straub <lukasstraub2@web.de>
> > > ---
> > > Hello Everyone,
> > > So here is v2, now checking if we overwrite a whole metadata buffer instead
> > > of the (buggy) check if we overwrite a whole tag area before.
> > > Performance stayed the same (with --buffer-sectors=1).
> > > 
> > > The only quirk now is that it advertises a very big optimal io size in the
> > > standard configuration (where buffer_sectors=128). Is this a Problem?
> > > 
> > > v2:
> > >  -fix dm_integrity_rw_tag to check if we overwrite a whole metadat buffer
> > >  -fix optimal io size to check if we overwrite a whole metadata buffer
> > > 
> > > Regards,
> > > Lukas Straub  
> > 
> > 
> > Not sure why you didn't cc Mikulas but I just checked with him and he
> > thinks:
> > 
> > You're only seeing a boost because you're using 512-byte sector and
> > 512-byte buffer. Patch helps that case but hurts in most other cases
> > (due to small buffers).
> 
> Hmm, buffer-sectors is still user configurable. If the user wants fast
> write performance on slow HDDs he can set a small buffer-sector and
> benefit from this patch. With the default buffer-sectors=128 it
> shouldn't have any impact.

OK, if you'd be willing to conduct tests to prove there is no impact
with larger buffers that'd certainly help reinforce your position and
make it easier for me to take your patch.

But if you're just testing against slow HDD testbeds then the test
coverage isn't wide enough.

Thanks,
Mike
