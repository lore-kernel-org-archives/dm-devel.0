From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Reducing size of thin spare metadata, thin metadata
Date: Mon, 06 Oct 2014 09:39:30 +0200
Message-ID: <54324732.5080107@redhat.com>
References: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: patrik@dsl.sk
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 6.10.2014 v 09:28 Patrik Horn=EDk napsal(a):
> Hi,
>
> is it possible to (safely) reduce size of thin metadata and / or thin
> spare metadata? What size of spare metadata is needed? Can it be
> smaller than size of pool metadata?
>

You could remove pool spare volume anytime  - lvremove.
(it's only used for automated lvconvert --repair)

Repair needs free space in VG - if there is no free space - well tool can't=
 be =

used.

You could also reduce size of thin pool metadata in case it's too big, just =

not online.


With offline thinpool with these manual steps
(will be later automated with tool as well):

--

make a temporary LV of any size.
swap this temp LV with  pool metadata

# lvconvert --thinpool  vg/mypool   --poolmetadata mytemplv

Create your volume for metadata with new reduced size
(unsure which size is your target - but some calcs based on estimated usage =

are necessary)

Activate   mytemplv  which has now real metadata from thinpool.

# thin_repair  -i /dev/vg/mytemplv   -o /dev/vg/mynewsizemeta

# thin_check  /dev/vg/mynewsizemeta


If all is green - swap new meta into your thinpool

# lvconvert --thinpool  vg/mypool   --poolmetadata mynewsizemeta


If all works great you are done :)
In all other cases you have your backup at hand :)

Yeah - you still have old metadata in mytemplv - this volume you may remove
later if all works well - otherwise you may try to swap this volume back.

Zdenek
