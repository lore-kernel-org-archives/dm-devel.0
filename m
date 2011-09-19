From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Mon, 19 Sep 2011 15:49:12 +0900
Message-ID: <4E76E5E8.9040701@ce.jp.nec.com>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

On 09/16/11 22:59, Mike Snitzer wrote:
> When processing a request, DM-mpath's map_io() set the cloned request's
> request_queue to the appropriate underlying device's request_queue
> without getting a reference on that request_queue.
> 
> DM-mpath now maintains a reference count on the underlying devices'
> request_queue.  This change wasn't motivated by a specific report but
> code, like blk_insert_cloned_request(), will access the request_queue
> with the understanding that the request_queue is valid.

Umm, I think it doesn't make sense.

DM opens underlying devices and it should be sufficient to keep
request_queue from being freed.
If it was not enough, any other openers would have to get the reference
count, too, and that should be done in more generic place.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
