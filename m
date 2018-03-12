From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: move dm-bufio.h to include/linux/
Date: Mon, 12 Mar 2018 11:57:13 -0400
Message-ID: <20180312155712.GB29395@redhat.com>
References: <alpine.LRH.2.02.1803080421030.9508@file01.intranet.prod.int.rdu2.redhat.com>
	<20180308144955.GA23262@infradead.org>
	<20180308203621.GA8133@redhat.com>
	<20180312074827.GA30695@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180312074827.GA30695@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Thomas Jaskiewicz <tomj@permabit.com>
List-Id: dm-devel.ids

On Mon, Mar 12 2018 at  3:48am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 08, 2018 at 03:36:21PM -0500, Mike Snitzer wrote:
> > While I appreciate your interest in what constitutes a reasonable change
> > for DM, why are you so emphatic about disallowing out-of-tree DM modules
> > from using dm-bufio?
> 
> Because I'd rather get them into the tree than providing escapes just
> for them. 

This isn't about providing an escape.

It may be unintuitive, or you may not believe me, but as I said in my
previous email this change encourages out of tree DM targets to use
dm-bufio rather than invent their own equivalent.  It is very useful to
me (speaking as the sucker who has to shepherd DM targets upstream) for
others to get that code path right, without reinventing it, rather than
have to disruptively change the target to use dm-bufio (where it makes
sense) prior to submission for upstream inclusion.

For DM targets that are extremely complex, external use of dm-bufio vs
not is the tail wagging the dog.  There are like 50+ other things that
need work in addition to using dm-bufio.  But every code transformation
hurdle to upstream inclusion that can be done out of tree will help the
DM target be more stable upon upstream inclusion.

Mike
