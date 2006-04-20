From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 22:53:00 +0200
Message-ID: <4447F4AC.5040904@free.fr>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>	<4447E8BF.1060205@bzed.de>
	<20060420204739.GB32417@ingress.sbb.uvm.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060420204739.GB32417@ingress.sbb.uvm.edu>
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

Steve Feehan a =E9crit :
> On Thu, Apr 20, 2006 at 10:02:07PM +0200, Bernd Zeimetz wrote:
>  =20
>> Steve Feehan wrote:
>>    =20
>>> Hello. I'm trying to figure out multipath on a StorageWorks HSG80
>>> contoller. I'm using Ubuntu "Dapper" with the following software
>>>  =20
>>>      =20
>> there was a thread about the HSG80s few days ago.
>> http://www.redhat.com/archives/dm-devel/2006-April/msg00025.html
>> probably that answers all your questions.
>>    =20
>
> Yes, I saw that. The particular problem that I saw there
> was the misreporting of unit size. The Ubuntu init script
> takes care of this and all of my units report the same=20
> size.
>
>  =20
That's certainly where the IO errors are triggered at bootup.
Can you send the code snippet ?

Regards,
cvaroqui
