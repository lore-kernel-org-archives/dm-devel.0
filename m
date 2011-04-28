From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm: allow a target to relax discard
 restrictions
Date: Thu, 28 Apr 2011 04:41:17 -0400
Message-ID: <20110428084117.GA32658@infradead.org>
References: <20110427150623.GC13487@infradead.org>
	<20110427151911.GF7294@redhat.com>
	<20110427215537.GA13386@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110427215537.GA13386@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Wed, Apr 27, 2011 at 05:55:38PM -0400, Mike Snitzer wrote:
> A target, like the upcoming thin provisioning target, may want to allow
> discards even if the underlying devices do not support them natively.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

This would work, but I thing it's really confusing to have your
new discards_supported flag in the dm_target structure in addition
to the existing discards_supported in the dm_table and the
num_discard_requests field there.

May we should allow the target to set a tristate

enum discard_enabled {
	NEVER,
	ALWAYS,
	PASSTHROUGH
}

to indicate it's discard support?
