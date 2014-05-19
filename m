From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Status of Linux LVM thin provisioning
Date: Mon, 19 May 2014 13:51:04 +0200
Message-ID: <5379F028.6040700@redhat.com>
References: <CAAOsTSk_wy5snVhQM_8k4fyk5KpnYMYn317+OzkgX6CSoA0K7A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAOsTSk_wy5snVhQM_8k4fyk5KpnYMYn317+OzkgX6CSoA0K7A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: patrik@dsl.sk, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 19.5.2014 00:46, Patrik Horn=EDk napsal(a):
> Hello there,
>
> I am editor in chief of leading Slovak IT news server DSL.sk and I am
> preparing material for our future article about Linux LVM. We are
> creating production data storage system and will report experience
> with that.
>
> What I am trying to find out right now is what is exact status of LVM
> thin provisioning. There is warning in
> https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning.=
txt
> that it is very much still in experimental state and not recommended
> for production, but the text seems little outdated. So what is exact
> status and what versions of kernel / tools are needed? (We are
> currenly using Debian stable but with kernel, LVM and thin
> provisioning tools from Debian testing, so kernel 3.13.10-1, lvm2
> 2.02.104(2) (2013-11-13) and thin-provisioning-tools 0.2.8-1.)
>


Hi

The last distro for lvm2 testing I'd suggest is any Debian based one. The =

reason behind it is - Debian supplies its own untested udev rules. =

Unfortunately device stack is becoming more and more complex (udev/systemd) =

and there are many small piece that needs to cooperate together. =

Synchronization with udev is the critical point - and with badly working ud=
ev =

you may experience many error message to be shown and many things may not w=
ork =

- however lvm2 tries to at least detect those moments.

I'd say the best is to play with upstream  git repository and  upstream ude=
v =

rules (though you have to carefully remove those from Debian distribution).

With any runtime problem - try to seek for help on freenode #lvm.

Also in the recent version (>=3D106) there is  'man lvmthin' which may help=
 to =

understand usage of thin pools and volumes.

Regards

Zdenek
