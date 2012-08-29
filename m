From: Peter Osterlund <peterosterlund2@gmail.com>
Subject: Re: [PATCH v6 04/13] pktcdvd: Switch to bio_kmalloc()
Date: Wed, 29 Aug 2012 06:35:30 +0200 (CEST)
Message-ID: <alpine.LFD.2.02.1208290634360.15468@acer.localdomain>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com> <1345655050-28199-5-git-send-email-koverstreet@google.com> <20120822195546.GG19212@google.com> <alpine.LNX.2.00.1208281608560.22447@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1208281608560.22447@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com
List-Id: dm-devel.ids

On Tue, 28 Aug 2012, Jiri Kosina wrote:

> On Wed, 22 Aug 2012, Tejun Heo wrote:
>
>> (cc'ing Jiri, hi!)
>
> Hi there! :)
>
>> On Wed, Aug 22, 2012 at 10:04:01AM -0700, Kent Overstreet wrote:
>>> This is prep work for killing bi_destructor - previously, pktcdvd had
>>> its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
>>> necessitating its own bi_destructor implementation.
>>>
>>> v5: Un-reorder some functions, to make the patch easier to review
>>>
>>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>>> CC: Peter Osterlund <petero2@telia.com>
>>
>> Apart from bio_reset() not resetting bi_end_io and bi_private, this
>> looks fine to me but lack of testing makes me a bit hesitant to ack
>> it.
>>
>> Peter doesn't want to be the maintainer of pktcdvd anymore.  Maybe
>> Jiri can be tricked into taking this one too?  :)
>
> Gah, seems like the floppy saga is going to cause me some more trouble in
> the future ... :)
>
> Well, I definitely have hardware back at home that supports this, so I can
> take it. Doesn't seem to be heavy traffic code either.
>
> Peter, ok with that? Also, how was this usually fed upstream -- through
> Jens' tree?

Yes, I am ok with that.

-- 
Peter Osterlund - peterosterlund2@gmail.com, petero2@comhem.se
http://web.comhem.se/petero2home
