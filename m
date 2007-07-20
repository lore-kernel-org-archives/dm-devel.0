From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools causes path to come back as	different
	block device
Date: Fri, 20 Jul 2007 16:40:11 +0200
Message-ID: <46A0C94B.4010905@suse.de>
References: <469FEBBB.5040507@csupomona.edu> <46A0631F.4030404@suse.de>
	<20070720115315.GA26421@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070720115315.GA26421@bogon.ms20.nix>
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

Guido Guenther wrote:
> Hi Hannes,
> On Fri, Jul 20, 2007 at 09:24:15AM +0200, Hannes Reinecke wrote:
>> Hmm. multipathd really should react to the 'remove' events for sdX.
>> Checking ...
>>
>> Looks as if it does. And it even is supposed to stop the path checker.
>>
>> Care to run multipathd with full debugging (ie -v 4) and post the outp=
ut?
>> My guess is that somehow the path checker is not stopped and the fd is=
 kept
>> open, so that the device is not released properly.
> This even happens with no multipathd running on a Clariion with qla2xx.
> So multipathd can't be at fault here, can it? Also with multipathd
> running the device nodes in /dev/ and the sysfs nodes in /sys/block get
> removed properly (at least it looks like to me). Any hints where else t=
o
> start digging?
Removing from /dev and /sys in not sufficient, sadly.
The memory is only released after the last reference has gone.
So all fd's have to be closed (ie multipathd and the path checkers have
to have this path disabled) and no device-mapper table must reference it.

So easiest way is infact to have multipathd run with -v 4, as this will
tell you exactly if multipathd has stopped the path checker.
The device-mapper tables can be checked manually with dmsetup.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
