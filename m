From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Questions regarding request based dm-multipath and
	blk-layer/elevator
Date: Thu, 20 May 2010 20:18:25 +0900
Message-ID: <4BF51A81.1080503@ct.jp.nec.com>
References: <201005191716.38617.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201005191716.38617.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

Hi Nikanth,

On 05/19/2010 08:46 PM +0900, Nikanth Karthikesan wrote:
> Hi
> 
> I have couple of questions regd request based dm.
> 
> 1. With request based multipath, we have 2 elevators in the path to the
> device. Doesn't 2 idling I/O schedulers affect performance? Is it better to
> use the noop elevator for the dm device? What is suggested?
> I can send a patch to set noop as default for rq based dm, if it would be
> better.

Vivek answered perfectly.

 
> 2. The blk-layer limit nr_requests is the maximum nr of requests per-queue.
> Currently we set it to the default maximum(128) and leave it.
> 
> Instead would it be better to set it to a higher number based on the number of
> paths(underlying devices) and their nr_requests? In bio-based dm-multipath, we
> were queueing upto the sum of all the underlying queue's nr_requests.
> 
> For example the attached patch would set it to the sum of nr_requests of all
> the targets. May be it is better to do it from the user-space daemon,
> multipathd? Or just 128 requests is enough as in the end, it is going to be a
> single LUN? Or should we simply use the nr_request from one of the underlying
> device? Or the maximum nr_request amoung the underlying devices?

Thank you for working on this!
This has been on my TODO list for a long time and I have been having
the same concern.

My personal opinion is:
  o q->nr_requests of underlying devices may not be of our interests,
    since we don't use 'request' of underlying device's queue.

  o Instead, we might have to consider queue_depth of bottom devices,
    since queue_depth should affect I/O performance.
    Propagating the sum of underlying device's queue_depth to upper
    device using I/O topology framework or something may be an candidate
    for that.

  o On the other hand, which underlying devices are used depends on
    multipath configuration. (e.g. For multibus, the sum of all
    underlying devices' queue_depth should be appropriate.  But for
    failover, one of the underlying devices' queue_depth may be enough.)

  o Considering above, the userspace daemon, which knows multipath
    configuration in use, may be a good place to implement that.
    (Although some help/interface in kernel should be needed.)

Thanks,
Kiyoshi Ueda
