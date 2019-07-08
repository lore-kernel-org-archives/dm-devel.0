From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm bufio: fix deadlock issue with loop device
Date: Mon, 8 Jul 2019 10:14:28 -0400
Message-ID: <20190708141427.GA8414@redhat.com>
References: <20190702231456.19121-1-junxiao.bi@oracle.com>
	<20190703162106.GA13984@redhat.com>
	<1aa51708-1c1b-bd12-72ed-ecbae39043f7@oracle.com>
	<460d932b-e801-e2f8-9d0d-d3c96e1bb1ce@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <460d932b-e801-e2f8-9d0d-d3c96e1bb1ce@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: honglei.wang@oracle.com, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 05 2019 at  4:24pm -0400,
Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Hi Mike,
> 
> Do i make sense on this?

No, you haven't made your chase for this change.  Sorry.

Please refine the patch header to _not_ get into context you have from
a vendor kernel.  I know you say this is hard to reproduce, etc.  But
you don't even get into ther usecase where the issue was seen.  Was this
DM thinp?  DM cache?  Something else?

Please be as concise and precise as possible.  Saying that shrinker is
the same context as loop doesn't imply a whole lot to me (relative to
why this is prone to deadlock).

To restate my concern: if __GFP_FS isn't set then why does your patch
help at all?  If __GFP_FS is set, then that changes things..

Mike
