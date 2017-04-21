From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] dm-mpath: Requeue after a small delay if
 blk_get_request() fails
Date: Fri, 21 Apr 2017 20:34:35 +0000
Message-ID: <1492806874.2550.30.camel@sandisk.com>
References: <dbf70983-7e32-0a65-589b-8cfb15c12792@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dbf70983-7e32-0a65-589b-8cfb15c12792@sandisk.com>
Content-Language: en-US
Content-ID: <0F4E54A232ECFF4AAD09B001D19AA1DC@namprd04.prod.outlook.com>
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

On Fri, 2017-04-07 at 16:50 -0700, Bart Van Assche wrote:
> If blk_get_request() returns ENODEV then multipath_clone_and_map()
> causes a request to be requeued immediately. This can cause a
> kworker thread to spend 100% of the CPU time of a single core in
> __blk_mq_run_hw_queue() and also can cause device removal to
> never finish.
> 
> Avoid this by only requeuing after a delay if blk_get_request()
> fails. Additionally, reduce the requeue delay.

Hello Mike,

The v4.12 merge window will open soon. Have you already had the
time to review this patch?

Thanks,

Bart.
