From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Mon, 13 Apr 2009 10:46:26 -0400
Message-ID: <20090413144626.GF18007@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090413.130552.226792299.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <vivek.goyal2008@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> Hi Alasdair and all,
> 
> I did more tests on dm-ioband and I've posted the test items and
> results on my website. The results are very good.
> http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> 

Hi Ryo,

I quickly looked at the xls sheet. Most of the test cases seem to be
direct IO. Have you done testing with buffered writes/async writes and
been able to provide service differentiation between cgroups?

For example, two "dd" threads running in two cgroups doing writes.

Thanks
Vivek
