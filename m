From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Tue, 30 Jul 2019 09:30:31 -0300
Message-ID: <6400083b-3cf3-cbc6-650a-c3ae6629b14c@canonical.com>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<87zhkwl6ya.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87zhkwl6ya.fsf@notabene.neil.brown.name>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, Song Liu <songliubraving@fb.com>, dm-devel@redhat.com, Neil F Brown <nfbrown@suse.com>
List-Id: dm-devel.ids

On 29/07/2019 21:08, NeilBrown wrote:
>[...]
>> +	if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
>> +		bio_io_error(bio);
>> +		return BLK_QC_T_NONE;
>> +	}
> 
> I think this should only fail WRITE requests, not READ requests.
> 
> Otherwise the patch is probably reasonable.
> 
> NeilBrown

Thanks for the feedback Neil! I thought about it; it seemed to me better
to deny/fail the reads instead of returning "wrong" reads, since a file
read in a raid0 will be incomplete if one member is missing.
But it's fine for me to change that in the next iteration of this patch.

Cheers,


Guilherme
