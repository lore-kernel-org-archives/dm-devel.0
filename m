From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath - AAArgh! How do I turn "features=1
	queue_if_no_path" off?
Date: Thu, 1 Oct 2009 11:44:24 +0200
Message-ID: <20091001094424.GB4210@ochil.suse.de>
References: <4AC333E2.9090005@Calva.COM> <20090930154212.GA8507@us.ibm.com>
	<4AC44B1E.7020509@suse.de> <4AC46E70.9060509@Calva.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AC46E70.9060509@Calva.COM>
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

On Thu, Oct 01, 2009 at 10:55:12AM +0200, John Hughes wrote:
> Hannes Reinecke wrote:
>> malahal@us.ibm.com wrote:
>>> John Hughes [john@Calva.COM] wrote:
>>>> I want to turn queue_if_no_path off and use
>>>>
>>>>                polling_interval        5
>>>>                no_path_retry           5
>>>>
>>>> because I've had problems with things hanging when a lun "vanishes" =
(I=20
>>>> deleted it from my external raid box).
>>>>
>>>> But whatever I put in /etc/multipath.conf when I do a "multipath -l"=
 or=20
>>>> "multipath-ll" it shows:
>>>> 360024e80005b3add000001b64ab05c87dm-28 DELL    ,MD3000       =20
>>>> [size=3D68G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
>>>> \_ round-robin 0 [prio=3D3][active]
>>>> \_ 3:0:1:13 sdad 65:208 [active][ready]
>>>> \_ round-robin 0 [prio=3D0][enabled]
>>>> \_ 4:0:0:13 sdas 66:192 [active][ghost]
>>>>
>> Which is entirely correct. The 'queue_if_no_path' flag _has_ to
>> be set here as we do want to retry failed paths, if only for
>> a limited amount of retries.
>>
>> The in-kernel dm-multipath module should handle the situation correctl=
y
>> and switch off the queue_if_no_path flag (=3D pass I/O errors upwards)
>> when the amount of retries is exhausted.
> As far as I can tell it retries forever (even with polling_interval 5 a=
nd=20
> no_path_retry 5).   The mdadm raid10 built on top of the multipath devi=
ces=20
> hangs, even /proc/mdstat hangs.
>
> You're saying that without queue_if_no_path multipath basicly won't wor=
k -=20
> mdadm will see I/O errors on multipath devices if a path fails?
>
If _all_ paths fail. Note the 'no_path' bit :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
