From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] dm: fix free_rq_clone() NULL pointer when
 requeueing unmapped request
Date: Wed, 29 Apr 2015 21:11:28 +0200
Message-ID: <55412CE0.4060909@sandisk.com>
References: <553F7474.70905@sandisk.com> <20150429132029.GA3876@lst.de>
	<20150429133433.GA23127@redhat.com> <20150429185345.GA5975@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150429185345.GA5975@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: device-mapper development <dm-devel@redhat.com>, Aaro Koskinen <aaro.koskinen@nokia.com>
List-Id: dm-devel.ids

On 04/29/15 20:53, Mike Snitzer wrote:
> Actually, here is the proper 4.1-only fix (Bart please verify this works
> for you):

Hello Mike,

Thanks for the patch. But against which tree has this patch been 
generated ? It doesn't seem to apply on v4.1-rc1:

$ git reset --hard v4.1-rc1
HEAD is now at b787f68 Linux 4.1-rc1
$ patch -p1 < ~/\[PATCH\]\ dm\:\ fix\ free_rq_clone\(\)\ NULL\ pointer\ 
when\ requeueing\ unmapped\ request.eml
(Stripping trailing CRs from patch; use --binary to disable.)
patching file drivers/md/dm.c
Hunk #1 FAILED at 1031.
Hunk #2 succeeded at 1124 (offset 53 lines).
Hunk #3 succeeded at 1143 (offset 53 lines).
1 out of 3 hunks FAILED -- saving rejects to file drivers/md/dm.c.rej

Bart.
