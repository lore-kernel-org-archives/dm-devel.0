From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] dm-mpath: Only reprocess queued IO after pg
 initialization finished
Date: Tue, 4 Oct 2016 21:20:56 -0700
Message-ID: <b370e924-d04c-5c9f-5b68-3dacb9310100@sandisk.com>
References: <fdedde34-4785-fe1d-f88f-a2d6b3713500@sandisk.com>
	<8e13e2f0-ef7c-c48f-d73e-5fa3a533daa3@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8e13e2f0-ef7c-c48f-d73e-5fa3a533daa3@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/02/16 23:06, Junichi Nomura wrote:
> So I don't think the patch makes sense...

Hello Junichi,

I had overlooked that pg_init_done() holds m->lock while manipulating 
m->pg_init_in_progress. So now I agree with you that this patch should 
not change the behavior of the dm-mpath driver. I will continue my 
search for what is causing the high number of multipath_busy() calls.

Bart.
