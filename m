From: Lars Marowsky-Bree <lmb@novell.com>
Subject: Re: RFC: multipath IO multiplex
Date: Mon, 8 Nov 2010 15:18:38 +0100
Message-ID: <20101108141838.GN16210@suse.de>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
	<20101106165743.GE30809@suse.de>
	<1289125849.2821.5.camel@Nokia-N900-42-11>
	<20101108115028.GH16210@suse.de>
	<20101108121208.GA15253@agk-dp.fab.redhat.com>
	<20101108121941.GK16210@suse.de>
	<20101108125638.GB15253@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101108125638.GB15253@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>, device-mapper development <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

On 2010-11-08T12:56:38, Alasdair G Kergon <agk@redhat.com> wrote:

> > I wonder how other latency-sensitive IO handles multipath? Maybe they
> > just haven't noticed yet they'd like a facility like this? ;-)
> As usual, it's the lack of a cancellation interface for incomplete I/O
> that seems to make the kernel-side option troublesome: we still have
> to wait for timeouts.

That would apply just as well to user-space though, no?

Like I said, the goal would be to report the first successful IO
completion, or the last failure - any other failures or results simply
get discarded at the kernel level. (Or wherever.)

> Do we prevent more than one I/O being sent in this mode, given that
> any other alternative would have races?

I don't follow. What races?

Of course the application needs to know this, and can't just treat it
like a regular block device.


Regards,
    Lars

-- =

Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
