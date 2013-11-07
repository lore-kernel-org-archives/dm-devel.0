From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC PATCH v3] dm mpath: add a queue_if_no_path
	timeout
Date: Thu, 7 Nov 2013 01:03:17 +0000
Message-ID: <11AF7C027C4C02408624617A49860784EF6CAF@BPXM12GP.gisp.nec.co.jp>
References: <20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
	<11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
	<1383664708.4504.4.camel@bobble.lax.corp.google.com>
	<1383667332.4504.8.camel@bobble.lax.corp.google.com>
	<5279E79C.8010509@suse.de>
	<1383752639.4504.23.camel@bobble.lax.corp.google.com>
	<20131106192105.GB409@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131106192105.GB409@redhat.com>
Content-Language: ja-JP
Content-ID: <A6F500E12969D34DB61A716415A12564@gisp.nec.co.jp>
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
Cc: Alasdair G Kergon <agk@redhat.com>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 11/07/13 04:21, Mike Snitzer wrote:
> On Wed, Nov 06 2013 at 10:43am -0500,
> Frank Mayhar <fmayhar@google.com> wrote:
> 
>> On Wed, 2013-11-06 at 07:54 +0100, Hannes Reinecke wrote:
>>> On 11/05/2013 05:02 PM, Frank Mayhar wrote:
>>>> This is the patch submitted by Jun'ichi Nomura, originally based on
>>>> Mike's patch with some small changes by me.  Jun'ichi's description
>>>> follows, along with my changes:
>>>>
>>>> On Tue, 2013-11-05 at 07:18 -0800, Frank Mayhar wrote:
>>>>> On Fri, 2013-11-01 at 04:17 +0000, Junichi Nomura wrote:
>>>>>> I slightly modified the patch:
>>>>>>   - fixed the timeout handler to correctly find
>>>>>>     clone request and "struct multipath"
>>>>>>   - the timeout handler just disables "queue_if_no_path"
>>>>>>     instead of killing the request directly
>>>>>>   - "dmsetup status" to show the parameter
>>>>>>   - changed an interface between dm core and target
>>>>>>   - added some debugging printk (you can remove them)
>>>>>> and checked the timeout occurs, at least.
>>>>>>
>>>>>> I'm not sure if this feature is good or not though.
>>>>>> (The timer behavior is not intuitive, I think)
>>>>> Thanks!  I integrated your new patch and tested it.  Sure enough, it
>>>>> seems to work.  I've made a few tweaks (added a module tunable and
>>>>> support for setting the timer in multipath_message(), removed your debug
>>>>> printks) and will submit the modified patch for discussion shortly.
>>>>
>>>> Comments?
>>>>
>>> Yeah. Seems to be my eternal fate; initiating fixes and not getting
>>> mentioned at all.
>>> Sigh.
>>>
>>> I dimly remember having sent the original patch for the blk timeout
>>> function ... hence a short notice would've been nice.
>>
>> Sorry, I did ding you early on (and I think Mike dinged you as well),
>> but you were apparently busy with other things at the time.
> 
> Hi Frank,
> 
> I wouldn't worry about this.  You didn't even supply a patch header.. so
> it isn't like Hannes was obviously left out.  Fact is this patch has had
> 4 iterations, the first of which from Hannes didn't compile or even make
> sense.  Anyway, he'll get attribution through Suggested-by unless he
> wins the race to produces the first upstream-worthy variant of this line
> of work.
> 
> So far it has all been RFC-style patches.. your most recent one that
> builds on Jun'ichi's patch with a module param and timeout default:  We
> generally don't add module params to targets (but I can appreciate why
> you might want that.. just not seeing the need).  And having a message
> to change the timeout conflicts with my desire to conditionally
> establish a timed_out method only if a timeout was specified (like my
> last reply in this thread suggested).

BTW, this approach of using blk timer might conflict with
possible future removal of multipath internal queue:
  https://www.redhat.com/archives/dm-devel/2013-November/msg00025.html
because the timer is stopped if the request is queued to block layer.
To cope with that, we might have to extend block layer to run timer
for queued request, etc.

-- 
Jun'ichi Nomura, NEC Corporation
