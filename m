From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Mon, 12 Mar 2018 21:32:39 +0000
Message-ID: <1520890358.3469.68.camel@wdc.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180312212314.GA30763@redhat.com>
Content-Language: en-US
Content-ID: <AD26612FF16A82418FA3A29605DE4244@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2018-03-12 at 17:23 -0400, Mike Snitzer wrote:
> Could you provide more details on your setup?
> 
> Obviously you're using "queue_mode mq", what are your underlying paths?
> 
> Given the trace it would seem you're hitting multipath_clone_and_map()'s
> blk_queue_dying(q) error path that calls activate_or_offline_path().

Hello Mike,

The reported kernel crash was triggered by running the following command:

srp-test/run_tests -c -d -r 10 -t 02-mq

The srp-test software is available at https://github.com/bvanassche/srp-test.
All patches necessary to run that script in a virtual machine (RoCE support
for the SRP initiator and target drivers) will be sent to Linus during the
kernel v4.17 merge window. These patches are already available in linux-next
today. Although I have not tried this myself, I expect that if you run the
above command against a kernel built from the linux-next code that that will
allow you to reproduce what I reported.

Thanks,

Bart.
