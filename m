From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 05/13] dm-mpath: Make it easier to analyze
 requeuing behavior
Date: Thu, 27 Apr 2017 15:29:23 -0400
Message-ID: <20170427192923.GB67119@redhat.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
	<20170427171126.26814-6-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170427171126.26814-6-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Apr 27 2017 at  1:11P -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> When debugging the dm-mpath driver it is important to know what
> decisions have been taken with regard to requeuing. Hence this
> patch that adds pr_debug() statements that report what decisions
> have been taken.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>

I've not used pr_debug() before.. I generally sprinkle debugging when
I'm actively chasing an issue and then throw it away once I sort the
problem out.

Documentation/process/coding-style.rst says:
"Coming up with good debugging messages can be quite a challenge; and once
you have them, they can be a huge help for remote troubleshooting.  However
debug message printing is handled differently than printing other non-debug
messages.  While the other pr_XXX() functions print unconditionally,
pr_debug() does not; it is compiled out by default, unless either DEBUG is
defined or CONFIG_DYNAMIC_DEBUG is set."

So I assume you're leveraging DYNAMIC_DEBUG.

Anyway, I'm not liking the idea of making this debugging part of the
mpath code.  But if there is a convincing argument for it please
elaborate.

Are you finding that things are going wrong on production systems and
enabling pr_debug() in these paths would have, or has, saved you?
