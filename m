From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][multipath-tools] discovery.c set hwe pointer
 for bus type ccw
Date: Fri, 03 Feb 2006 08:15:27 +0100
Message-ID: <43E3030F.6060600@suse.de>
References: <OFFD0A28A6.4D76571F-ONC1257109.004DBE99-C1257109.0052476D@de.ibm.com>
	<20060202161906.GA11415@pundit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060202161906.GA11415@pundit>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: Stefan Weinhuber <WEIN@de.ibm.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe Varoqui wrote:
>> I tried to use the current git tree version of the multipath-tools in =
a=20
>> Linux on zSeries environment with DASD devices. The tool multipath see=
med=20
>> to
>> recognize the disks correctly, but ignored the device specific=20
>> configuration
>> in my multipath.conf.
>>
> Good to see there is some testing happening there.
> Next major distro release is approaching and not many seem to care to b=
ullet proof the next release ...
>=20
Well, real-life testing is about to begin.
Just because there are no queries / bugs doesn't necessarily mean no-one
uses it. Sometimes it can also mean that there are, well, no bugs.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
