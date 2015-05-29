From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm: fix false alarm in free_rq_clone() for non
 blk-mq target
Date: Fri, 29 May 2015 04:17:49 +0000
Message-ID: <5567E86D.7080204@ce.jp.nec.com>
References: <5566CAE8.4070404@ce.jp.nec.com>
	<20150528191457.GA26218@redhat.com>	<5567B2D2.5080907@ce.jp.nec.com>
	<20150529031842.GA26268@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150529031842.GA26268@redhat.com>
Content-Language: ja-JP
Content-ID: <0DCDB473B4ADBC4CAE926FE8B4803E5B@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 05/29/15 12:18, Mike Snitzer wrote:
>> So I don't think it's necessary to extend dm_end_request() with 'mapped'
>> parameter.
> 
> I'm starting to question the need for 'must_be_mapped' param to
> free_rq_clone().  It was motivated by strange reports from Bart's
> testing but in reality I don't think it ever actually helped.
> 
> It was to act as a canary in the coal mine for the future but I'm now
> more inclined to just remove the parameter entirely.  Or do you think
> 'must_be_mapped' is still useful?

No. I think removing the parameter is good.

-- 
Jun'ichi Nomura, NEC Corporation
