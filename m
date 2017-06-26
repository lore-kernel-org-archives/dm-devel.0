From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache coherence issue
Date: Mon, 26 Jun 2017 16:58:08 +0100
Message-ID: <20170626155808.GC20683@nim>
References: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
	<20170626113341.GA20683@nim>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170626113341.GA20683@nim>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Bauer <dfnsonfsduifb@gmx.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 26, 2017 at 12:33:42PM +0100, Joe Thornber wrote:
> On Sat, Jun 24, 2017 at 03:56:54PM +0200, Johannes Bauer wrote:
> > So I seem to have a very basic misunderstanding of what the cleaner
> > policy/dirty pages mean. Is there a way to force the cache to flush
> > entirely? Apparently, "dmsetup wait" and/or "sync" don't do the job.
> 
> I'll try and reproduce your scenario and get back to you.

Here's a similar scenario that I've added to the dm test suite:

https://github.com/jthornber/device-mapper-test-suite/commit/457e889b0c4d510609c0d7464af07f2ebee20768

It goes through all the steps you need to use to decommission a cache
with dirty blocks.  Namely:

- switch to writethrough mode (so new io can't create new dirty blocks)
- switch to the cleaner policy
- wait for clean
- remove the cache device before accessing the origin directly

I've run it with a recent kernel, and one from about a year ago and it
passes fine.

- Joe
