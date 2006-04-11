From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Problems with multipathing
Date: Tue, 11 Apr 2006 20:42:02 +0200
Message-ID: <443BF87A.10804@free.fr>
References: <443BF12E.50900@ludd.luth.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443BF12E.50900@ludd.luth.se>
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

Roger H=E5kansson a =E9crit :
> I'm trying to setup a couple of machines running CentOS 4.3 x86_64 usin=
g
> disk from a SAN, but I can't get the multipathing to work properly.
>
> The machines (three in total) all have two Emulex LP10000-M2 and thus
> are using the lpfc-driver.
>
> When I boot the machines the paths seem to be multipathed somewhat, if =
i
> put a "multipath"-tag in /etc/multipath.conf with a specific alias
> (yellow,red) for each wwid, those paths are mapped under /dev/mapper an=
d
> /dev/mpath.
>
> But multipath -ll doesn't show what I expect (basically no mappings) an=
d
> if I do a multipath -F I can't get the mappings back without a reboot.
>
> If I do a 'multipath -v3' directly after boot, this is what I get:
> ...
> Anyone got a clue how to solve this problem?
>
>  =20
Can you reproduce with upstream version ?

Regards,
cvaroqui
