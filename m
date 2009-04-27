From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: dm-ioband: Test results.
Date: Mon, 27 Apr 2009 19:30:06 +0900 (JST)
Message-ID: <20090427.193006.112614137.ryov@valinux.co.jp>
References: <20090421141607.GA22619@redhat.com>
	<20090422.121443.104042516.ryov@valinux.co.jp>
	<20090422151805.GC32602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090422151805.GC32602@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com
Cc: fernando@oss.ntt.co.jp, dm-devel@redhat.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, agk@redhat.com, jens.axboe@oracle.com, nauman@google.com, vgoyal@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Mike,

> Why is it that you repeatedly ignore concern/discussion about your
> determination to continue using a custom grouping mechanism?  It is this
> type of excess layering that serves no purpose other than to facilitate
> out-of-tree use-cases.  dm-ioband would take a big step closer to being
> merged upstream if you took others' feedback and showed more willingness
> to work through the outstanding issues.

I think dm-ioband's approach is one simple way to handle cgroup
because the current cgroup has no way to manage kernel module's
resources. Please tell me if you have any good ideas to handle 
cgroup by dm-ioband.

Thanks,
Ryo Tsuruta
