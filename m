From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Fix kernel NULL pointer dereference
	in	dm-mpath.c
Date: Sat, 12 Jun 2010 01:45:37 +0100
Message-ID: <20100612004537.GI8043@agk-dp.fab.redhat.com>
References: <AANLkTilQx3qv6HIi83nYIoC9QRvgS4lJiC42UlcanhSs@mail.gmail.com>
	<AANLkTim0Fgiwj-3h5XweiO0oiXQOM7twKfCg7csO8Zc1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTim0Fgiwj-3h5XweiO0oiXQOM7twKfCg7csO8Zc1@mail.gmail.com>
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

On Fri, Jun 11, 2010 at 10:18:14AM -0700, Patrick J. LoPresti wrote:
> P.S. =A0Are the Coverity folks still running the kernel through their
> tool? =A0This seems like the sort of thing it would catch.
 =

No - it hasn't run since February, unfortunately.

Alasdair
