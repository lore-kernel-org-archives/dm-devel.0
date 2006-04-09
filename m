From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Technical information requested on MultiPath module
	of Linux
Date: Sun, 09 Apr 2006 22:09:55 +0200
Message-ID: <44396A13.5010204@free.fr>
References: <b043f1b00604091015w7468d9ecjf729c3188761f295@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b043f1b00604091015w7468d9ecjf729c3188761f295@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joanne Neil <joanne.neil@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Joanne Neil a =E9crit :
> Hello,
>
>       I was in search of technical details on MultiPath module of Linux=
. I found
> the excellent page of  christophe. I apologize for sending the email to=
 you
> directly. Can I know:
>
> a. Which will be the right email forum to send technical/development qu=
estions
> on MultiPath for Linux?
>
>  =20
dm-devel@redhat.com
> b. I was looking at Linux 2.6.11 MultiPath code and found EMC CX/AX
> specific code. This is where I am most interested in. Does it require t=
hat
> a storage vendor has to implement specific hooks for the generic MultiP=
ath
> code to work with their product in Linux?. If yes, can I be pointed lin=
k or
> references or document on what a storage vendor has to implement to
> have their storage work on Linux.
>
>  =20
I guess you refer to "hardware handlers" modules. Those are needed only=20
if special host-initiated action is needed for the storage hardware to=20
activate failback paths.

This is often the case with asymmetric arrays.
> c. From what I have read, the MultiPath architecture has changed from
> Linux 2.4 and Linux 2.6. Is this correct?. And the device mapper archit=
ecture
> was introduced in Linux 2.6.
>
>  =20
The DM multipath driver is lk2.6 only. The MD multipath driver was=20
available in lk2.4, and is still maintained in lk2.6. The=20
multipath-tools interface the DM framework only.
> d. Will Linux 2.6 MultiPath code be applicable to Linux 2.4?
>
>  =20
There is no plan for userspace tools to support lk2.4 (pre-sysfs=20
kernels, pre-kevents).
Hardware handlers use a "lk2.6 DM" specific API.
> Appreciate any help
>
> Regards
> Joanne
>  =20
