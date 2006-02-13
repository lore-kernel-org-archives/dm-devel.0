From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath: multipath setup okay, nothing in
	/dev/disk/by-name
Date: Mon, 13 Feb 2006 17:01:54 +0100
Message-ID: <1139846514.7784.9.camel@zezette>
References: <57309.194.39.131.39.1139845883.squirrel@www.hcsd.de>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57309.194.39.131.39.1139845883.squirrel@www.hcsd.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On lun, 2006-02-13 at 16:51 +0100, Stephan Austerm=C3=BChle wrote:
> Hi,
>=20
> I've just setup a multipath'd connection to a EMC Clariion CX700. Altho=
ugh
> the output of "multipath -l" looks right for me (see below), no symlink=
s
> in /dev/disk/by-name appear. Under which circumstances does multipath
> create this symlinks and how can I force the creation?
>=20
Please mention the distrib you report for.
It'll help get the right people get involved.
This area is heavily distrib (and distrib version) dependent.

Regards,
cvaroqui
