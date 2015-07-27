From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-4.2-rc4/drivers/md/dm-cache-policy-smq.c:1689:
 bad if test ?
Date: Mon, 27 Jul 2015 08:14:13 -0400
Message-ID: <20150727121413.GA2312@redhat.com>
References: <DUB128-W57EEA6D50E9781025705219C8E0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DUB128-W57EEA6D50E9781025705219C8E0@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Binderman <dcb314@hotmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 27 2015 at  3:00P -0400,
David Binderman <dcb314@hotmail.com> wrote:

> Hello there,
> =

> [linux-4.2-rc4/drivers/md/dm-cache-policy-smq.c:1689]: (warning) Logical =
conjunction always evaluates to false: !EXPR && EXPR.
> =

> Source code is
> =

> =A0 if (!mq->cache_hit_bits && mq->cache_hit_bits) {
> =

> Maybe
> =

> =A0 if (!mq->cache_hit_bits) {
> =

> was intended.

Thanks, was fixed with this, will go upstream for 4.2-rc5:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/com=
mit/?h=3Dfor-next&id=3D134bf30c06f057d6b8d90132e8f8b3cd2be79572
