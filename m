From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: fstrim discarding too many or wrong blocks on Linux 5.1, leading
 to data loss
Date: Tue, 21 May 2019 16:12:27 -0400
Message-ID: <20190521201226.GA23332@lobo>
References: <297da4cbe20235080205719805b08810@bi-co.net>
 <CAJCQCtR-uo9fgs66pBMEoYX_xAye=O-L8kiMwyAdFjPS5T4+CA@mail.gmail.com>
 <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
 <CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
 <AD966642-1043-468D-BABF-8FC9AF514D36@bi-co.net>
 <158a3491-e4d2-d905-7f58-11a15bddcd70@gmx.com>
 <C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net>
 <3142764D-5944-4004-BC57-C89C89AC9ED9@bi-co.net>
 <F170BB63-D9D7-4D08-9097-3C18815BE869@bi-co.net>
 <20190521190023.GA68070@glet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521190023.GA68070@glet>
Sender: linux-btrfs-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@linux.it>
Cc: Michael =?iso-8859-1?B?TGHf?= <bevan@bi-co.net>, dm-devel@redhat.com, Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, May 21 2019 at  3:00pm -0400,
Andrea Gelmini <andrea.gelmini@linux.it> wrote:

> On Tue, May 21, 2019 at 06:46:20PM +0200, Michael Laß wrote:
> > > I finished bisecting. Here’s the responsible commit:
> > > 
> > > commit 61697a6abd24acba941359c6268a94f4afe4a53d
> > > Author: Mike Snitzer <snitzer@redhat.com>
> > > Date:   Fri Jan 18 14:19:26 2019 -0500
> > > 
> > >    dm: eliminate 'split_discard_bios' flag from DM target interface
> > > 
> > >    There is no need to have DM core split discards on behalf of a DM target
> > >    now that blk_queue_split() handles splitting discards based on the
> > >    queue_limits.  A DM target just needs to set max_discard_sectors,
> > >    discard_granularity, etc, in queue_limits.
> > > 
> > >    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Reverting that commit solves the issue for me on Linux 5.1.3. Would
> that be an option until the root cause has been identified? I’d rather
> not let more people run into this issue.
> 
> Thanks a lot Michael, for your time/work.
> 
> This kind of bisecting are very boring and time consuming.
> 
> I CC: also the patch author.

Thanks for cc'ing me, this thread didn't catch my eye.

Sorry for your troubles.  Can you please try this patch?

Thanks,
Mike

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1fb1333fefec..997385c1ca54 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1469,7 +1469,7 @@ static unsigned get_num_write_zeroes_bios(struct dm_target *ti)
 static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
 				       unsigned num_bios)
 {
-	unsigned len = ci->sector_count;
+	unsigned len;
 
 	/*
 	 * Even though the device advertised support for this type of
@@ -1480,6 +1480,8 @@ static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *
 	if (!num_bios)
 		return -EOPNOTSUPP;
 
+	len = min((sector_t)ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+
 	__send_duplicate_bios(ci, ti, num_bios, &len);
 
 	ci->sector += len;
