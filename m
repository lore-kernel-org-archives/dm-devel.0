From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: directio path-checker for multipath-tools
Date: Thu, 09 Feb 2006 23:31:47 +0100
Message-ID: <1139524307.2915.38.camel@zezette>
References: <42FB6447.8000105@suse.de>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42FB6447.8000105@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On jeu, 2005-08-11 at 16:44 +0200, Hannes Reinecke wrote:
> Hi Christophe,
> 
> I've implemented yet another path checker, based on O_DIRECT.
> Rationale: On S/390 it's possible to activate multipath support for DASD
> devices (called Parallel Access Volume (PAV)). As these are no SCSI
> devices the readsector0 path checker wouldn't work.
> And as this checker is quite generic it'll work for just about anybody.
> 
There seem to be cases where this checker can "hang forever" on failing
paths, and thus block the whole daemon. If I understand correctly the
open() manual, O_DIRECT reads by-design block until the data is sent
back.

If there is a trick to unblock the checker I'd like to learn it, because
as-is this checker is really more dangerous than useful :/

I hit this problem easily by bringing down the network interface
supporting the iSCSI trafic to an sfnet-IET target.

Regards,
cvaroqui

PS: I have to check if other checkers are not affected too. If I
remember we needed some SG infrastructure to let our checkers ask the
kernel to FAILFAST its requests ...
