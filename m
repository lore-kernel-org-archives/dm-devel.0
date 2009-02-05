From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 05 Feb 2009 19:13:15 +0000
Message-ID: <498B3A4B.2030205@redhat.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>	
	<498B00B3.5020402@redhat.com>
	<1a4a774c0902051056j7dab1bf9p28d6f1c947d03565@mail.gmail.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a4a774c0902051056j7dab1bf9p28d6f1c947d03565@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Christian R=F8snes wrote:
>>
>>               vendor                  "DGC"
>>               product                 "*"
>>
>> I suspect from the output below that you want:
>>
>>               vendor                  "DELL"
>>               product                 "DELL,MD Virtual Disk"
>>
>>
> Here's what I see for the MD3000i:
>=20
> # cat /sys/block/sdb/device/vendor
> DELL
> # cat /sys/block/sdb/device/model
> MD Virtual Disk
>=20
> Thank you
> Christian
>=20

That's what I thought based on the output you posted earlier. You need=20
to put this in multipath.conf instead of the values you currently have=20
("DELL"/"MD3000i" which are not correct for this hardware) but you=20
also need to resolve the issue of whether you want to use=20
device-mapper or MPP multipathing - the /etc/multipath.conf file is=20
only used by the device-mapper multipath tools.

Regards,
Bryn.
