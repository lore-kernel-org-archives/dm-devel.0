From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH for-4.2 2/3] block,
 dm: don't copy bios for request clones
Date: Wed, 3 Jun 2015 23:13:09 +0000
Message-ID: <556F8A05.70706@ce.jp.nec.com>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com> <5566B7E5.1070101@ce.jp.nec.com>
	<20150529165451.GA2682@lst.de> <556BB1F1.4030404@ce.jp.nec.com>
	<20150603073725.GA12072@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150603073725.GA12072@lst.de>
Content-Language: ja-JP
Content-ID: <9DE58ED35E67FF4CB1FDCD4651AD6F03@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 06/03/15 16:37, Christoph Hellwig wrote:
> From scsi_io_completion:
> 
> 	/*
> 	 * If we finished all bytes in the request we are done now.
> 	 */
> 	if (!scsi_end_request(req, error, good_bytes, 0))
> 		return;
> 
> 	/*
> 	 * Kill remainder if no retrys.
> 	 */
> 	if (error && scsi_noretry_cmd(cmd)) {
> 		if (scsi_end_request(req, error, blk_rq_bytes(req), 0))
> 			BUG();
> 		return;
> 	}
> 
> So for a noretry command send from dm-mpath we will never leave a command
> that had an error completion around, even if it was a partial completion.

scsi_noretry_cmd() is not always true even for dm-mpath.

Following code in the later part of the function tries to complete
some bytes with error and requeue the remainder.
However it depends on blk_rq_err_bytes() whether partial error completion
actually happens...

        case ACTION_FAIL:
                ...
                if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
                        return;
                /*FALLTHRU*/
        case ACTION_REPREP:
        requeue:
                /* Unprep the request and put it back at the head of the queue.
                 * A new command will be prepared and issued.
                 */
                if (q->mq_ops) {
                        cmd->request->cmd_flags &= ~REQ_DONTPREP;
                        scsi_mq_uninit_cmd(cmd);
                        scsi_mq_requeue_cmd(cmd);
                } else {
                        scsi_release_buffers(cmd);
                        scsi_requeue_command(q, cmd);
                }

> Relying on the LLDDs to get this right seems rather dangerous, though, so
> it might make sense to lift the above sequence to core code after a careful
> audit of other drivers to see if and how they handle partial completions.

Right, that is the point.

-- 
Jun'ichi Nomura, NEC Corporation
