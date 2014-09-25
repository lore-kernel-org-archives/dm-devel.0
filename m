From: Keith Busch <keith.busch@intel.com>
Subject: Re: dm-mpath: Work with blk multi-queue drivers
Date: Thu, 25 Sep 2014 09:57:41 -0600 (MDT)
Message-ID: <alpine.LRH.2.03.1409250923390.4696@AMR>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
	<20140924145215.GA26398@infradead.org>
	<alpine.LRH.2.03.1409241020540.4696@AMR>
	<20140924183453.GA23052@redhat.com>
	<20140924184834.GB23052@redhat.com>
	<20140925001341.GA25145@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140925001341.GA25145@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 24 Sep 2014, Mike Snitzer wrote:
> Mike Snitzer <snitzer@redhat.com> wrote:
>> On Wed, Sep 24 2014 at  2:34pm -0400,
>> Mike Snitzer <snitzer@redhat.com> wrote:
>>> I never did take the time to properly review Hannes' proposal but now
>>> that you're floating this blk-mq support for DM core (and DM mpath) I'm
>>> clearly going to have to take this all on in a much more focused way.
>>>
>>> Christoph/Hannes/Junichi/Keith/others, can you see a way forward that
>>> offers a lighter request-based DM that makes required callouts to (new?)
>>> block interfaces that helps us abstract the old request and blk-mq
>>> request allocation, etc?
>>
>> (sorry about replying to myself...)
>>
>> SO revisiting that thread from above, these posts stand out:
>> http://www.redhat.com/archives/dm-devel/2014-June/msg00026.html
>> http://www.redhat.com/archives/dm-devel/2014-June/msg00028.html
>>
>> I'd love to see us get rid of request-based DM's bio cloning for each
>> cloned request (we never did get an answer from the NEC guys to know
>> _why_ that was done).
>
> Actually, Junichi did respond with why:
> http://www.redhat.com/archives/dm-devel/2014-June/msg00033.html
>
> So this needs more review and thought.

Thank you for all the background information. This definitely gives me
a lot more to think about.

For my part, the goal was to change as little as possible to get basic
blk-mq support working safely without regressing, and performance is
not even on my radar yet. I purposefully did not try to understand the
existing design well enough to propose re-arching. If we can address the
'request' life cycle management duality issue, would this be acceptable
as a stopgap for blk-mq support?
