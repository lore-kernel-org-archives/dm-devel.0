From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipathd segfault and error calling out
Date: Thu, 26 Feb 2009 08:16:27 +0100
Message-ID: <49A641CB.30008@suse.de>
References: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>	<20090226030401.GB6700@mars.virtualiron.com>
	<1235618628.6568.67.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1235618628.6568.67.camel@jaspav.missionsit.net.missionsit.net>
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

John A. Sullivan III wrote:
> On Wed, 2009-02-25 at 22:04 -0500, Konrad Rzeszutek wrote:
>> On Wed, Feb 25, 2009 at 09:07:44PM -0500, John A. Sullivan III wrote:
>>> Hello, all.  I am running on kernel 2.6.27 on CentOS 5.2 with VServer
>>> and device-mapper-multipath-0.4.7-17.el5.  I have a custom
>>> mpath_prio_ssi script which takes the device name (e.g., sdaa), pulls
>>> out the path from /etc/disk/by-path and then echos a priority based u=
pon
>>> a lookup table.  It works perfectly fine from the command line.
>>> multipath -ll shows the priorities assigned perfectly and exactly the
>>> right paths are active.
>>>
>>> However, when I start multipathd, it all goes down the tubes.  The pa=
ths
>>> disappear and /var/log/messages is filled with:
>>> Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mp=
ath_prio_ssi sdh
>> Keep in mind that the environment you have when multipathd calls is qu=
ite
>> limited. I believe there is no PATH set, nor any other "normal" values=
.
>>
>> Make sure your code uses absolute paths. So "/bin/grep" ,"/bin/cut", e=
tc..
> <snip>
> Thank you.  I was enthusiastic that might have been the problem, but
> alas not. Even with absolute pathnames and setting the PATH variable, i=
t
> still gives the same error.  In fact, I should have mentioned, I create=
d
> a bogus file with the same pathname which did nothing but "echo hello"
> and it gave the same error calling out error.  What next? - John
Return an explicit exit code. It might be that eg 'cut' returns a non-zer=
o
value, which then would interpreted as a failure.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
