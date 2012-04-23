From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm thin: fix memory leak of singleton
	bio-prison cell
Date: Mon, 23 Apr 2012 08:24:08 +0100
Message-ID: <20120423072407.GA8082@ubuntu>
References: <1334270075-11699-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1334270075-11699-1-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 12, 2012 at 06:34:34PM -0400, Mike Snitzer wrote:
> Add missing mempool_free() to __cell_release_singleton().
> 
> This is a pretty significant leak that will accumulate to over 2GB of
> leaked memory just from running the full thinp-test-suite.

When was this introduced?  With agk's tweaks for 3.4?
