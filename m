From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath - unable to use multiple active paths at
 once, and deprecated example in docs
Date: Tue, 26 Nov 2019 10:39:17 -0500
Message-ID: <20191126153917.GA2025@redhat.com>
References: <CAN-y+EJOt=MRDEXCx9_U4zmDs+i9yXj364E4+z=xC=u8+Ao1PQ@mail.gmail.com>
	<329fd408ea605f1f14c0eebb46209fd3c46c3af8.camel@suse.de>
	<CAN-y+E+65bgiUSL6VMvRJLd3AiqD7xApbm1nA69ue_M6tTsGrA@mail.gmail.com>
	<a9b5e49f6c6ef0fedaa403ce02cf0d1b39912cff.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a9b5e49f6c6ef0fedaa403ce02cf0d1b39912cff.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.de>
Cc: dm-devel@redhat.com, Drew Hastings <dhastings@crucialwebhost.com>
List-Id: dm-devel.ids

On Mon, Nov 25 2019 at  4:07pm -0500,
Martin Wilck <mwilck@suse.de> wrote:

> On Mon, 2019-11-25 at 13:42 -0700, Drew Hastings wrote:
> > On Mon, Nov 25, 2019 at 12:48 PM Martin Wilck <mwilck@suse.de> wrote:
> > > I think you are seeing this FIXME:
> > > 
> > > https://elixir.bootlin.com/linux/v4.19.79/source/drivers/md/dm-mpath.c#L612
> > > 
> > > For your testing, perhaps you just remove that if(!pgpath)
> > > condition.
> > > 
> > > Regards,
> > > Martin
> > 
> > That's correct, thanks. It works as expected after removing that
> > condition.
> > 
> > With some limited testing using fio, I don't see any obvious negative
> > impacts of allowing choose_pgpath to run each bio mapping. I also
> > don't see any significant increase in CPU usage or IO latency during
> > benchmarking.
> > 
> > The FIXME comment acknowledges that this sort of defeats the
> > balancing function of multipath, so I'm assuming this was removed for
> > a good reason. Does anyone know why this was done? In my particular
> > use case, I benefit from balancing the paths for throughput, so it's
> > useful to me.
> 
> This originates from the former use of dm-multipath for NVMe devices,
> the now obsolete "nvme" queue mode, and from the attempt to separate
> dm-multipath from SCSI and its device handler model. See 8d47e65948dd
> ("dm mpath: remove unnecessary NVMe branching in favor of scsi_dh
> checks").
> 
> It seems indeed strange to skip choosing the path in the absence of the
> SCSI device handler, which is (with a grain of salt) responsible for
> switching *path groups*, not paths inside a group. It's a corner case,
> I don't think many real-world multipath setups deploy bio-based dm-
> mpath without a device handler.
> 
> So, I suggest you submit a patch and discuss this with Mike :-)

Hindsight being 20/20: it was misplaced micro-optimization that
compromised the broader features provided by the configurable path
selectors.

I've just removed __map_bio_fast(), see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.5&id=dbaf971c9cdf10843071a60dcafc1aaab3162354

not sure when I'll send this to Linus.. likely in a couple weeks as part
of any other DM fixes (first batch of DM changes for 5.5 was already
merged yesterday).

Thanks,
Mike
