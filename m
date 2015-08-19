From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-statistics: report precise timestamps and
	histogram
Date: Wed, 19 Aug 2015 06:50:36 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1508190643410.7633@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1508181618100.19666@file01.intranet.prod.int.rdu2.redhat.com>
	<20150818210727.GA17473@redhat.com>
	<20150818214112.GA17757@redhat.com>
	<20150819084828.GB7891@bmr.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150819084828.GB7891@bmr.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: dm-devel@redhat.com, Bryn Reeves <breeves@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Wed, 19 Aug 2015, Bryn M. Reeves wrote:

> On Tue, Aug 18, 2015 at 05:41:12PM -0400, Mike Snitzer wrote:
> > On Tue, Aug 18 2015 at  5:07pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > On Tue, Aug 18 2015 at  4:26pm -0400,
> > > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > 
> > > > Mike, please submit this patch to the upstream kernel before 4.2 is 
> > > > released, so that the all the kernels that support the options 
> > > > "precise_timestamps" and "histogram" also report these values back.
> > > 
> > > It is really late to be sending pull requests for 4.2 (next release is
> > > likely 4.2 final).  I've already sent 6 'fixes' pull requests to Linus
> > > for 4.2.  This patch is just too late, sorry.
> > > 
> > > But what I will do is tag this commit for 4.2-stable inclusion.
> > > 
> > > Userspace will have to check the DM ioctl version to know if DM provides
> > > these extra keywords.
> > 
> > I've staged the following for 4.3:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=bd49784fd1e8f42c7600fbfa206361324857f373
> > 
> > Bryn, please verify this change is sufficient for your needs.
> 
> Yes; this will be usable by dmstats.
> 
> Unfortuntely the fact that there are kernels out there without this
> means that we will need to either carry a workaround in dmstats
> userspace forever or just disallow use of these features on those
> kernels.

That's why I think it should be submitted to 4.2 now - so that there won't 
be an upstream kernel without this feature.

> The workaround is fairly unobtrusive and is already written so it's not
> the end of the world (it also has future uses for which kernel support
> will not help so it won't be solely used for precise/histogram
> tracking).
> 
> Regards,
> Bryn.

Mikulas
