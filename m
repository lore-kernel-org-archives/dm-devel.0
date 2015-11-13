From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Fri, 13 Nov 2015 11:27:29 +0800
Message-ID: <CAMz4kuJxL1yiPrzS7WzjcZmFcXTnqUZHXE-q_gUERoxaVTBmbw@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151112122400.GB27454@quack.suse.cz>
	<CAMz4kuLmGfyae=PXb8keuCpkEFDdXZzvuBtUiJHRAz0P55mxXg@mail.gmail.com>
	<4436790.rotQ3a7v5c@wuerfel>
	<20151112150238.GO12392@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151112150238.GO12392@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 12 November 2015 at 23:02, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Nov 12, 2015 at 01:57:27PM +0100, Arnd Bergmann wrote:
>> On Thursday 12 November 2015 20:51:10 Baolin Wang wrote:
>
>> > But it maybe not enough for HW engine which can handle maybe 10M/20M
>> > at one time.
>
>> Given that you have already done measurements, can you find out how much
>> you lose in overall performance with your existing patch if you artificially
>> limit the maximum size to sizes like 256kb, 1MB, 4MB, ...?
>
> It's probably also worth looking at the impact on CPU utilisation as
> well as throughput in your benchmarking since the system will often not
> be idle when it's doing a lot of I/O - I know you've done some
> measurements in that area before, including them when looking at block
> sizes might be interesting.

Make sense.



-- 
Baolin.wang
Best Regards
