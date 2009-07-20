From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Emulate BLKRRPART on device-mapper
Date: Mon, 20 Jul 2009 19:23:24 +0100
Message-ID: <20090720182324.GD32330@agk-dp.fab.redhat.com>
References: <200907081414.50698.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200907081414.50698.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 08, 2009 at 02:14:50PM +0530, Nikanth Karthikesan wrote:
> From: Hannes Reinecke <hare@suse.de>
> Subject: Emulate BLKRRPART on device-mapper
> 
> Partitions on device-mapper devices are managed by kpartx (if at
> all). So if we were just to send out a 'change' event if someone
> called BLKRRPART on these devices, kpartx will be triggered via udev
> and can manage the partitions accordingly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
 
Please could I have a 'Tested-by' for this one?

I agree with the idea, but I need some evidence that this specific patch
works correctly.  (The block layer is supposed to handle that class
of ioctls itself and I didn't think dm saw them.)

Alasdair
