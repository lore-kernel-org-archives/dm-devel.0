From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/2] Add suspended state check for
	target	messages
Date: Mon, 16 Nov 2009 16:25:26 +0900
Message-ID: <4B00FE66.9020405@ct.jp.nec.com>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>	<4AFD3358.7000007@ct.jp.nec.com>
	<20091113141930.GA3185@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091113141930.GA3185@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

On 11/13/2009 11:19 PM +0900, Alasdair G Kergon wrote:
> Would DMF_BLOCK_IO_FOR_SUSPEND work instead?

Maybe.
But we must remember that using the flag means that multipath can't
use message during flushing I/Os, although I'm not sure how it hurts us.

If we'd like to keep the ability to use message during flushing I/Os,
we should use another flag for this purpose and set it after
dm_wait_for_completion().

Thanks,
Kiyoshi Ueda
