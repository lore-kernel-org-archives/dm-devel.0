From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] Add suspended state check for target
	messages
Date: Fri, 13 Nov 2009 10:47:06 -0800
Message-ID: <20091113184706.GA8768@linux.vnet.ibm.com>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>
	<4AFD3358.7000007@ct.jp.nec.com>
	<20091113141930.GA3185@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Alasdair G Kergon <agk@redhat.com> wrote:
> Would DMF_BLOCK_IO_FOR_SUSPEND work instead?
> 

DMF_BLOCK_IO_FOR_SUSPEND appears to be a better choice, but since other
targets like dm-raid already have a internal suspend bit being used
unclear on the value of creating a generic accessor vs. just adding a
suspend atomic to the multipath target.

To close another window I believe we need a form of synchronization to
ensure a current multipath_message has completed prior to
multipath_postsuspend calling flush_multipath_work. Later
multipath_message calls would return without adding work if a bit check
indicated that we where suspended.

I will redo the patch(s) and resubmit.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
