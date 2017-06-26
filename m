From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache coherence issue
Date: Mon, 26 Jun 2017 12:33:42 +0100
Message-ID: <20170626113341.GA20683@nim>
References: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Jun 24, 2017 at 03:56:54PM +0200, Johannes Bauer wrote:
> So I seem to have a very basic misunderstanding of what the cleaner
> policy/dirty pages mean. Is there a way to force the cache to flush
> entirely? Apparently, "dmsetup wait" and/or "sync" don't do the job.

Your understanding is correct.  There is a tool in the latest thinp
tools release called cache_writeback that does offline decommissioning
of a cache.

I'll try and reproduce your scenario and get back to you.

- Joe
