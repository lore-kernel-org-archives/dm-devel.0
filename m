From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Problem when creating snashots
Date: Wed, 27 Sep 2006 12:03:11 +0200
Message-ID: <451A4C5F.3000606@bzed.de>
References: <77299A0E-4C81-4820-97BF-FB15B1A96FD6@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,
>
> I'd like to create many snaphot of an image but I've got when I attemp=20
> to create the 32th snapshot :
>
> root@B03:/diplome# lvcreate -s -L150M -n 232 /dev/openvz/vps-core
>   Rounding up size to full physical extent 152.00 MB
>   device-mapper: reload ioctl failed: Ne peut allouer de la m=E9moire
>   Failed to suspend origin vps-core
do you probably run into the bug mentioned in
https://www.redhat.com/archives/dm-devel/2006-September/msg00058.html



Best regards,

Bernd Zeimetz
