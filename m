From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v3 1/2] md raid0/linear: Mark array as
 'broken' and fail BIOs if a member is gone
Date: Fri, 23 Aug 2019 14:48:35 -0300
Message-ID: <8163258e-839c-e0b8-fc4b-74c94c9dae1d@canonical.com>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
	<73C4747E-7A9E-4833-8393-B6A06C935DBE@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <73C4747E-7A9E-4833-8393-B6A06C935DBE@fb.com>
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
To: Song Liu <songliubraving@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 22/08/2019 18:55, Song Liu wrote:
> [...] 
>> +	if (unlikely(!(tmp_dev->rdev->bdev->bd_disk->flags & GENHD_FL_UP))) {
>> +		if (!test_bit(MD_BROKEN, &mddev->flags))
>> +			pr_warn("md: %s: linear array has a missing/failed member\n",
>> +				mdname(mddev));
>> +		set_bit(MD_BROKEN, &mddev->flags);
>> +		bio_io_error(bio);
>> +		return true;
>> +	}
>> +
> 
> Maybe we can somehow put this block in a helper and use it in both raid0
> and linear code?
> 
> Otherwise, looks good to me. 
> 
> Thanks,
> Song
> 

OK, so something as a function with a prototype like
"void md_is_broken(struct md_rdev *rd, const char *md_type)"
is good for you?
Then we can use that as the check if a member failed and in positive
case, we can print the message (if not printed before) and return to the
raid0/linear driver in order it fails the bio and returns.
I'd prefer keeping the bio out of the helper, agreed?

If you have suggestion for a better name, let me know.
Thanks,


Guilherme
