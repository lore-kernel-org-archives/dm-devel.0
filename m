From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: queue_if_no_paths timeout handling
Date: Sun, 24 Jul 2005 22:17:13 +0200
Message-ID: <20050724201713.GK8005@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321AB67@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB67@SRMANNING.eng.emc.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On 2005-07-12T22:28:09, "goggin, edward" <egoggin@emc.com> wrote:

> May need to be able to at least offer the option of timing out ios to
> multipath block devices enabled with the queue_if_no_paths feature
> which are in an all-paths-down use case for a configurable amount of
> time.

Proposed solution part A: multipathd should disable queue_if_no_path
(via the message ioctl) if all paths are down for N seconds.

Proposed solution part B: Must figure out a way how to throttle higher
levels from throwing more IO at us when we're in that state. A regular
app will be throttled by the fact that no ACK's come back, I guess.

Proposed solution part C: In case of multipathd dieing, do we need a
last resort way for the kernel to disable queue if no path by itself so
memory can be reclaimed, which might be necessary for multipathd being
able to restart?


So, there is a more generic issue here involving the fact that dm-mpath
and multipathd are pretty tightly coupled, and we might not be able to
always behave "correctly" if user-space dies on us. (In fact, I can see
this affecting not just multipathd, but even some cluster
infrastructure.) So I have this really sick idea about this, which I'm
now going to share with you. Grab a bucket before reading on. But maybe
you won't find it that horrible.

Ready? Ok, I warned you.

Within user-space, what we do in the Linux-HA heartbeat project for some
of these critical tasks is that we run an application heartbeat to the
monitor process - if one fails to heartbeat for too long, we'll take
recovery action.

So, how about having critical user-space heartbeat to the kernel?

(There's prior art here in the software watchdog, but that's a much more
global hammer.)

Just having the kernel watch whether the process keeps running won't do.
We ought to be able to restart the user-space process, which might mean
it exits/restarts within some timeout.

It not actually all that difficult to implement. Simply setup a timer on
registration, set it back whenever user-space heartbeats (by writing to
a sysfs file would be more generic, but if we want to stay within dm for
a second, by sending us a heartbeat via the message ioctl), and if it
eventually triggers, kick a callback function provided at registration
with some data.

(Said callback function might, in our case, reset all paths to "healthy"
to give them a last chance, and disable queue_if_no_path - so that if
all paths fail again, IO would be errored out for good.)

On graceful shutdown, multipathd would either lengthen that timer (to
allow for a restart) or disable it completely (maybe along with
queue_if_no_path) so that the system can reboot gracefully.

Now how is that?

It seems somewhat hackish, but I quite like it ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
