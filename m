From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 1/2] block: Introduce BIO_ENDIO_FREE for bio flags
Date: Thu, 12 Nov 2015 12:05:32 +0800
Message-ID: <CAMz4ku+rKTJ=mtfQ3wp36qJCh0Jv+9-aUqiER=9UR9Y6xmv3ow@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<2bd3cc769530061501af545c7949dcc832263930.1447233227.git.baolin.wang@linaro.org>
	<20151111175411.GC12236@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151111175411.GC12236@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, keith.busch@intel.com, jmoyer@redhat.com, Mark Brown <broonie@kernel.org>, tj@kernel.org, bart.vanassche@sandisk.com, "Garg, Dinesh" <dineshg@quicinc.com>
List-Id: dm-devel.ids

On 12 November 2015 at 01:54, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Nov 11 2015 at  4:31am -0500,
> Baolin Wang <baolin.wang@linaro.org> wrote:
>
>> When we use dm-crypt to decrypt block data, it will decrypt the block data
>> in endio() when one IO is completed. In this situation we don't want the
>> cloned bios is freed before calling the endio().
>>
>> Thus introduce 'BIO_ENDIO_FREE' flag to support the request handling for dm-crypt,
>> this flag will ensure that blk layer does not complete the cloned bios before
>> completing the request. When the crypt endio is called, post-processsing is
>> done and then the dm layer will complete the bios (clones) and free them.
>
> Not following why request-based DM's partial completion handling
> (drivers/md/dm.c:end_clone_bio) isn't a sufficient hook -- no need to
> add block complexity.
>

Sorry for lacking of more explanation for that. The dm-crypt will
decrypt block data in the end_io() callback function when one request
is completed, so we don't want the bios of this request is freed when
calling the end_io() callback. Thus we introduce a flag to indicate
these type bios of this request will be freed at dm layer not in block
layer.

> But that aside, I'm not liking the idea of a request-based dm-crypt.
>
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>> index 76d23fa..f636c50 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -407,6 +407,11 @@ union map_info *dm_get_rq_mapinfo(struct request *rq);
>>
>>  struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
>>
>> +void dm_end_request(struct request *clone, int error);
>> +void dm_kill_unmapped_request(struct request *rq, int error);
>> +void dm_dispatch_clone_request(struct request *clone, struct request *rq);
>> +struct request *dm_get_orig_rq(struct request *clone);
>> +
>>  /*
>>   * Geometry functions.
>>   */
>
> I have no interest in seeing any request-based DM interfaces exported.

OK.


-- 
Baolin.wang
Best Regards
