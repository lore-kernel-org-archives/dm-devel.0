From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: dm-cache coherence issue
Date: Mon, 26 Jun 2017 22:36:23 +0200
Message-ID: <5319af39-68eb-a732-0818-26f7d21ecbf1@gmx.de>
References: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
	<20170626113341.GA20683@nim> <20170626155808.GC20683@nim>
	<745c64ba-a5ec-363b-bc6f-2abd0d242b38@gmx.de>
	<20170626195617.GA599@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170626195617.GA599@redhat.com>
Content-Language: de-LU
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
Cc: dm-devel@redhat.com, thornber@redhat.com
List-Id: dm-devel.ids

On 26.06.2017 21:56, Mike Snitzer wrote:

>> Interesting, I did *not* change to writethrough. However, there
>> shouldn't have been any I/O on the device (it was not accessed by
>> anything after I switched to the cleaner policy).
[...]
>> Anyways, I'll try to replicate my scenario again because I'm actually
>> quite sure that I did everything correctly (I did it a few times).
> 
> Except you didn't first switch to writethrough -- which is _not_
> correct.

Absolutely, very good to know. So even without any I/O being request,
dm-cache is allowed to "hold back" pages as long as the dm-cache device
is in writeback mode? Would this also explain why the "dmsetup wait"
hung indefinitely?

I do think I followed a tutorial that I found on the net regarding this.
Scary that such a crucial fact is missing there. The fact that dirty
pages are reported as zero just gives the impression that everything is
coherent, when in fact it's not.

Regardless, I find this and your explanation extremely interesting and
want to thank you for clearing this up. Very fascinating topic indeed.

Best regards,
Johannes
