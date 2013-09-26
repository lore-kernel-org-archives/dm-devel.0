From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Fri, 27 Sep 2013 00:22:42 +0100
Message-ID: <20130926232241.GC31328@agk-dp.fab.redhat.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1380217633.25252.46.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 26, 2013 at 10:47:13AM -0700, Frank Mayhar wrote:
> Launching it from ramdisk won't help, particularly, since it still goes
> through the block layer.  The other stuff won't help if a (potentially
> unrelated) bug in the daemon happens to be being tickled at the same
> time, or if some dependency happens to be broken and _that's_ what's
> preventing the daemon from making progress.
 
Then put more effort into debugging your daemon so it doesn't have
bugs that make it die?  Implement the timeout in a robust independent
daemon if it's other code there that's unreliable?

> And as far as lvm2 and multipath-tools, yeah, they cope okay in the kind
> of environments most people have, but that's not the kind of environment
> (or scale) we have to deal with.

In what way are your requirements so different that a locked-into-memory
monitoring daemon cannot implement this timeout?

Alasdair
