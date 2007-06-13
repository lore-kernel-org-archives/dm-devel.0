From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: 4k block LUN problem
Date: Wed, 13 Jun 2007 20:55:50 +0100
Message-ID: <20070613195550.GI18457@agk.fab.redhat.com>
References: <20070613193433.GG18457@agk.fab.redhat.com>
	<3DB43EBAF77555449D828440C12F8E7E034406FD@usbmaxms02.am.sony.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3DB43EBAF77555449D828440C12F8E7E034406FD@usbmaxms02.am.sony.com>
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

On Wed, Jun 13, 2007 at 03:47:15PM -0400, Vassar, Bob wrote:
> I didn't partition the dm device. I used fdisk to create the sda[1]
> partition on the lun. The dm device is then created on sda[1]. I then
> simply mkfs on the dm partition.  
 
If the lun appears as sda, then multipath will present it to you as
a dm multipath device.  Never run anything on /dev/sda - always use
the /dev/mpath one instead.

Then you should do the pvcreate against the /dev/mpath device etc.

Alasdair
-- 
agk@redhat.com
