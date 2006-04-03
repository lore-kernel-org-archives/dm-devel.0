From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: creating partition mappings with different delimiters
Date: Mon, 03 Apr 2006 23:23:18 +0200
Message-ID: <44319246.6040008@free.fr>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>
	<1144097506.3111.81.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1144097506.3111.81.camel@gator.sc.steeleye.com>
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

Eddie Williams a =E9crit :
> I see it is kpartx that is defaulting to the 'p' as the delimiter (in
> the set_delimiter function) when the uuid ends with a digit and no
> delimiter when the uuid ends with a character.
>
> Wouldn't it be better to always use the same delimiter by default?  As
> it stands now one will not be able to determine that a node is a
> partition versus a full device by just looking at the name.=20
>
>  =20
This behaviour mimics the kernel partition naming policies : /dev/sd?=20
partitions have no separator, while /dev/cciss/c0d0 have one, for example=
.

kpartx once meant to be a true alternative to in-kernel partition=20
handling, thus cared about that naming compatibility.

I'm inclined to leave it that way, if not only to discourage people to=20
partition multipathed devices :)

Regards,
cvaroqui
