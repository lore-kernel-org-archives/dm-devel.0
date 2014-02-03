From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 3/5] dm-multipath: remove process_queued_ios()
Date: Mon, 3 Feb 2014 10:26:13 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401058925@BPXM12GP.gisp.nec.co.jp>
References: <1391159444-17987-1-git-send-email-hare@suse.de>
	<1391159444-17987-4-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784010535C4@BPXM12GP.gisp.nec.co.jp>
	<52EBB958.5090803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52EBB958.5090803@suse.de>
Content-Language: ja-JP
Content-ID: <0B8A512D072F94408721279D58B18BD9@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/31/14 23:55, Hannes Reinecke wrote:
> Problem here is that pg_init_done() is per path, so at face value
> SCSI_DH_RETRY is per path, too.
> So from that we should be retrying this path (and this path only).
> Hence it would be correct to call queue_delayed_work directly.
> 
> However, typically any pg_init affects _every_ path in the multipath
> device (active paths become passive and vice versa).
> Which seems to be the intended usage, as we're checking for
> pg_init_in_progress prior to invoking queue_delayed_work().
> 
> But _if_ we assume that, then we only need to send a _single_
> pg_init, as this will switch all paths. So again, a call to
> __pg_init_all_paths will not do the correct thing as it'll
> send activations to _every_ active path.

Sending activation for every paths was introduced by this:
  commit e54f77ddda72781ec1c1696b21aabd6a30cbb7c6
  Author: Chandra Seetharaman <sekharan@us.ibm.com>
  Date:   Mon Jun 22 10:12:12 2009 +0100
So if you make change in the logic, you have to check whether the
change does not break what the above solved.

> (And, in fact, we're trying really hard in scsi_dh_rdac
> and scsi_dh_alua to bunch together all the various pg_init
> requests precisely for the cited reason).
> 
> So my inclination here would be to treat SCSI_DH_RETRY
> as _per path_, and retry only this specific path.
> IE removing the check to pg_init_in_progress and call
> queue_delayed_work() directly.
> 
> IMHO this would impose the least restriction on
> the internal workings of the various device handlers.
> 
> What do you think?

I don't have strong opinion either way. But if we do that, more code
has to be changed, e.g. the management of retry count.

Removing the unnecessary workqueue has already a benefit.
It would be nice to focus on that instead of folding in more changes.

-- 
Jun'ichi Nomura, NEC Corporation
