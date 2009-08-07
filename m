From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH] dm-ioband-v1.12.3: I/O bandwidth controller
Date: Fri, 07 Aug 2009 10:36:40 +0900 (JST)
Message-ID: <20090807.103640.104065157.ryov@valinux.co.jp>
References: <20090731.130333.104034609.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20090731.130333.104034609.ryov@valinux.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: agk@redhat.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hi Alasdair,

Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> Hi Alasdair,
> 
> This is dm-ioband v1.12.3 release that is a minor update to avoid
> sparse warnings other than related to the event tracing. (I used
> sparse-2009-07-29.)
> 
> This patch can be applied to the current dm-devel tree and 2.6.31-rc4,
> so could you please replace dm-add-ioband.patch in your tree with this?
> And I would appreciate it if you would let me know your thoughts about
> merging dm-ioband to upstream.

The dm-ioband patch in the dm-devel tree is still older. Could you
please update it with the new patch? And could you please let me know
your thoughts about dm-ioband?

Thanks,
Ryo Tsuruta
