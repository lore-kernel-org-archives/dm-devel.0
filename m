From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Thu, 11 Dec 2014 10:26:26 -0500
Message-ID: <20141211152626.GA8196@redhat.com>
References: <54883195.1060304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <54883195.1060304@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: gregkh@linuxfoundation.org, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, thornber@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 10 2014 at  6:42am -0500,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> This patch adds dm-writeboost to staging tree.
> 
> dm-writeboost is a log-structured SSD-caching driver.
> It caches data in log-structured way on the cache device
> so that the performance is maximized.
> 
> The merit of putting this driver in staging tree is
> to make it possible to get more feedback from users
> and polish the codes.
> 
> Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>

Joe Thornber Nacked this from going into staging based on his further
review of the code.  On the basis that you should _not_ be copying all
pages associated with each bio into an in-core buffer.  Have you
addressed that fundamental problem?

But taking a step back: Why do you think going into staging actually
helps you?  Anyone who is willing to test this code should be able to
apply a patch to their kernel.  Having to feed changes to Greg to
deliver updates to any early consumers of this _EXPERIMENTAL_ target
seems misplaced when you consider that Joe has detailed important
fixes, capabilties and tools that need addressing before anyone should
trust their production data to dm-writeboost.

I think you're completely missing that you are pushing _hard_ for this
target to go upstream before it is actually ready.  In doing so you're
so hung up on that "upstream" milestone that you cannot appreciate the
reluctance that Joe and I have given the quantity of code you're pushing
-- especially when coupled with the limited utility of dm-writeboost in
comparison with full featured upstream drivers like dm-cache and bcache.

As for this v2, you didn't detail what you changed (I can obviously
apply v1 and then v2 to see the difference but a brief summary would be
helpful in general when you revise a patch)

But one inline comment:

> diff --git a/drivers/staging/writeboost/TODO b/drivers/staging/writeboost/TODO
> new file mode 100644
> index 0000000..761a9fe
> --- /dev/null
> +++ b/drivers/staging/writeboost/TODO
> @@ -0,0 +1,52 @@
> +TODO:
> +
> +- Get the GitExtract test so it's performance is similar to raw spindle.

No, the whole point of a write cache is to improve performance.  You
should be trying to surpass the performance of the raw spindle.
