From: Hannes Reinecke <hare@suse.de>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Mon, 26 May 2014 14:29:32 +0200
Message-ID: <538333AC.60103@suse.de>
References: <5368ABE8.9050909@acm.org> <536B1CC1.6080709@suse.de>
	<53832919.8080500@acm.org> <53832F2B.9060808@suse.de>
	<53833183.7080106@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53833183.7080106@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 05/26/2014 02:20 PM, Bart Van Assche wrote:
> On 05/26/14 14:10, Hannes Reinecke wrote:
>> Mike Snitzer had a patch in his device-mapper tree:
>>
>> dm mpath: fix lock order inconsistency in multipath_ioctl (2014-05-14
>> 16:12:17 -0400)
>>
>> I was sort of hoping that would address this issue.
>> Can you check?
>
> Hello Hannes,
>
> Is it possible that that patch already got included in v3.15-rc6 and
> hence that that patch was included in my test ?
>
> $ git log v3.15-rc5..v3.15-rc6 | grep 'dm mpath: fix lock order
> inconsistency in multipath_ioctl'
>        dm mpath: fix lock order inconsistency in multipath_ioctl
>      dm mpath: fix lock order inconsistency in multipath_ioctl
>
Could be.

Okay, I'll be cross-checking.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
