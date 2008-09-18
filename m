From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 15:46:31 +0530
Message-ID: <200809181546.32242.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Christophe Saout <christophe@saout.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Milan

I was able to talk to Alasdair on Freenode#device-mapper and he is also of the 
opinion full-barrier support is the way to go.

On Thu, Sep 18, 2008 at 12:27 PM, Milan Broz <mbroz@redhat.com> wrote:
> Andi's patch is not complete and I think there can be several problems with 
> it:
>
> - imagine DM device which has barrier support switched on by this simple
> patch and you try to run pvmove on it. How is the barrier request processed
> by underlying devices now?
>
> -> mapping can change online (pvmove, lvextend, lvconvert, ...) to more
> complicated mapping - who reset barrier flag support?
>

I think these things will not create problems.

> - what about stacking devices? Imagine crypto - there is one device per
> table possible under linear target (where you enable barriers by this
> patch).
> dm-crypt will need to implement some queue flushes to properly support
> barriers. Another example - partition mapping over multipath (kpartx), ...
> Are you sure that is it safe with Andi's patch?
> ...

I do not have knowledge of dm-crypt, but yes, dm-crypt might possibly reorder.
Either they should flush the queues or atleast return -EOPNOTSUPP if we need 
to use Andi's patch.

>
> It is dangerous to use that patch IMO, better not support barriers at all
> here. That's why we need something more robust.
>

I understand the possible problems.

> Unfortunately I received _no_ feedback to mentioned RFC barrier patches.

Alasdair said that he will be reviewing/queueing them next week.

Thanks
Nikanth
