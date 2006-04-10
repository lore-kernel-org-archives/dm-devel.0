From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: HSG80, DM, multipath issues
Date: Tue, 11 Apr 2006 00:17:17 +0200
Message-ID: <443AD96D.403@free.fr>
References: <20060410174210.GA3798@tditx.com> <443AA3DF.3080404@free.fr>
	<443AD592.7080605@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443AD592.7080605@bzed.de>
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

Bernd Zeimetz a =E9crit :
> Hi,
>
>  =20
>> That problem solved, you'll hit the next wall, which is the hardware
>> handler need for this array family.
>>    =20
> if I remember right somebody posted a HW handler for this type of array
> long time ago...!? Do you knwo what's up with it!?
>
>
>  =20
Yes, I store the different trials here :=20
http://christophe.varoqui.free.fr/multipath-tools/

(the dm-* files)

Mike Christie and Dave Olien coded those, at different times.

The main problem there is that HP won't endorse such handlers, nor=20
maintain, nor even advertise them ... so they are close to unmaintained.

Regards,
cvaroqui
