From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 5 Nov 2014 15:16:12 -0500
Message-ID: <20141105201612.GA18581@redhat.com>
References: <20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105161015.GD14285@redhat.com>
	<20141105165611.GA19885@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141105165611.GA19885@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 05 2014 at 11:56am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Nov 05 2014 at 11:10am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Wed, Nov 05 2014 at  9:37am -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > This is not about performance, it is about unclear behavior.
> > > 
> > > If someone does internal_suspend followed by remove, what should be the 
> > > correct behavior? The current code deadlocks in this case.
> > 
> > You need to be specific, if internal suspend was used by the thin-pool
> > suspend to suspend thin devices you'll need the thin-pool resumed before
> > you can remove any thin device!
> >
> > Like any interface there is a right way and a wrong way to use it.
> > dm_internal_suspend must always be followed by dm_internal_resume.
> > I cannot yet see a hole where properly written code is exposed here.
> 
> But thinking further about what you said, you're correctly concerned
> about the potential for dm-stats to have used dm_internal_suspend and
> then someone attempting to remove that device while it is internally
> suspended.

As we discussed (but for benefit of others): dm-stats does the
dm_internal_suspend+dm_internal_resume within a single DM message
(ioctl) so there is no potential for race with device delete.

> We just need a patch like this:

That untested patch was flawed, caused deadlock due to wait_on_bit()
while holding _hash_lock -- so resume ioctl wasn't possible.

So I'm still really not sure what your original point was about "If
someone does internal_suspend followed by remove, what should be the
correct behavior? The current code deadlocks in this case."

There is no deadlock:

dmsetup suspend thin-pool
dmsetup remove thin-thin1
dmsetup resume thin-pool

the thin-pool suspend will internal suspend thin-thin1, but I can still
remove thin-thin1 (provided it isn't in-use), and later resuming the
thin-pool works fine too.
