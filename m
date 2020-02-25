From: =?UTF-8?Q?Daniel_Gl=c3=b6ckner?= <dg@emlix.com>
Subject: Re: [dm-devel] [PATCH] dm integrity: reinitialize __bi_remaining when
 reusing bio
Date: Tue, 25 Feb 2020 20:54:07 +0100
Message-ID: <a932a297-266e-4dee-f030-40ecbc9899ca@emlix.com>
References: <20200225170744.10485-1-dg@emlix.com>
 <20200225191222.GA3908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200225191222.GA3908@infradead.org>
Content-Language: de-DE
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christoph,

Am 02/25/20 um 20:12 schrieb Christoph Hellwig:
> On Tue, Feb 25, 2020 at 06:07:44PM +0100, Daniel Glöckner wrote:
>> In cases where dec_in_flight has to requeue the integrity_bio_wait work
>> to transfer the rest of the data, the __bi_remaining field of the bio
>> might already have been decremented to zero. Reusing the bio without
>> reinitializing that counter to 1 can then result in integrity_end_io
>> being called too early when the BIO_CHAIN flag is set, f.ex. due to
>> blk_queue_split. In our case this triggered the BUG() in
>> blk_mq_end_request when the hardware signalled completion of the bio
>> after integrity_end_io had modified it.
>>
>> Signed-off-by: Daniel Glöckner <dg@emlix.com>
> 
> Drivers have no business poking into these internals.  If a bio is
> reused the caller needs to use bio_reset instead.

bio_reset will reset too many fields. As you can see in the context of
the diff, dm-integrity expects f.ex. the values modified by bio_advance
to stay intact and the transfer should of course use the same disk and
operation.

How about doing the atomic_set in bio_remaining_done (in block/bio.c)
where the BIO_CHAIN flag is cleared once __bi_remaining hits zero?
Or is requeuing a bio without bio_reset really a no-go? In that case a
one-liner won't do...

Best regards,

  Daniel

-- 
Besuchen Sie uns auf der Embedded World 2020 in Nürnberg!
-> Halle 4, Stand 368

Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11,
Gothaer Platz 3, 37083 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführung: Heike Jordan, Dr. Uwe Kracke
Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
