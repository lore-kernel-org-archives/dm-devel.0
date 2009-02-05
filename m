From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 05 Feb 2009 19:16:53 +0000
Message-ID: <498B3B25.3060204@redhat.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>	<498B00B3.5020402@redhat.com>	<E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
	<1a4a774c0902051113u513d9d43sda8278ebaf6899bd@mail.gmail.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a4a774c0902051113u513d9d43sda8278ebaf6899bd@mail.gmail.com>
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

Christian R=F8snes wrote:
> # multipath -ll
> mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD Virtual Disk
> [size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D6][active]
>  \_ 9:0:0:1  sdi 8:128 [active][ready]

That looks better! Seems like device-mapper multipath is configuring=20
these OK now. You might want to just check that mpp is fully disabled=20
if you're going with device-mapper (and also test some cable-pulls to=20
make sure the RDAC failover happens properly) but this is certainly=20
picking up your hw handler configuration now.

Regards,
Bryn.
