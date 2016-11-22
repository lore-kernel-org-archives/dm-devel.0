From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Tue, 22 Nov 2016 15:47:31 -0800
Message-ID: <a8311b54-cd95-a1f9-7cd2-11adb10eec80@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
	<20161116003720.GA19059@redhat.com>
	<be828cfa-1121-8d99-0cd1-9021fab3adc8@sandisk.com>
	<20161121234316.GA25362@redhat.com>
	<d4a3879e-ec60-69f6-abb8-95aa7f305277@sandisk.com>
	<20161122003444.GB25362@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161122003444.GB25362@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/21/2016 04:34 PM, Mike Snitzer wrote:
> But you WARN_ON_ONCE(clone && q->mq_ops) will trigger with sq-on-mq.

Hello Mike,

This behavior is indeed triggered by the sq-on-mq test. After having 
added the following code in __bind():

	if (old_map &&
	    dm_table_all_blk_mq_devices(old_map) !=
	    dm_table_all_blk_mq_devices(t))
		pr_debug("%s: old all_blk_mq %d <> new all_blk_mq %d\n",
			 dm_device_name(md),
			 dm_table_all_blk_mq_devices(old_map),
			 dm_table_all_blk_mq_devices(t));

I see the following output appear frequently in the kernel log:

dm_mod:__bind: 254:0: old all_blk_mq 1 <> new all_blk_mq 0

Could these all_blk_mq state changes explain that WARN_ON_ONCE(clone && 
q->mq_ops) is triggered in __multipath_map()? Does this mean that the 
comment in patch http://marc.info/?l=dm-devel&m=147925314306752 is correct?

Thanks,

Bart.
