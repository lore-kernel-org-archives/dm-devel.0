From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Simulating faulty disk
Date: Fri, 21 Oct 2011 16:21:23 +0100
Message-ID: <4EA18DF3.3000800@redhat.com>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com>
	<4EA04201.1050702@cs.utah.edu> <4EA044A9.6070406@redhat.com>
	<4EA05072.10107@cs.utah.edu> <4EA05D0A.7030909@redhat.com>
	<4EA06020.9000708@cs.utah.edu> <4EA13A52.60902@redhat.com>
	<4EA18610.3050900@cs.utah.edu> <4EA1881B.5070607@redhat.com>
	<4EA188F3.4000206@cs.utah.edu> <4EA18C11.5060600@cs.utah.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EA18C11.5060600@cs.utah.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yathindra <ydev@cs.utah.edu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/21/2011 04:13 PM, Yathindra wrote:
>  >mount -t ext3 /dev/sdb /mnt
> Copied some data into /mnt
>  >dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay
> /dev/sdb 0 500"
> device-mapper: reload ioctl failed: Invalid argument
> Command failed

You can't create a mapped device on something while it is mounted as 
device-mapper needs to open it exclusively.

> But as seen from above, dmsetup is failing to create a flakey/delay
> device when /dev/sdb
> has a filesystem on top of it. Is there any workaround ?

Set up the file system the way you want it on sdb first. Then unmount it 
and create the device-mapper devices and mount that.

Regards,
Bryn.
