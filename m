From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC PATCH v2] dm mpath: add a queue_if_no_path
 timeout
Date: Fri, 1 Nov 2013 01:23:31 +0000
Message-ID: <11AF7C027C4C02408624617A49860784EE09EF@BPXM12GP.gisp.nec.co.jp>
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
	<1383239860.17572.18.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383239860.17572.18.camel@bobble.lax.corp.google.com>
Content-Language: ja-JP
Content-ID: <AC8D3E801378094B968254781E5CF018@gisp.nec.co.jp>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/01/13 02:17, Frank Mayhar wrote:
> On Thu, 2013-10-31 at 14:31 +0000, Alasdair G Kergon wrote:
>> (And also remember to test table swap/push back.)
> 
> That brings up something I wanted to ask.  I've dug through the code and
> this particular thing isn't clear to me.  So how does it handle the
> queued I/Os when switching tables?  I see nothing in the table_load()
> path that would deal with this.  I'm guessing that the requests are
> pushed back to the block layer and are later resubmitted and requeued on
> the new multipath queue, but I don't see how that works.
> 
> Code references would be very welcome.

Relevant piece of codes is:
  - multipath_presuspend() temporarily disables "queue_if_no_path"
  - during the suspend process, __must_push_back() catches (otherwise
    failing) requests and requeues them back to the block layer queue
  - upon resume, dm starts processing requests in the block layer queue
    as usual

Hope this helps.
-- 
Jun'ichi Nomura, NEC Corporation
