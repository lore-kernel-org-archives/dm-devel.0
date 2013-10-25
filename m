From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 01/24] dm: nest targets used for testing
 under DM_TEST_TARGETS
Date: Fri, 25 Oct 2013 15:25:56 -0400
Message-ID: <20131025192556.GB4804@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-2-git-send-email-snitzer@redhat.com>
	<20131024231722.GD17070@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131024231722.GD17070@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 24 2013 at  7:17pm -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -371,27 +371,12 @@ config DM_MULTIPATH_ST
>   	  
> > -config DM_DELAY
> > -	tristate "I/O delaying target"
> 
> > +config DM_DELAY
> > +	tristate "I/O delaying target (EXPERIMENTAL)"
> 
> Why has EXPERIMENTAL reappeared???
> See d57916a00fd749ccd354a7f754c2aba98f86d064
> 
> Please regenerate these patches against an up-to-date upstream base!

The base for these patches is v3.12-rc5, certainly recent enough.

What you took issue with here has nothing to do with an older base being
used for the patches.  It has everything to do with Joe having made this
change in his thin-dev branch quite a while ago -- when I rebased I
didn't change the text the patch moved.  Will remove the EXPERIMENTALs.

As for delay being useful for non-test use-cases, that may be but
classifying it as a target that is used for testing is fair (hence
"Useful for testing." in the DM_DELAY help text).  That said, if you'd
really prefer DM_DELAY not be nested under DM_TEST_TARGETS I can revert
it.
