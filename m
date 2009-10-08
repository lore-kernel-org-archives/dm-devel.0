From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO controller V10
Date: Thu, 08 Oct 2009 19:22:42 +0900 (JST)
Message-ID: <20091008.192242.39182274.ryov@valinux.co.jp>
References: <20091006112201.GA27866@redhat.com>
	<20091007.233805.183040347.ryov@valinux.co.jp>
	<4ACCC4B7.4050805@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ACCC4B7.4050805@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: riel@redhat.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, vgoyal@redhat.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, m-ikeda@ds.jp.nec.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi Rik,

Rik van Riel <riel@redhat.com> wrote:
> Ryo Tsuruta wrote:
> 
> > If once dm-ioband is integrated into the LVM tools and bandwidth can
> > be assigned per device by lvcreate, the use of dm-tools is no longer
> > required for users.
> 
> A lot of large data center users have a SAN, with volume management
> handled SAN-side and dedicated LUNs for different applications or
> groups of applications.
> 
> Because of alignment issues, they typically use filesystems directly
> on top of the LUNs, without partitions or LVM layers.  We cannot rely
> on LVM for these systems, because people prefer not to use that.

Thank you for your explanation. So I have a plan to reimplement
dm-ioband into the block layer to make dm-tools no longer required.
My opinion I wrote above assumes if dm-ioband is used for a logical
volume which consists of multiple physical devices. If dm-ioband is
integrated into the LVM tools, then the use of the dm-tools is not
required and the underlying physical devices can be automatically
deteced and configured to use dm-ioband.

Thanks,
Ryo Tsuruta

> Besides ... isn't the goal of the cgroups io bandwidth controller
> to control the IO used by PROCESSES?
>
> If we want to control processes, why would we want the configuration
> to be applied to any other kind of object in the system?
