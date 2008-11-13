From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 1/8] dm-ioband: Introduction
Date: Thu, 13 Nov 2008 14:36:43 -0500
Message-ID: <491C81CB.7010705@cfl.rr.com>
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp>
	<20081113.121146.623571555980959797.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081113.121146.623571555980959797.ryov@valinux.co.jp>
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
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Ryo Tsuruta wrote:
> Create two ioband devices "ioband1" and "ioband2". "ioband1" is mapped
> to "/dev/sda1" and has a weight of 40. "ioband2" is mapped to "/dev/sda2"
> and has a weight of 10. "ioband1" can use 80% --- 40/(40+10)*100 ---
> of the bandwidth of the physical disk "/dev/sda" while "ioband2" can use 20%.

Just to clarify, when you say ioband1 can use 80% of the bandwidh, you 
mean that is how much it will get if both io bands are loaded right?  If 
there is no activity on ioband2, then ioband1 will get the full disk 
bandwidth right?
