From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 02:34:48 -0700
Message-ID: <425A44B8.4050807@us.ibm.com>
References: <20050410192934.GP12752@marowsky-bree.de>	<1113164717.8372.2.camel@zezette>	<4259B895.4070600@us.ibm.com>	<20050411011444.GA3748@osdl.org>	<20050411084611.GA12752@marowsky-bree.de>
	<425A42EF.50808@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <425A42EF.50808@us.ibm.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike Christie wrote:
> Lars Marowsky-Bree wrote:
>=20
>> On 2005-04-10T18:14:44, Dave Olien <dmo@osdl.org> wrote:
>>
>>
>>> You're correct.  I'll rewrite it on Thursday this week.
>>> I'll use the same methods Lars used in the dm-emc.c
>>
>>
>>
>> Note that dm-emc.c also would need to pre-allocate it's requests, but
>> doesn't right now :/
>>
>> Pre-allocating the requests sucks: Either we pre-allocate for _every_
>> path we might potentially need to send the request down on, or fix up
>> the request for the path we sent it down on (which would require us to
>> use internal knowledge about the req structs we're not supposed to
>> have).
>=20
>=20
> what is wrong with what you have now where you utilize the queue/path's=
=20
> mempool by doing a blk_get_request with GFP_WAIT?=20

or were you talking about the page for data backing which does not have=20
a mempool like the bios (not per queue though) and requests.

Is that "fix up the
> request..." comment meaning that you do not like to access the request=20
> structure for that code, or was it meaning that you have one request=20
> that is shared across paths and it needs to be cleaned up for reuse.
>=20
> I think the hw_handlers setting up the requests is not so fun. Maybe th=
e=20
> block layer scsi_ioctl code could be reworked a little so that it could=
=20
> set some of that up for us since it is very similar. My hw handler was=20
> basically cutting and pasting of that code with some large=20
> simplifcations. I am working on a Target Port Group handler that is=20
> again cutting and pasting more code.
>=20
>>
>> Good solutions solicited ;-)
>>
>>
>> Sincerely,
>>     Lars Marowsky-Br=E9e <lmb@suse.de>
>>
>=20
>=20
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
