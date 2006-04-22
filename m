From: Arsene Gschwind <arsene.gschwind@unibas.ch>
Subject: Re: Multipath blacklisted devices
Date: Sat, 22 Apr 2006 13:49:03 +0200
Message-ID: <444A182F.9010808@unibas.ch>
References: <4447CB84.6060804@unibas.ch> <4447ED2F.3090505@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4447ED2F.3090505@free.fr>
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

Hi Christophe,

I've found the problem, my entry in multipath.conf was devnode_blacklist=20
{ } and it should be only blacklist{}.
You may have to correct multipath.conf.synthetic provided by the tarball=20
( and the git version) because I've used that file to create my own and=20
it includes this error.

Thanks a lot for your help and work
Ars=E8ne

Christophe Varoqui wrote:

> URZ- AG a =E9crit :
>
>> Hi,
>>
>> I'm using the latest git version of multipath-tools with a 2.6.16=20
>> kernel.
>> Today I've tried to blacklist a scsi device in the multipath.conf=20
>> file using the following entry:
>>        devnode "^(sda)[0-9]*"
>>
>> This didn't work at all, it seems that multipath doesn't use the=20
>> blacklist entries found in multipatch.conf.
>> I've patched the source code to hardcode that device and this works=20
>> well.
>> I've tried to debug the config loading but my C knowledge is too poor=20
>> and I haven't been able to find out whats wrong so far.
>> Any help for debugging would be greatly apreciated, I've tried to=20
>> write some code which dumps all entries read from the config file but=20
>> it didn't work so far.
>>
>> Thanks for your time and great work,
>> Ars=E8ne
>>
>> --=20
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
> It works here :(
> Try to extract the live blacklist with :
>
> # multipathd/multipathd -k"show conf"
> ...
> blacklist {
>        devnode ^(sda)[0-9]*
>        devnode ^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*
>        devnode ^hd[a-z]
>        devnode ^cciss!c[0-9]d[0-9]*
>        wwid 26353900f02796769
>        device {
>                vendor IET
>                product A.*A
>        }
>        device {
>                vendor DGC
>                product LUNZ
>        }
> }
> ...
>
> Regards,
> cvaroqui
>
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=20
***********************************************************
Gschwind Arsene		=09
Universitaet Rechenzentrum (URZ)
Klingelbergstrasse 70
CH-4056 Basel
SWITZERLAND

Languages : F/E/D
WWW:  <http://www.urz.unibas.ch>
Mail: <Arsene DOT Gschwind AT unibas DOT ch>
************************************************************
