From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Reject sector_size feature if
	device	length is not aligned to it
Date: Tue, 3 Oct 2017 20:09:34 +0100
Message-ID: <20171003190934.GB9979@agk-dp.fab.redhat.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
	<20171003120508.GA9979@agk-dp.fab.redhat.com>
	<20171003180804.GA25465@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171003180804.GA25465@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 03, 2017 at 02:08:04PM -0400, Mike Snitzer wrote:
> Not sure why you're putting such value on that behaviour.  The earlier
> we catch invalid tables the better off we are.  Failing at resume time
> sucks (always has).
 
Validation code shouldn't be making assumptions about things that lie
completely outside its control and falsely failing operations that would
actually succeed if they were allowed to proceed.  The existing
kernel/userspace interface does not require userspace to load devices in
any particular sequence.  We could have provided a tree-based kernel/userspace
interface with stronger requirements like these, but the fact is, we haven't.
Perhaps we will one day.

As a minimum, you would need to change the patch to validate against the
inactive tables of underlying devices instead of the live ones - i.e. assume
that userspace already loaded all the underlying devices (and will resume them
all before the one being validated gets resumed).  Currently no such
ordering requirement is imposed on userspace, so you'd also need a
compatibility flag to enable the stronger contraints.

This patch can break valid userspace code.

Alasdair
