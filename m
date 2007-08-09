From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: [PATCH] Fixup kpartx rules for dmraid
Date: Thu, 9 Aug 2007 13:36:33 +0200
Message-ID: <20070809113633.GA12768@bogon.ms20.nix>
References: <46B70473.2030406@suse.de> <20070806184554.GA4415@bogon.ms20.nix>
	<46B80BF7.1010904@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B80BF7.1010904@suse.de>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Tue, Aug 07, 2007 at 08:06:47AM +0200, Hannes Reinecke wrote:
> Guido Guenther wrote:
> > On Mon, Aug 06, 2007 at 01:22:27PM +0200, Hannes Reinecke wrote:
> >> -ENV{DM_UUID}=="?*", IMPORT{program}=="/lib/udev/kpartx_id %M %m $env{DM_UUID}"
> >> +ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
> > /lib/udev/kpartx_id isn't in $PATH. This patch breaks the udev rule.
> 
> And /lib/udev is the standard path prefix since udev-0.89.
Ahh...right, IMPORT prefixes with /lib/udev, didn't know that, but it's
actually in the changelog. Sorry.
 -- Guido
