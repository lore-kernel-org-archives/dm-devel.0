From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Does dm avoid container/member loops?
Date: Thu, 5 Oct 2006 14:40:50 +0100
Message-ID: <20061005134050.GI17654@agk.surrey.redhat.com>
References: <17700.39744.188262.731633@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17700.39744.188262.731633@cse.unsw.edu.au>
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

On Thu, Oct 05, 2006 at 03:42:24PM +1000, Neil Brown wrote:
>  As both dm and md  create a block device using other block
>  devices as components, and as components can be added after creation,
>  it is theoretically possible to create a loop.

Userspace LVM2 code takes steps to catch the most likely cases:
  exclusive open is required to create a PV;
  device-mapper dependencies are checked for loops when adding a PV to a VG.

The general problem is harder as you also have to track through filesystems
(losetup) etc.

>  This would probably give lockdep a major headache, but should detect
>  loops reliably, including loops involving both md and dm.

I reckon the solution involves bd_claim* preventing loops in the device
dependency tree.

Alasdair
-- 
agk@redhat.com
