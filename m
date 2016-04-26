From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Tue, 26 Apr 2016 11:19:33 +0200
Message-ID: <571F32A5.7090405@redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<20160425173838.GE26117@octiron.msp.redhat.com>
	<571F0009.3080903@suse.de>
	<571F295A.6060607@redhat.com> <571F2B3C.5040306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <571F2B3C.5040306@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids

On 26.4.2016 10:47, Hannes Reinecke wrote:
> On 04/26/2016 10:39 AM, Zdenek Kabelac wrote:
>> On 26.4.2016 07:43, Hannes Reinecke wrote:
>>> On 04/25/2016 07:38 PM, Benjamin Marzinski wrote:
>>>> On Mon, Apr 25, 2016 at 02:56:35PM +0200, Christophe Varoqui wrote:
>>>>>      Hi,
>>>>>      Those example udev rules are indeed unmaintained and should
>>>>> be removed not
>>>>>      to confuse distributors.
>>>>>      Distributors can't be asked to agree on a common udev
>>>>> ruleset. Ben,
>>>>>      Hannes, Xos=E9, Peter are you ok with my deleting the udev
>>>>> rules example ?
>>>>
>>>> I am personally fine with kpartx.rules being deleted. Red Hat
>>>> doesn't
>>>> package it.
>>>>
>>> Well, we do. We use kpartx to generate partitions for multipath and
>>> dmraid, so we do need this rule.
>>> Please do not delete it; if so I will only have to re-add it again
>>> in a SUSE-specific patch.
>>
>> Hi
>>
>> Can you please elaborate what is the 'specific' need of SUSE for patch?
>>
>> AFAIK there should be no need for it - all identifiers are not
>> tracked by
>> 10-dm.rules
>>
>> It has whole logic about device state built-in.
>>
>> So what exactly would you need to trace in kpartx.rules ?
>>
> We use kpartx.rules to call 'kpartx' itself for creating the
> partition devices on top of any multipath or dmraid devices.
>
> If that logic has been moved into other, generic, device-mapper
> rules please let me know.
> But until then we need the kpartx.rules. file.

Ok, so it seems it is completely chaotic -

As in RHEL/Fedora there is largely hacked  mpath udev rule file,
which is then responsible for using partx?

While in SUSE this seems to be handled by broken old unmaintained  kpartx u=
dev =

rules file (as the file is useless - wondering how could do anything useful=
 on =

SUSE)

AFAIK seems we miss communication between Ben with Hannes here :)

As logically it seem  calling  kpartx rule calls belong to  kpartx package.
However  kpartx upstream rule file is for  systems  from 2007 year.

So I'd have assumed lots of current mpath  RHEL rule patches should be
relocated to kpartx rules.

Leaving this to you guys...

Regards

Zdenek
