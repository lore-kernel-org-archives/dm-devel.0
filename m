From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [RFC] dm-writeboost: Removing a tunable
	barrier_deadline_ms
Date: Thu, 24 Jul 2014 17:13:58 +0900
Message-ID: <20140724171358.00b5b89ce1afb37d68f9fa1f@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ejt@redhat.com
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, masami.hiramatsu@gmail.com, dchinner@redhat.com
List-Id: dm-devel.ids

Hi Joe,

These days, I am trying to simplify Writeboost.


In the thread below,
http://www.redhat.com/archives/dm-devel/2013-October/msg00010.html

- Joe mentioned dm-thin delays REQ_FLUSH for a tiny momemnt expecting that other subsequent
  REQ_FUA are aggregated.
- Dave Chinner, a XFS developer, mentioned that such delay would better be removed because
  XFS does such delaying in its journaling and delay twice meaninglessly.

Writeboost also dalays REQ_FLUSH as dm-thin for the same reason
but the delaying seconds is tunable by barrier_deadline_ms. This is implemented by timer.

There can be pros/cons for making it tunable

Pros:
  1. We can aggregate more REQ_FUA than dm-thin can.
Cons:
  1. Complicate the interface. Writeboost's type 1 doesn't use this but only type 0 does
     makes it more complicated (Some guys reviewed my doc mentioned this).
  2. Make it difficult to isolate the cause of slowdown/malbehavior.
  3. User may set extermely higher value.
  4. Not tested so much. Will probably stall the system by never acking to REQ_FLUSH.
     Actually, a user of Writeboost reported a bugfix for this mechanism before.

My direction may be:
If it is meaningless or unreasonable to delay REQ_FLUSH longer than dm-thin
I will remove the tunableness from Writeboost.

So I ask you:
- What is the reason that it is enough to delay REQ_FLUSH for as tiny moment as dm-thin does?
- Is it a heuristic thing?

And, related to this topic I propose that
we should add a knob to enable/disable such delay for the sake of XFS.
AFAIK, dm-thin and dm-cache does this optimization.


Cheers,
- Akira
