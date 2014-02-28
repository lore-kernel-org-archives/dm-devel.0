From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 8/8] dm-mpath: do not activate failed paths
Date: Fri, 28 Feb 2014 10:02:43 -0500
Message-ID: <20140228150243.GB1140@redhat.com>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
	<1393486229-72034-9-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784010D7C45@BPXM12GP.gisp.nec.co.jp>
	<531057A7.4020208@suse.de>
	<11AF7C027C4C02408624617A49860784010D7F79@BPXM12GP.gisp.nec.co.jp>
	<53105C4D.50305@suse.de> <20140228142230.GA1140@redhat.com>
	<5310A0C7.6000601@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5310A0C7.6000601@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 28 2014 at  9:44am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/28/2014 03:22 PM, Mike Snitzer wrote:
> [ .. ]
> > 
> > FYI, I still intend to review/take your "accept failed paths" patch.
> > Would be helpful if any rebase is needed for that patch that you do so
> > and re-post.
> > 
> > One thing I noticed is you're only converting MAJ:MIN paths to devices.
> > I think we should factor a helper out of DM core that does the full path
> > lookup check from dm_get_device() -- rather than you open coding an
> > older version of the MAJ:MIN device path processing.
> > 
> > But is there a reason for not using lookup_bdev()?  Because the device
> > is failed it cannot be found using lookup_bdev()?
> > 
> Yes, that's precisely it.
> When setting dev_loss_tmo very aggressively (to, say, 10 or even 5
> seconds) it might well be that multipathd won't be able to keep up
> with the events in time.
> So by the time multipathd tries to push a new table into the kernel
> (which contains major:minor numbers only) those devices are already
> gone. So lookup_bdev() won't be able to find them, either.

Been talking this over with Alasdair.  Need some things clarified.

Are you needing to handle non-existent devices during initial mpath
table load?

Or is the failed path in question already part of the active mpath table
-- so active table currently holds a reference to the device?

Or do you need to support both cases?  Sounds like you want to support
both cases..

> Not sure if factoring things out from dm_get_device() would help
> here ...
> 
> But I'll be sending an updated patch, which'll apply on top of the
> 'push back' patchset.

Thanks.
