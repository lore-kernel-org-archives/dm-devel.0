From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipath-tools] multipath -ll and offline devices
Date: Mon, 26 Sep 2005 11:30:23 +0200
Message-ID: <20050926093023.GE27319@free.fr>
References: <20050926075803.GD27319@free.fr>
	<OF0C2F4897.5FD0B0FC-ONC1257088.0031BFAC-C1257088.003203CE@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF0C2F4897.5FD0B0FC-ONC1257088.0031BFAC-C1257088.003203CE@de.ibm.com>
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

On Mon, Sep 26, 2005 at 11:08:05AM +0200, Stefan Bader wrote:
> Hi Christophe,
> 
> looks good. After setting a device offline it is reported as failed by 
> 'multipath -ll'.
> Just calling 'multipath' will remove the offline device which makes sense. 
> The path
> can be re-established by calling multipath again after returning the 
> device to online
> state.
> 
Good, I'm uploading another fix :

When the daemon runs while test your scenario you'll notice multipath won't load the map because it get a wwid 
for the path from the daemon cache, which causes multipath to try to load a map *with* the faulty path ... which 
fails in the kernel DM subsystem.

Fix is memseting pp->wwid in discovery.c:pathinfo() error path.

Regards,
cvaroqui
