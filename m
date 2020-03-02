From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: multipath-tools merges
Date: Mon, 2 Mar 2020 21:51:04 +0000
Message-ID: <3f8ae4512f68c5ba0cce93e5da27bb812dd8107e.camel@suse.com>
References: <CABr-Gne_oOns4W0A4Ny4t4xRPbU3qdtS5Z6BSt7wQ0N7cRqDeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gne_oOns4W0A4Ny4t4xRPbU3qdtS5Z6BSt7wQ0N7cRqDeQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <4EAD0A9D07ED294399ED93B7A58B9077@namprd18.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

On Mon, 2020-03-02 at 11:19 +0100, Christophe Varoqui wrote:
> Hi ben, Martin,
>=20
> I finally catched up with your changes from october till now.
> Please review I did not mess up the merges, then i'll commit a
> version bump.

This is great, thanks a lot!
I admit that I was starting to get nervous :-)

It seems that you missed the following patches from me, reviewed by
Ben:

 * My "Drop nr_active, and some more fixes" series from 11/19
   - "multipathd: move set_no_path_retry() back to libmultipath"
      Review: https://www.redhat.com/archives/dm-devel/2019-November/msg000=
99.html
   - libmultipath: dict.c: rename duplicate set_no_path_retry()
      Review: https://www.redhat.com/archives/dm-devel/2019-November/msg001=
00.html
   - libmultipath: drop mpp->nr_active field
      Review: https://www.redhat.com/archives/dm-devel/2019-December/msg000=
37.html
   - libmultipath: fix (max_)polling_interval setting logic
     Review: https://www.redhat.com/archives/dm-devel/2019-November/msg0010=
1.html
   - libmultipath: fix ALUA autodetection when paths are down
     Review: https://www.redhat.com/archives/dm-devel/2019-November/msg0010=
7.html

 * libmultipath: fix compilation with -fno-common
   Review: https://www.redhat.com/archives/dm-devel/2020-January/msg00118.h=
tml
 * libmultipath: fix files read from config_dir (from Enzo):
   Review (by me): https://www.redhat.com/archives/dm-devel/2020-February/m=
sg00058.html

Furthermore, as I indicated before, I'd like to propose a minor change on t=
op of Ben's
last series before you tag a new version. No C code changes, just build log=
ic for
unit tests, and a README. I'll post it ASAP.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE
Software Solutions Germany GmbH=20
HRB 36809 (AG N=FCrnberg) GF: Felix
Imend=F6rffer
