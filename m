From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question about WWID
Date: Mon, 03 May 2010 13:12:48 +0200
Message-ID: <4BDEAFB0.8000609@suse.de>
References: <o2zaf7b4eb21004301216s726e4e82x8de50d0fa21469d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <o2zaf7b4eb21004301216s726e4e82x8de50d0fa21469d@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Rodrigo Nascimento wrote:
> Hi All,
> =

> How the WWID from dm-mp is generated? I can image that it use serial
> number of the disk, but how it is really generated?
> =

It is using the SCSI Inquiry VPD pages; page 0x83 or, failing that, path 0x=
80.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
