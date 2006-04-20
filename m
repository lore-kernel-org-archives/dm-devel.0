From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath blacklisted devices
Date: Thu, 20 Apr 2006 22:21:03 +0200
Message-ID: <4447ED2F.3090505@free.fr>
References: <4447CB84.6060804@unibas.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4447CB84.6060804@unibas.ch>
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

URZ- AG a =E9crit :
> Hi,
>
> I'm using the latest git version of multipath-tools with a 2.6.16 kerne=
l.
> Today I've tried to blacklist a scsi device in the multipath.conf file=20
> using the following entry:
>        devnode "^(sda)[0-9]*"
>
> This didn't work at all, it seems that multipath doesn't use the=20
> blacklist entries found in multipatch.conf.
> I've patched the source code to hardcode that device and this works wel=
l.
> I've tried to debug the config loading but my C knowledge is too poor=20
> and I haven't been able to find out whats wrong so far.
> Any help for debugging would be greatly apreciated, I've tried to=20
> write some code which dumps all entries read from the config file but=20
> it didn't work so far.
>
> Thanks for your time and great work,
> Ars=E8ne
>
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
It works here :(
Try to extract the live blacklist with :

# multipathd/multipathd -k"show conf"
...
blacklist {
        devnode ^(sda)[0-9]*
        devnode ^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*
        devnode ^hd[a-z]
        devnode ^cciss!c[0-9]d[0-9]*
        wwid 26353900f02796769
        device {
                vendor IET
                product A.*A
        }
        device {
                vendor DGC
                product LUNZ
        }
}
...

Regards,
cvaroqui
