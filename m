From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: multipath: Path checks on open-iscsi software
	initiators
Date: Mon, 8 Feb 2010 23:45:35 -0500
Message-ID: <170fa0d21002082045t5ea45011x25c98fd808758e8@mail.gmail.com>
References: <1265678289.2221.162.camel@agari.van.xensource.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1265678289.2221.162.camel@agari.van.xensource.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Mon, Feb 8, 2010 at 8:18 PM, Daniel Stodden
<daniel.stodden@citrix.com> wrote:
>
> Hi.
>
> I've recently been spending some time tracing path checks on iSCSI
> targets.
>
> Samples described here were taken with the directio checker on a netapp
> lun, but I believe the target kind doesn't matter here, since most of
> what I find is rather driven by the initiator side.
>
> So what I see is:
>
> 1. The directio checker issues its aio read on sector0.
>
> 2. The request obviously will block until iscsi is giving up on it.
> =A0This typically happens not before target pings (noop-out ops)
> =A0issued internally by the initiator time out. Look like:
>
> =A0iscsid: Nop-out timedout after 15 seconds on connection 1:0
> =A0state (3). Dropping session.
>
> =A0(period and timeouts depend on the configuration at hand).
>
> 3. Session failure still won't unblock the read. This is because the
> =A0iscsi session will enter recovery mode, to avoid failing the
> =A0data path right away. The device will enter blocked state during
> =A0that period.
>
> =A0Since I'm provoking a complete failure, this will time out as well,
> =A0but only later:
>
> =A0iscsi: session recovery timed out after 15 secs
>
> =A0(again, timeouts are iscsid.conf-dependent)
>
> 4. This will finally unblock the directio check with EIO,
> =A0 triggering the path failure.
>
>
> My main issue is that a device sitting on a software iscsi initiator
>
> =A0a) performs its own path failure detection and
> =A0b) defers data path operations to mask failures,
> =A0 =A0which obviously counteracts a checker based on
> =A0 =A0data path operations.
>
> Kernels somewhere during the 2.6.2x series apparently started to move
> part of the session checks into the kernel (apparently including the
> noop-out itself, but I don't). One side effect of that is that session
> state can be queried via sysfs.
>
> So right now I'm mainly wondering if a multipath failure driven rather
> by polling session state that a data read wouldn't be more effective?
>
> I've only been browsing part of the iscsi code by now, but I don't see
> how data path failures wouldn't relate to session state.
>
> There's some code attached below to demonstrate that. It presently jumps
> through some extra loops to reverse-map fd back to the block device
> node, but the basic thing was relatively straightforward to implement.
>
> Thanks in advance for about any input on that matter.
>
> Cheers,
> Daniel
>

You might look at the multipath-tools patch included in a fairly
recent dm-devel mail titled "[PATCH] Update path_offline() to return
device status"

The committed patch is available here:
http://git.kernel.org/gitweb.cgi?p=3Dlinux/storage/multipath-tools/.git;a=
=3Dcommit;h=3D88c75172cf56e
