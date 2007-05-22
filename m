From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Re: [PATCH 0/21] SUSE multipath-tools resync
Date: Tue, 22 May 2007 10:23:05 +0200
Message-ID: <OF7DF0ABB0.C2D5CD4F-ONC12572E3.002D91F4-C12572E3.002DFE0C@de.ibm.com>
References: <1179786427.10963.60.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1179786427.10963.60.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, dm-devel-bounces@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

> - directio checker async mode
> Interesting stuff.
> 1) Do we need the libaio.h copy ?
>
Not really. Just need some interface definitions.

> 2) Have you put some thought to SG_IO async mode feasability ?
>
That is not really an option if you have non-SCSI devices. ;-)

> 3) Shouldn't we also timeout the execv() for path prios and ids to avoid
> blocking the daemon.
>
Could be worth a thought. But maybe these are not that critical.
At least as long as you don't require these calls to re-activate
any failed paths...

Regards,
Stefan
