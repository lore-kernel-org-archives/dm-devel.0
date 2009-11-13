From: malahal@us.ibm.com
Subject: Re: [PATCH 0/2] Add suspended state check for target
	messages
Date: Fri, 13 Nov 2009 10:30:47 -0800
Message-ID: <20091113183047.GA19866@us.ibm.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon [agk@redhat.com] wrote:
> Would DMF_BLOCK_IO_FOR_SUSPEND work instead?

Should, provided that multipath_message() and multipath_postsuspend()
use some lock to synchronize. Without the lock, multipath_postsuspend()
could be executed between multipath_message's bit flag check and
its action().

multipath_message()
{
	lock();
	if (DMF_BLOCK_IO_FOR_SUSPEND is set) {
		unlock and fail;
	} else { /* postsuspend has not been executed yet and won't be
	completed until we are done here */
		action();
	}
	unlock();
}

multipath_postsuspend()
{
	lock();
	flush work();
	unlock();
}
