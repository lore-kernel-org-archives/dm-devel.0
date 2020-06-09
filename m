From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 0/3] multipath: change default devnode
	blacklist
Date: Tue, 9 Jun 2020 22:20:42 +0000
Message-ID: <7592ecbee0d4e8b3d06e39992d62256efaf5d109.camel@suse.com>
References: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <B463664BB9638D4F9A50EBA461BFBB99@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "nkshirsa@redhat.com" <nkshirsa@redhat.com>
List-Id: dm-devel.ids

On Tue, 2020-06-09 at 16:35 -0500, Benjamin Marzinski wrote:
> I recently got a request to add the Oracle ASM filer driver devices
> to
> multipath's builtin devnode blacklist.  However, instead of having to
> do
> always this for each device type individually, I decided to make
> multipath blacklist all non scsi, nvme, and dasd devnodes by default.
> This is what the multipath udev rules already do.
>=20
> Changes from v1:
> Everything. Martin suggested an alternative method for doing this,
> which
> is to treat an exclamation mark at the start of the
> blacklist/exceptions
> regexes as inverting the matching on the rest of the regex.
>=20
> Benjamin Marzinski (3):
>   libmultipath: remove _blacklist_exceptions functions
>   libmultipath: fix parser issue with comments in strings
>   libmultipath: invert regexes that start with exclamation point
>=20
>  libmultipath/blacklist.c   | 103 +++++++++++++++-------------------
>  libmultipath/blacklist.h   |   3 +
>  libmultipath/parser.c      |   4 +-
>  multipath/multipath.conf.5 |  17 ++++--
>  tests/blacklist.c          | 110
> +++++++++++++++++++++++++++++++++++++
>  tests/parser.c             |  42 ++++++++++++++
>  tests/test-lib.c           |   2 +-
>  7 files changed, 215 insertions(+), 66 deletions(-)
>=20

Very nice work, thank you!

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
