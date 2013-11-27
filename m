From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] multipathd: Implement systemd watchdog
	integration
Date: Wed, 27 Nov 2013 08:05:12 +0100
Message-ID: <529599A8.1020407@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
	<1385466090-24290-7-git-send-email-hare@suse.de>
	<20131126184110.GO1661@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131126184110.GO1661@dhcp80-209.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 11/26/2013 07:41 PM, Benjamin Marzinski wrote:
> On Tue, Nov 26, 2013 at 12:41:27PM +0100, Hannes Reinecke wrote:
>> In the past there have been several instances where multipathd
>> would hang with the checkerloop as some path checker might not
>> be able to return in time.
>> This patch now activates the watchdog feature from systemd
>> to shutdown (and possibly restart) multipathd in these
>> situations.
>> Due to a bug in systemd watchdog integration only works
>> correctly with later version (> 206), so watchdog integration
>> has been disabled per default on earlier implementations.
> =

> I'm still not sure what having multipath restarted gets us.  Is the hope
> that on restart, multipath will simply be unable to access the path, and
> it will fail there quicker that the checker would?  Otherwise, the
> checker will likely get stuck in the same place on the restart. Also,
> the checker can get stuck in uninterruptible sleep.  In this case,
> systemd isn't going to be able to to restart multipathd until the issue
> has already cleared up.
> =

Most cases I've come across where the checkerloop was hanging it was
_not_ due to an uninterruptible sleep, but rather a bug in some odd
cornercase. So there it definitely would make sense.

And if you don't like the 'restart' behaviour you can easily switch
it off by just editing the service file.

In general the watchdog integration (with or without restart) is
a _very_ useful thing, as multipathd hanging is a pain to debug
on a customer site. If systemd notifies this debugging becomes
_way_ easier.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
