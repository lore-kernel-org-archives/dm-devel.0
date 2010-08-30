From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Mon, 30 Aug 2010 15:10:22 +0200
Message-ID: <4C7BADBE.1090202@suse.de>
References: <20100825155918.GB8509@redhat.com>
	<4C7B984E.4070802@suse.de>	<4C7B9F14.9080900@mvista.com>
	<4C7BA670.2060303@suse.de> <1283172674.23482.3.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283172674.23482.3.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Christophe Varoqui wrote:
>> So we would be ending with:
>>
>> ENOLINK: transport failure
>> EIO: retryable remote failure
>> EREMOTEIO: non-retryable remote failure
>>
> would scsi reservation conflict errors raise EREMOTEIO in this case ?
> =

Precisely.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
