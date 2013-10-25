From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 01/24] dm: nest targets used for
	testing	under DM_TEST_TARGETS
Date: Fri, 25 Oct 2013 20:29:38 +0100
Message-ID: <20131025192938.GK17070@agk-dp.fab.redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-2-git-send-email-snitzer@redhat.com>
	<20131024231722.GD17070@agk-dp.fab.redhat.com>
	<20131025192556.GB4804@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131025192556.GB4804@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 25, 2013 at 03:25:56PM -0400, Mike Snitzer wrote:
> As for delay being useful for non-test use-cases, that may be but
> classifying it as a target that is used for testing is fair (hence
> "Useful for testing." in the DM_DELAY help text).  That said, if you'd
> really prefer DM_DELAY not be nested under DM_TEST_TARGETS I can revert
> it.
 
I'm not objecting to its inclusion with the TEST TARGETS, as that remains
the primary use of it, but with the statement that the target is then meant
only for testing.

Alasdair
