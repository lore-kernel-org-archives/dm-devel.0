From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: systemd unit file
Date: Thu, 1 Sep 2011 09:46:24 -0500
Message-ID: <20110901144624.GH11793@ether.msp.redhat.com>
References: <20110901030028.GE11793@ether.msp.redhat.com>
	<4E5F24DE.50004@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E5F24DE.50004@suse.de>
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

On Thu, Sep 01, 2011 at 08:23:26AM +0200, Hannes Reinecke wrote:
> On 09/01/2011 05:00 AM, Benjamin Marzinski wrote:
>> Here is a systemd unit file for managing multipathd.
>>
> [ .. ]
>> Index: multipath-tools-110831/multipathd/multipathd.service
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- /dev/null
>> +++ multipath-tools-110831/multipathd/multipathd.service
>> @@ -0,0 +1,14 @@
>> +[Unit]
>> +Description=3DDevice-Mapper Multipath Device Controller
>> +Before=3Discsi.service iscsid.service
>> +After=3Dsyslog.target
>> +
>> +[Service]
>> +Type=3Dforking
>> +PIDFile=3D/var/run/multipathd.pid
>> +ExecStart=3D/sbin/multipathd
>> +ExecReload=3D/bin/kill -HUP $MAINPID
>> +#ExecStop=3D/path/to/scrip delete-me if not necessary
>> +
>> +[Install]
>> +WantedBy=3Dmulti-user.target
>>
> Hmm. First of all, I'm trying to get rid of the PID file, as with it it's =

> quite hard to start multipathing when /var/run isn't mounted.
> Plus it's not actually needed; everything can be done via multipathd -k =

> nowadays.

At least on fedora, The systemd people changed /var/run so that it's now ju=
st a symlink
to /run, which is a tmpfs filesystem.
>
> So may I suggest to use
> ExecReload=3D/sbin/multipathd -k'reconfigure'

Makes sense. Sure.

> here?
> And do we actually need
> PIDFile=3D
> for systemd?
> If not I'd rather remove that line, too.

To comply with the Systemd Daemon best practices (in man
systemd.service(5)), I appears so. But I don't believe that it's
strictly necessary. If you don't add it, systemd will try to guess the
mainpid, and since multipath multi-thread instead of multi-process, I'm
pretty sure it will guess correctly.

But if /var/run becomes a tmpfs, then I don't see a need to remove the
pidfile. =


-Ben

> Cheers,
>
> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
