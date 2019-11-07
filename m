From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache: change config parameters using
	messages
Date: Thu, 7 Nov 2019 14:50:01 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911071448290.20334@file01.intranet.prod.int.rdu2.redhat.com>
References: <fa95f1f0-67d6-d02e-6999-ba1f90d70fe2@petasan.org>
	<8388b99a-a531-981e-9e36-8aeb3dffd18e@petasan.org>
	<20191106150831.GA27888@redhat.com>
	<5370f009-c324-1530-4400-adf1b59f0bbd@petasan.org>
	<20191107190958.GA2821@redhat.com>
	<cba8f93a-3477-9c87-0bff-fe7e6962d606@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cba8f93a-3477-9c87-0bff-fe7e6962d606@petasan.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maged Mokhtar <mmokhtar@petasan.org>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Thu, 7 Nov 2019, Maged Mokhtar wrote:

>=20
>=20
> On 07/11/2019 21:09, Mike Snitzer wrote:
> > On Thu, Nov 07 2019 at  1:55pm -0500,
> > Maged Mokhtar <mmokhtar@petasan.org> wrote:
> >=20
> > >=20
> > >=20
> > > On 06/11/2019 17:08, Mike Snitzer wrote:
> > > > On Tue, Nov 05 2019 at  4:19pm -0500,
> > > > Maged Mokhtar <mmokhtar@petasan.org> wrote:
> > > >=20
> > > > > Gentle ping please.
> > > > >=20
> > > > > It could add flexibility in changing cache parameters after devic=
e
> > > > > creation.
> > > >=20
> > > > I'm inclined to _not_ take this type of change.
> > > >=20
> > > > Why isn't changing the config parameters via table reload viable fo=
r
> > > > you?
> > > >=20
> > >=20
> > >=20
> > > Hi Mike,
> > >=20
> > > Thank you for your response. The main issue is to enable setting
> > > some config parameters while the device is mounted and running and
> > > avoid calling target ctr() by sending parameter changes via
> > > messages. A similar setup was used in dm-cache.
> > >=20
> > > The reason is that tuning the write cache may require run time
> > > changes. If un-tuned we can observes periods of spikes and/or step
> > > like disk utilization on the slow device during writeback using
> > > iostat, and these spikes correspond to periods of increased client
> > > io latency. Utilization can be tuned by varying the number of active
> > > writeback jobs + the gap between high and low marks to achieve a
> > > smooth high utilization.  Such tuning is difficult to do when
> > > creating the cache device as it depends on the hardware and io
> > > workload. We are hoping to use some userspace monitoring and tuning
> > > tool to periodically adjust these values while the device is
> > > running.
> >=20
> > I think you're missing that any actively used DM device can be
> > suspended, table reloaded, resumed.  So the tuning at runtime is still
> > possible, it just requires more steps.
> >=20
> > And I'm saying that unless/until there is a better reason other than
> > "dm-cache allowed tuning via messages" I'm not interested in having
> > multiple methods for tuning dm-writecache.
> >=20
> > Mike
> >=20
> just for my understanding, does not table reload call _ctr() and
> re-initializes things like threads/read metadada ..?

Yes it does. But you don't have to unmount the filesystem when you reload=
=20
the table.

Mikulas
