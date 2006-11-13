From: Jure =?UTF-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>
Subject: Re: bio too big device dm-XX (256 > 255) on 2.6.17
Date: Tue, 14 Nov 2006 00:41:20 +0100
Message-ID: <20061114004120.30c821c8.pegasus@nerv.eu.org>
References: <20061109005227.73b4fd14.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061109005227.73b4fd14.pegasus@nerv.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: evms-devel@lists.sourceforge.net, dm-devel@redhat.com, reiserfs-list@namesys.com
List-Id: dm-devel.ids


Hello,

this is getting more and more annoying.

Somewhere in the stack reiserfs-dm-md-hd[bd] lies the problem that's ca=
using "bio too big device dm-10 (256 > 255)" errors, which cause i/o fa=
ilures.

It works as expected on reiserfs-dm-sda and on ext3-dm-md-hd[bd].

Debian Etch, 2.6.17-2.



On Thu, 9 Nov 2006 00:52:27 +0100
Jure Pe=C4=8Dar <pegasus@nerv.eu.org> wrote:

>=20
> Hello,
>=20
> Recently I upgraded my home server. I moved EVMS volumes from 3ware h=
w
> mirrors (lvm2) to a md raid1 (lvm2) and am now getting lots of these
> errors, which result in Input/output errors trying to read files from
> those volumes. It's kind of ugly because I have all the data, I just
> cannot read it ...
>=20
> Google comes up with mails from 2003 mentioning such problems. Are th=
ere
> any known such problems in recent kernels or am I hitting something n=
ew
> here?


--=20

Jure Pe=C4=8Dar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
