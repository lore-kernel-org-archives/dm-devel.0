From: Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 05/11] dm-snap: remove SECTOR_SHIFT define
Date: Mon, 13 Aug 2007 11:20:36 +0200
Message-ID: <20070813092036.GB12730@hasse.suse.de>
References: <20070810200204.455820246@suse.de>>
	<20070810200205.703776854@suse.de>
	<20070810203854.GG2064@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070810203854.GG2064@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Aug 10, Alasdair G Kergon wrote:

> On Fri, Aug 10, 2007 at 10:02:09PM +0200, Jan Blunck wrote:
> > Sector size on Linux is always 512 bytes. Don't even try to give the
> > impression this is changeable.
> 
> If that's what worries you, add a comment next to the definition,
> perhaps?

That and that the code just looks more like the rest of the block layer
code. Only a few users (UFS, MSDOS, HFS, IDE) use a predefined
SECTOR_{SHIFT,SIZE}.

> It's there so you can easily locate all the places within dm that
> perform these conversions by using a simple search.  Searching for '9'
> wouldn't be as easy.  (I don't know about other people, but I find the
> code easier to read the way it is.)

Hmm, so I guess this is more about dis/like of how the code looks. Maybe we
should define a global SECTOR_{SIZE,SHIFT} into blkdev.h.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
