From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 5/5] block: use a driver-specific handler for
 the "inflight" value
Date: Thu, 8 Nov 2018 06:52:40 -0800
Message-ID: <20181108145240.GA20087@infradead.org>
References: <20181106213858.391264280@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181106213858.391264280@debian-a64.vm>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 06, 2018 at 10:35:03PM +0100, Mikulas Patocka wrote:
> Device mapper was converted to percpu inflight counters. In order to
> display the correct values in the "inflight" sysfs file, we need a custom
> callback that sums the percpu counters.

The attribute that calls this is per-partition, while your method
is per-queue, so there is some impedence mismatch here.

Is there any way you could look into just making the generic code
use percpu counters?

Also please cc linux-block on patches that touch the generic block
code.
