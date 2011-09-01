From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath: systemd unit file
Date: Thu, 01 Sep 2011 09:11:56 +0200
Message-ID: <4E5F303C.3010906@suse.de>
References: <20110901030028.GE11793@ether.msp.redhat.com>	<4E5F24DE.50004@suse.de>
	<1314860671.14056.83.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1314860671.14056.83.camel@lapoo.opensvc.com>
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

On 09/01/2011 09:04 AM, Christophe Varoqui wrote:
>>> +[Unit]
>>> +Description=3DDevice-Mapper Multipath Device Controller
>>> +Before=3Discsi.service iscsid.service
>>> +After=3Dsyslog.target
>>> +
>>> +[Service]
>>> +Type=3Dforking
>>> +PIDFile=3D/var/run/multipathd.pid
>>> +ExecStart=3D/sbin/multipathd
>>> +ExecReload=3D/bin/kill -HUP $MAINPID
>>> +#ExecStop=3D/path/to/scrip delete-me if not necessary
>>> +
>>> +[Install]
>>> +WantedBy=3Dmulti-user.target
>>>
>> Hmm. First of all, I'm trying to get rid of the PID file, as with it
>> it's quite hard to start multipathing when /var/run isn't mounted.
>> Plus it's not actually needed; everything can be done via multipathd
>> -k nowadays.
>>
> Agreed
>
>> So may I suggest to use
>> ExecReload=3D/sbin/multipathd -k'reconfigure'
>>
> Or even:
> ExecReload=3Dmultipathd reconfigure
>
That works? Cool.

Bet it's not documented in the manpage ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
