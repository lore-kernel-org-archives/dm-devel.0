From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Multipath / iSCSI issues
Date: Sun, 24 Feb 2013 17:50:00 -0600
Message-ID: <512AA728.7040507@cs.wisc.edu>
References: <CAEctU6r9dnVnaMFgzO+8g0ktJ2VFTCaN47NiR5F4QH16_iX53g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEctU6r9dnVnaMFgzO+8g0ktJ2VFTCaN47NiR5F4QH16_iX53g@mail.gmail.com>
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
Cc: Devin <delldudedevin@gmail.com>
List-Id: dm-devel.ids

On 02/24/2013 01:15 PM, Devin wrote:
> 
> I am running Oracle Enterprise Linux 5.8 (which is really just Redhat).
> I am using Multipath and I have LUNS presented to me via iSCSI from a
> Hitachi SAN. I have the NICS bonded using the Linux bonding driver and
> using Active-Backup mode. I notice that when I loose a switch or
> connection to one of the switches that multipath freezes for at least 60
> seconds before it starts to respond again. Also it appears that IO being
> generated freezes until multipath responds again, this pause up to 60
> seconds is causing my Oracle instances to crash.
> 
> I have not been able to easily find what settings i could possibly
> change to make it fail to a new path faster. It almost seems like it's
> taking multipath a bit to fail all IO to a new path that is working.
> 
> Is there any information that might be useful for me that I can check on
> either the multipath side or the iSCSI side to see what is causing the
> issue???
> 

What iscsi driver are you using? If you are using software iscsi that
comes with OEL 5.8 what are our node.session.timeo.replacement_timeout,
.timeo.noop_out_timeout and .timeo.noop_out_interval. And what is your
scsi command timeout. You can see that by doing:

cat /sys/block/sdX/device/timeout
