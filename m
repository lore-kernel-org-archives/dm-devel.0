From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] libmultipath: hwhandler auto-detection
	for ALUA
Date: Wed, 4 Apr 2018 08:38:35 +0200
Message-ID: <20180404083835.213875f1@pentland.suse.de>
References: <20180327215053.3631-1-mwilck@suse.com>
	<20180327215053.3631-2-mwilck@suse.com>
	<20180403203132.GF3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180403203132.GF3103@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Tue, 3 Apr 2018 15:31:32 -0500
"Benjamin Marzinski" <bmarzins@redhat.com> wrote:

> On Tue, Mar 27, 2018 at 11:50:52PM +0200, Martin Wilck wrote:
> > If the hardware handler isn't explicitly set, infer ALUA support
> > from the pp->tpgs attribute. Likewise, if ALUA is selected, but
> > not supported by the hardware, fall back to no hardware handler.  
> 
> Weren't you worried before about temporary ALUA failures? If you had a
> temporary failure while configuring a device that you explicitly set
> to be ALUA, then this would cause the device to be misconfigured? If
> the hardware handler isn't set, inferring ALUA is fine. But what is
> the case where we want to say that a device that is explicitly set to
> ALUA shouldn't actually be ALUA?  It seem like if there is some
> uncertaintly, we should just not set the hardware handler, and allow
> multipath to infer it via the pp->tpgs value.
> 
> I'm not strongly against this patch. I just don't see the value in
> overriding an explicit configuration, if we believe that temporary
> failures are possible.
> 
We _do_ have an definitive guide, namely the TGPS bit.
If that isn't set it's pretty much pointless to try alua, regardless
what the configuration says.
If it's set but ALUA configuration fails we do have an error.
If it's not set and ALUA configuration fails then it's 'just' a
misconfiguration.

Which is precisely what bit us with the IPR controller; all devices
appear as 'IPR', but only for some configuration the TPGS bit is
set.

And as the hardware handler was set to 'ALUA' the hardware handler
always tried to attach, but failed for those devices which did not
support ALUA.

_And_ as we don't have a distinction between 'configuration error' and
'hardware failure' these devices failed to setup, and booting would
stop.

So this patch is just how to handle devices which are configured to use
the ALUA hardware handler, but which do not have the TPGS bit set.
For these devices attaching ALUA _will_ fail, but that's _actually_
expected, as the devices never claimed to support alua.

Hence I'm perfectly fine with this patch.

Cheers,

Hannes
