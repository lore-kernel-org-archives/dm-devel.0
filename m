From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Fri, 13 Nov 2015 19:37:21 +0800
Message-ID: <CAMz4kuKOe8dT_K-8KQC_jMciCw-3jA_rxY22KG6347ENR-uGyQ@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151112125901.GD27454@quack.suse.cz>
	<CAMz4ku+NfrPG9PEwOHb-dLxn+jWhKEtwF2UoBnJes7Ok2MOiVQ@mail.gmail.com>
	<4015766.7tjD0ocbRK@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4015766.7tjD0ocbRK@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 13 November 2015 at 17:05, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 13 November 2015 10:05:28 Baolin Wang wrote:
>>
>> Well, I did a simple test with dd reading, cause my engine limitation is 1M,
>> (1) so the time like below when handle 1M at one time.
>> 1048576 bytes (1.0 MB) copied, 0.0841235 s, 12.5 MB/s
>> 1048576 bytes (1.0 MB) copied, 0.0836294 s, 12.5 MB/s
>> 1048576 bytes (1.0 MB) copied, 0.0836526 s, 12.5 MB/s
>>
>> (2) These handle 64K at one time * 16 times
>> 1048576 bytes (1.0 MB) copied, 0.0937223 s, 11.2 MB/s
>> 1048576 bytes (1.0 MB) copied, 0.097205 s, 10.8 MB/s
>> 1048576 bytes (1.0 MB) copied, 0.0935884 s, 11.2 MB/s
>>
>> Here is a 10ms level difference, try to image if the hardware engine's
>> throughput is bigger than that. But like Jens said, we can measure it
>> by the performance data.
>
> The absolute numbers look really low. Does this include writing to
> a hard drive? That would certainly make the difference appear
> less significant.
>

OK, I'll supply the complete performance data to measure it.

> Could you try backing this with a ram disk backing for comparison,
> and also use 'time dd' to show the CPU utilization for all cases?
> For completeness, including cpu-only performance might also help
> put this into perspective.
>

OK, I'll try. Thanks.

>         Arnd



-- 
Baolin.wang
Best Regards
