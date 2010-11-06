From: Lars Marowsky-Bree <lmb@novell.com>
Subject: Re: RFC: multipath IO multiplex
Date: Sat, 6 Nov 2010 17:57:43 +0100
Message-ID: <20101106165743.GE30809@suse.de>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101106115102.GF10171@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2010-11-06T11:51:02, Alasdair G Kergon <agk@redhat.com> wrote:

Hi Neil, Alasdair,

thanks for the feedback. Answering your points in reverse order -

> >  Might it make sense to configure a range of the device where writes al=
ways
> >  went down all paths?  That would seem to fit with your problem descrip=
tion
> >  and might be easiest??
> Indeed - a persistent property of the device (even another interface with=
 a
> different minor number) not the I/O.

I'm not so sure that would be required though. The equivalent of our
"mkfs" tool wouldn't need this. Also, typically, this would be a
partition (kpartx) on top of a regular MPIO mapping (that we want to be
managed by multipathd).

Handling this completely differently would complicate setup, no?

> And what is the nature of the data being written, given that I/O to one p=
ath
> might get delayed and arrive long after it was sent, overwriting data
> sent later.  Successful stale writes will always be recognised as such
> by readers - how?

The very particular use case I am thinking of is the "poison pill" for
node-level fencing. Nodes constantly monitor their slot (using direct
IO, bypassing all caching, etc), and either can successfully read it or
commit suicide (assisted by a hardware watchdog to protect against
stalls).

The writer knows that, once the message has been successfully written,
the target node will either have read it (and committed suicide), or
been self-fenced because of a timeout/read error.

Allowing for the additional timeouts incurred by MPIO here really slows
this mechanism down to the point of being unusable.

Now, even if a write was delayed - which is not very likely, it's more
likely that some of the IO will just fail if indeed one of the paths
happens to go down, and this would not resubmit it to other paths -, the
worst that could happen would be a double fence. (If it gets written
after the node has cycled once and cleared its message slot; that would
imply a significant delay already, since servers take a bit to boot.)

For the 'heartbeat' mechanism and others (if/when we get around for
adding them), we could ignore the exact contents that have been written
and just watch for changes; worst, the node death detection will take a
bit longer.

Basically, the thing we need to get around is the possible IO latency in
MPIO, for things like poison pill fencing ("storage-based death") or
qdisk-style plugins. I'm open for other suggestions as well.



Regards,
    Lars

-- =

Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
