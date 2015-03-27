From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 77/78] multipathd: asynchronous configuration
Date: Fri, 27 Mar 2015 09:09:35 +0100
Message-ID: <5515103F.8020903@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-78-git-send-email-hare@suse.de>
	<20150327055820.GW29132@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150327055820.GW29132@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/27/2015 06:58 AM, Benjamin Marzinski wrote:
> On Mon, Mar 16, 2015 at 01:37:04PM +0100, Hannes Reinecke wrote:
>> For initial configuration multipathd waits it has synchronized
>> with the existing setup. On larger systems this takes up quite
>> some time (I've measured 80 seconds on a system with 1024 paths)
>> causing systemd to stall and the system to fail booting.
>> This patch makes the initial configuration asynchronous, and
>> using the same codepath as the existing 'reconfigure' CLI
>> command.
> =

> If the issue is that configure takes too long, and is keeping multipath
> from resetting the watchdog timer, can't this problem still happen?
> =

> reconfigure still is called under the vecs lock, and checkerloop still
> locks the vecs lock, so a call to reconfigure can still stall the
> checker loop for just as long.
> =

> Or am I missing something?

The problem here is that on large configurations multipathd might
spend too much time in configure(), so the sd_notify() call with
'RUNNING' is would be later than the default systemd service timeout.
Hence multipathd will be killed by systemd with a job timeout, with
no chance to get it to run, ever.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
