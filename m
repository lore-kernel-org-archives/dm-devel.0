From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Mon, 13 Aug 2012 15:05:34 -0700
Message-ID: <20120813220534.GB25632@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-9-git-send-email-koverstreet@google.com>
	<20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120813215511.GE9541@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120813215511.GE9541-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Mon, Aug 13, 2012 at 02:55:11PM -0700, Kent Overstreet wrote:
> > If the condition is detectable, WARN_ON_ONCE() please.
> 
> I know I said I liked this idea, but I changed my mind.
> 
> Sticking a WARN_ON_ONCE() there is saying that passing __GFP_WAIT from
> under generic_make_request() is always wrong - it might as well be a
> BUG_ON() except warn is better for the user.

WARN_ON_ONCE(), as opposed to BUG_ON(), doesn't mean that something
isn't always wrong.  It's just better to always use WARN variant if
the system doesn't *need* to be put down immediately to avoid, say,
massive data corruption - limping machine is simply better than dead
one.

> If that's true, then an assertion is completely wrong because we can
> just do the right thing instead - mask out __GFP_WAIT if
> current->bio_list != NULL and document that it can fail in that
> situation.

That's worse because it confuses the reader.  Taking something which
is as well-known as __GFP_WAIT and then silently ignoring it isn't a
good idea.  Please just add a WARN_ON.

Thanks.

-- 
tejun
