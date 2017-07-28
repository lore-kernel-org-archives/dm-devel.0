From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: update 3PARdata builtin config
Date: Fri, 28 Jul 2017 17:37:13 -0500
Message-ID: <20170728223713.GI2940@octiron.msp.redhat.com>
References: <1498503799-24026-1-git-send-email-bmarzins@redhat.com>
	<5d7143cd-4964-93ca-1e71-0119eb2a8ea1@gmail.com>
	<20170629145731.GR2940@octiron.msp.redhat.com>
	<e1f2c3d3-77d1-bb86-c212-b65719815065@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e1f2c3d3-77d1-bb86-c212-b65719815065@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 13, 2017 at 08:25:30PM +0200, Xose Vazquez Perez wrote:
> On 06/29/2017 04:57 PM, Benjamin Marzinski wrote:
> 
> >>> +		.fast_io_fail  = 10,
> >>> +		.dev_loss      = MAX_DEV_LOSS_TMO,
> 
> > On Wed, Jun 28, 2017 at 07:48:38PM +0200, Xose Vazquez Perez wrote:
> >
> >> It would be nice to have more information.
> >> Why and when is this needed?
> > 
> > I assume the change to dev_loss_tmo is simply a preference issue. Like
> > Netapp, they don't want their devices to get auto-removed when they go
> > down. I also assume that in their internal testing, they hit cases where
> > 5 seconds wasn't enough time to wait for some transient issue with the
> > array to resolve.  At any rate, I'm simply passing along their request,
> > which seems like a perfectly reasonable one to me.
> 
> Those arguments should come from the vendor.
> 
> "dev_loss_tmo 14" is recommended(???) in latest 3PAR docs (Jun 2017):
> 
> - HPE 3PAR SUSE Linux Enterprise Implementation Guide (Wed 14 Jun 2017 11:48:14 PM CEST)
>    http://h20564.www2.hpe.com/portal/site/hpsc/public/kb/docDisplay/?docId=c02663748
> 
> - HPE 3PAR Red Hat Enterprise Linux and Oracle Linux Implementation Guide (Wed 14 Jun 2017 12:10:06 AM CEST)
>    http://h20564.www2.hpe.com/portal/site/hpsc/public/kb/docDisplay/?docId=c04448818

Here I what I got from HP:

********

We will be changing the recommendation in the next version of the 3PAR
Implementation Guide. I am the owner for these guides. 

The reason we want the  dev_loss_tmo "infinity"  is to help in a feature
called Peer Persistence where on primary array power fails and the
device on the remote array (standby array) becomes active. The standby
state of the device paths will automatically change to active state if
the underlying device instances exist so we need infinity setting.

The fast_io_fail_tmo we want to be bumped from 5 to 10 so that it allows
a array feature called persistent port to work well where we want the
want the array path going away failure transient state to be held for
the longer time in the SCSI and FC OS layers (I/O retry) without
multipath reacting to it which allows the array to move the physical
port flogi instance on the switch to move to partner physical port as an
NPIV Port when the array node goes down.  Complete details in this PDF  

https://www.hpe.com/h20195/v2/GetPDF.aspx/4AA4-4545ENW.pdf

*******

-Ben
