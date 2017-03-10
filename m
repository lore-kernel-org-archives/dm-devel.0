From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] blk: improve order of bio handling in
 generic_make_request()
Date: Thu, 9 Mar 2017 21:40:24 -0700
Message-ID: <9af0f921-ad24-961e-085d-86c1973dbe8a@kernel.dk>
References: <87h93blz6g.fsf@notabene.neil.brown.name>
 <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com>
 <87lgsjj9w8.fsf@notabene.neil.brown.name>
 <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk>
 <87r328j00i.fsf@notabene.neil.brown.name>
 <87d1dphhuy.fsf@notabene.neil.brown.name>
 <58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 03/09/2017 09:38 PM, Jens Axboe wrote:
> On 03/09/2017 09:32 PM, NeilBrown wrote:
>>
>> I started looking further at the improvements we can make once
>> generic_make_request is fixed, and realised that I had missed an
>> important detail in this patch.
>> Several places test current->bio_list, and two actually edit the list.
>> With this change, that cannot see the whole lists, so it could cause a
>> regression.
>>
>> So I've revised the patch to make sure that the entire list of queued
>> bios remains visible, and change the relevant code to look at both
>> the new list and the old list.
>>
>> Following that there are some patches which make the rescuer thread
>> optional, and then starts removing it from some easy-to-fix places.
> 
> Neil, note that the v2 patch is already in Linus tree as of earlier
> today. You need to rebase the series, and if we need fixups on
> top of v2, then that should be done separately and with increased
> urgency.

Additionally, at least the first patch appears to be badly mangled.
The formatting is screwed up.

-- 
Jens Axboe
