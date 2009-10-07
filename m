From: Rik van Riel <riel@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Wed, 07 Oct 2009 12:41:27 -0400
Message-ID: <4ACCC4B7.4050805@redhat.com>
References: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>	<20091006.161744.189719641.ryov@valinux.co.jp>	<20091006112201.GA27866@redhat.com>
	<20091007.233805.183040347.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091007.233805.183040347.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, vgoyal@redhat.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, m-ikeda@ds.jp.nec.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Ryo Tsuruta wrote:

> If once dm-ioband is integrated into the LVM tools and bandwidth can
> be assigned per device by lvcreate, the use of dm-tools is no longer
> required for users.

A lot of large data center users have a SAN, with volume management
handled SAN-side and dedicated LUNs for different applications or
groups of applications.

Because of alignment issues, they typically use filesystems directly
on top of the LUNs, without partitions or LVM layers.  We cannot rely
on LVM for these systems, because people prefer not to use that.

Besides ... isn't the goal of the cgroups io bandwidth controller
to control the IO used by PROCESSES?

If we want to control processes, why would we want the configuration
to be applied to any other kind of object in the system?

-- 
All rights reversed.
