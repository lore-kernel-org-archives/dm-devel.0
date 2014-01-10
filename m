From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-3.14] dm btree: add
	dm_btree_find_lowest_key
Date: Fri, 10 Jan 2014 10:16:07 +0000
Message-ID: <20140110101607.GB20496@debian>
References: <1389303053-31684-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1389303053-31684-1-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, joe.thornber@gmail.com, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 09, 2014 at 04:30:53PM -0500, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>
> dm_btree_find_lowest_key is needed for an upcoming DM target, as such it
> is best to get this interface in place.

Premature, the dm-era target that would use this is still in
development.  For instance I may decide to digest the bloom filters by
using the existing btree_walk method rather than repeatedly grabbing
the lowest entry.
