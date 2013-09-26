From: Frank Mayhar <fmayhar@google.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 26 Sep 2013 10:31:56 -0700
Message-ID: <1380216716.25252.39.camel@bobble.lax.corp.google.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130926172422.GA31328@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2013-09-26 at 18:24 +0100, Alasdair G Kergon wrote:
> Timeouts were discussed when we added queue_if_no_path. and we made the
> decision to implement this in userspace not the kernel.
> 
> Make sure that your daemon doesn't die - or that something monitors it
> and relaunches it if it does.

Uh, huh.  And what about when (not if) _that_ fails?  (For one thing,
what if the stuckness caused by the queued I/O prevents the binary from
being successfully pulled in from storage?)

Granted, this is a belt-and-suspenders kind of thing that most won't
need, but when you need it, you _need_ it.
-- 
Frank Mayhar
310-460-4042
