From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: multipath-tools causes path to come back as
	different block device
Date: Fri, 20 Jul 2007 13:53:16 +0200
Message-ID: <20070720115315.GA26421@bogon.ms20.nix>
References: <469FEBBB.5040507@csupomona.edu> <46A0631F.4030404@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46A0631F.4030404@suse.de>
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

Hi Hannes,
On Fri, Jul 20, 2007 at 09:24:15AM +0200, Hannes Reinecke wrote:
> Hmm. multipathd really should react to the 'remove' events for sdX.
> Checking ...
> 
> Looks as if it does. And it even is supposed to stop the path checker.
> 
> Care to run multipathd with full debugging (ie -v 4) and post the output?
> My guess is that somehow the path checker is not stopped and the fd is kept
> open, so that the device is not released properly.
This even happens with no multipathd running on a Clariion with qla2xx.
So multipathd can't be at fault here, can it? Also with multipathd
running the device nodes in /dev/ and the sysfs nodes in /sys/block get
removed properly (at least it looks like to me). Any hints where else to
start digging?
Cheers,
 -- Guido
