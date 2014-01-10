From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-3.14] dm cache: add total cache blocks to
 status output
Date: Fri, 10 Jan 2014 10:11:17 +0000
Message-ID: <20140110101116.GA20496@debian>
References: <20140109210412.GA5288@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140109210412.GA5288@redhat.com>
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

On Thu, Jan 09, 2014 at 04:04:12PM -0500, Mike Snitzer wrote:
> Improve cache_status to emit <#used cache blocks>/<#total cache blocks>
> This provides useful context for the how much of the cache is used.

I'd be happy with this if cache wasn't already upstream.  But it is,
and this patch changes a kernel interface.  If you're going to do this
you need to:

i) bump the version number of the target module
ii) update the test suite
iii) apologise to users who's scripts are about to be broken.

<#used cache blocks> is already emitted.  The blocksize is available
from the table.  The <#total cache blocks> is just the SSD size
divided by the blocksize.  I see no compelling reason to make this
change.

- Joe
