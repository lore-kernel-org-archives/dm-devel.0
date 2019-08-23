From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 1/2] md raid0/linear: Mark array as
 'broken' and fail BIOs if a member is gone
Date: Fri, 23 Aug 2019 17:51:18 +0000
Message-ID: <F0E716F8-76EC-4315-933D-A547B52F1D27@fb.com>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
	<73C4747E-7A9E-4833-8393-B6A06C935DBE@fb.com>
	<8163258e-839c-e0b8-fc4b-74c94c9dae1d@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8163258e-839c-e0b8-fc4b-74c94c9dae1d@canonical.com>
Content-Language: en-US
Content-ID: <0674B3614E0FBC4BABE51F8D02901F68@namprd15.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids



> On Aug 23, 2019, at 10:48 AM, Guilherme G. Piccoli <gpiccoli@canonical.com> wrote:
> 
> On 22/08/2019 18:55, Song Liu wrote:
>> [...] 
>>> +	if (unlikely(!(tmp_dev->rdev->bdev->bd_disk->flags & GENHD_FL_UP))) {
>>> +		if (!test_bit(MD_BROKEN, &mddev->flags))
>>> +			pr_warn("md: %s: linear array has a missing/failed member\n",
>>> +				mdname(mddev));
>>> +		set_bit(MD_BROKEN, &mddev->flags);
>>> +		bio_io_error(bio);
>>> +		return true;
>>> +	}
>>> +
>> 
>> Maybe we can somehow put this block in a helper and use it in both raid0
>> and linear code?
>> 
>> Otherwise, looks good to me. 
>> 
>> Thanks,
>> Song
>> 
> 
> OK, so something as a function with a prototype like
> "void md_is_broken(struct md_rdev *rd, const char *md_type)"
> is good for you?
> Then we can use that as the check if a member failed and in positive
> case, we can print the message (if not printed before) and return to the
> raid0/linear driver in order it fails the bio and returns.
> I'd prefer keeping the bio out of the helper, agreed?
> 

I guess md_is_broken() should return bool? Otherwise, looks good to me. 

Thanks,
Song
