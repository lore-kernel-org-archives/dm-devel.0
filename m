From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: LVM snapshots: guess *that's* not how it's done
Date: Sat, 12 Nov 2005 19:40:42 +0100
Message-ID: <62b0912f0511121040o6e7610f2qd8ec59598e810d59@mail.gmail.com>
References: <62b0912f0511110516gf83b91eta2098d137f456d51@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f0511110516gf83b91eta2098d137f456d51@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

I wrote:
> Since Fedora Core 4 has a couple of those things already in the
> distro, I went with that.
>
> I did this:
> 1. Install Fedora Core 4
> 2. Create a snapshot of the root volume with lvcreate
>
> Seems the snapshotting did not go after plan - see attached screenshot.=
...
>
> Is that a serious bug in device-mapper or lvm, or is it just me that's
> doing something wrong?
>
> After the lvcreate, nothing works.  A couple things like 'df' does,
> but otherwise there's dialogs complaining about missing ELF headers
> and non-executable binary files no matter what I click or try to run.

I was imagining that someone might have had a good way to get
information about what LVM and DM actually did wrong out of this
system.  Seems not.

If anybody wants to analyze this problem, the window of opportunity is cl=
osing.
If nobody pings me within 15 minutes, I'll nuke it and try EVMS :-).

Also, I'll be recommending LVM and DM to my family and friends.
Seems rock stable.  Not!!!  Haha...
