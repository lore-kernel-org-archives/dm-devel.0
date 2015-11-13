From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Fri, 13 Nov 2015 10:07:25 +0800
Message-ID: <CAMz4kuL0r=wJuxyQvftuY_p=5k3_bYaksfgha6O2idNgqiBNZw@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111181813.GD12236@redhat.com>
	<CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
	<20151112100422.GM12392@sirena.org.uk>
	<5644AFA2.6040201@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5644AFA2.6040201@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mark Brown <broonie@kernel.org>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, keith.busch@intel.com, jmoyer@redhat.com, tj@kernel.org, bart.vanassche@sandisk.com, "Garg, Dinesh" <dineshg@quicinc.com>
List-Id: dm-devel.ids

On 12 November 2015 at 23:26, Jens Axboe <axboe@kernel.dk> wrote:
> On 11/12/2015 03:04 AM, Mark Brown wrote:
>>
>> On Thu, Nov 12, 2015 at 04:20:41PM +0800, Baolin Wang wrote:
>>
>>> 3. perforamence data
>>> It is just a simple dd test result, and will provide the formal report
>>> in future. But from the simple test, we can see the improvement.
>>
>>
>> It's probably also worth pointing out that Qualcomm have been shipping
>> an out of tree implementation of this as a separate module in their BSP
>> (originally written by Danesh Garg who's on this thread):
>>
>>
>> https://android.googlesource.com/kernel/msm/+/android-msm-dory-3.10-kitkat-wear/drivers/md/dm-req-crypt.c
>>
>> Android now wants to encrypt phones and tablets by default and have been
>> seeing substantial performance hits as a result, we can try to get
>> people to share performance data from productionish systems but it might
>> be difficult.
>
>
> Well, shame on them for developing out-of-tree, looks like they are reaping
> all the benefits of that.
>
> Guys, we need some numbers, enough with the hand waving. There's no point
> discussing this further until we know how much of a difference it makes to
> handle X MB chunks instead of Y MB chunks. As was previously stated, unless
> there's a _substantial_ performance benefit, this patchset isn't going
> anywhere.

That's fair enough and we will provide the performance data to measure
the patchset.

>
> If there is a huge benefit, we can look into ways of making it actually
> work. That may not even be a request interface, it could just be proper
> utilization of plugging for in-dm bio merging.

Make sense. Thanks.

>
> --
> Jens Axboe
>



-- 
Baolin.wang
Best Regards
