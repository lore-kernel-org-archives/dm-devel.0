From: Jan Blunck <jblunck@suse.de>
Subject: Re: Problem when creating snashots
Date: Tue, 26 Sep 2006 23:14:08 +0200
Message-ID: <20060926211407.GA2915@hasse.suse.de>
References: <77299A0E-4C81-4820-97BF-FB15B1A96FD6@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <77299A0E-4C81-4820-97BF-FB15B1A96FD6@gmail.com>
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

On Tue, Sep 26, The MoonSeeker wrote:

> I'd like to create many snaphot of an image but I've got when I =20
> attemp to create the 32th snapshot :
>=20
> root@B03:/diplome# lvcreate -s -L150M -n 232 /dev/openvz/vps-core
>   Rounding up size to full physical extent 152.00 MB
>   device-mapper: reload ioctl failed: Ne peut allouer de la m=E9moire
>   Failed to suspend origin vps-core
>=20
> I don't understand the error..

I'm not a native french speaker (hint!) but I assume you run out of
memory.

Yes there are limitations to the number of snapshots. For every single
snapshot we have to allocate memory for copying the chunks to the excepti=
on
store.

Do you really need that many snapshots at the same time?
