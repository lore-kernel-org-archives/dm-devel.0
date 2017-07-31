From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] libmultipath: update 3PARdata builtin config
Date: Mon, 31 Jul 2017 13:37:42 +0200
Message-ID: <9df9cda5-3353-b07d-d84b-3b2b5cbcce40@gmail.com>
References: <1498503799-24026-1-git-send-email-bmarzins@redhat.com>
	<5d7143cd-4964-93ca-1e71-0119eb2a8ea1@gmail.com>
	<20170629145731.GR2940@octiron.msp.redhat.com>
	<e1f2c3d3-77d1-bb86-c212-b65719815065@gmail.com>
	<20170728223713.GI2940@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170728223713.GI2940@octiron.msp.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/29/2017 12:37 AM, Benjamin Marzinski wrote:

> Here I what I got from HP:
> 
> We will be changing the recommendation in the next version of the 3PAR
> Implementation Guide. I am the owner for these guides. 
> 
> The reason we want the  dev_loss_tmo "infinity"  is to help in a feature
> called Peer Persistence where on primary array power fails and the
> device on the remote array (standby array) becomes active. The standby
> state of the device paths will automatically change to active state if
> the underlying device instances exist so we need infinity setting.
> 
> The fast_io_fail_tmo we want to be bumped from 5 to 10 so that it allows
> a array feature called persistent port to work well where we want the
> want the array path going away failure transient state to be held for
> the longer time in the SCSI and FC OS layers (I/O retry) without
> multipath reacting to it which allows the array to move the physical
> port flogi instance on the switch to move to partner physical port as an
> NPIV Port when the array node goes down.  Complete details in this PDF  
> 
> https://www.hpe.com/h20195/v2/GetPDF.aspx/4AA4-4545ENW.pdf

Fine, I will send a v2 PATCH with that text. Christophe, drop this one.
