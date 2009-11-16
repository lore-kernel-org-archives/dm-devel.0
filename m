From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] Add suspended state check for target
	messages
Date: Sun, 15 Nov 2009 23:43:33 -0800
Message-ID: <20091116074333.GB20475@linux.vnet.ibm.com>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>
	<4AFD3358.7000007@ct.jp.nec.com>
	<20091113141930.GA3185@agk-dp.fab.redhat.com>
	<4B00FE66.9020405@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B00FE66.9020405@ct.jp.nec.com>
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

Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi Alasdair,
> 
> On 11/13/2009 11:19 PM +0900, Alasdair G Kergon wrote:
> > Would DMF_BLOCK_IO_FOR_SUSPEND work instead?
> 
> Maybe.
> But we must remember that using the flag means that multipath can't
> use message during flushing I/Os, although I'm not sure how it hurts us.
> 
> If we'd like to keep the ability to use message during flushing I/Os,
> we should use another flag for this purpose and set it after
> dm_wait_for_completion().
> 

I just re-rolled / re-submitted a update series that use a multipath
internal flag for the suspended state plus a mutex. This would avoid a
extended meaning for DMF_BLOCK_IO_FOR_SUSPEND if we needed to avoid that
case.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
