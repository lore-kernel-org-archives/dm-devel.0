From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH 2/7] multipathd: fix check_path errors with
	removed map
Date: Fri, 19 Jun 2020 22:03:57 +0200
Message-ID: <ddd54050b083d930cac6c779a4d049060116d937.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-3-git-send-email-bmarzins@redhat.com>
	<f09ec3b6537a7b7ac1ae26433e43846176f1dd48.camel@suse.com>
	<20200618231711.GM5894@octiron.msp.redhat.com>
	<a1df6c71-1427-9649-3e81-138ffcd04370@suse.de>
	<20200619163003.GO5894@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619163003.GO5894@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-06-19 at 11:30 -0500, Benjamin Marzinski wrote:
> On Fri, Jun 19, 2020 at 08:32:34AM +0200, Hannes Reinecke wrote:
> > > > fac68d7 is related to the famous "dm-multipath: Accept failed
> > > > paths for
> > > > multipath maps" patch (e.g.
> > > > https://patchwork.kernel.org/patch/3368381/#7193001), which
> > > > never made
> > > > it upstream. SUSE kernels have shipped this patch for a long
> > > > time, but
> > > > we don't apply it any more in recent kernels.
> > > >=20
> > > > With this patch, The reinstate_path() failure would occur if
> > > > multipathd
> > > > had created a table with a "disabled" device (one which would
> > > > be
> > > > present in a dm map even though the actual block device didn't
> > > > exist),
> > > > and then tried to reinstate such a path. It sounds unlikely,
> > > > but it
> > > > might be possible if devices are coming and going in quick
> > > > succession.
> > > > In that situation, and with the "accept failed path" patch
> > > > applied, a
> > > > reload makes some sense, because reload (unlike reinstate)
> > > > would not
> > > > fail (at least not for this reason) and would actually add that
> > > > just-
> > > > reinstated path. OTOH, it's not likely that the reload would
> > > > improve
> > > > matters, either. After all, multipathd is just trying to
> > > > reinstate a
> > > > non-existing path. So, I'm fine with skipping the reload.
> > > >=20
> > It's actually _not_ unlikely, but a direct result of multipathd
> > listening to
> > uevents.
> >=20
> > If you have a map with four paths, and all four of them are going
> > down, you
> > end up getting four events.
> > And multipath will be processing each event _individually_, causing
> > it to
> > generate a reload sequence like:
> >=20
> > [a b c d]
> > [b c d]
> > [c d]
> > [d]
> > []
> >=20
> > Of which only the last is valid, as all the intermediate ones
> > contain
> > invalid paths.
> >=20
> > And _that_ is the scenario I was referring to when creating the
> > patch.
>=20
> But even still, I'm not in favor of calling ev_add_path() with the
> code
> as it currently is. In the case you point out, it will presumably
> fail
> when adopt_paths() calls pathinfo(). That will orphan the path, which
> is
> good. But if the map got removed (intentionally) instead of the path,
> ev_add_path() will recreate the map, which is bad. Also, it seems
> more
> likely for a path to still exist and be usable while the multipath
> device is gone (the bad case), than for the path to pass the checker
> function and then disappear before mutipathd tries to reinstate it
> immediately afterwards (the good case).  Further, the bad result,
> where
> a deleted multipath device reappears, is actually a problem for
> users.
> Having multipathd take a bit of time and pointless effort to catch up
> after multiple changes happen at once doesn't effect users
> noticeably.
>=20
> Since the checkerloop thread spends the vast majority of it's not not
> checking any specific path, if a path goes away, it is most likely to
> be
> caught by the path_offline() function. I we want to do something to
> proactively deal with a path that has been removed, we should do it

Hannes and I discussed about this, and he agreed that calling
ev_add_path() in the situation at hand wasn't helpful. Hence his
suggestion with pp->mpp that we discussed in the other sub-thread.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
