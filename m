From: Eli Klein <elijah@aclue.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Wed, 30 Sep 2009 13:16:16 -0600
Message-ID: <06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
	<4AC3AC88.9020404@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: multipart/mixed; boundary="===============0110878686=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC3AC88.9020404@redhat.com>
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


--===============0110878686==
Content-Type: multipart/alternative; boundary=Apple-Mail-8--994413526


--Apple-Mail-8--994413526
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes

On Sep 30, 2009, at 1:07 PM, John Brier wrote:

> On 09/30/2009 12:41 PM, Eli Klein wrote:
>> I'm running into an issue where the failback option in  
>> multipath.conf is
>> being ignored. I've tried to set this to a value > 0 to cause dm to
>> pause before reinstating a recovered path, but it reinstates the path
>> immediately. The same is true when setting the value to "manual", the
>> path is reinstated immediately. The delay is most useful when a  
>> ethernet
>> switch has failed or rebooted. During the boot of the switch, the
>> interface comes up and drops again multiple times. I'd love to be  
>> able
>> to introduce a delay before DM marks the path as reinstated after a
>> recovery. This would save me the hassle of running into I/O errors  
>> (and
>> occasional filesystem RO) as the path bounces while the switch is  
>> booting.
>>
>> Thanks in advance for any help or suggestions!
>>
>> -Eli
>>
>> I've included my multipath.conf as well as output from multipath - 
>> ll below:
>>
>> multipath.conf:
>>
>> blacklist {
>> devnode "sda$"
>> # devnode "*"
>> }
>>
>> ## By default, devices with vendor = "IBM" and product = "S/390.*"  
>> are
>> ## blacklisted. To enable mulitpathing on these devies, uncomment the
>> ## following lines.
>> #blacklist_exceptions {
>> # device {
>> # vendor "IBM"
>> # product "S/390.*"
>> # }
>> #}
>>
>> ## Use user friendly names, instead of using WWIDs as names.
>> defaults {
>> user_friendly_names yes
>> }
>> ##
>> ## Here is an example of how to configure some standard options.
>> ##
>> #
>> defaults {
>> udev_dir /dev
>> polling_interval 10
>> selector "round-robin 0"
>> path_grouping_policy multibus
>> getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
>> prio_callout /bin/true
>> path_checker readsector0
>> rr_min_io 10
>> rr_weight priorities
>> failback 120
>> features "1 queue_if_no_path"
>> no_path_retry 1
>> user_friendly_name yes
>> }
>
> It looks like you have two defaults {} sections. Is that allowed?  
> Maybe multipath is only picking up the first one? I'd remove the  
> first one/comment out and put user_friendly_names yes in the second  
> one.
>
> Also I think multipath -v3 -d will show you what settings would be  
> applied so you don't have to test the behavior by cycling your  
> ethernet switch.
>
> For example on one of my systems multipath -v3 shows
> mpath1: pgfailback = -2 (controller setting)
>
>
> After you have it configured right run multipath -v3 without the -d  
> (dry run)
>
> Can someone confirm if pgfailback from multipath -v3 output  
> indicates the current setting of failback that multipath is using?
>
> John Brier

Here's the abbreviated output from multipath -v3:

mpath1: pgfailback = 120 (config file default)
mpath1: pgpolicy = multibus (config file default)
mpath1: selector = round-robin 0 (internal default)
mpath1: features = 1 queue_if_no_path (internal default)
mpath1: hwhandler = 0 (internal default)
mpath1: rr_weight = 2 (config file default)
mpath1: minio = 10 (config file default)
mpath1: no_path_retry = 1 (config file default)
pg_timeout = NONE (internal default)
mpath1: set ACT_NOTHING (map unchanged)

It's definitely picking up the settings correctly from multipath.conf,  
but the paths are still reinstated immediately once they're  
reconnected (even if it's just for a split second).

-Eli
--Apple-Mail-8--994413526
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div><div>On Sep 30, 2009, at 1:07 PM, John Brier wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>On =
09/30/2009 12:41 PM, Eli Klein wrote:<br><blockquote type=3D"cite">I'm =
running into an issue where the failback option in multipath.conf =
is<br></blockquote><blockquote type=3D"cite">being ignored. I've tried =
to set this to a value &gt; 0 to cause dm to<br></blockquote><blockquote =
type=3D"cite">pause before reinstating a recovered path, but it =
reinstates the path<br></blockquote><blockquote type=3D"cite">immediately.=
 The same is true when setting the value to "manual", =
the<br></blockquote><blockquote type=3D"cite">path is reinstated =
immediately. The delay is most useful when a =
ethernet<br></blockquote><blockquote type=3D"cite">switch has failed or =
rebooted. During the boot of the switch, the<br></blockquote><blockquote =
type=3D"cite">interface comes up and drops again multiple times. I'd =
love to be able<br></blockquote><blockquote type=3D"cite">to introduce a =
delay before DM marks the path as reinstated after =
a<br></blockquote><blockquote type=3D"cite">recovery. This would save me =
the hassle of running into I/O errors (and<br></blockquote><blockquote =
type=3D"cite">occasional filesystem RO) as the path bounces while the =
switch is booting.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Thanks in =
advance for any help or suggestions!<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">-Eli<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I've included =
my multipath.conf as well as output from multipath -ll =
below:<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">multipath.conf:<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">blacklist =
{<br></blockquote><blockquote type=3D"cite">devnode =
"sda$"<br></blockquote><blockquote type=3D"cite"># devnode =
"*"<br></blockquote><blockquote =
type=3D"cite">}<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">## By default, =
devices with vendor =3D "IBM" and product =3D "S/390.*" =
are<br></blockquote><blockquote type=3D"cite">## blacklisted. To enable =
mulitpathing on these devies, uncomment the<br></blockquote><blockquote =
type=3D"cite">## following lines.<br></blockquote><blockquote =
type=3D"cite">#blacklist_exceptions {<br></blockquote><blockquote =
type=3D"cite"># device {<br></blockquote><blockquote type=3D"cite"># =
vendor "IBM"<br></blockquote><blockquote type=3D"cite"># product =
"S/390.*"<br></blockquote><blockquote type=3D"cite"># =
}<br></blockquote><blockquote type=3D"cite">#}<br></blockquote><blockquote=
 type=3D"cite"><br></blockquote><blockquote type=3D"cite">## Use user =
friendly names, instead of using WWIDs as =
names.<br></blockquote><blockquote type=3D"cite">defaults =
{<br></blockquote><blockquote type=3D"cite">user_friendly_names =
yes<br></blockquote><blockquote =
type=3D"cite">}<br></blockquote><blockquote =
type=3D"cite">##<br></blockquote><blockquote type=3D"cite">## Here is an =
example of how to configure some standard =
options.<br></blockquote><blockquote =
type=3D"cite">##<br></blockquote><blockquote =
type=3D"cite">#<br></blockquote><blockquote type=3D"cite">defaults =
{<br></blockquote><blockquote type=3D"cite">udev_dir =
/dev<br></blockquote><blockquote type=3D"cite">polling_interval =
10<br></blockquote><blockquote type=3D"cite">selector "round-robin =
0"<br></blockquote><blockquote type=3D"cite">path_grouping_policy =
multibus<br></blockquote><blockquote type=3D"cite">getuid_callout =
"/sbin/scsi_id -g -u -s /block/%n"<br></blockquote><blockquote =
type=3D"cite">prio_callout /bin/true<br></blockquote><blockquote =
type=3D"cite">path_checker readsector0<br></blockquote><blockquote =
type=3D"cite">rr_min_io 10<br></blockquote><blockquote =
type=3D"cite">rr_weight priorities<br></blockquote><blockquote =
type=3D"cite">failback 120<br></blockquote><blockquote =
type=3D"cite">features "1 queue_if_no_path"<br></blockquote><blockquote =
type=3D"cite">no_path_retry 1<br></blockquote><blockquote =
type=3D"cite">user_friendly_name yes<br></blockquote><blockquote =
type=3D"cite">}<br></blockquote><br>It looks like you have two defaults =
{} sections. Is that allowed? Maybe multipath is only picking up the =
first one? I'd remove the first one/comment out and put =
user_friendly_names yes in the second one.<br><br>Also I think multipath =
-v3 -d will show you what settings would be applied so you don't have to =
test the behavior by cycling your ethernet switch.<br><br>For example on =
one of my systems multipath -v3 shows<br>mpath1: pgfailback =3D -2 =
(controller setting)<br><br><br>After you have it configured right run =
multipath -v3 without the -d (dry run)<br><br>Can someone confirm if =
pgfailback from multipath -v3 output indicates the current setting of =
failback that multipath is using?<br><br>John Brier<font =
class=3D"Apple-style-span" color=3D"#000000"><font =
class=3D"Apple-style-span" =
color=3D"#144FAE"><br></font></font></div></blockquote><br></div><div>Here=
's the abbreviated output from multipath =
-v3:</div><div><br></div><div><div>mpath1: pgfailback =3D 120 (config =
file default)</div><div>mpath1: pgpolicy =3D multibus (config file =
default)</div><div>mpath1: selector =3D round-robin 0 (internal =
default)</div><div>mpath1: features =3D 1 queue_if_no_path (internal =
default)</div><div>mpath1: hwhandler =3D 0 (internal =
default)</div><div>mpath1: rr_weight =3D 2 (config file =
default)</div><div>mpath1: minio =3D 10 (config file =
default)</div><div>mpath1: no_path_retry =3D 1 (config file =
default)</div><div>pg_timeout =3D NONE (internal =
default)</div><div>mpath1: set ACT_NOTHING (map =
unchanged)</div><div><br></div><div>It's definitely picking up the =
settings correctly from multipath.conf, but the paths are still =
reinstated immediately once they're reconnected (even if it's just for a =
split second).</div><div><br></div><div>-Eli</div></div></body></html>=

--Apple-Mail-8--994413526--


--===============0110878686==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0110878686==--
