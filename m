From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-band: The I/O bandwidth controller:
	Overview
Date: Thu, 24 Jan 2008 02:25:15 +0900 (JST)
Message-ID: <20080124.022515.226770887.ryov@valinux.co.jp>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<1201098755.6341.54.camel@lappy>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <1201098755.6341.54.camel@lappy>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: a.p.zijlstra@chello.nl
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hi Peter,

> What definition of bandwidth does it use? Does it for example account
> for seek latency?

The bandwidth in dm-band is determined by the proportion of the
processing time of each device's tokens(I/Os) to the processing time
of all device's tokens(I/Os).
The processing time of one token(I/O) is determined by one I/O cycle 
include seek latency, interrupt latency, etc...

Thanks,
Ryo Tsuruta <ryov@valinux.co.jp>
