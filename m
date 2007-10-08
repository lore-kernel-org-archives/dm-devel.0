From: Hannes Reinecke <hare@suse.de>
Subject: Re: RDAC 09.01.B5.55 with RHEL4 reboot time
Date: Mon, 08 Oct 2007 11:10:15 +0200
Message-ID: <4709F3F7.3010903@suse.de>
References: <1403218a0710010540r25c03c45ndf5cf08dcbddc7e4@mail.gmail.com>	<1191259229.1933.180.camel@linuxchandra>
	<1403218a0710080139y3a257bc8lde1666f289131b96@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1403218a0710080139y3a257bc8lde1666f289131b96@mail.gmail.com>
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

Voiper wrote:
> Sorry, you mean there are two different RDAC products ???
>=20
Correct.

> On 10/1/07, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
>> Hi,
>>
>> The RDAC driver you are referring to is an independent driver that
>> supports DS4K.
>>
This is the proprietary driver from LSI/Engenio, using it's own multipath
framework.

>> Whereas the RDAC driver being talked in this mailing list works under
>> DM-Multipath.
>>
This is the driver included in multipath-tools / linux.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
