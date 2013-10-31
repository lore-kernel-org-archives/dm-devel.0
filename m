From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH v2] dm mpath: add a queue_if_no_path
 timeout
Date: Thu, 31 Oct 2013 10:17:40 -0700
Message-ID: <1383239860.17572.18.camel@bobble.lax.corp.google.com>
References: <1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com> <20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<20131031143110.GF24325@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131031143110.GF24325@agk-dp.fab.redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, 2013-10-31 at 14:31 +0000, Alasdair G Kergon wrote:
> On Thu, Oct 31, 2013 at 07:16:51AM -0700, Frank Mayhar wrote:
> > Unfortunately the clones don't appear to be associated with a request
> > queue; they're just put on multipath's internal queue.
> 
> (And also remember to test table swap/push back.)

That brings up something I wanted to ask.  I've dug through the code and
this particular thing isn't clear to me.  So how does it handle the
queued I/Os when switching tables?  I see nothing in the table_load()
path that would deal with this.  I'm guessing that the requests are
pushed back to the block layer and are later resubmitted and requeued on
the new multipath queue, but I don't see how that works.

Code references would be very welcome.
-- 
Frank Mayhar
310-460-4042
