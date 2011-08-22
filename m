From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Native systemd service files for multipathd
Date: Mon, 22 Aug 2011 17:01:50 +0100
Message-ID: <20110822160150.GB26199@agk-dp.fab.redhat.com>
References: <4E0C83BE.9020507@gmail.com>
	<1314020862.30562.3.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1314020862.30562.3.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel <dm-devel@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>, =?iso-8859-1?Q?J=F3hann_B=2E_Gu=F0mundsson?= <johannbg@gmail.com>
List-Id: dm-devel.ids

On Mon, Aug 22, 2011 at 03:47:42PM +0200, Christophe Varoqui wrote:
> On jeu., 2011-06-30 at 14:10 +0000, "J=F3hann B. Gu=F0mundsson" wrote:
> > Is anyone taking a look at porting the multipathd legacy sysv init =

> > script to native systemd unit file?
> > I filed 690828 on 2011-03-25 and yet to receive somekind of response on =

> > it and unless some action is taken then a) device-mapper-multipath will =

> > be blocking the Fedora 16 alpha release or b) be ripped out of @base an=
d =

> > be made sure it does not get installed on the official livecd.
> What is the status of this request ? Has anyone stepped-in to the job ?
> If not I'll look into it. If you have Fedora-specific systemd
> implementation guideline, please point me to the appropriate
> documentation.
 =

As you can see, that bugzilla got closed 19th July.

It was linked to another one 723357 which is also closed, but the comment #2
there suggests there is still a problem to be dealt with:

  I'm not sure why udev synchronization is failing during startup, but it i=
s. =


Ben, is that still a problem to be investigated?

Alasdair
