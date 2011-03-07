From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 07 Mar 2011 15:24:23 +0100
Message-ID: <4D74EA97.5080209@redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>	<20110228114801.GZ3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>	<20110228121149.GA3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>	<20110228131028.GB3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>	<4D6BA566.1050305@redhat.com>
	<yq1oc5wp5i3.fsf@sermon.lab.mkp.net>	<4D73F104.2050807@redhat.com>
	<yq1y64reiu8.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1y64reiu8.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 7.3.2011 03:59, Martin K. Petersen napsal(a):
>>>>>> "Zdenek" == Zdenek Kabelac <zkabelac@redhat.com> writes:
> 
> Zdenek> My finding seems to show that BIP-256 slabtop segment grow by
> Zdenek> ~73KB per each device (while dm-io is ab out ~26KB)
> 
> Ok, I see it now that I tried with a bunch of DM devices.
> 
> DM allocates a bioset per volume. And since each bioset has an integrity
> mempool you'll end up with a bunch of memory locked down. It seems like
> a lot but it's actually the same amount as we reserve for the data path
> (bio-0 + biovec-256).
> 
> Since a bioset is not necessarily tied to a single block device we can't
> automatically decide whether to allocate the integrity pool or not. In
> the DM case, however, we just set up the integrity profile so the
> information is available.
> 
> Can you please try the following patch? This will change things so we
> only attach an integrity pool to the bioset if the logical volume is
> integrity-capable.
> 

Yep - patch seems to fix the problem with wasted memory.

Thanks

tested-by: zkabelac@redhat.com
