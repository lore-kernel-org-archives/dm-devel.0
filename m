From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5] dm: add unstriped target
Date: Tue, 19 Dec 2017 16:38:12 -0500
Message-ID: <20171219213812.GA13257@redhat.com>
References: <cover.1513618685.git.heinzm@redhat.com>
	<1513639353-7231-1-git-send-email-snitzer@redhat.com>
	<20171219183511.wdbr3kmz5fw2f4lr@sbauer-Z170X-UD5>
	<20171219200353.GA65364@redhat.com>
	<20171219201647.vqmsmj2l26o7sldj@sbauer-Z170X-UD5>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171219201647.vqmsmj2l26o7sldj@sbauer-Z170X-UD5>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Scott Bauer <scott.bauer@intel.com>
Cc: Keith Busch <keith.busch@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 19 2017 at  3:16pm -0500,
Scott Bauer <scott.bauer@intel.com> wrote:

> On Tue, Dec 19, 2017 at 03:03:53PM -0500, Mike Snitzer wrote:
> > On Tue, Dec 19 2017 at  1:35P -0500,
> > Scott Bauer <scott.bauer@intel.com> wrote:
> > 
> > > On Mon, Dec 18, 2017 at 06:22:33PM -0500, Mike Snitzer wrote:
> > > 
> > > > +	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1) {
> > >                         ^ should be argv[4]
> > > > +		ti->error = "Invalid striped device offset";
> > > > +		goto err;
> > > > +	}
> > > > +	uc->physical_start = start;
> > > 
> > > Hi Mike,
> > > Sorry for the bombardment of emails. I think I've fixed the last
> > > problem. Above is the last issue.
> > > 
> > > Below is a patch you can apply that will fix up the sector switch, I
> > > had mentioned in the previous mail, as well as the wrong argv usage
> > > from above.
> > > 
> > > I still have not solved the NULL pointer issue, i'll continue to
> > > investigate that. Unless you have an idea of why that is occuring.
> > 
> > See below for incremental patch that should fix the NULL pointer, please
> > test and I'll fold it in, along with your incremental.
> > 
> > Thanks!
> > 
> > > You can trigger it without having to create/remove/create. Just a
> > > creation with a bad (odd length) target length will do it.
> > > 
> > > If you don't want this patch but want me to do a v6 I can do that as
> > > well.
> > 
> > I'll take it, no worries on sending out v6.
> 
> Functionally the code is good now -- Thank you very much for the help.
> The last thing is I need to fix up the bash script in documentation.
> I *really* have to work on this other project for the rest of the day.
> Do you care if we land this now, and I will just submit a small fixup
> of the Documentation tomorrow?

Not sure what docs you think need fixing (since I did update them).
Please see what is now staged in linux-next:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=0aaa5aeed6921f65dc1e91e6d6ba43f4a8e1458e

But if you have an incremental patch to fix up something in
Documentation I'll gladly take it.

Thanks,
Mike
