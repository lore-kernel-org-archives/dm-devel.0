From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: add fast_io_fail and	dev_loss_tmo
	config parameters
Date: Tue, 3 Aug 2010 13:15:27 -0500
Message-ID: <20100803181527.GK25030@ether.msp.redhat.com>
References: <4C5297AA.4070708@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C5297AA.4070708@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Michael Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 30, 2010 at 06:13:14PM +0900, Jun'ichi Nomura wrote:
> Hi,
> 
> (03/23/10 11:44), Benjamin Marzinski wrote:
> > This patch adds two new configuration parameters to multipath.conf,
> > fast_io_fail_tmo and dev_loss_tmo which set
> > 
> > /sys/class/fc_remote_ports/rport-<host>:<channel>-<rport_id>/fast_io_fail_tmo and
> > /sys/class/fc_remote_ports/rport-<host>:<channel>-<rport_id>/dev_loss_tmo
> ...
> 
> This is nice feature but the code uses scsi_id instead of rport_id:
> 

Indeed it does. Sorry.

You patch looks fine to me.

-Ben
