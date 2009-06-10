From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Re: Re: Can SCSI commands trigger the reinit of a disabled
	path?
Date: Thu, 11 Jun 2009 00:50:26 +0800
Message-ID: <d364733c0906100950k5d05f770i9edb9c4b36e692d6@mail.gmail.com>
References: <20090610160044.57D8B619E37@hormel.redhat.com>
	<6416EE16C1AF1E4C86882867E4DD0FF605C111AF@CORPUSMX40B.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6416EE16C1AF1E4C86882867E4DD0FF605C111AF@CORPUSMX40B.corp.emc.com>
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

On Thu, Jun 11, 2009 at 12:35 AM, <Levy_Jerome@emc.com> wrote:
>> I went through the multipath code and found there was hardware handler
>> for specified hardware, such as emc. =A0When init path, it will use th=
e
>> trespass command given by the handler. Does this mean it only support
>> the A/PF mode of array? When SCSI commands, =A0such as SCSI PR, are se=
nt
>> to a disabled path, will trespass be triggered?
>
> In A/PF mode, with failovermode set to 1 (as it should be for dm-mpio)
> the Clariion array will only trespass LUNs on receipt of an explicit
> trespass command, not on other I/O.
Yes, it's what the A/PF mode. But for ALUA, how does device mapper
mutipath driver failback the path and how to avoid Ping-pong state? I
could not find this part of codes.
Thanks,
>
> Jerry Levy, EMC
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Xie Gang
