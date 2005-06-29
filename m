From: "Zhao Qian" <zhaoqian@aaastor.com>
Subject: bio's bi_size bug also be founded at dm-stripe.c and
	dm-snap.c
Date: Wed, 29 Jun 2005 18:06:01 +0800
Message-ID: <009201c57c92$282303e0$1f000064@polaris>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

As i had written here before, sometimes bio which dispatched to the dm's =
target, it's bi_size could exceed
region size in dm-mirror.c, i also found similar problem in dm-stripe.c a=
nd dm-snap.c , in such situation,
bio's bi_size could exceed strip target's chunk size and snap target's ch=
unk size, but in current code, we
never care about this. so in strip target we could read/write bad positio=
n after stripe_map() function,
and cause same effect in dm-snap.c.
I think such bugs are very dangerous then kernel panic or cracsh becasue =
it may destroy your data=20
in silence. we'd better to annonuce our linux users don't use thus dm-tar=
gets before we correct it.

Sincerely,
                Zhao Qian <zhaoqian@aaastor.com>
