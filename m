From: Luca Berra <bluca@comedia.it>
Subject: Re: add devname module aliases to allow module	on-demand
	auto-loading
Date: Tue, 25 May 2010 07:33:41 +0200
Message-ID: <20100525053341.GB31345@maude.comedia.it>
References: <1274371640.302.5.camel@yio.site>
	<AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com>
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com>
	<201005211909.29326.knikanth@suse.de>
	<AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com>
	<20100521182325.GO3991@agk-dp.fab.redhat.com>
	<AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, Nikanth Karthikesan <knikanth@suse.de>, Peter Rajnoha <prajnoha@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Chris Mason <chris.mason@oracle.com>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, "David S. Miller" <davem@davemloft.net>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, May 21, 2010 at 08:51:49PM +0200, Kay Sievers wrote:
>On Fri, May 21, 2010 at 20:23, Alasdair G Kergon <agk@redhat.com> wrote:
>> On Fri, May 21, 2010 at 03:55:21PM +0200, Kay Sievers wrote:
>>> >> On my box without this patch:
>>> >> =A0 dmsetup version
>>> >> =A0 Library version: =A0 1.02.42 (2010-01-14)
>>> >> =A0 /proc/misc: No entry for device-mapper found
>>> >> =A0 Is device-mapper driver missing from kernel?
>>> >> =A0 Failure to communicate with kernel device-mapper driver.
>>
>> (Curiously this is not an issue I remember anyone raising with me as a p=
roblem
>> before.)
I am fairly sure i did report that, i even tried moving the module
loading framework from lvm2 to device mapper, but the resulting code
sucked too much to submit, the idea was to load device-mapper module,
and all target modules on first use.

>Because distros go the easy and stupid way and just load everything
>they configured as a module. :) That is something to solve, or at
>least avoid and hide a bit.
In this case we were forced to preload dm-mod to work around the issue
;)

>
>I think its all covered with this patch. :) But if yo have any better
>idea, let us know.

what patch?

L.
-- =

Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
