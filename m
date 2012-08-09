From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Thu, 9 Aug 2012 10:32:17 -0700
Message-ID: <20120809173217.GA6644@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-9-git-send-email-koverstreet@google.com>
	<20120808230532.GH6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120809013923.GH7262@moria.home.lan>
	<20120809072217.GH2845@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120809073334.GD9128@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120809073334.GD9128-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
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
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Thu, Aug 09, 2012 at 03:33:34AM -0400, Kent Overstreet wrote:
> > If you think the active dropping is justified, please let the change
> > and justification clearly stated.  You're burying the active change in
> > two separate patches without even mentioning it or cc'ing people who
> > care about bio-integrity (Martin K. Petersen). 
> 
> Not intentionally, he isn't in MAINTAINERS so get_maintainers.pl missed
> it and it slipped by while I was looking for people to CC. Added him.

git-log is your friend.  For one-off patches, doing it this way might
be okay.  Higher layer maintainer would be able to redirect it but if
you intend to change block layer APIs significantly as you try to do
in this patch series, you need to be *way* more diligent than you
currently are.  At least I feel risky about acking patches in this
series.

* Significant change is buried without explicitly mentioning it or
  discussing its implications.

* The patchset makes block layer API changes which impact multiple
  stacking and low level drivers which are not particularly known for
  simplicity and robustness, but there's no mention of how the patches
  are tested and/or why the patches would be safe (e.g. reviewed all
  the users and tested certain code paths and am fairly sure all the
  changes should be safe because xxx sort of deal).  When asked about
  testing, not much seems to have been done.

* Responses and iterations across patch postings aren't responsive or
  reliable, making it worrisome what will happen when things go south
  after this hits mainline.

You're asking reviewers and maintainers to take a lot more risks than
they usually have to, which isn't a good way to make forward progress.

Thanks.

-- 
tejun
