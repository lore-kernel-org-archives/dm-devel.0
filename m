From: Eli Klein <elijah@aclue.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Wed, 30 Sep 2009 12:51:21 -0600
Message-ID: <7A313BC9-D652-4195-9D2A-AA27F7AD5E68@aclue.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: multipart/mixed; boundary="===============0072051374=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0072051374==
Content-Type: multipart/alternative; boundary=Apple-Mail-7--995909084


--Apple-Mail-7--995909084
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes

Sorry, left off a few key details:

I'm running the following:

redhat 5.3 x86_64
device-mapper-1.02.28-2.el5
device-mapper-multipath-0.4.7-23.el5_3.4

Let me know if there are other details that would be helpful.

-Eli

On Sep 30, 2009, at 10:41 AM, Eli Klein wrote:

> I'm running into an issue where the failback option in  
> multipath.conf is being ignored.  I've tried to set this to a value  
> > 0 to cause dm to pause before reinstating a recovered path, but it  
> reinstates the path immediately.  The same is true when setting the  
> value to "manual", the path is reinstated immediately.  The delay is  
> most useful when a ethernet switch has failed or rebooted.  During  
> the boot of the switch, the interface comes up and drops again  
> multiple times.  I'd love to be able to introduce a delay before DM  
> marks the path as reinstated after a recovery.  This would save me  
> the hassle of running into I/O errors (and occasional filesystem RO)  
> as the path bounces while the switch is booting.
>
> Thanks in advance for any help or suggestions!
>
> -Eli
>
> I've included my multipath.conf as well as output from multipath -ll  
> below:
>
> multipath.conf:
>
> blacklist {
>         devnode "sda$"
> #        devnode "*"
> }
>
> ## By default, devices with vendor = "IBM" and product = "S/390.*" are
> ## blacklisted. To enable mulitpathing on these devies, uncomment the
> ## following lines.
> #blacklist_exceptions {
> #	device {
> #		vendor	"IBM"
> #		product	"S/390.*"
> #	}
> #}
>
> ## Use user friendly names, instead of using WWIDs as names.
> defaults {
> 	user_friendly_names yes
> }
> ##
> ## Here is an example of how to configure some standard options.
> ##
> #
> defaults {
> 	udev_dir		/dev
> 	polling_interval 	10
> 	selector		"round-robin 0"
> 	path_grouping_policy	multibus
> 	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
> 	prio_callout		/bin/true
> 	path_checker		readsector0
> 	rr_min_io		10
> 	rr_weight		priorities
> 	failback		120
> 	features		"1 queue_if_no_path"
> 	no_path_retry		1
> 	user_friendly_name	yes
> }
>
> multipath -ll:
>
> mpath2 (36000eb3945b8703a00000000000000f4) dm-3 LEFTHAND,iSCSIDisk
> [size=400G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 192:0:0:0 sdl 8:176 [active][ready]
>  \_ 191:0:0:0 sdf 8:80  [active][ready]
> mpath152 (36000eb3945b8703a0000000000001431) dm-2 LEFTHAND,iSCSIDisk
> [size=300G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 186:0:0:0 sdh 8:112 [active][ready]
>  \_ 185:0:0:0 sde 8:64  [active][ready]
> mpath149 (36000eb3945b8703a0000000000001429) dm-5 LEFTHAND,iSCSIDisk
> [size=300G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 189:0:0:0 sdc 8:32  [active][ready]
>  \_ 190:0:0:0 sdi 8:128 [active][ready]
> mpath151 (36000eb3945b8703a000000000000142d) dm-6 LEFTHAND,iSCSIDisk
> [size=300G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 188:0:0:0 sdj 8:144 [active][ready]
>  \_ 187:0:0:0 sdg 8:96  [active][ready]
> mpath150 (36000eb3945b8703a0000000000001435) dm-4 LEFTHAND,iSCSIDisk
> [size=200G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 184:0:0:0 sdk 8:160 [active][ready]
>  \_ 183:0:0:0 sdd 8:48  [active][ready]


--Apple-Mail-7--995909084
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
">Sorry, left off a few key details:<div><br></div><div>I'm running the =
following:</div><div><br></div><div>redhat 5.3 =
x86_64</div><div>device-mapper-1.02.28-2.el5</div><div>device-mapper-multi=
path-0.4.7-23.el5_3.4</div><div><br></div><div>Let me know if there are =
other details that would be =
helpful.</div><div><br></div><div>-Eli<br><div><div><br></div><div>On =
Sep 30, 2009, at 10:41 AM, Eli Klein wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div =
style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; ">I'm running into an issue where =
the failback option in multipath.conf is being ignored. &nbsp;I've tried =
to set this to a value &gt; 0 to cause dm to pause before reinstating a =
recovered path, but it reinstates the path immediately. &nbsp;The same =
is true when setting the value to "manual", the path is reinstated =
immediately. &nbsp;The delay is most useful when a ethernet switch has =
failed or rebooted. &nbsp;During the boot of the switch, the interface =
comes up and drops again multiple times. &nbsp;I'd love to be able to =
introduce a delay before DM marks the path as reinstated after a =
recovery. &nbsp;This would save me the hassle of running into I/O errors =
(and occasional filesystem RO) as the path bounces while the switch is =
booting. &nbsp;<div><div><br></div><div>Thanks in advance for any help =
or =
suggestions!</div><div><br></div><div>-Eli</div><div><br></div><div>I've =
included my multipath.conf as well as output from multipath -ll =
below:</div><div><br></div><div><b>multipath.conf</b>:</div><div><br></div=
></div><blockquote class=3D"webkit-indent-blockquote" style=3D"margin: 0 =
0 0 40px; border: none; padding: 0px;"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px; ">blacklist {<br>&nbsp;&nbsp; &nbsp; &nbsp; =
&nbsp;devnode "sda$"<br># &nbsp; &nbsp; &nbsp; &nbsp;devnode =
"*"<br>}<br><br>## By default, devices with vendor =3D "IBM" and product =
=3D "S/390.*" are<br>## blacklisted. To enable mulitpathing on these =
devies, uncomment the<br>## following lines.<br>#blacklist_exceptions =
{<br>#</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">device =
{<br>#</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">vendor</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">"IBM"<br>#</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">product</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">"S/390.*"<br>#</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">}<br>#}<br><br>## =
Use user friendly names, instead of using WWIDs as names.<br>defaults =
{<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">user_friendly_names yes<br>}<br>##<br>## Here is an example of =
how to configure some standard options.<br>##<br>#<br>defaults =
{<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">udev_dir</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">/dev<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">polling_interval =
</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">10<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">selector</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">"round-robin =
0"<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">path_grouping_policy</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">multibus<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">getuid_callout</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">"/sbin/scsi_id -g =
-u -s /block/%n"<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">prio_callout</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">/bin/true<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">path_checker</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">readsector0<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">rr_min_io</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">10<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">rr_weight</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">priorities<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">failback</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">120<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">features</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">"1 =
queue_if_no_path"<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">no_path_retry</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">		</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">1<br></span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">user_friendly_name</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: =
12px;">yes<br>}</span></font></blockquote><div><div><div><br></div><div><b=
>multipath -ll</b>:</div><div><br></div></div></div><blockquote =
class=3D"webkit-indent-blockquote" style=3D"margin: 0 0 0 40px; border: =
none; padding: 0px;"><font class=3D"Apple-style-span" face=3D"'Courier =
New'" size=3D"3"><span class=3D"Apple-style-span" style=3D"font-size: =
12px;">mpath2 (36000eb3945b8703a00000000000000f4) dm-3 =
LEFTHAND,iSCSIDisk<br>[size=3D400G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-robin 0 =
[prio=3D0][active]<br>&nbsp;\_ 192:0:0:0 sdl 8:176 =
[active][ready]<br>&nbsp;\_ 191:0:0:0 sdf 8:80 =
&nbsp;[active][ready]<br>mpath152 (36000eb3945b8703a0000000000001431) =
dm-2 LEFTHAND,iSCSIDisk<br>[size=3D300G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-robin 0 =
[prio=3D0][active]<br>&nbsp;\_ 186:0:0:0 sdh 8:112 =
[active][ready]<br>&nbsp;\_ 185:0:0:0 sde 8:64 =
&nbsp;[active][ready]<br>mpath149 (36000eb3945b8703a0000000000001429) =
dm-5 LEFTHAND,iSCSIDisk<br>[size=3D300G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-robin 0 =
[prio=3D0][active]<br>&nbsp;\_ 189:0:0:0 sdc 8:32 =
&nbsp;[active][ready]<br>&nbsp;\_ 190:0:0:0 sdi 8:128 =
[active][ready]<br>mpath151 (36000eb3945b8703a000000000000142d) dm-6 =
LEFTHAND,iSCSIDisk<br>[size=3D300G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-robin 0 =
[prio=3D0][active]<br>&nbsp;\_ 188:0:0:0 sdj 8:144 =
[active][ready]<br>&nbsp;\_ 187:0:0:0 sdg 8:96 =
&nbsp;[active][ready]<br>mpath150 (36000eb3945b8703a0000000000001435) =
dm-4 LEFTHAND,iSCSIDisk<br>[size=3D200G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-robin 0 =
[prio=3D0][active]<br>&nbsp;\_ 184:0:0:0 sdk 8:160 =
[active][ready]<br>&nbsp;\_ 183:0:0:0 sdd 8:48 =
&nbsp;[active][ready]</span></font></blockquote></div></blockquote></div><=
br></div></body></html>=

--Apple-Mail-7--995909084--


--===============0072051374==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0072051374==--
