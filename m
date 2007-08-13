From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix remap handling by blktrace
Date: Mon, 13 Aug 2007 14:16:09 +0200
Message-ID: <20070813121608.GR23758@kernel.dk>
References: <46B87357.8040802@hp.com> <20070807133252.GY5245@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070807133252.GY5245@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: dm-devel@redhat.com, btrace <linux-btrace@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Aug 07 2007, Jens Axboe wrote:
> On Tue, Aug 07 2007, Alan D. Brunelle wrote:
> > 
> 
> > 
> > This patch provides more information concerning REMAP operations on block
> > IOs. The additional information provides clearer details at the user level,
> > and supports post-processing analysis in btt.
> > 
> > o  Adds in partition remaps on the same device.
> > o  Fixed up the remap information in DM to be in the right order
> > o  Sent up mapped-from and mapped-to device information
> > 
> > Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> 
> Thanks (again) Alan, applied!

And it was merged over the weekend, better late than never :-)

-- 
Jens Axboe
