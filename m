From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Fri, 16 May 2008 11:53:21 -0700
Message-ID: <1210964001.21974.351.camel@chandra-ubuntu>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <482C0676.9070004@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Thu, 2008-05-15 at 11:46 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > What is the purpose of this feature ?
> > 
> > With dh_state functionality, one could associate a handler to a new
> > device and then if one does "multipath", the hardware handler would be
> > associated with the multipath device. What are we achieving by this ?
> > 
> This allows multipath to override the device tables build into
> the device handler. Reason here is that multipath has a configuration
> file which allows the user to override the build-in defaults.
> And this includes the hardware handler, so we need to make sure that
> the hardware handler is indeed attached.

Hardware handler's existence is currently been verified during parsing
(by doing a request_module() followed by scsi_dh_handler_exist() in
parse_hw_handler()).

Hardware handler module is attached to the device itself (thru
try_module_get() in attach), so, the module will exist as long as the
device exists.

Hence, there is no need to attach it again from the multipath layer.

Or, I am missing something totally :)

<snip>


