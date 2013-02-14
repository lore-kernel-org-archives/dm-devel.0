From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Thu, 14 Feb 2013 21:06:16 +0000
Message-ID: <20130214210615.GJ24130@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
	<20130212152733.GH12499@agk-dp.fab.redhat.com>
	<20130214140549.GB5045@Barry.lambda.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130214140549.GB5045@Barry.lambda.co.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 14, 2013 at 02:05:50PM +0000, Joe Thornber wrote:
> When we've discussed this sort of thing before we've always decided
> not to version sub modules and instead just rely on the overall kernel
> version.  Who are you intending should consume this DMINFO?
 
People who have reason to look at their system logs when something
they can't explain has happened (and then us, when they send
snippets of the logs).

All the optional dm sub-modules that plug into other modules report when they
are loaded/unloaded.  Then given that they are writing a line to the log,
they might as well supply a version number in it, particularly if we're
anticipating that once the core has settled down, future change will be
concentrated around tuning these modules so we can't necessarily deduce
which version of sub-module code is running from the module code version.

Relying on the core kernel version just turns this into a lookup table
maintenance problem to find out what patch was applied to what distro
when.  dm versioning gives us a quick distro-independent way to guess
which version of our code was likely to have been running from
information often included in the intial report of the problem.

Alasdair
