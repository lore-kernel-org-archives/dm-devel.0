From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: multipath-tools causes path to come back as
	different block device
Date: Fri, 20 Jul 2007 12:10:29 +0200
Message-ID: <20070720101028.GA12738@bogon.ms20.nix>
References: <469FEBBB.5040507@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <469FEBBB.5040507@csupomona.edu>
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

Hi Brian,
On Thu, Jul 19, 2007 at 03:54:51PM -0700, Brian De Wolf wrote:
> I've been testing multipath-tool's rdac capability with a qla2xxx HBA and an IBM
> DS4800 some more and I've hit another stumbling block.  When I test unplugging
> one of the HBA ports and plugging it back in with multipath running, it seems to
> cause bad things to happen.  Here is what the syslog looks like (note:  sdb is a
> path, sdd is initially unused, and sde is the second path):
I'm seeing the same and send a report to Christophe about this just
yesterday, it doesn't seem to be a driver issue since iSCSI is affected
as well.
Cheers,
 -- Guido
