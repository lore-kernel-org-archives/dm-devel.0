From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: dm-zoned: Fix overflow in exposed capacity
Date: Fri, 9 Jun 2017 23:41:04 +0900
Message-ID: <42af3a80-8355-0444-f95a-fa5025827608@wdc.com>
References: <20170609040605.4340-1-damien.lemoal@wdc.com>
	<20170609120339.GB11110@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170609120339.GB11110@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

On 6/9/17 21:03, Mike Snitzer wrote:
> I've switched from .presuspend to .postsuspend, and eliminated the
> .presuspend_undo
> 
> I'm not seeing any reason for .presuspend_undo
> 
> See dm-cache-target.c for a .postsuspend that is pretty comparable to
> what dm-zoned's is doing.
> 
> As for .presuspend_undo, dm-thinp has a need for it but most target do
> not.  And I'm not seeing why dm-zoned needs it.

Thanks for the pointer. I looked at dm-thin for examples, but that was
not the best one. I will study all these methods more.

> I've pushed to linux-dm.git's 'for-next' to get more test coverage;
> doesn't mean that I consider dm-zoned's review complete.

Thank you. Let me know if you see anything not satisfying. I will keep
testing on my side to make sure there are no obvious problems remaining.
We are also finishing a set of test case for blktests for the dm zoned
block device series. Will be submitting that soon.

Best regards.

-- 
Damien Le Moal
Western Digital Research
