From: Adam Chasen <adam@chasen.name>
Subject: Re: [Multipath] Round-robin performance limit
Date: Mon, 2 May 2011 09:36:35 -0400
Message-ID: <BANLkTi=h0AwEy0S4Miv-SYTEu3jF0DXXJQ@mail.gmail.com>
References: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
	<20110502072528.GW32595@reaktio.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110502072528.GW32595@reaktio.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Lowering rr_min_io provides marginal improvement. I see 6MB/s
improvement at an rr_min_io of 3 vs 100. I played around with it
before all the way down to 1. People seems to settle on 3. Still, I am
not seeing the bandwidth I assume it should be (4 aggregated links).

Some additional information. If I attempt to pull from my two
multipath devices simultaneously (different LUNs, but same iSCSI
connections) then I can pull additional data (50MB/s vs 27-30MB/s
from each link).

Adam

This is a response to a direct email I sent to someone who had a
similar issue on this list a while back:
Date: Sat, 30 Apr 2011 00:13:20 +0200
From: Bart Coninckx <bart.coninckx@telenet.be>
Hi Adam,

I believe setting rr_min_io to 3 in stead of 100 improved things
significantly.
What is still an unexplainable issue though is dd-ing to the multipath
device (very slow) while reading from it is very fast. Doing the same
piped over SSH to the original devices on the iSCSI server was OK, so it
seems like either an iSCSI or still a multipath issue.

But I definitely remember that lowering rr_min_io helped quite a bit.
I think the paths are switched faster in this way resulting into more speed.

Good luck,

b.


On Mon, May 2, 2011 at 3:25 AM, Pasi K=E4rkk=E4inen <pasik@iki.fi> wrote:
> On Thu, Apr 28, 2011 at 11:55:55AM -0400, Adam Chasen wrote:
>>
>> [root@zed ~]# multipath -ll
>> 3600c0ff000111346d473554d01000000 dm-3 DotHill,DH3000
>> size=3D1.1T features=3D'0' hwhandler=3D'0' wp=3Drw
>> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>> =A0 |- 88:0:0:0 sdd 8:48 =A0active ready =A0running
>> =A0 |- 86:0:0:0 sdc 8:32 =A0active ready =A0running
>> =A0 |- 89:0:0:0 sdg 8:96 =A0active ready =A0running
>> =A0 `- 87:0:0:0 sdf 8:80 =A0active ready =A0running
>> 3600c0ff00011148af973554d01000000 dm-2 DotHill,DH3000
>> size=3D1.1T features=3D'0' hwhandler=3D'0' wp=3Drw
>> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>> =A0 |- 89:0:0:1 sdk 8:160 active ready =A0running
>> =A0 |- 88:0:0:1 sdi 8:128 active ready =A0running
>> =A0 |- 86:0:0:1 sdh 8:112 active ready =A0running
>> =A0 `- 87:0:0:1 sdl 8:176 active ready =A0running
>>
>> /etc/multipath.conf
>> defaults {
>> =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0multibus
>> =A0 =A0 =A0 =A0 rr_min_io 100
>> }
>
> Did you try a lower value for rr_min_io ?
>
> -- Pasi
>
>>
>> multipath-tools v0.4.9 (05/33, 2016)
>> 2.6.35.11-2-fl.smp.gcc4.4.x86_64
>>
>> Thanks,
>> Adam
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
