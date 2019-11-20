From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 3/5] libmultipath: drop mpp->nr_active field
Date: Wed, 20 Nov 2019 08:24:15 +0000
Message-ID: <ca926b381746635f6861c973ee32e1812753406b.camel@suse.com>
References: <20191115143403.31692-1-martin.wilck@suse.com>
	<20191115143403.31692-4-martin.wilck@suse.com>
	<20191119222203.GL30153@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191119222203.GL30153@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <0AD77CE7DA48C741B703A4F481904402@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

On Tue, 2019-11-19 at 16:22 -0600, Benjamin Marzinski wrote:
> On Fri, Nov 15, 2019 at 02:41:50PM +0000, Martin Wilck wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > The tracking of nr_active has turned out to be error prone and hard
> > to verify. Calculating it on the fly is a quick operation, so
> > do this rather than trying to track nr_active. Use a boolean
> > field instead to track whether a map is currently in recovery mode.
> >=20
> > Moreover, clean up the recovery logic by making set_no_path_retry()
> > the place that checks the current configuration and state, sets
> > "queue_if_no_path" if necessary, and enters or leaves recovery
> > mode if necessary. This ensures that consistent logic is applied.
>=20
> Thanks. This looks better. The only thing I'm am sorta worried about
> is
> that when we call the cli_handler functions, we haven't called
> update_multipath_strings() to sync the state with the kernel first.
> This
> could mean that multipathd is wrong about what the queue_if_no_path
> state
> is, which is possible since it doesn't update mpp->features whenever
> it
> calls dm_queue_if_no_path(). However, in the worst case scenario,
> this
> would only cause multipathd to need to wait for the next call to
> check_path to fix this up. Alternatively, we might to call
> update_multipath_strings() here, or even replace the calls to
> set_no_path_retry() with something like setup_multipath() or
> update_multipath().
>=20
> Any thoughts? I might just be being overly paranoid here, since I
> can't
> really come up with a good explanation for how this could even get to
> be
> in a problem state, and like I said, even if it does occur, it will
> just
> get resolved on the next call to check_path.

Having to call setup_multipath() in this code path seems too much to
me. One tempting thought would be to simply keep mpp->features up-to-
date, but we're trying to achieve consistent state with this patch set,
and that doesn't go well together with trying to track kernel state in
user space. After all, in theory at least, users could run "dmsetup
message /dev/dm-$X 0 fail_if_no_path" any time, and there's no way to
get notified about this. The way multipathd currently works, we would
find out in check_path(), no sooner.

So, I believe the cli_handler code path should not look at the features
string. I'll send a v2.

Thanks for the review and regards,
Martin
