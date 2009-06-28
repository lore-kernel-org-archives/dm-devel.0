From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that
	checks data integrity
Date: Sun, 28 Jun 2009 12:30:25 -0300
Message-ID: <20090628153025.GH5913@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar>
	<87my91qsn4.fsf@frosties.localdomain>
	<20090525174630.GI1376@blitiri.com.ar>
	<8763fop31e.fsf@frosties.localdomain>
	<20090526125252.GL1376@blitiri.com.ar>
	<19014.47753.69063.510164@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <19014.47753.69063.510164@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, Goswin von Brederlow <goswin-v-b@web.de>
List-Id: dm-devel.ids

On Sun, Jun 28, 2009 at 10:34:17AM +1000, Neil Brown wrote:
> On Tuesday May 26, albertito@blitiri.com.ar wrote:
> > On Tue, May 26, 2009 at 12:33:01PM +0200, Goswin von Brederlow wrote:
> > > > This scheme assumes writes to a single sector are atomic in the presence of
> > > > normal crashes, which I'm not sure if it's something sane to assume in
> > > > practise. If it's not, then the scheme can be modified to cope with that.
> > > 
> > > What happens if you have multiple writes to the same sector? (assuming
> > > you ment "before" above)
> > > 
> > > - user writes to sector
> > > - queue up write for M1 and data1
> > > - M1 writes
> > > - user writes to sector
> > > - queue up writes for M2 and data2
> > > - data1 is thrown away as data2 overwrites it
> > > - M2 writes
> > > - system crashes
> > > 
> > > Now both M1 and M2 have a different checksum than the old data left on
> > > disk.
> > > 
> > > Can this happen?
> > 
> > No, parallel writes that affect the same metadata sectors will not be allowed.
> > At the moment there is a rough lock which does not allow simultaneous updates
> > at all, I plan to make that more fine-grained in the future.
> 
> Can I suggest a variation on the above which, I think, can cause a
> problem.
> 
>  - user writes data-A' to sector-A (which currently contains data-A)
>  - queue up write for M1 and data-A'
>  - M1 is written correctly.
>  - power fails (before data-A' is written)
> reboot
>  - read sector-A, find data-A which matches checksum on M2, so
>    success.
> 
> So everything is working perfectly so far...
> 
>  - write sector-B (in same 62-sector range as sector-A).
>  - queue up write for M2 and data-B
>  - those writes complete
>  - read sector-A.  find data-A, which doesn't match M1 (that has
>    data-A') and doesn't match M2 (which is mostly a copy of M1),
>    so the read fails.

The thing is that M2 is not a copy of M1. When updating M2 for data-B, the
procedure is not "copy M1, update sector-B's checksum, write" but "read M2,
update sector-B's checksum, write". So as long as there are no writes to
sector-A, M1 will have the incorrect checksum and M2 will have the correct
one, regardless of writes to the other sectors.

However, a troubling scenario based on yours could be:

 - M2 has the right checksum but is older, M1 has the wrong checksum but is
   newer.
 - user writes data-A'' to sector'A
 - queue up write for M2 (chosen because it is older)
 - M2 is written correctly
 - power fails before data-A'' is written

At that point, data-A is written at sector-A, but both M1 and M2 have
incorrect checksums for it.

I'll try to come up with a better scheme that copes with this kind of
scenarios and post an updated patch.

Thanks a lot,
		Alberto
