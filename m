From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 01/24] dm: nest targets used for
	testing	under DM_TEST_TARGETS
Date: Fri, 25 Oct 2013 00:51:50 +0100
Message-ID: <20131024235150.GE17070@agk-dp.fab.redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382639437-27007-2-git-send-email-snitzer@redhat.com>
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

On Thu, Oct 24, 2013 at 02:30:14PM -0400, Mike Snitzer wrote:
> Both the flakey and delay targets are generally used for testing.  
                                        ^^^^^^^^^
Indeed - not exclusively.

> --- a/drivers/md/Kconfig

> +config DM_TEST_TARGETS

> +         Targets that are only useful for testing.

Could we delete the word 'only'?  Or replace it with something like
'primarily'?

(I don't like this classification for DM_DELAY: I think it can have uses in
non-testing scenarios.)

Alasdair
