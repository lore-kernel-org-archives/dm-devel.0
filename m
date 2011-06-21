From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: Don't install merge function if
	not	needed
Date: Tue, 21 Jun 2011 22:05:57 +0100
Message-ID: <20110621210557.GL19996@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1106211604110.22545@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106211604110.22545@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 21, 2011 at 04:08:52PM -0400, Mikulas Patocka wrote:
> This patch may also improve CPU consumption a little bit by not providing 
> a merge function on linear devices, where it is not needed.

That would be a trade-off - dependent on the actual table construction.
The risk from not calling the merge function is that you'll necessitate
splitting (and consequent possible reordering).  Historically we found
it highly desirable to avoid splitting vs. an unnoticeable overhead from
calling the merge function.  Probably needs some numbers with different
sorts of tables and workloads to see where the trade-off might now lie.

Essentially my position is that the linear merge function:
  Improves *some* configurations and processing of specific bios noticeably;
  Has neglible overhead in the cases it doesn't improve.

So to counter that I'd like to see evidence of counter-examples,
e.g. It has noticeable overhead in some configurations that don't
benefit from it.

Then we can debate whether we can distinguish between these classes
automatically or make the change globally.

(BTW md linear should be included in these tests, as the same
considerations ought to apply - if there are solid grounds to make
a change, those grounds may apply to both md and dm.)

Alasdair
