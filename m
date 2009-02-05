From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Patchwork and patch flow
Date: Thu, 05 Feb 2009 20:45:08 +0900 (JST)
Message-ID: <20090205.204508.71105166.ryov@valinux.co.jp>
References: <20090107025952.GH3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090107025952.GH3512@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

> I'd also like to see more people visibly reviewing and testing patches.
> Please respond in the mailing list threads with comments and Reviewed-by: or
> Tested-by: lines as appropriate.  If you've only reviewed part of the patch
> or only tested a subset of the cases you think need testing, explain in the 
> thread but don't add those lines.  Only offer a Reviewed-by line if you have
> performed a complete line-by-line review of the patch and patch header and
> you support its inclusion in the tree.

To add a Tested-by tag, how much test do we actually need?
We've already done several tests of dm-ioband:
  Proportional I/O bandwidth controlling
  Loading/unloading driver and changing settings while under I/O load
  Bounds checking of setting parameters
  Benchmarks
Do you think these are enough for adding the tag?
It's very difficult for me to determine whether it's qualified or not.
It would be helpful if you could give me some advice.

Thanks,
Ryo Tsuruta
