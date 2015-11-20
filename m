From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Adding new resiliency type to LVM
Date: Fri, 20 Nov 2015 13:17:04 +0000
Message-ID: <20151120131704.GC903@agk-dp.fab.redhat.com>
References: <CAPLK-i8-Agg+LOjw5w5G9epu1yGyUaGeY1Jv1rGV9Zp3rpXjDw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAPLK-i8-Agg+LOjw5w5G9epu1yGyUaGeY1Jv1rGV9Zp3rpXjDw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Nov 19, 2015 at 04:25:44PM -0500, Shehbaz Jaffer wrote:
> ln -s /dev/dm-0 /dev/mapper/vol_vg-root
 
Lots of pieces of code are involved - if you are using udev, then udev rules
are responsibly for managing it.

For debugging, check you have 'activation/verify_udev_operations' set to 1 in
lvm.conf.

Alasdair
