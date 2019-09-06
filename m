From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v5 0/7] Elevator cleanups and improvements
Date: Thu, 5 Sep 2019 19:53:11 -0600
Message-ID: <b0913603-5a3f-472d-1013-9b12835e77fe@kernel.dk>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
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
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On 9/5/19 3:51 AM, Damien Le Moal wrote:
> This patch series implements some cleanup of the elevator initialization
> code and introduces elevator features identification and device matching
> to enhance checks for elevator/device compatibility and fitness.
> 
> The first 2 patches of the series are simple cleanups which simplify
> elevator initialization for newly allocated device queues.
> 
> Patch 3 introduce elevator features, allowing a clean and extensible
> definition of devices and features that an elevator supports and match
> these against features required by a block device. With this, the sysfs
> elevator list for a device always shows only elevators matching the
> features that a particular device requires, with the exception of the
> none elevator which has no features but is always available for use
> with any device.
> 
> The first feature defined is for zoned block device sequential write
> constraint support through zone write locking which prevents the use of
> any elevator that does not support this feature with zoned devices.
> 
> The last 4 patches of this series rework the default elevator selection
> and initialization to allow for the elevator/device features matching
> to work, doing so addressing cases not currently well supported, namely,
> multi-queue zoned block devices.

Applied for 5.4, thanks.

-- 
Jens Axboe
